FROM Animal;

INSERT INTO GoatAttributes(animal_id,trait_code,alpha_value)
SELECT animal_id,trait_code,alpha_value
FROM SessionAnimalTrait;

DROP VIEW BirthWeights;
DROP VIEW VigorScores;
DROP VIEW NumOfKids;
DROP VIEW DamMilk;

CREATE VIEW BirthWeights (animal_id,birth_weight) AS
    SELECT animal_id, MAX(alpha_value)
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

CREATE VIEW DamMilk(animal_id,DamMilk) AS
    SELECT animal_id, MAX(alpha_value)
    FROM GoatAttributes
    WHERE trait_code=475
    GROUP BY animal_id;


DROP TABLE Animal;
DROP TABLE Note;
DROP TABLE PicklistValue;
DROP TABLE SessionAnimalActivity;
DROP TABLE SessionAnimalTrait;

