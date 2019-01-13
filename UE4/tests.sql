--- Aufgabe 1

-- 1 a.1), inserting same tour, same ankerplatz but different day
SELECT * FROM TourAnkerplatz;
INSERT INTO TourAnkerplatz (tid, krz, tag) VALUES (1000, 'K1', 2);
SELECT * FROM TourAnkerplatz;
DELETE FROM TourAnkerplatz WHERE tid=1000 AND tag=2;

-- 1 a.2), inserting same crew, same ship but different start date
SELECT * FROM Gechartet;
INSERT INTO Gechartet VALUES (10, 1, 'K1', 0, 1000, to_date('2016-09-09', 'YYYY-MM-DD'));
SELECT * FROM Gechartet;
DELETE FROM Gechartet WHERE startdatum=to_date('2016-09-09', 'YYYY-MM-DD');

-- 1 b) inserting an entry into table "segler" with a default value for ID (sequence)
SELECT * FROM Segler;
INSERT INTO Segler VALUES (default, 'Name13', to_date('1963-09-13', 'YYYY-MM-DD'), 'email13@email.com');
SELECT * FROM Segler;
DELETE FROM Segler WHERE name='Name13';

-- 1 c) inserting an entry into table "tour" with a default value for TID (sequence)
SELECT * FROM Tour;
INSERT INTO Tour VALUES (default, 'xxxxxx', 14, 10);
SELECT * FROM Tour;
DELETE FROM Tour WHERE bez='xxxxxx';

-- 1 d)
SELECT * FROM Skipper;
INSERT INTO Segler VALUES (1234, 'Name1234', to_date('1963-12-23', 'YYYY-MM-DD'), 'email1234@email.com');
INSERT INTO Skipper VALUES (1234, 'D', 144, 1000); -- will fail becaus of 'D' as schein (only A/B/C allowed)
INSERT INTO Skipper VALUES (1234, 'A', 144, 1000);
SELECT * FROM Skipper;
DELETE FROM Skipper WHERE id=1234;
DELETE FROM Segler WHERE id=1234;

-- 1 e) NUMERIC(7, 2) for prices
INSERT INTO Ankerplatz VALUES ('123', 'coord', 'blablabla');
SELECT * FROM Hafen;
INSERT INTO Hafen VALUES ('123', 123.5677777, true, true); -- will be truncated
SELECT * FROM Hafen;
DELETE FROM Hafen WHERE krz='123';
DELETE FROM Ankerplatz WHERE krz='123';

-- 1 f) PK of Ankerplatz should be char of fixed size (3)
SELECT * FROM Ankerplatz;
INSERT INTO Ankerplatz VALUES ('1234', 'coord', 'blablabla'); -- will fail
INSERT INTO Ankerplatz VALUES ('123', 'coord', 'blablabla');
SELECT * FROM Ankerplatz;
DELETE FROM Ankerplatz WHERE krz='123';

-- 1 g) Cyclic dependencies should be checked at the end of transaction
INSERT INTO Segler VALUES (1234, 'Name1234', to_date('1963-12-23', 'YYYY-MM-DD'), 'email1234@email.com');

SELECT * FROM Tour;
SELECT * FROM Skipper;

-- both will fail
INSERT INTO Tour VALUES (1111, 'xxxxxx', 14, 1234);
INSERT INTO Skipper VALUES (1234, 'A', 144, 1111);

BEGIN;
INSERT INTO Tour VALUES (1111, 'xxxxxx', 14, 1234);
INSERT INTO Skipper VALUES (1234, 'A', 144, 1111);
END;

SELECT * FROM Tour;
SELECT * FROM Skipper;

BEGIN;
DELETE FROM Skipper WHERE id=1234;
DELETE FROM Tour WHERE tid=1111;
COMMIT;
DELETE FROM Segler WHERE id=1234;

-- 1 h) no umlauts

-- 1 i)
--  i.1) - Capacity and number of berths should be positive integers (>=0)
SELECT * FROM Segelschiff;
INSERT INTO Segelschiff VALUES ('K1', 123, 'Titanic', 1909, -1, 2); -- will fail
INSERT INTO Segelschiff VALUES ('K1', 123, 'Titanic', 1909, 2, -1); -- will fail
INSERT INTO Segelschiff VALUES ('K1', 123, 'Titanic', 1909, 0, 0);
SELECT * FROM Segelschiff;
DELETE FROM Segelschiff WHERE name='Titanic';

-- i.2) - Day in TourAnkerplatz should be a positive integer (>0)
SELECT * FROM TourAnkerplatz;
INSERT INTO TourAnkerplatz VALUES ('1000', 'K3', 0); -- will fail
INSERT INTO TourAnkerplatz VALUES ('1000', 'K3', -1); -- will fail
INSERT INTO TourAnkerplatz VALUES ('1000', 'K3', 100);
SELECT * FROM TourAnkerplatz;
DELETE FROM TourAnkerplatz WHERE tag=100;

