DROP TABLE Animal;
CREATE TABLE Animal (
    animal_id integer primary key,
    lrid integer NOT NULL default 0,
    tag varchar(16) NOT NULL default '',
    rfid varchar(15) NOT NULL default '',
    nlis varchar(16) NOT NULL default '',
    is_new integer NOT NULL default 1,
    draft varchar(20) NOT NULL default '',
    sex varchar(20) NOT NULL default '',
    dob timestamp,
    sire varchar(16) NOT NULL default '',
    dam varchar(16) NOT NULL default '',
    breed varchar(20) NOT NULL default '',
    colour varchar(20) NOT NULL default '',
    weaned integer NOT NULL default 0 ,
    prev_tag varchar(10) NOT NULL default '',
    prev_pic varchar(20) NOT NULL default '',
    note varchar(30) NOT NULL default '',
    note_date timestamp,
    is_exported integer NOT NULL default 0,
    is_history integer NOT NULL default 0,
    is_deleted integer NOT NULL default 0,
    tag_sorter varchar(48) NOT NULL default '',
    donordam varchar(16) NOT NULL default '',
    whp timestamp,
    esi timestamp,
status varchar(20) NOT NULL default '',
status_date timestamp,
overall_adg varchar(20) NOT NULL default '',
current_adg varchar(20) NOT NULL default '',
last_weight varchar(20) NOT NULL default '',
last_weight_date timestamp,
selected integer default 0,
animal_group varchar(20) NOT NULL default '',
current_farm varchar(20) NOT NULL default '',
current_property varchar(20) NOT NULL default '',
current_area varchar(20) NOT NULL default '',
current_farm_date timestamp,
current_property_date timestamp,
current_area_date timestamp,
animal_group_date timestamp,
sex_date timestamp,
breed_date timestamp,
dob_date timestamp,
colour_date timestamp,
prev_pic_date timestamp,
sire_date timestamp,
dam_date timestamp,
donordam_date timestamp,
prev_tag_date timestamp,
tag_date timestamp,
rfid_date timestamp,
nlis_date timestamp,
modified timestamp,
full_rfid varchar(16) default '',
full_rfid_date timestamp);
DROP TABLE Note;
CREATE TABLE Note (
animal_id integer NOT NULL,
created timestamp,
note varchar(30) NOT NULL,
session_id integer NOT NULL,
is_deleted integer default 0,
is_alert integer default 0,
primary key( animal_id, created ));
DROP TABLE SessionAnimalActivity;
CREATE TABLE SessionAnimalActivity (
session_id integer NOT NULL,
animal_id integer NOT NULL,
activity_code integer NOT NULL,
when_measured timestamp NOT NULL,
latestForSessionAnimal integer default 1,
latestForAnimal integer default 1,
is_history integer NOT NULL default 0,
is_exported integer NOT NULL default 0,
is_deleted integer NOT NULL default 0,
primary key( session_id, animal_id, activity_code, when_measured )
);
DROP TABLE SessionAnimalTrait;
CREATE TABLE SessionAnimalTrait (
session_id integer NOT NULL,
animal_id integer NOT NULL,
trait_code integer NOT NULL,
alpha_value varchar(20) NOT NULL default '',
alpha_units varchar(10) NOT NULL default '',
when_measured timestamp NOT NULL,
latestForSessionAnimal integer default 1,
latestForAnimal integer default 1,
is_history integer NOT NULL default 0,
is_exported integer NOT NULL default 0,
is_deleted integer default 0,
primary key(session_id, animal_id, trait_code, when_measured));
DROP TABLE PicklistValue;
CREATE TABLE PicklistValue (
picklistvalue_id integer primary key,
picklist_id integer,
value varchar(30)
);
-- read the CSV file into the table
\copy Animal from 'Animal.csv' WITH DELIMITER ',' CSV HEADER;
-- read the CSV file into the table
\copy Note from 'Note.csv' WITH DELIMITER ',' CSV HEADER;
-- read the CSV file into the table

\copy SessionAnimalActivity from 'SessionAnimalActivity.csv' WITH DELIMITER ',' CSV HEADER;
-- read the CSV file into the table
\copy SessionAnimalTrait from 'SessionAnimalTrait.csv' WITH DELIMITER ',' CSV HEADER;
-- read the CSV file into the table
\copy PicklistValue from 'PicklistValue.csv' WITH DELIMITER ',' CSV HEADER;

