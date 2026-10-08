-- stg_awards
-- total award count
SELECT COUNT(*) AS total_rows
FROM stg_awards; -- the table has all rows from the source table (109125 records)

-- unique identifiers
SELECT COUNT(DISTINCT id) AS unique_id
FROM stg_awards; -- the id column is unique (109125 ids)

SELECT COUNT(DISTINCT title) AS unique_title
FROM stg_awards; -- title is not unique

SELECT COUNT(DISTINCT main_ocid) AS unique_mainocid
FROM stg_awards; -- main_ocid column is not unique

SELECT COUNT(DISTINCT main_id) AS unique_mainid
FROM stg_awards; -- main_id column is not unique

-- nulls/blanks in important columns
SELECT
	COUNT(*) AS total_rows,
    SUM(id IS NULL OR id = '') AS id,
    SUM(title IS NULL OR title = '') AS title,
    SUM(value_amount IS NULL OR value_amount= '') AS value_amount,
    SUM(value_currency IS NULL OR value_currency = '') AS value_currency,
    SUM(contractperiod_startdate IS NULL OR contractperiod_startdate = '') AS contractperiod_startdate,
    SUM(main_ocid IS NULL OR main_ocid = '') AS main_ocid,
    SUM(main_id IS NULL OR main_id = '') AS main_id,
    SUM(contractperiod_enddate IS NULL OR contractperiod_enddate = '') AS contractperiod_enddate,
    SUM(description IS NULL OR description = '') AS description
FROM stg_awards;
-- No blanks/nulls in critical columns like id, title, value_amount, main_ocid, and main_id
-- Also, no blanks/nulls in value_currency column
-- Multiple blanks/nulls in contractperiod_startdate and contractperiod_enddate

-- duplicates
SELECT
	title,
    value_amount,
    value_currency,
    contractperiod_startdate,
    main_ocid,
    main_id,
    contractperiod_enddate,
    description,
    COUNT(*) AS duplicate_count
FROM stg_awards
GROUP BY
	title,
    value_amount,
    value_currency,
    contractperiod_startdate,
    main_ocid,
    main_id,
    contractperiod_enddate,
    description
HAVING COUNT(*) > 1;
-- There are duplicate awards in this table

WITH duplicateawards AS (
	SELECT
	title,
    value_amount,
    value_currency,
    contractperiod_startdate,
    main_ocid,
    main_id,
    contractperiod_enddate,
    description,
    COUNT(*) AS duplicate_count
FROM stg_awards
GROUP BY title,
    value_amount,
    value_currency,
    contractperiod_startdate,
    main_ocid,
    main_id,
    contractperiod_enddate,
    description
HAVING COUNT(*) > 1
)
SELECT s.*
FROM stg_awards s
JOIN duplicateawards d
	ON s.title <=> d.title
    AND s.value_amount <=> d.value_amount
    AND s.value_currency <=> d.value_currency
    AND s.contractperiod_startdate <=> d.contractperiod_startdate
    AND s.main_ocid <=> d.main_ocid
    AND s.main_id <=> d.main_id
    AND s.contractperiod_enddate <=> d.contractperiod_enddate
    AND s.description <=> d.description
WHERE s.contractperiod_startdate <> ''
AND s.contractperiod_enddate <> '';
/*The query identifies 2009 records sharing identical award attributes while retaining
their unique ids. This indicates that multiple records have identical values across selected
award attributes, although each record has a unique id. These records, however, should not be
treated as duplicates requiring deletion, since the unique ids might represent separate records
within the source data.*/

SELECT
	title,
    value_amount,
    value_currency,
    contractperiod_startdate,
    main_ocid,
    main_id,
    contractperiod_enddate,
    description,
    COUNT(*) AS duplicate_count,
    GROUP_CONCAT(id ORDER BY id) AS ids
FROM stg_awards
GROUP BY
	title,
    value_amount,
    value_currency,
    contractperiod_startdate,
    main_ocid,
    main_id,
    contractperiod_enddate,
    description
HAVING COUNT(*) > 1;
/*For each duplicated record, this query concatenates their ids while showing the selected
attributes that they share (e.g., title, value_amount, main_ocid, main_id, etc). This
step facilitates further exploration of potential duplicate records as shown below.*/