-- i.3) - A tour can only use one TourAnkerplatz during the same day
SELECT * FROM TourAnkerplatz;
INSERT INTO TourAnkerplatz VALUES ('1000', 'K3', 100);
INSERT INTO TourAnkerplatz VALUES ('1000', 'K2', 100); -- will fail
INSERT INTO TourAnkerplatz VALUES ('1000', 'K2', 101);
SELECT * FROM TourAnkerplatz;
DELETE FROM TourAnkerplatz WHERE tag=100 OR tag=101;

-- i.4) - A head of a crew, as well as cooks and first aid personnel should be also present in CrewMitglieder table
SELECT * FROM Crew;
SELECT * FROM CrewMitglieder WHERE cleiter=12 AND cid=2;
-- both will fail, should be inside of a transaction
INSERT INTO Crew VALUES (12, 2, 'xxx');
INSERT INTO CrewMitglieder VALUES (12, 12, 2);
-- OK
BEGIN;
INSERT INTO Crew VALUES (12, 2, 'xxx');
INSERT INTO CrewMitglieder VALUES (12, 12, 2);
COMMIT;
SELECT * FROM Crew;
SELECT * FROM CrewMitglieder WHERE cleiter=12 AND cid=2;

SELECT * FROM CrewKoch WHERE cleiter=12 AND cid=2;
INSERT INTO CrewKoch VALUES (3, 12, 2); -- will fail, cook should be in CrewMitglieder
INSERT INTO CrewMitglieder VALUES (3, 12, 2);
INSERT INTO CrewKoch VALUES (3, 12, 2); -- OK
SELECT * FROM CrewKoch WHERE cleiter=12 AND cid=2;

SELECT * FROM CrewErsthelfer WHERE cleiter=12 AND cid=2;
INSERT INTO CrewErsthelfer VALUES (9, 12, 2); -- will fail for the same reason
INSERT INTO CrewMitglieder VALUES (9, 12, 2);
INSERT INTO CrewErsthelfer VALUES (9, 12, 2); -- OK
SELECT * FROM CrewErsthelfer WHERE cleiter=12 AND cid=2;

DELETE FROM CrewErsthelfer WHERE cleiter=12 AND cid=2;
DELETE FROM CrewKoch WHERE cleiter=12 AND cid=2;
BEGIN;
DELETE FROM CrewMitglieder WHERE cleiter=12 AND cid=2;
DELETE FROM Crew WHERE leiter=12 AND cid=2;
COMMIT;

-- 1 j) NULL values are not allowed - All fields have NOT NULL constraint (except primary keys - PKs have it implicitly)


-- Aufgabe 3

/* Data after insert.sql

Prices
Hafen krz ---   gebuehr
    K1    ---   750.99
    K2    ---   880.00
    K3    ---   600.00

TourAnkerplatz
1000 --- K1
1010 --- K2
1020 --- K3
1030 --- K3
*/

-- a)
SELECT * FROM TourAnkerplatz NATURAL JOIN Hafen;
SELECT * FROM TourG;
UPDATE Hafen SET gebuehr = gebuehr + 100;
SELECT * FROM TourAnkerplatz NATURAL JOIN Hafen;
SELECT * FROM TourG;
-- current value of tid = 1000 is 850.99
INSERT INTO TourAnkerplatz VALUES ('1000', 'K3', 6);
-- new value of tid = 1000 is 850.99+700=1550.99
SELECT * FROM TourAnkerplatz NATURAL JOIN Hafen;
SELECT * FROM TourG;
DELETE FROM TourAnkerplatz WHERE tid=1000 AND tag=6;
UPDATE Hafen SET gebuehr = gebuehr - 100;

-- b)
SELECT * FROM Teiltour;
Current dependencies: 1000->1010, 1010->1020, 1020->1030
/* => geb(1000) =  750.99
   => geb(1010) = geb(1000) + 880.00 = 1630.99
   => geb(1020) = geb(1010) + 600.00 = 2230.99
   => geb(1030) = geb(1020) + 600.00 = 2830.99
*/
SELECT * FROM TourGebuehr;
DELETE FROM Teiltour WHERE tid=1000 AND teil_von=1010;

SELECT * FROM Teiltour;
Current dependencies: 1010->1020, 1020->1030
/* => geb(1000) =  750.99
   => geb(1010) =  880.00
   => geb(1020) = geb(1010) + 600.00 = 1480.00
   => geb(1030) = geb(1020) + 600.00 = 2080.00
*/
SELECT * FROM TourGebuehr;

INSERT INTO Teiltour VALUES(1000, 1030);
SELECT * FROM Teiltour;
Current dependencies: 1010->1020, 1020->1030, 1000-1030
/* => geb(1000) =  750.99
   => geb(1010) =  880.00
   => geb(1020) = geb(1010) + 600.00 = 1480.00
   => geb(1030) = geb(1020) + geb(1000) + 600.00 = 2830.99
*/
SELECT * FROM TourGebuehr;
UPDATE Teiltour SET teil_von=1010 WHERE tid=1000;


-- Aufgabe 4

