/*
    2024 Goat Database Project
    Konrad Wnorowski, Nicholas Merritt, Varun Pawar 
*/

--Animal table from Animal.csv
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
    full_rfid_date timestamp
);

--Note table from Note.csv
DROP TABLE Note;
CREATE TABLE Note (
    animal_id integer NOT NULL,
    created timestamp,
    note varchar(30) NOT NULL,
    session_id integer NOT NULL,
    is_deleted integer default 0,
    is_alert integer default 0,
    primary key( animal_id, created )
);

--SessionAnimalActivity table from SessionAnimalActivity.csv
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

--SessionAnimalTrait table from SessionAnimalTrait.csv
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
    primary key(session_id, animal_id, trait_code, when_measured)
);

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

--Dropping the views and tables to avoid creating something which already exists
DROP VIEW HighSold;
DROP VIEW MiddleSold;
DROP VIEW LowSold;
DROP VIEW HighQuality;
DROP VIEW MiddleQuality;
DROP VIEW LowQuality;
DROP VIEW SoloGoats;
DROP VIEW SumOfPoints;
DROP TABLE Goats;
DROP TABLE GoatAttributes;

--The goats table that the database primarily use
CREATE TABLE Goats (
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
    status varchar(20) NOT NULL default '',
    stat_date timestamp,
    overall_adg varchar(20) NOT NULL default '',
    current_adg varchar(20) NOT NULL default '',
    last_weight varchar(20) NOT NULL default '',
    last_weight_date timestamp, 
    animal_group varchar(20) NOT NULL default '',
    modified timestamp
);

--Goat attributes to hold points and keep track of traits of the goats
CREATE TABLE GoatAttributes (
    animal_id integer NOT NULL,
    trait_code integer NOT NULL,
    alpha_value varchar(20) default '',
    pointVal integer NOT NULL default 0
);

--Poppulate the goats table using the data from the animal table
INSERT INTO Goats(animal_id,lrid,tag,rfid,nlis,draft,sex,dob,sire,dam,weaned,tag_sorter,status,stat_date,esi,overall_adg,current_adg,last_weight,last_weight_date,animal_group,modified)
SELECT animal_id,lrid,tag,rfid,nlis,draft,sex,dob,sire,dam,weaned,tag_sorter,status,status_date,esi,overall_adg,current_adg,last_weight,last_weight_date,animal_group,modified
FROM Animal;

--Poppulate the goat attributes table using the data from the SessionAnimalTrait table
INSERT INTO GoatAttributes(animal_id,trait_code,alpha_value,pointVal)
SELECT animal_id,trait_code,alpha_value,0
FROM SessionAnimalTrait;


/*Updating GoatAttributes to insert point values*/

/*Birth weight points*/
UPDATE GoatAttributes
SET pointVal = pointVal + 3
WHERE trait_code=357 and alpha_value <= '6' and alpha_value > '0';

UPDATE GoatAttributes
SET pointVal = pointVal + 5
WHERE trait_code=357 and alpha_value > '6';

/*Sibling points*/
UPDATE GoatAttributes
SET pointVal = pointVal + 2
WHERE alpha_value = '1 Single';

UPDATE GoatAttributes
SET pointVal = pointVal + 3
WHERE alpha_value = '3 Triplets';

UPDATE GoatAttributes
SET pointVal = pointVal + 4
WHERE alpha_value = '2 Twins';

/*Milking points*/
UPDATE GoatAttributes
SET pointVal = pointVal + 5
WHERE alpha_value = '1 Good Milk';

UPDATE GoatAttributes
SET pointVal = pointVal + 1
WHERE alpha_value = '2 Poor Milk' or alpha_value = 'OK milk';

/*Mothering points*/
UPDATE GoatAttributes
SET pointVal = pointVal + 5
WHERE trait_code = 740 and alpha_value = 'Good mom';

UPDATE GoatAttributes
SET pointVal = pointVal + 1
WHERE trait_code = 740 and alpha_value != 'Good mom' and alpha_value != '';

/*Vigor points*/
UPDATE GoatAttributes
SET pointVal = pointVal + 5
WHERE trait_code = 230 and alpha_value = '1';

UPDATE GoatAttributes
SET pointVal = pointVal + 3
WHERE trait_code = 230 and alpha_value = '2';

/*Number weaned points*/

UPDATE GoatAttributes
SET pointVal= pointVal + 5
WHERE animal_id IN (SELECT animal_id FROM Goats WHERE Goats.last_weight_date - Goats.dob > interval '90 days');

/*Views which are used for the database queries*/

/*View which sums up point values for each goat*/
CREATE VIEW SumOfPoints (animal_id,totalPoints) AS 
SELECT animal_id, SUM(pointVal)
FROM GoatAttributes
GROUP BY animal_id;

/*View which combines the tag, animal_id, dam attributes from goats with the totalPoints attribute from SumOfPoints, and adds a new quality attribute*/
CREATE VIEW SoloGoats (tag, quality, animal_id,dam,totalPoints) AS
SELECT tag, '', Goats.animal_id, Goats.dam, SumOfPoints.totalPoints
FROM Goats INNER JOIN SumOfPoints ON Goats.animal_id=SumOfPoints.animal_id;

/*View which groups goats into the high quality range, based on their total points */
CREATE VIEW HighQuality (tag, quality, animal_id,dam,totalPoints) AS 
SELECT SoloGoats.tag, 'High', SoloGoats.animal_id, SoloGoats.dam, SoloGoats.totalPoints
FROM SoloGoats
WHERE totalPoints >= 80;

/*View which groups goats into the middle quality range, based on their total points */
CREATE VIEW MiddleQuality (tag, quality, animal_id,dam,totalPoints) AS
SELECT SoloGoats.tag, 'Middle', SoloGoats.animal_id, SoloGoats.dam, SoloGoats.totalPoints
FROM SoloGoats
WHERE totalPoints >= 30 AND totalPoints < 80;

/*View which groups goats into the low quality range, based on their total points */
CREATE VIEW LowQuality (tag, quality, animal_id,dam,totalPoints) AS 
SELECT SoloGoats.tag, 'Low', SoloGoats.animal_id, SoloGoats.dam, SoloGoats.totalPoints
FROM SoloGoats
WHERE totalPoints < 30 AND totalPoints > 0;

/*View which counts how many high quality goats were sold*/
CREATE VIEW HighSold(quality,SoldCount) AS
SELECT HighQuality.quality, Count(status)
FROM HighQuality INNER JOIN Goats ON HighQuality.animal_id=Goats.animal_id
WHERE Goats.status='Sold'
GROUP BY HighQuality.quality;

/*View which counts how many middle quality goats were sold*/
CREATE VIEW MiddleSold(quality,SoldCount) AS
SELECT MiddleQuality.quality, Count(status)
FROM MiddleQuality INNER JOIN Goats ON MiddleQuality.animal_id=Goats.animal_id
WHERE Goats.status='Sold'
GROUP BY MiddleQuality.quality;

/*View which counts how many low quality goats were sold*/
CREATE VIEW LowSold(quality,SoldCount) AS
SELECT LowQuality.quality, Count(status)
FROM LowQuality INNER JOIN Goats ON LowQuality.animal_id=Goats.animal_id
WHERE Goats.status='Sold'
GROUP BY LowQuality.quality;