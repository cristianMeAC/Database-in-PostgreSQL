create sequence seq_segler start with 1 increment by 1;      --  Aufgabe 1 b) define sequence

create sequence seq_crew;
create sequence seq_segelschiff;

create sequence seq_tour start with 1000 increment by 10;    --  Aufgabe 1 c) 
create type schein_enum as enum ('A', 'B', 'C');             --  Aufgabe 1 d)



create table Segler(
    id              integer     not null primary key default nextval('seq_segler'),  -- default nextval() ca si auto_increment
    name            varchar(50) not null                                          ,
    gebdatum        date        not null                                          ,
    notfallkontakt  varchar(50) not null
);

create table Koch(
    id              integer primary key references Segler(id),
    seehauben       integer not null
);

create table Ersthelfer(
    id              integer     primary key references Segler(id),
    ausbildung      varchar(50) not null
);

create table Skipper(   
     id              integer        primary key references Segler(id)   ,
     schein          schein_enum    not null                            ,
     seemeilen       integer        not null                            ,
     lieblingstour   integer                  -- we leave it like this for awhile
);

create table Crew(
    leiter           integer        not null references Skipper(id)         ,
    cid              integer        not null default nextval('seq_crew')    , 
    crewname         varchar(50)    not null                                ,
    constraint crewPK primary key (leiter, cid)   -- adding a label to this Constraint for future reference 
);

create table CrewMitglieder(
    segler          integer         not null references Segler(id),
    cleiter         integer         not null                      ,
    cid             integer         not null                      ,
    constraint CrewMitgliederPK primary key (segler, cleiter, cid),
    constraint CrewMitgliederFK foreign key (cleiter, cid) references Crew(leiter, cid)
);

create table CrewErsthelfer(
    ersthelfer      integer         not null references Ersthelfer(id) ,
    cleiter         integer         not null                           ,
    cid             integer         not null                           ,
    constraint CrewErsthelferPK primary key (ersthelfer, cleiter, cid) ,
    constraint CrewErsthelferFK_1 foreign key (cleiter, cid) references Crew(leiter, cid),
    constraint CrewErsthelferFK_2 foreign key (ersthelfer, cleiter, cid) references CrewMitglieder(segler, cleiter, cid)     -- Aufgabe 1, i) Unterpunkt 4, este ceva in plus, o a 2-a FK .... ce am vorbit cu Stefan; ce este in stg trebuie sa fie si in dreapta 
);

create table CrewKoch(
    koch            integer         not null references Koch(id)            ,
    cleiter         integer         not null                                ,
    cid             integer         not null                                ,
    constraint CrewKochPK primary key  (koch, cleiter, cid)                 ,
    constraint CrewKochFK_1 foreign key (cleiter, cid) references Crew(leiter, cid)  ,
    constraint CrewKochFK_2 foreign key (koch, cleiter, cid) references CrewMitglieder(segler, cleiter, cid)                 -- Aufgabe 1, i) Unterpunkt 4, este ceva in plus, o a 2-a FK
);

create table Ankerplatz(
    krz             char(10)         not null primary key    ,   -- Aufgabe 1, f)
    koordinaten     varchar(10)     not null                ,
    name            varchar(50)     not null  
);

create table Tankstelle(
    krz             char(10)         not null references Ankerplatz(krz),  -- daca scrii REFERENCES este foreign key implizit 
    selfservice     boolean         not null                           ,                      
    constraint TankstellePK primary key (krz)    
);

create table Fjord(
    krz             char(10)        not null primary key references Ankerplatz(krz) ,
    nacht           boolean         not null                                        ,
    beschreibung    varchar(50)     not null
);

create table Hafen(
     krz             char(10)        not null primary key references Ankerplatz(krz),
     gebuehr         numeric(8,2)    not null,                                          -- Aufgabe 1) e) 8 e cate cifre ai si 2, cate cifre ai dupa ,
     duschen         boolean         not null,                                          -- daca nu treceam not null, era lasat campul gol
     einkauf         boolean         not null
);

create table Segelschiff(
    hafen           char(10)        not null references Hafen(krz)                              , 
    sid             integer         not null default nextval('seq_segelschiff')                 ,
    name            varchar(50)     not null                                                    ,
    baujahr         integer         not null                                                    ,    
    kojen           integer         not null check (kojen >= 0)                                 ,   -- Aufgabe 1, i) Unterpunkt 1 
    kapazitaet      integer         not null check (kapazitaet >= 0)                            ,
    constraint SegelschiffPK primary key (sid, hafen)                                            
);

create table Tour(
    tid             integer         not null primary key default nextval('seq_tour')    ,
    bez             varchar(50)     not null                                            ,
    dauer           integer         not null                                            ,
    geplant_von     integer         not null references Skipper(id)
);


alter table Skipper
add constraint lieblingTourConstraint foreign key (lieblingstour) references Tour(tid) deferrable initially deferred; -- Aufgabe 1, g)


create table Teiltour(
    tid             integer         not null references Tour(tid),
    teil_von        integer         not null references Tour(tid),
    constraint TeiltourPK primary key (tid, teil_von)
);

create table TourAnkerplatz(
    tid             integer         not null references Tour(tid)       ,
    krz             char(10)        not null references Ankerplatz(krz) ,
    tag             integer         not null check (tag > 0)            ,  -- Aufgabe 1, i) Unterpunkt 2
    constraint TourAnkerplatzPK primary key (tid, krz, tag)             ,  -- Aufgabe 1, a) Unterpunkt 1 (explicatie poza) - spune verschiedene Tagen
    constraint TourAnkerplatz_constraints unique (tid, tag)                -- Aufgabe 1, i) Unterpunkt 3
);

create table Gechartert(
    cleiter         integer         not null                                    ,
    cid             integer         not null                                    ,
    hafen           char(10)        not null                                    ,
    sid             integer         not null                                    ,
    tid             integer         not null                                    ,
    startdatum      date            not null                                    ,
    constraint GechartertFK1 foreign key (tid) references Tour (tid)            ,
    constraint GechartertFK2 foreign key (cleiter, cid) references Crew (leiter, cid)       ,
	constraint GechartertFK3 foreign key (hafen, sid) references Segelschiff (hafen, sid)   ,
    constraint GechartertPK  primary key (cleiter, cid, hafen, sid, tid, startdatum)        -- Aufgabe 1, a) Unterpunkt 2 
);









