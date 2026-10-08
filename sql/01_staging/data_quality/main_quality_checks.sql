SELECT * FROM stg_main LIMIT 10;

SELECT
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS ids,
    SUM(CASE WHEN tag IS NULL THEN 1 ELSE 0 END) AS tags,
    SUM(CASE WHEN date IS NULL THEN 1 ELSE 0 END) AS dates,
    SUM(CASE WHEN ocid IS NULL THEN 1 ELSE 0 END) AS ocids,
    SUM(CASE WHEN language IS NULL THEN 1 ELSE 0 END) AS languages,
    SUM(CASE WHEN initiationtype IS NULL THEN 1 ELSE 0 END) AS initiations,
    SUM(CASE WHEN buyer_id IS NULL THEN 1 ELSE 0 END) AS buyer_ids,
    SUM(CASE WHEN buyer_name IS NULL THEN 1 ELSE 0 END) AS buyer_names,
    SUM(CASE WHEN tender_id IS NULL THEN 1 ELSE 0 END) AS tender_ids,
    SUM(CASE WHEN tender_title IS NULL THEN 1 ELSE 0 END) AS tender_titles,
    SUM(CASE WHEN tender_mainprocurementcategory IS NULL THEN 1 ELSE 0 END) AS categories,
    SUM(CASE WHEN tender_mainprocurementmethod IS NULL THEN 1 ELSE 0 END) AS methods,
    SUM(CASE WHEN tender_tenderperiod_enddate IS NULL THEN 1 ELSE 0 END) AS enddates,
    SUM(CASE WHEN tender_tenderperiod_startdate IS NULL THEN 1 ELSE 0 END) AS startdates,
    SUM(CASE WHEN tender_awardcriteria IS NULL THEN 1 ELSE 0 END) AS criteria
FROM stg_main;
/*The query evaluates all columns in the table and counts up all cells that are nulls. All
counts produced zeros, which means that the table has no nulls.*/

SELECT
	SUM(CASE WHEN id = '' THEN 1 ELSE 0 END) AS ids,
    SUM(CASE WHEN tag = '' THEN 1 ELSE 0 END) AS tags,
    SUM(CASE WHEN date = '' THEN 1 ELSE 0 END) AS dates,
    SUM(CASE WHEN ocid = '' THEN 1 ELSE 0 END) AS ocids,
    SUM(CASE WHEN language = '' THEN 1 ELSE 0 END) AS languages,
    SUM(CASE WHEN initiationtype = '' THEN 1 ELSE 0 END) AS initiations,
    SUM(CASE WHEN buyer_id = '' THEN 1 ELSE 0 END) AS buyer_ids,
    SUM(CASE WHEN buyer_name = '' THEN 1 ELSE 0 END) AS buyer_names,
    SUM(CASE WHEN tender_id = '' THEN 1 ELSE 0 END) AS tender_ids,
    SUM(CASE WHEN tender_title = '' THEN 1 ELSE 0 END) AS tender_titles,
    SUM(CASE WHEN tender_mainprocurementcategory = '' THEN 1 ELSE 0 END) AS categories,
    SUM(CASE WHEN tender_mainprocurementmethod = '' THEN 1 ELSE 0 END) AS methods,
    SUM(CASE WHEN tender_tenderperiod_enddate = '' THEN 1 ELSE 0 END) AS enddates,
    SUM(CASE WHEN tender_tenderperiod_startdate = '' THEN 1 ELSE 0 END) AS startdates,
    SUM(CASE WHEN tender_awardcriteria = '' THEN 1 ELSE 0 END) AS criteria
FROM stg_main;
/*The query counts up blank cells for each column. Its output confirms that there are
4 columns with blank cells, namely tener_mainprocurementcategory, tender_tenderperiod_enddate,
tender_tenderperiod_startdate, and tender_awardcriteria. Deleting these blank cells could
result in the loss of important information. Hence, I will be converting all blank values
to null.*/

UPDATE stg_main
SET tender_mainprocurementcategory = NULL
WHERE tender_mainprocurementcategory = '';

UPDATE stg_main
SET tender_tenderperiod_enddate = NULL
WHERE tender_tenderperiod_enddate = '';

UPDATE stg_main
SET tender_tenderperiod_startdate = NULL
WHERE tender_tenderperiod_startdate = '';

UPDATE stg_main
SET tender_awardcriteria = NULL
WHERE tender_awardcriteria = '';