SELECT *
FROM stg_awards
WHERE id IN ('20210218091330-15498','20210218094650-15499');
/*Exploring the concatenated ids in this query reveals that the records are completely
identical except for their ids. This suggests that the same award might have been recorded
multiple times in the source system. However, this is still not sufficient reason to delete 
these potential duplicates until their relationships with the other source tables and
 the resulting impact on data integrity have been assessed.*/

SELECT
	main_id,
    main_ocid,
    COUNT(*) AS record_count,
    COUNT(DISTINCT id) AS distinct_ids
FROM stg_awards
GROUP BY main_id, main_ocid
HAVING record_count > 1
ORDER BY record_count DESC;
/*While the id uniquely identifies each row, multiple awards share the same characteristics
like title, value_amount, value_currency, contract start date, ocid, main_id, contract end
date, and description. However, at this point, deleting these potential duplicates is not 
recommended until their implications for data integrity have been assessed.*/

SELECT *
FROM stg_awards
LIMIT 10;

-- invalid dates
SELECT
	SUM(CASE WHEN contractperiod_startdate REGEXP '[^0-9:T\\-\\+\\.]' THEN 1 ELSE 0 END) AS invalid_startdate,
    SUM(CASE WHEN contractperiod_enddate REGEXP '[^0-9:T\\-\\+\\.]' THEN 1 ELSE 0 END) AS invalid_enddate
FROM stg_awards;


SELECT
	id,
    contractperiod_startdate,
    contractperiod_enddate
FROM stg_awards
WHERE 
	(contractperiod_startdate IS NOT NULL
    AND TRIM(contractperiod_startdate) <> ''
    AND STR_TO_DATE(LEFT(contractperiod_startdate, 10), '%Y-%m-%d') IS NULL)
OR 
	(contractperiod_enddate IS NOT NULL
    AND TRIM(contractperiod_enddate) <> ''
    AND STR_TO_DATE(LEFT(contractperiod_enddate, 10), '%Y-%m-%d') IS NULL);
    
SELECT
	SUM(CASE
			WHEN contractperiod_startdate IS NOT NULL
			AND TRIM(contractperiod_startdate) <> ''
			AND STR_TO_DATE(LEFT(contractperiod_startdate, 10), '%Y-%m-%d') IS NULL
            THEN 1
            ELSE 0
		END) AS invalid_startdates,
	SUM(CASE
			WHEN contractperiod_enddate IS NOT NULL
			AND TRIM(contractperiod_enddate) <> ''
			AND STR_TO_DATE(LEFT(contractperiod_enddate, 10), '%Y-%m-%d') IS NULL
            THEN 1
            ELSE 0
		END) AS invalid_enddates
	FROM stg_awards;
/*For the 2 non-null date columns in the awards table, no unparseable dates exist. The
extracted date portion can be converted into date using the STR_TO_DATE function. */

-- invalid numeric fields

SELECT
	SUM(CASE WHEN value_amount REGEXP '[^0-9\\.]' THEN 1 ELSE 0 END) AS invalids
FROM stg_awards;
/*This query identifies 2 invalid amounts in the value_amount column. The 2 entries
are determined to contain other characters other than numbers (0-9) and and a period
usually used to denote decimals. Further investigation of these values is necessary.*/

SELECT
	id,
    value_amount
FROM stg_awards
WHERE value_amount REGEXP '[^0-9\\.]';
/*The query narrows down the 2 invalid entries in the value_amount column, showing
their ids. This way, I was able to see that the reason why these fields were flagged
was because they were stored using the scientific notation in the source file (e.g., 1.40E+11).
Although numerically valid, these 2 entries require conversion into the standard decimal
notation before loading them into the appropriate numeric data type.*/

SELECT
	id,
    value_amount AS original_value,
    value_amount + 0 AS standard_notation
FROM stg_awards
WHERE value_amount REGEXP '[^0-9\\.]';
/*The query converts the values stored in scientific notation into numeric form using
implicit numeric conversion. This allows the affected recordds to be inspected in
standard numeric notation before applying a permanent data-type conversion to value_amount.*/

UPDATE stg_awards
SET value_amount = (value_amount + 0)
WHERE value_amount REGEXP '[^0-9\\.]';
/*The query updates the entries in scientific notation and implicitly converts them to a 
standard numeric notation.*/

SELECT
	id,
    value_amount
FROM stg_awards
WHERE value_amount REGEXP '[^0-9\\.]';
/*The query confirms that all the values in the value column are all in standard numeric
notation. ALL values, even those in scientific notation, are successfully in the required
format.*/

