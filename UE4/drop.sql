drop table Gechartert ;
drop table TourAnkerplatz ;
drop table Teiltour ;

alter table Skipper drop constraint lieblingTourConstraint;

drop table Tour ;
drop table Segelschiff ;
drop table Hafen ;
drop table Fjord ;
drop table Tankstelle ;
drop table Ankerplatz ;
drop table CrewKoch ;
drop table CrewErsthelfer ;
drop table CrewMitglieder ;
drop table Crew ;
drop table Skipper ;
drop table Ersthelfer ;
drop table Koch ;
drop table Segler ;

drop sequence seq_tour;
drop sequence seq_segelschiff;
drop sequence seq_crew;
drop sequence seq_segler;
drop type schein_enum;