-- a) Trigger that check if sid is NULL when inserting in Segelschiff
SELECT hafen, sid, name FROM Segelschiff JOIN Hafen ON hafen=krz;
INSERT INTO Segelschiff VALUES ('K1', 100, 'xxx', 2014, 12, 12);
SELECT hafen, sid, name FROM Segelschiff JOIN Hafen ON hafen=krz;
INSERT INTO Segelschiff VALUES ('K1', NULL, 'yyy', 2014, 12, 12);
SELECT hafen, sid, name FROM Segelschiff JOIN Hafen ON hafen=krz;
DELETE FROM Segelschiff WHERE name='yyy' OR name='xxx';

-- b) Trigger that check if a ship has enough capacity for a crew + trigger that checks if two tour on the same ship do not overlap

-- b.1)
SELECT COUNT(*) as Crew_1_size FROM Crew c JOIN CrewMitglieder cm ON c.leiter=cm.cleiter AND c.cid=cm.cid WHERE c.crewname='Crew 1';

INSERT INTO Segelschiff VALUES ('K1', 100, 'enough cap', 2014, 12, 5);
INSERT INTO Segelschiff VALUES ('K1', NULL, 'not enough cap', 2014, 12, 3);

SELECT hafen, sid, name, kapazitaet FROM Segelschiff WHERE name='enough cap' OR name='not enough cap';

INSERT INTO Gechartet VALUES (10, 1, 'K1', 101, 1000, to_date('2017-10-20', 'YYYY-MM-DD')); -- will fail, 3<5
INSERT INTO Gechartet VALUES (10, 1, 'K1', 100, 1000, to_date('2017-10-20', 'YYYY-MM-DD')); -- OK 5>=5
SELECT * FROM Gechartet WHERE sid=100 OR sid=101;

-- b.2)
SELECT g.startdatum, t.dauer FROM gechartet g NATURAL JOIN Tour t WHERE g.sid=100;
INSERT INTO Gechartet VALUES (10, 1, 'K1', 100, 1010, to_date('2017-10-22', 'YYYY-MM-DD')); -- will fail, ship will be chartet at this time
INSERT INTO Gechartet VALUES (10, 1, 'K1', 100, 1010, to_date('2017-10-27', 'YYYY-MM-DD')); -- OK
SELECT g.startdatum, t.dauer FROM gechartet g NATURAL JOIN Tour t WHERE g.sid=100;
DELETE FROM Gechartet WHERE startdatum = to_date('2017-10-27', 'YYYY-MM-DD') OR startdatum = to_date('2017-10-20', 'YYYY-MM-DD');
DELETE FROM Segelschiff WHERE sid=100 OR sid=101;

-- c) Trigger that adjusts the duration of a tour when update/delete/insert operation on teiltour table is performed

-- c.1) change duration of tours on update of tour table
SELECT * FROM teiltour;
-- Current dependencies: 1000->1010, 1010->1020, 1020->1030
SELECT tid, dauer FROM Tour;
UPDATE Tour SET dauer = dauer+10 WHERE tid=1000; -- duration of every tour should encrease by 10
SELECT tid, dauer FROM Tour;
UPDATE Tour SET dauer = dauer-10 WHERE tid=1020; -- duration of tours 1020 and 1030 should decrease by 10
SELECT tid, dauer FROM Tour;

UPDATE Tour SET dauer = dauer+10 WHERE tid=1020;
UPDATE Tour SET dauer = dauer-10 WHERE tid=1000;

-- c.2) change duration of tours on insert/delete/update operation on teiltour table
SELECT * FROM teiltour;
-- Current dependencies: 1000->1010, 1010->1020, 1020->1030
SELECT tid, dauer FROM Tour;

DELETE FROM Teiltour WHERE tid=1000;
SELECT * FROM teiltour;
-- Current dependencies: 1010->1020, 1020->1030
SELECT tid, dauer FROM Tour; --- Duration of all tours should decrease by duration(1000)

INSERT INTO Teiltour VALUES (1000, 1020);
SELECT * FROM teiltour;
-- Current dependencies: 1010->1020, 1000->1020, 1020->1030
SELECT tid, dauer FROM Tour; --- Duration of tours 1020 and 1030 should decrease by duration(1000)

UPDATE Teiltour SET teil_von=1010 WHERE tid=1000;
SELECT * FROM teiltour;
-- Current dependencies: 1000->1010, 1010->1020, 1020->1030
SELECT tid, dauer FROM Tour;

-- d) CreateCrew(cleiter_id, name, eh, ko, mg) procedure

-- d.1) Check the number of first aid personnel and cooks + d.2) increase cid with every new crew
SELECT * From Crew;
BEGIN;
SELECT CreateCrew(10, 'Crew 10', 1, 1, 1); -- will fail
COMMIT;
BEGIN;
SELECT CreateCrew(10, 'Crew 10', 2, 0, 1); -- will fail
COMMIT;
BEGIN;
SELECT CreateCrew(10, 'Crew 10', 2, 5, 1); -- will fail
COMMIT;
SELECT CreateCrew(10, 'Crew 10', 2, 2, 1); -- OK
COMMIT;
SELECT * From Crew;