/*To establish referential consistency with the stg_main table, I want to find if there
are awards in the stg_awards table that don't exist in the stg_main table.*/

SELECT
	COUNT(*) AS total_awards,
    COUNT(DISTINCT main_id) AS distinct_main_ids
FROM stg_awards;
/*The query shows that main_id in the awards table is not unique, which is expected as it is
meant to be a foreign key. The total distinct count of main_ids is lower than the total number
of awards in the table (91524 vs 109125). This outcome suggests a one-to-many relationship
between the stg_awards table and stg_main table, where one procurement record is associated with
multiple awards.*/

WITH repeatedmains AS (
	SELECT
		main_id
	FROM stg_awards
    GROUP BY main_id
    HAVING COUNT(*) > 1
)
SELECT
	a.main_id,
    a.id AS award_id,
    a.title,
    a.value_amount,
    a.contractperiod_startdate
FROM stg_awards a
JOIN repeatedmains b
	ON a.main_id = b.main_id
ORDER BY a.main_id, a.id;
/*The query shows that there are multiple awards with the same main_id, title,
and contract start date while having completely different award ids and value
amounts. This suggests that the awards are not necessarily identical but the
award may be split among different suppliers or components.*/

SELECT
	a.id AS award_id,
    a.main_id
FROM stg_awards a
LEFT JOIN stg_main b
	ON a.main_id = b.id
WHERE a.main_id IS NOT NULL
AND TRIM(a.main_id) <> ''
AND b.id IS NULL;
/*The queryshows that every main_id recorded in the stg_awards table is correctly
matched to a record in the stg_main table. The results of this query affirms that 
the two tables are referentially consistent (stg_awards.main_id links to stg_main.id)*/

SELECT
	a.id AS award_id,
    a.main_ocid
FROM stg_awards a
LEFT JOIN stg_main b
	ON a.main_ocid = b.ocid
WHERE a.main_ocid IS NOT NULL
AND TRIM(a.main_ocid) <> ''
AND b.ocid IS NULL;
/*The query shows that main_ocid correctly matches to a record in the stg_main table. Its
results imply referential consistency (stg_awards.main_ocid links to stg_main.ocid).*/

SELECT
	a.id AS award_id,
    a.main_id,
    a.main_ocid,
    b.id AS main_record_id,
    b.ocid AS main_ocid_from_main
FROM stg_awards a
JOIN stg_main b
	ON a.main_id = b.id
WHERE a.main_ocid <> b.ocid;
/*This query shows no inconsistencies between stg_awards.main_ocid and the corresponing stg_main.ocid
values for awards whose main_id matched stg_main.id. As such, the results of this query suggests referential consistency in the
relationship between the two tables.*/

SELECT *
FROM stg_awards
LIMIT 10;

UPDATE stg_awards
SET contractperiod_startdate = TRIM(contractperiod_startdate);

UPDATE stg_awards
SET contractperiod_startdate = STR_TO_DATE(LEFT(contractperiod_startdate, 19), '%Y-%m-%dT%H:%i:%s');

UPDATE stg_awards
SET contractperiod_enddate = STR_TO_DATE(LEFT(contractperiod_enddate, 19), '%Y-%m-%dT%H:%i:%s');

UPDATE stg_awards
SET description = NULL
WHERE description = '';

SELECT
	SUM(CASE WHEN id = '' THEN 1 ELSE 0 END) AS ids,
    SUM(CASE WHEN title = '' THEN 1 ELSE 0 END) AS titles,
    SUM(CASE WHEN value_amount = '' THEN 1 ELSE 0 END) AS amounts,
    SUM(CASE WHEN value_currency = '' THEN 1 ELSE 0 END) AS currency,
    SUM(CASE WHEN contractperiod_startdate = '' THEN 1 ELSE 0 END) AS startdate,
    SUM(CASE WHEN main_ocid = '' THEN 1 ELSE 0 END) AS ocid,
    SUM(CASE WHEN main_id = '' THEN 1 ELSE 0 END) AS m_ids,
    SUM(CASE WHEN contractperiod_enddate = '' THEN 1 ELSE 0 END) AS enddate,
    SUM(CASE WHEN description = '' THEN 1 ELSE 0 END) AS descriptions
FROM stg_awards;