SELECT
	SUM(CASE WHEN id <> TRIM(id) THEN 1 ELSE 0 END) AS ids,
    SUM(CASE WHEN tag <> TRIM(tag) THEN 1 ELSE 0 END) AS tags,
    SUM(CASE WHEN date <> TRIM(date) THEN 1 ELSE 0 END) AS dates,
    SUM(CASE WHEN ocid <> TRIM(ocid) THEN 1 ELSE 0 END) AS ocids,
    SUM(CASE WHEN language <> TRIM(language) THEN 1 ELSE 0 END) AS languages,
    SUM(CASE WHEN initiationtype <> TRIM(initiationtype) THEN 1 ELSE 0 END) AS initiations,
    SUM(CASE WHEN buyer_id <> TRIM(buyer_id) THEN 1 ELSE 0 END) AS buyer_ids,
    SUM(CASE WHEN buyer_name <> TRIM(buyer_name) THEN 1 ELSE 0 END) AS buyer_names,
    SUM(CASE WHEN tender_id <> TRIM(tender_id) THEN 1 ELSE 0 END) AS tender_ids,
    SUM(CASE WHEN tender_title <> TRIM(tender_title) THEN 1 ELSE 0 END) AS tender_titles,
    SUM(CASE WHEN tender_mainprocurementcategory <> TRIM(tender_mainprocurementcategory) THEN 1 ELSE 0 END) AS categories,
    SUM(CASE WHEN tender_mainprocurementmethod <> TRIM(tender_mainprocurementmethod) THEN 1 ELSE 0 END) AS methods,
    SUM(CASE WHEN tender_tenderperiod_enddate <> TRIM(tender_tenderperiod_enddate) THEN 1 ELSE 0 END) AS enddates,
    SUM(CASE WHEN tender_tenderperiod_startdate <> TRIM(tender_tenderperiod_startdate) THEN 1 ELSE 0 END) AS startdates,
    SUM(CASE WHEN tender_awardcriteria <> TRIM(tender_awardcriteria) THEN 1 ELSE 0 END) AS criteria
FROM stg_main;
/*The query is designed to find those columns that contain cells with whitespaces in need of
trimming. Only 2 columns fit this description, namely buyer_name (27238 cells with whitespaces)
and tender_title (23396 cells with whitespaces).*/

UPDATE stg_main
SET
	buyer_name = TRIM(buyer_name),
    tender_title = TRIM(tender_title);
/*After the update, it was confirmed that there are no whitespaces in this table's columns.*/

-- Next, I want to fix the caps in text columns
SELECT
	buyer_name AS original_name,
    initcap2(buyer_name) AS fixed_name,
    tender_title AS original_title,
    initcap2(tender_title) AS fixed_title
FROM stg_main;

UPDATE stg_main
SET
	buyer_name = initcap2(buyer_name),
    tender_title = initcap2(tender_title);
    
SELECT * FROM stg_main LIMIT 10;

UPDATE stg_main
SET date = TRIM(STR_TO_DATE(LEFT(date, 19), '%Y-%m-%dT%H:%i:%s'))
WHERE date IS NOT NULL;

UPDATE stg_main
SET tender_tenderperiod_enddate = TRIM(STR_TO_DATE(LEFT(tender_tenderperiod_enddate, 19), '%Y-%m-%dT%H:%i:%s'))
WHERE tender_tenderperiod_enddate IS NOT NULL;
/*This update failed because there were some dates in this column have a negative year. To proceed, I need
to fix these dates.*/

SELECT
	COUNT(*)
FROM (
	SELECT
		tender_tenderperiod_startdate
	FROM stg_main
	WHERE tender_tenderperiod_startdate LIKE '-%'
) x;
/*The query counts all the dates in this date column with a negative year. It turns out that there are 
around 7 dates with a negative year. Instead of deleting the entire stack, the best approach would be
to turn these dates to null to preserve data integrity.*/

UPDATE stg_main
SET tender_tenderperiod_enddate = NULL
WHERE tender_tenderperiod_enddate IS NOT NULL
AND
	(tender_tenderperiod_enddate LIKE '-%'
    OR tender_tenderperiod_enddate REGEXP '[^0-9:T\\-\\+]'
    OR LENGTH(tender_tenderperiod_enddate) < 19);
/*This query converts the 7 invalid date formats to null.*/    

UPDATE stg_main
SET tender_tenderperiod_enddate = TRIM(STR_TO_DATE(LEFT(tender_tenderperiod_enddate, 19), '%Y-%m-%dT%H:%i:%s'))
WHERE tender_tenderperiod_enddate IS NOT NULL;
/*The query standardized all dates in this column.*/

UPDATE stg_main
SET tender_tenderperiod_startdate = TRIM(STR_TO_DATE(LEFT(tender_tenderperiod_startdate, 19), '%Y-%m-%dT%H:%i:%s'))
WHERE tender_tenderperiod_startdate IS NOT NULL;
/*The query standardized all dates in this column.*/

SELECT * FROM stg_main LIMIT 10;