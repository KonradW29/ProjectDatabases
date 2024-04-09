DROP TABLE Goats;
CREATE TABLE Goats
(
    animal_id integer primary_key,
    lrid integer NOT NULL default 0,
    tag varchar(16) NOT NULL default ' ',
    rfid varchar(15) NOT NULL default ' ',
    nlis varchar(16) NOT NULL default ' ',
    draft varchar(20) NOT NULL default ' ',
    sex varchar(20) NOT NULL default ' ',
    dob timestamp,
    sire varchar(16) NOT NULL default '',
    dam varchar(16) NOT NULL default ' ',
    weaned integer NOT NULL default 0,
    tag_sorter varchar(48) NOT NULL default ' ',
    esi timestamp,
    overall_adg varchar(20) NOT NULL default ' ',
    current_adg varchar(20) NOT NULL default ' ',
    last_weight varchar(20) NOT NULL default ' ',
    last_weight_date timestamp,
    animal_group varchar(20) NOT NULL default ' ',
    modified timestamp,
);
DROP TABLE GoatAttritubes;
CREATE TABLE GoatAttritubes
(
    animal_id integer,
    trait_code integer,
    alpha_value varchar(20) NOT NULL default ' ',
);