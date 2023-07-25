/* We wil Explore LA Crime Datasets */

-- lacrime database
USE lacrime;

-- We will check the total count in the Crime 2010-2019 table
SELECT count(*) FROM lacrime.crimeto2019;
-- contains 2,135,664 observations

-- Now we will check the Crime 2020-2022 dataset
SELECT count(*) FROM lacrime.crimeto2020;
-- COntains 757,141 observations

-- Lets check the first date and last date fro crimeto2019
SELECT Date_RPTD
FROM lacrime.crimeto2019
ORDER BY Date_RPTD ASC
LIMIT 1;
-- the first date on the table is on January 1, 2010

SELECT Date_RPTD
FROM lacrime.crimeto2019
ORDER BY Date_RPTD DESC
LIMIT 1;
-- the last date on the table is on December 31, 2022

-- Crime 2020 table
SELECT Date_RPTD
FROM lacrime.crimeto2020
ORDER BY Date_RPTD ASC
LIMIT 1;
-- The first date on this table is on January 1, 2020

SELECT Date_RPTD
FROM lacrime.crimeto2020
ORDER BY Date_RPTD DESC
LIMIT 1;
-- The first date on this table is on December 31, 2022

/* Observe that crime 2020 is a subset of the crime 2019 table, however since crime 2020 is the most recent table we will keep the data and work on the lacrime2019 table */

Select *
FROM crimeto2019;

/* The LAPD has 21 Community Police Stations referred to as Geographic Areas within the department. 
These Geographic Areas are sequentially numbered from 1-21. */
SELECT AREA, AREA_NAME
FROM crimeto2019
GROUP BY AREA, AREA_NAME;

/* Indicates the crime committed. (Same as Crime Code 1)
*/
SELECT CRM_CD, CRM_CD_DESC
FROM crimeto2019
GROUP BY CRM_CD, CRM_CD_DESC;

/* 	
The type of structure, vehicle, or location where the crime took place. */
SELECT PREMIS_CD, PREMIS_DESC
FROM crimeto2019
GROUP BY PREMIS_CD, PREMIS_DESC;

/* now we fix the date column so we work with time easier */
Select Date_RPTD, CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR) as DATE_OF_CRIME
FROM crimeto2019;

Select *
FROM crimeto2019;

