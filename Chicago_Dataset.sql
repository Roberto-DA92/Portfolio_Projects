-- List the school names, community names and average attendance for communities with a hardship index of 98




SELECT ps.NAME_OF_SCHOOL,
ps.COMMUNITY_AREA_NAME,
ps.AVERAGE_STUDENT_ATTENDANCE
FROM [chicago_data].[dbo].[ChicagoPublicSchools$] AS ps
JOIN [chicago_data].[dbo].[ChicagoCensusData$] AS cs
ON ps.COMMUNITY_AREA_NAME = cs.COMMUNITY_AREA_NAME
WHERE HARDSHIP_INDEX = 98;




-- List all crimes that took place at a school. Include case number, crime type and community name.
 



SELECT crime.CASE_NUMBER,
crime.PRIMARY_TYPE,
ps.COMMUNITY_AREA_NAME
FROM [chicago_data].[dbo].[ChicagoCrimeData$] AS crime
JOIN [chicago_data].[dbo].[ChicagoPublicSchools$] AS ps
ON crime.COMMUNITY_AREA_NUMBER = ps.COMMUNITY_AREA_NUMBER
WHERE crime.LOCATION_DESCRIPTION = 'SCHOOL, PUBLIC, GROUNDS';



/* Create a view from the Chicago Public Schools table. View's name should be Name of schools. 
Columns. School_Name, Safety_Icon like Safety_Rating, FamilyInvolvementIcon like Family_Rating, Environment_Icon like Environment_Rating, 
Instruction_Icon like Instruction_Rating, Leaders_Icon like Leaders_Rating, Teachers_Icon like Teachers_Rating */



CREATE VIEW Name_Of_Schools
AS 
SELECT NAME_OF_SCHOOL AS School_Name, Safety_Icon AS Safety_Rating,
Family_Involvement_Icon AS Family_Rating,
Environment_Icon AS Environment_Rating,
Instruction_Icon AS Instruction_Rating,
Leaders_Icon AS Leaders_Rating, 
Teachers_Icon AS Teachers_Rating
FROM [chicago_data].[dbo].[ChicagoPublicSchools$];



-- Return all of the columns from the view.


SELECT *
FROM Name_Of_Schools;


-- Returns just the school name and leaders rating from the view.



SELECT School_Name, 
Leaders_Rating
FROM Name_Of_Schools;




/* Write the structure of a query to create or replace a stored procedure called UPDATELEADERSSCORE 
that takes a inSchoolID parameter as an integer and a inLeaderScore parameter as an integer. */



CREATE PROCEDURE UPDATELEADERSCORE 
(
@InSchoolID INT,
@InLeaderScore INT
)
AS
BEGIN 
SELECT *
FROM [chicago_data].[dbo].[ChicagoPublicSchools$]
END

-- I dropped a Procedure because of wrong imputs of elements, I had to re-run the previous query.



IF EXISTS (
SELECT *
FROM [chicago_data].[dbo].[ChicagoPublicSchools$]
)
DROP PROCEDURE UPDATELEADERSCORE



