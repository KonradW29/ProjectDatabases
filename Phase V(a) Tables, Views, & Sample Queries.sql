CREATE TABLE Doe (TotalPoints int, GoatId int, BirthWeight float, Weight float, Date date, DoeSpecificPoints int);
CREATE TABLE Siblings (SiblingId int, SiblingPoints int);
CREATE TABLE Children (MotherId int, GoatId int, ChildrenPoints int, Weight float, WeanWeeks int, VigorScore int, Date date);
CREATE TABLE Milk (GoatId int, MilkPoints int);
CREATE TABLE Price (Worded Price int, PricePoints int, GoatId int);

CREATE VIEW DoeBW AS
SELECT Weight, DoeSpecificPoints
FROM Doe
CREATE VIEW DoeWeight AS
SELECT Weight, Date, DoeSpecificPoints
FROM Doe
CREATE VIEW ChildrenWeanWeeks AS
SELECT WeanWeeks, ChildrenPoints
FROM Children
CREATE VIEW ChildrenWeights AS
SELECT Weight, Date, ChildrenPoints
FROM Children
CREATE VIEW ChildrenVigor AS
SELECT VigorScore, ChildrenPoints
FROM Children

INSERT INTO Doe (GoatId, BirthWeight, Weight, Date)
VALUES (‘1’, ‘6.5’, ‘115.1’, ‘2023-29-3’);
INSERT INTO Children (MotherId, GoatId, Weight, WeanWeeks, VigorScore, Date)
VALUES (‘1’, ‘101’, ‘56.3’, ‘10.5’, ‘5’, ‘2023-29-3’);
SELECT GoatId, Weight
FROM Children;
SELECT *
FROM ChildrenWeanWeeks;
UPDATE Children
SET Weight = ‘63.5’
WHERE GoatId = ‘56.3’;
