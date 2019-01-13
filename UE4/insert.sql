begin;

insert into Segler(name, gebdatum, notfallkontakt) values ('Segler1',  '1994-04-27', '+43664-123.145');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler2',  '1995-08-10', '+43664-123.256');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler3',  '1988-07-31', '+43664-123.367');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler4',  '1977-12-14', '+43664-123.478');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler5',  '2000-06-15' , '+43664-123.589');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler6',  '1990-06-15' , '+43664-123.610');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler7',  '1975-06-10' , '+43664-123.711');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler8',  '1981-06-14' , '+43664-123.812');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler9',  '1966-06-27' , '+43664-123.913');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler10', '1986-06-25' , '+43664-123.014');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler11', '1990-09-20' , '+43664-123.125');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler12', '1990-06-10' , '+43664-123.236');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler13', '1990-07-11' , '+43664-123.347');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler14', '1990-08-12' , '+43664-123.457');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler15', '1990-08-13' , '+43664-123.568');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler16', '1990-09-14' , '+43664-123.679');
insert into Segler(name, gebdatum, notfallkontakt) values ('Segler17', '1990-10-15' , '+43664-123.780');


insert into Koch(id, seehauben) values (2,4);
insert into Koch(id, seehauben) values (3,3);
insert into Koch(id, seehauben) values (4,4);
insert into Koch(id, seehauben) values (5,5);
insert into Koch(id, seehauben) values (6,3);


insert into Ersthelfer values (11, 'highschool');
insert into Ersthelfer values (12, 'bachelor');
insert into Ersthelfer values (13, 'bachelor');
insert into Ersthelfer values (14, 'master');
insert into Ersthelfer values (15, 'master');
insert into Ersthelfer values (16, 'phd');
insert into Ersthelfer values (17, 'phd');


insert into Skipper values (1,  'A',  20, 1000);
insert into Skipper values (7,  'B',  10, 1020);
insert into Skipper values (10, 'C',  50, 1040);


insert into Crew(leiter, crewname) values (1, 'crew1');
insert into Crew(leiter, crewname) values (7, 'crew2');
insert into Crew(leiter, crewname) values (10, 'crew3');

-- Crew1
insert into CrewMitglieder values(1, 1, 1);		    -- skipper	
insert into CrewMitglieder values(2, 1, 1);	        -- koch
insert into CrewMitglieder values(11, 1, 1);		-- ersthelfer
insert into CrewMitglieder values(12, 1, 1);		-- ersthelfer

-- Crew2
insert into CrewMitglieder values(7, 7, 2);		    -- skipper
insert into CrewMitglieder values(3, 7, 2);	        -- koch
insert into CrewMitglieder values(13, 7, 2);		-- ersthelfer
insert into CrewMitglieder values(14, 7, 2);		-- ersthelfer
insert into CrewMitglieder values(15, 7, 2);		-- ersthelfer

-- Crew3
insert into CrewMitglieder values(10, 10, 3);        -- skipper
insert into CrewMitglieder values( 4, 10, 3);	    -- koch
insert into CrewMitglieder values(16, 10, 3);	    -- ersthelfer
insert into CrewMitglieder values(17, 10, 3);	    -- ersthelfer


/*
    CrewErsthelfer
*/

insert into CrewErsthelfer values(11, 1, 1);		-- ersthelfer
insert into CrewErsthelfer values(12, 1, 1);		-- ersthelfer

insert into CrewErsthelfer values(13, 7, 2);		-- ersthelfer
insert into CrewErsthelfer values(14, 7, 2);		-- ersthelfer
insert into CrewErsthelfer values(15, 7, 2);		-- ersthelfer

insert into CrewErsthelfer values(16, 10, 3);	    -- ersthelfer
insert into CrewErsthelfer values(17, 10, 3);	    -- ersthelfer
/*
*/


/*
    CrewKoch
*/

insert into CrewKoch values(2, 1,  1);

insert into CrewKoch values(3, 7,  2);	       

insert into CrewKoch values(4, 10, 3);
/*
*/

insert into Ankerplatz values('AP1', '(10, 10)', 'Ankerplatz 1 (hafen)');
insert into Ankerplatz values('AP2', '(11, 11)', 'Ankerplatz 2 (hafen)');
insert into Ankerplatz values('AP3', '(22, 22)', 'Ankerplatz 3 (hafen)');
insert into Ankerplatz values('AP4', '(33, 33)', 'Ankerplatz 4 (hafen)');
insert into Ankerplatz values('AP5', '(44, 44)', 'Ankerplatz 5 (tankstelle)');
insert into Ankerplatz values('AP6', '(55, 55)', 'Ankerplatz 6 (tankstelle)');
insert into Ankerplatz values('AP7', '(66, 66)', 'Ankerplatz 7 (tankstelle)');
insert into Ankerplatz values('AP8', '(77, 77)', 'Ankerplatz 8 (fjord)');
insert into Ankerplatz values('AP9', '(88, 88)', 'Ankerplatz 9 (fjord)');
insert into Ankerplatz values('AP10', '(90, 90)', 'Ankerplatz 10 (fjord)');


insert into Tankstelle values('AP5', true);
insert into Tankstelle values('AP6', false);
insert into Tankstelle values('AP7', false);


insert into Fjord values('AP8',  true,  'Take care, this Fjord is dangerous.');
insert into Fjord values('AP9',  false, 'Care is needed.');
insert into Fjord values('AP10', false, 'Enjoy the view!');


insert into Hafen values('AP1', 100.50, true,  false);
insert into Hafen values('AP2', 59.45,  true,  false);
insert into Hafen values('AP3', 30.99,  false, true);
insert into Hafen values('AP4', 90.99,  true,  true);


insert into Segelschiff(hafen, name, baujahr, kojen, kapazitaet) values ('AP1', 'Segelschiff1', 1994, 100, 200);
insert into Segelschiff(hafen, name, baujahr, kojen, kapazitaet) values ('AP2', 'Segelschiff2', 1980, 50, 100);
insert into Segelschiff(hafen, name, baujahr, kojen, kapazitaet) values ('AP3', 'Segelschiff3', 1984, 200, 200);
insert into Segelschiff(hafen, name, baujahr, kojen, kapazitaet) values ('AP4', 'Segelschiff4', 1999, 100, 600);


insert into Tour(bez, dauer, geplant_von) values ('It passes through 5 states', 5, 1);
insert into Tour(bez, dauer, geplant_von) values ('It goes from A to M', 10, 7);
insert into Tour(bez, dauer, geplant_von) values ('The most amazing journey', 15, 7);
insert into Tour(bez, dauer, geplant_von) values ('It goes from C to M', 20, 10);
insert into Tour(bez, dauer, geplant_von) values ('An exciting trip', 25, 10);


insert into Teiltour values (1010,1040);
insert into Teiltour values (1020,1040);
insert into Teiltour values (1030,1040);


insert into TourAnkerplatz values (1000, 'AP1', 1);
insert into TourAnkerplatz values (1010, 'AP2', 2);
insert into TourAnkerplatz values (1020, 'AP5', 4);
insert into TourAnkerplatz values (1030, 'AP6', 5);
insert into TourAnkerplatz values (1040, 'AP7', 9);


insert into Gechartert values (1, 1, 'AP1', 1,  1000, '1994-04-27');
insert into Gechartert values (7, 2, 'AP3', 3,  1010, '2018-04-28');
insert into Gechartert values (10, 3, 'AP4', 4, 1030, '2018-04-29');


commit;  -- so that we don't have autocommit from Postgres after each line 