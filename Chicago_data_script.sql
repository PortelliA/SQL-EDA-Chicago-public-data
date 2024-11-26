#Project Summary
#In this project, we explored three datasets provided by the City of Chicago’s Data Portal to complete various SQL tasks. The goal was to analyze data and solve assignment problems using the following datasets:
#Socioeconomic Indicators in Chicago:
#Contains six socioeconomic indicators of public health significance and a "hardship index" for each Chicago community area from 2008-2012.
#Detailed description and dataset: https://data.cityofchicago.org/Health-Human-Services/Census-Data-Selected-socioeconomic-indicators-in-C/kn9c-c2s2
#Chicago Public Schools:
#Shows school-level performance data used to create CPS School Report Cards for the 2011-2012 school year.
#Detailed description and dataset: https://data.cityofchicago.org/Education/Chicago-Public-Schools-Progress-Report-Cards-2011-/9xs2-f89t
#Chicago Crime Data:
#Reflects reported incidents of crime in Chicago from 2001 to present.
#Detailed description and dataset: https://data.cityofchicago.org/Public-Safety/Crimes-2001-to-present/ijzp-q8t2
#Due to the large size of the crime dataset, a smaller subset was used for this assignment. 

CREATE SCHEMA chicago_information;
USE chicago_information;
#In a seperate page I uploaded the files through a script, I'll provide the scripts in github!


#Find the total number of crimes recorded in the CRIME table.
SELECT COUNT(*) AS total_crimes
FROM chicago_crime;

#Retrieve first 10 rows from the CRIME table.
SELECT *
FROM chicago_crime
LIMIT 10;


#How many crimes involve an arrest?
SELECT COUNT(*) AS total_arrests
FROM chicago_crime
WHERE arrest = 'true';



#Which unique types of crimes have been recorded at GAS STATION locations?
SELECT DISTINCT primary_type
FROM chicago_crime
WHERE location_description = 'GAS STATION';




#In the CENUS_DATA table list all Community Areas whose names start with the letter ‘B’.
SELECT community_area_name
FROM chicago_socioeconomic_data
WHERE community_area_name LIKE 'B%';



#Which schools in Community Areas 10 to 15 are healthy school certified?
SELECT name_of_school
FROM chicago_public_schools
WHERE community_area_number BETWEEN 10 AND 15
AND healthy_school_certified = 'Yes';



#What is the average school Safety Score?
SELECT AVG(safety_score) AS avg_safety_score
FROM chicago_public_schools;


#List the top 5 Community Areas by average College Enrollment [number of students]
SELECT community_area_name, AVG(college_enrollment) AS avg_college_enrollment
FROM chicago_public_schools
GROUP BY community_area_name
ORDER BY avg_college_enrollment DESC
LIMIT 5;



#Use a sub-query to determine which Community Area has the least value for school Safety Score?
SELECT community_area_name
FROM chicago_public_schools
WHERE safety_score = (
    SELECT MIN(safety_score)
    FROM chicago_public_schools
);

#[Without using an explicit JOIN operator] Find the Per Capita Income of the Community Area which has a school Safety Score of 1.
SELECT per_capita_income
FROM chicago_socioeconomic_data
WHERE community_area_number = (
    SELECT community_area_number
    FROM chicago_public_schools
    WHERE safety_score = 1
    LIMIT 1
);





#Write and execute a SQL query to list the school names, community names and average attendance for communities with a hardship index of 98.
SELECT 
cps.NAME_OF_SCHOOL, 
cps.COMMUNITY_AREA_NAME,
cps. Average_teacher_attendance,
csd.HARDSHIP_INDEX
FROM chicago_public_schools cps
JOIN chicago_socioeconomic_data csd
ON cps.COMMUNITY_AREA_NAME = csd.COMMUNITY_AREA_NAME
WHERE csd.HARDSHIP_INDEX = 98;


#Write & execute a SQL query to list all crimes that took place at a school. Include case number, crime type & community name
SELECT 
    cc.CASE_NUMBER,
    cc.PRIMARY_TYPE,
    cps.COMMUNITY_AREA_NAME
FROM 
    chicago_crime cc
LEFT JOIN 
    chicago_public_schools cps 
ON 
    cc.COMMUNITY_AREA_NUMBER = cps.COMMUNITY_AREA_NUMBER
WHERE 
    cc.LOCATION_DESCRIPTION LIKE '%SCHOOL%';



#Creating a View, reducing information released so the public cant see the actual scores given to the school
#Write and execute a SQL statement to create a view showing the columns listed:
#NAME_OF_SCHOOL, Safety_icon, Family_Involvement_Icon, Environment_Icon, Instruction_Icon, Leaders_Icon & Teachers_Icon
CREATE VIEW School_Ratings AS
SELECT
NAME_OF_SCHOOL AS School_Name,
Safety_Icon AS Safety_rating,
Family_Involvement_Icon AS Family_rating,
Environment_Icon AS Environment_Rating,
Instruction_Icon AS Instruction_Rating,
Leaders_Icon AS Leaders_Rating,
Teachers_Icon AS Teachers_Rating
FROM chicago_public_schools;

SELECT*
FROM School_Ratings;

























