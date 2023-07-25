/* HOW TO IMPORT LARGE FILES FAST IN MYSQL WORKBVENCH */

----------------------------------------------------------------------
/* STEP 1: GET FOLDER LOCATION */ 
SHOW VARIABLES LIKE "SECURE_FILE_PRIV";

----------------------------------------------------------------------
/* STEP 2: PASTE CSV FILE INTO THE PATH ABOVE */

----------------------------------------------------------------------
/* STEP 3: CREATE TABLE TO IMPORT YOUR DATA */

CREATE TABLE crimeto2019 (
	DR_NO int,
    Date_RPTD text,
    Date_OCC text,
    TIME_OCC int,
    AREA int,
    AREA_NAME text,
    RPT_DIST_NO text,
    PART_1_2 int,
    CRM_CD text,
    CRM_CD_DESC text,
    MONOCODES text,
    VICT_AGE int,
    VICT_SEX text,
    VICT_DESCENT text,
    PREMISE_CD int,
    PREMIS_DESC text,
    WEAPON_USED_CD text,
    WEAPON_DESC text,
    STATUS text,
    STATUS_DESC text,
    CRM_CD_1 text,
    CRM_CD_2 text,
	CRM_CD_3 text,
    CRM_CD_4 text,
    LOCATION text,
    CROSS_STREET text,
    LAT float,
    LON float
    );
    
    CREATE TABLE crimeto2020 (
	DR_NO int,
    Date_RPTD text,
    Date_OCC text,
    TIME_OCC int,
    AREA int,
    AREA_NAME text,
    RPT_DIST_NO text,
    PART_1_2 int,
    CRM_CD text,
    CRM_CD_DESC text,
    MONOCODES text,
    VICT_AGE int,
    VICT_SEX text,
    VICT_DESCENT text,
    PREMISE_CD int,
    PREMIS_DESC text,
    WEAPON_USED_CD text,
    WEAPON_DESC text,
    STATUS text,
    STATUS_DESC text,
    CRM_CD_1 text,
    CRM_CD_2 text,
	CRM_CD_3 text,
    CRM_CD_4 text,
    LOCATION text,
    CROSS_STREET text,
    LAT float,
    LON float
    );
----------------------------------------------------------------------
/* STEP 4: LOCAL INFILE MUST BE SET TO TRUE */ 

show variables like "local_infile";
set global local_infile = 1;
 
----------------------------------------------------------------------
/* STEP 5: LOAD THE DATA */ 
  
LOAD DATA local INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Crime_Data_from_2010_to_2019.csv"
INTO TABLE crimeto2019
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

LOAD DATA local INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/Crime_Data_from_2020_to_Present.csv"
INTO TABLE crimeto2020
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;