/* we will select certain columns note original data contains 28 columns */
SELECT STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y") as DATE_OF_CRIME,
	YEAR(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as YEAR,
    MONTH(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as MONTH,
    MONTHNAME(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as MONTH_NAME,
    QUARTER(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as QUARTER,
	AREA,AREA_NAME, CRM_CD,CRM_CD_DESC, VICT_AGE,VICT_SEX,VICT_DESCENT,
    PREMIS_DESC, WEAPON_DESC, STATUS_DESC, CRM_CD_1, CRM_CD_2,
    LAT,LON
FROM crimeto2019;

SET GLOBAL net_read_timeout = 400;

/* create a new table for this clean data for the table crimeto2019*/
CREATE TABLE IF NOT EXISTS allcrime AS
SELECT STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y") as DATE_OF_CRIME,
	YEAR(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as YEAR,
    MONTH(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as MONTH,
    MONTHNAME(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as MONTH_NAME,
    QUARTER(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as QUARTER,
	AREA,AREA_NAME, CRM_CD,CRM_CD_DESC, CRM_CD_1, CRM_CD_2, 
    VICT_AGE,VICT_SEX,VICT_DESCENT, PREMIS_DESC, WEAPON_DESC, STATUS_DESC, 
    LAT,LON
FROM crimeto2019;

/* we also create a new table for the cleaned data for the table crimeto2020 */
CREATE TABLE IF NOT EXISTS allcrimenew AS
SELECT STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y") as DATE_OF_CRIME,
	YEAR(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as YEAR,
    MONTH(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as MONTH,
    MONTHNAME(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as MONTH_NAME,
    QUARTER(STR_TO_DATE(CAST(SUBSTRING(Date_RPTD,1,LOCATE(" ",Date_RPTD)) AS CHAR), "%m/%d/%Y")) as QUARTER,
	AREA,AREA_NAME, CRM_CD,CRM_CD_DESC, CRM_CD_1, CRM_CD_2, 
    VICT_AGE,VICT_SEX,VICT_DESCENT, PREMIS_DESC, WEAPON_DESC, STATUS_DESC, 
    LAT,LON
FROM crimeto2020;

-- Check the crime count by year
SELECT YEAR, COUNT(*)
FROM allcrime
GROUP BY YEAR
ORDER BY YEAR ASC;

-- check the crime count by year for updated data
SELECT YEAR, COUNT(*)
FROM allcrimenew
GROUP BY YEAR
ORDER BY YEAR ASC;

/* From the tables above we can see that the data in the allcrime table does not have the latest crime data for the years 2020-2023,
however the allcrimenew table has the updated crime data for the years 2020-2023. My goal will be to get rid of those year in the previous 
table then union both tables so twe have one large table with all the data between 2010-2023 */

SELECT YEAR, COUNT(*)
FROM allcrime
WHERE YEAR NOT IN (2020,2021,2022,2023)
GROUP BY YEAR
UNION
SELECT YEAR, COUNT(*)
FROM allcrimenew
GROUP BY YEAR
ORDER BY YEAR ASC;

-- ALL data with all columns 
SELECT *
FROM allcrime
WHERE YEAR NOT IN (2020,2021,2022,2023)
UNION
SELECT * 
FROM allcrimenew;
-- This query returned 2,821,452 rows of data


Create Table totalcrime AS 
SELECT *
FROM allcrime
WHERE YEAR NOT IN (2020,2021,2022,2023)
UNION
SELECT * 
FROM allcrimenew;

-- DROP PREVIOUS TABLES
DROP TABLE allcrime;
DROP TABLE allcrimenew;

/* Now we can snwer some data questions with this final data */

-- Crime Count Per Year 2010-2023
SELECT YEAR, COUNT(*)
FROM totalcrime
GROUP BY year
ORDER BY YEAR ASC;

-- crime count by year between 2020-2023
SELECT YEAR, COUNT(*)
FROM totalcrime
WHERE YEAR IN (2020,2021,2022,2023)
GROUP BY YEAR
ORDER BY YEAR ASC;

-- Crime count per AREA 2010-2023
SELECT AREA_NAME, COUNT(*)
FROM totalcrime
GROUP BY AREA_NAME
ORDER BY COUNT(*) DESC;

-- CRIME COUNT PER AREA IN 2020-2023
SELECT AREA_NAME, COUNT(*)
FROM totalcrime
WHERE YEAR IN (2020,2021,2022,2023)
GROUP BY AREA_NAME
ORDER BY COUNT(*) DESC;

-- CRIME COUNT BY YEAR AND BY AREA NAME 
SELECT YEAR, AREA_NAME, COUNT(*)
FROM totalcrime
GROUP BY YEAR, AREA_NAME
ORDER BY YEAR ASC, COUNT(*) DESC;

SELECT * FROM totalcrime;

-- CHECK CRIME IN THE LAST 5 YEARS BY QUARTER TO SEE IF CRIME IS SEASONAL
SELECT YEAR, QUARTER, COUNT(*)
FROM totalcrime
WHERE YEAR BETWEEN 2018 AND 2023
GROUP BY YEAR, QUARTER
ORDER BY YEAR ASC, COUNT(*) DESC;
-- THERE SEEMS TO BE A TREND WHERE QUARTERS 2 AND 3 HAVE THE HIGHEST CRIME COUNT BETWEEN THE YEARS

-- WHAT TYPE OF CRIME WAS THE MOST PREVALENT
SELECT CRM_CD_DESC, COUNT(*)
FROM totalcrime
GROUP BY CRM_CD_DESC
ORDER BY COUNT(*) DESC;

-- WHAT TYPE OF CRIME WAS THE MOST PREVALENT IN THE LAST FIVE YEARS - Top 10
SELECT CRM_CD_DESC, COUNT(*)
FROM totalcrime
WHERE YEAR BETWEEN 2018 AND 2023
GROUP BY CRM_CD_DESC
ORDER BY COUNT(*) DESC
LIMIT 10; 

/* SOME VICTIM INFORMATION */

-- victim average age by enthicity between 2018 and 2023
SELECT AVG(VICT_AGE)
FROM totalcrime
WHERE YEAR BETWEEN 2018 AND 2023;
-- VICTIM AVERAGE AGE IN THE LAST 5 YEARS IS 30.8

-- victime average age by ethnivity between 2018 and 2023

-- Victim sex crime count between the years 2018 and 2023
SELECT VICT_SEX, COUNT(*)
FROM totalcrime
WHERE YEAR BETWEEN 2018 AND 2023
GROUP BY VICT_SEX;

SELECT VICT_DESCENT, COUNT(*)
FROM totalcrime
WHERE YEAR BETWEEN 2018 AND 2023
GROUP BY VICT_DESCENT
ORDER BY COUNT(*) DESC;

-- TO CREATE A GEOGRAPHICAL DASHBOARD OF THE CRIMES IN THE LAST 5 YEARS 
SELECT DATE_OF_CRIME, AREA_NAME, CRM_CD_DESC, WEAPON_DESC, LAT, LON 
FROM totalcrime
WHERE YEAR BETWEEN 2020 AND 2023
ORDER BY DATE_OF_CRIME ASC;

SELECT COUNT(*)
FROM totalcrime
WHERE YEAR BETWEEN 2020 AND 2023;
-- 1,198,232 OBSERVATIONS

-- check crime count in 2022
select count(*)
from totalcrime
where YEAR = 2022;