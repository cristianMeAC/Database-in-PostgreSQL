--- 4 a) - check if sid is null
CREATE FUNCTION segelschiff_sid_checker() RETURNS trigger AS $$
BEGIN
  IF NEW.sid is NULL THEN
    NEW.sid = (SELECT COALESCE(max(ss.sid)+1, 0) FROM Segelschiff ss WHERE ss.Hafen=NEW.hafen);
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER ss_sid_trigger
BEFORE INSERT ON Segelschiff
FOR EACH ROW EXECUTE PROCEDURE segelschiff_sid_checker();


--- 4 b) - check if ss has enough capacity and two tours on the same ss do not overlap

CREATE FUNCTION chart_checker() RETURNS trigger AS $$
DECLARE
  crew_size integer;
  ss_capacity integer;
  start_date date;
  end_date date;
  rec record;
  start_date_tmp date;
  end_date_tmp date;
BEGIN
  -- get crew_size
  SELECT INTO crew_size COUNT(*)
  FROM CrewMitglieder cm
  WHERE cm.cleiter = NEW.cleiter AND cm.cid = NEW.cid;

  -- get capacity of the ship
  SELECT INTO ss_capacity ss.kapazitaet
  FROM Segelschiff ss
  WHERE ss.sid = NEW.sid  AND ss.hafen = NEW.hafen ;

  -- raise error in case the capacity is less than the size of a crew
  IF crew_size > ss_capacity THEN
    RAISE EXCEPTION 'Segelshiff (%) based in (%) has not enough capacity for a crew of this size', NEW.sid, NEW.hafen;
  END IF;

  -- get start date and compute end date of a tour
  start_date = NEW.startdatum;
  end_date = start_date + (SELECT t.dauer FROM Tour t WHERE t.tid = NEW.tid);

  -- go through all the tours that use the same ship and check if two tour dates overlap
  --IF (EXISTS (SELECT * FROM Gechartet g WHERE g.sid = NEW.sid AND g.hafen = NEW.hafen)) THEN
    FOR rec IN (SELECT * FROM Gechartet g NATURAL JOIN Tour t WHERE g.sid = NEW.sid AND g.hafen = NEW.hafen) LOOP
      start_date_tmp = rec.startdatum;
      end_date_tmp = start_date_tmp + rec.dauer;
      IF ((start_date, end_date) OVERLAPS (start_date_tmp, end_date_tmp)) THEN
        RAISE EXCEPTION 'Segelshiff (%) based in (%) is already chartered for this date.', NEW.sid, NEW.hafen;
      END IF;
    END LOOP;
  --END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER chart_trigger
BEFORE INSERT OR UPDATE ON Gechartet
FOR EACH ROW
EXECUTE PROCEDURE chart_checker();

-- 4 c) Update duration of a dependent tour
CREATE FUNCTION tour_duration_updater() RETURNS trigger AS $$
DECLARE
  delta integer;
  rec record;
BEGIN
  -- compute delta and update the tour table
  delta = NEW.dauer - OLD.dauer;
  FOR rec IN (SELECT * FROM Teiltour tt WHERE tt.tid=NEW.tid) LOOP
    UPDATE Tour SET dauer = dauer+delta WHERE tid=rec.teil_von;
  END LOOP;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tour_duration_trigger
AFTER UPDATE ON Tour
FOR EACH ROW
EXECUTE PROCEDURE tour_duration_updater();


CREATE FUNCTION teiltour_updater() RETURNS trigger as $$
DECLARE
  delta integer;
BEGIN

  -- on insert add a value
  IF TG_OP = 'INSERT' THEN
    SELECT INTO delta dauer FROM Tour t WHERE t.tid=NEW.tid;
    UPDATE Tour SET dauer = dauer + delta WHERE tid=NEW.teil_von;
  END IF;

  -- on update substract an old value and then add a new value
  IF TG_OP = 'UPDATE' THEN
    SELECT INTO delta dauer FROM Tour t WHERE t.tid = OLD.tid;
    UPDATE Tour SET dauer = dauer - delta WHERE tid=OLD.teil_von;
    SELECT INTO delta dauer FROM Tour t WHERE t.tid = NEW.tid;
    UPDATE Tour SET dauer = dauer + delta WHERE tid=NEW.teil_von;
  END IF;

 -- on delete substract an old value
  IF TG_OP = 'DELETE' THEN
    SELECT INTO delta dauer FROM Tour t WHERE t.tid = OLD.tid;
    UPDATE Tour SET dauer = dauer - delta WHERE tid=OLD.teil_von;
  END IF;
RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER teiltour_trigger
AFTER INSERT OR UPDATE OR DELETE ON Teiltour
FOR EACH ROW EXECUTE PROCEDURE teiltour_updater();


-- 4) d - create crew
CREATE OR REPLACE FUNCTION CreateCrew(cleiter_id integer, name varchar(20), eh integer, ko integer, mg integer) RETURNS void AS $$
DECLARE
cid_cnt integer := 0;
eh_id integer := 0;
ko_id integer := 0;
mg_id integer := 0;
loop_cnt integer := 0;
BEGIN
  -- d) 1
  IF eh < 2 THEN
    RAISE EXCEPTION 'Cannot create Crew. Number of ersthelfer should be greater than 1.';
  END IF;

  IF (ko < 1 OR ko > 4) THEN
    RAISE EXCEPTION 'Cannot create Crew. Number of kocher should be in [1, 4].';
  END IF;

  -- get last id of a crew - d) 2
  SELECT INTO cid_cnt COUNT(*)
  FROM Crew c
  WHERE c.leiter=cleiter_id;

  cid_cnt = cid_cnt+1;

  INSERT INTO Crew
  VALUES (cleiter_id, cid_cnt, name);
  INSERT INTO CrewMitglieder
  VALUES (cleiter_id, cleiter_id, cid_cnt);

  -- insert ersthelfer - d) 3
  loop_cnt = eh;
  WHILE loop_cnt > 0 LOOP
    SELECT INTO eh_id e.id
    FROM Ersthelfer e
    --WHERE e.id NOT IN (SELECT ce.ersthelfer FROM CrewErsthelfer ce); -- not part of any crew
    WHERE e.id NOT IN (SELECT ce.ersthelfer FROM CrewErsthelfer ce WHERE ce.cleiter = cleiter_id AND ce.cid = cid_cnt);

    INSERT INTO CrewMitglieder
    VALUES (eh_id, cleiter_id, cid_cnt);
    INSERT INTO CrewErsthelfer
    VALUES (eh_id, cleiter_id, cid_cnt);
    loop_cnt = loop_cnt-1;
  END LOOP;

  -- insert kocher - d) 4
  loop_cnt = ko;
  WHILE loop_cnt > 0 LOOP
    SELECT INTO ko_id k.id
    FROM Koch k
    --WHERE k.id NOT IN (SELECT ck.koch FROM CrewKoch ck); -- not part of any crew
    WHERE k.id NOT IN (SELECT ck.koch FROM CrewKoch ck WHERE ck.cleiter = cleiter_id AND ck.cid=cid_cnt);

    INSERT INTO CrewMitglieder
    VALUES (ko_id, cleiter_id, cid_cnt);
    INSERT INTO CrewKoch
    VALUES (ko_id, cleiter_id, cid_cnt);
    loop_cnt = loop_cnt-1;

  END LOOP;

  -- insert rest members
  loop_cnt = mg;
  WHILE loop_cnt > 0 LOOP
    SELECT INTO mg_id s.id
    FROM Segler s
    --WHERE s.id NOT IN (SELECT mg.segler FROM CrewMitglieder mg); -- not part of any crew
    WHERE s.id NOT IN (SELECT mg.segler FROM CrewMitglieder mg WHERE mg.cleiter = cleiter_id AND mg.cid=cid_cnt);

    INSERT INTO CrewMitglieder
    VALUES (mg_id, cleiter_id, cid_cnt);
    loop_cnt = loop_cnt-1;
  END LOOP;
  RAISE NOTICE 'Created crew (%), cleiter (%)', cid_cnt, cleiter_id;
END;
$$ LANGUAGE plpgsql;
