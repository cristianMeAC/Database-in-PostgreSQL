CREATE VIEW TourG AS SELECT t.tid, foo.geb as gebuehr
                     FROM Tour t JOIN (
                                         SELECT tid, SUM(gebuehr) AS geb
                                         FROM TourAnkerplatz NATURAL JOIN Hafen
                                         GROUP BY tid
                                      ) as foo ON t.tid=foo.tid;

CREATE VIEW TourGebuehr AS WITH RECURSIVE tg(tid, geb) AS (SELECT * FROM TourG
                                                           UNION ALL
                                                           SELECT tt.teil_von, tg.geb FROM Teiltour tt JOIN tg ON tg.tid = tt.tid)
                                                           SELECT tid, sum(geb) FROM tg GROUP BY tid;