DROP VIEW BirthWeights;
DROP VIEW VigorScores;
DROP VIEW NumOfKids;
DROP VIEW DamMilk;
DROP TABLE Goats;
DROP TABLE GoatAttributes;
CREATE TABLE Goats(
    animal_id integer primary key,
    lrid integer NOT NULL default 0,
    tag varchar(16) NOT NULL default '',
    rfid varchar(15) NOT NULL default '',
    nlis varchar(16) NOT NULL default '',
    draft varchar(20) NOT NULL default '',
    sex varchar(20) NOT NULL default '',
    dob timestamp,
    sire varchar(16) NOT NULL default '',
    dam varchar(16) NOT NULL default '',
    weaned integer NOT NULL default 0 ,
    tag_sorter varchar(48) NOT NULL default '',
    esi timestamp,
    overall_adg varchar(20) NOT NULL default '',
    current_adg varchar(20) NOT NULL default '',
    last_weight varchar(20) NOT NULL default '',
    last_weight_date timestamp, 
    animal_group varchar(20) NOT NULL default '',
    modified timestamp
);

CREATE TABLE GoatAttributes
(
    animal_id integer NOT NULL,
    trait_code integer NOT NULL,
    alpha_value varchar(20) default '',
    pointVal integer NOT NULL default 0
);

INSERT INTO Goats(animal_id,lrid,tag,rfid,nlis,draft,sex,dob,sire,dam,weaned,tag_sorter,esi,overall_adg,current_adg,last_weight,last_weight_date,animal_group,modified)
SELECT animal_id,lrid,tag,rfid,nlis,draft,sex,dob,sire,dam,weaned,tag_sorter,esi,overall_adg,current_adg,last_weight,last_weight_date,animal_group,modified
FROM Animal;

INSERT INTO GoatAttributes(animal_id,trait_code,alpha_value,pointVal)
SELECT animal_id,trait_code,alpha_value,0
FROM SessionAnimalTrait;

DROP VIEW Doe;
DROP VIEW Child;

CREATE VIEW Doe  AS
    SELECT *
    FROM Goats
    WHERE sex='Female';

CREATE VIEW Child AS
    SELECT *
    FROM Goats, Doe
    WHERE Goats.dam=Doe.dam;


CREATE VIEW BirthWeights (animal_id,birth_weight) AS
    SELECT animal_id, CAST(MAX(alpha_value) AS int)
    FROM GoatAttributes 
    WHERE trait_code=357
    GROUP BY animal_id;

CREATE VIEW VigorScores (animal_id,vigorScores) AS
    SELECT animal_id, MAX(alpha_value)
    FROM GoatAttributes
    WHERE trait_code=230
    GROUP BY animal_id;

CREATE VIEW NumOfKids(animal_id,children) AS
    SELECT animal_id, MAX(alpha_value)
    FROM GoatAttributes
    WHERE trait_code=486
    GROUP BY animal_id;

CREATE VIEW DamMilk(animal_id,milk) AS
    SELECT animal_id, MAX(alpha_value)
    FROM GoatAttributes
    WHERE trait_code=475
    GROUP BY animal_id;

UPDATE GoatAttributes
SET pointVal=pointVal+3
WHERE trait_code=357 and alpha_value<= '6' and alpha_value> '0';

UPDATE GoatAttributes
SET pointVal=pointVal+5
WHERE trait_code=357 and alpha_value > '6';

UPDATE GoatAttributes
SET pointVal=pointVal+5
WHERE trait_code=230 and alpha_value > '6';


CREATE VIEW AllAttributes (bwt,vigor,children,milk,pointVal)
SELECT BirthWeights.birth_weight,VigorScores.vigorScores,NumOfKids.children,DamMilk.milk
FROM DamMilk JOIN(NumOfKids JOIN(VigorScores JOIN BirthWeights ON animal_id) ON animal_id) ON animal_id

DROP TABLE Animal;
DROP TABLE Note;
DROP TABLE PicklistValue;
DROP TABLE SessionAnimalActivity;
DROP TABLE SessionAnimalTrait;

