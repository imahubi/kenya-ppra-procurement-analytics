SELECT * FROM stg_contracts LIMIT 10;

SELECT
	id,
    COUNT(*) AS occurrences
FROM stg_contracts
GROUP BY id
HAVING COUNT(*) > 1;
/*Every id uniquely identifies each row in the stg_contracts table. The query
shows that id is a unique key with no duplicates.*/

SELECT
    title,
    value_amount,
    value_currency,
    period_startdate,
    main_ocid,
    main_id,
    date_signed,
    period_enddate,
    description,
    status,
    COUNT(*) AS occurrences
FROM stg_contracts
GROUP BY title,
    value_amount,
    value_currency,
    period_startdate,
    main_ocid,
    main_id,
    date_signed,
    period_enddate,
    description,
    status
HAVING COUNT(*) > 1;
/*Without the id column, the other characteristics of a contract have duplicates.*/

SELECT
    title,
    value_amount,
    value_currency,
    period_startdate,
    main_ocid,
    main_id,
    date_signed,
    period_enddate,
    description,
    status,
    GROUP_CONCAT(id ORDER BY id) AS ids,
    COUNT(*) AS occurrences
FROM stg_contracts
GROUP BY title,
    value_amount,
    value_currency,
    period_startdate,
    main_ocid,
    main_id,
    date_signed,
    period_enddate,
    description,
    status
HAVING COUNT(*) > 1;

SELECT *
FROM stg_contracts
WHERE id IN ('20210218091330-15498-UoE/EQUIP/05/2019-202', '20210218094650-15499-UoE/EQUIP/05/2019-2020');
/*Investigating the pair of ids, although different, the other characteristics of the contracts are exactly the same.
Treating them as duplicates and deleting them outright is not recommended because of the potential that the same
contract was awarded to multiple parties deliberately. */

-- What is the referential relationship that this table shares with others?
-- contracts -> awards
SELECT
	awardid,
    COUNT(*) AS contracts
FROM stg_contracts
GROUP BY awardid
HAVING COUNT(*) > 1
ORDER BY contracts DESC;
/*The query shows that each award is tied to one single contract. As such, the query
returns no rows because no awardid repeats per contract. Since awardid is a foreign key
linking the stg_contracts table with stg_awards_suppliers table, this outcome could be
indicative of a one-to-one cardinality in the relationship between these 2 tables.*/

SELECT
	COUNT(*) AS total_orphan_awards,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM stg_awards) * 100, 2) AS orphan_percentage
FROM stg_awards a
LEFT JOIN stg_contracts b
	ON a.id = b.awardid
WHERE b.awardid IS NULL;

SELECT
	COUNT(*) AS total_orphan_awards,
    ROUND(COUNT(*) / (SELECT COUNT(*) FROM stg_awards) * 100, 2) AS orphan_percentage
FROM stg_awards a
WHERE NOT EXISTS (
	SELECT 1
	FROM stg_contracts b
    WHERE a.id = b.awardid
);
/*The query tests for the existence of orphaned awards, i.e., that is these awards are not
associated with any contract records. Its results show that only 21 awards fit this criteria,
which is synonymous to about 0.02% of all awards in the dataset.*/

SELECT
	a.id AS awards,
    a.title AS award_title,
    b.id AS matched_contract,
    b.title AS contract_title
FROM stg_awards a
JOIN stg_contracts b
	ON a.id = b.awardid;
    
SELECT
	a.id AS awards,
    a.title AS award_title,
    COUNT(b.id) AS matched_contracts
FROM stg_awards a
JOIN stg_contracts b
	ON a.id = b.awardid
GROUP BY a.id, a.title
ORDER BY matched_contracts DESC;
/*The query was used to match awards with contracts. Its output shows that each
award is linked to one contract. From the previous tests, there were some orphan
awards with no contracts assigned to them. In this sense, the stg_awards and
stg_contracts tables seem to have a one-to-one or zero relationship. */

-- stg_contracts also has other foreign keys besides award_id, namely main_ocid and main_id
-- these 2 columns reference the main table, suggesting that the table has some relationship with it.
-- I have already established that the main_ocid is not unique because a small number of ocid values repeat
-- However, just to confirm, I will test the validity of main_ocid as a potential foreign key in stg_contracts
-- to start, how many contracts are associated with a single ocid?
SELECT
	main_ocid,
    COUNT(*) AS contracts
FROM stg_contracts
GROUP BY main_ocid
ORDER BY contracts ASC;
/*The query seeks to count the number of contracts associated with a single main_ocid. Its output shows that
one main_ocid is linked to more than one contract. At its highest, one main_ocid has upwards of 236 contracts.
At the lowest, a main_ocid is linked to only one record. Through the main_ocid connection, it appears that the
2 tables have a one-to-many relationship.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(a.main_ocid) AS non_null_main_ocids,
    COUNT(DISTINCT a.main_id) AS unique_main_ocids,
    COUNT(DISTINCT b.ocid) AS matched_ocids
FROM stg_contracts a
LEFT JOIN stg_main b
	ON a.main_ocid = b.ocid;
/*The query tests the link between the stg_contracts and stg_main tables via the main_ocid -> ocid channel.
Its output shows that each row in the stg_contracts table has an attached main_ocid. However, it is important
to note that, out of the 259117 ocids in the stg_main table, only 91523 of them are present in the stg_contracts
table. This is one less than the number of unique main_ocids in the stg_contracts table.*/

SELECT
	a.id AS contract_id,
    a.main_ocid
FROM stg_contracts a
LEFT JOIN stg_main b
	ON a.main_ocid = b.ocid
WHERE a.main_ocid IS NOT NULL
AND TRIM(a.main_ocid) <> ''
AND NOT EXISTS (
	SELECT 1
    FROM stg_main c
    WHERE c.ocid = a.main_ocid
);

SELECT
	a.id AS contract_id,
    a.main_ocid
FROM stg_contracts a
LEFT JOIN stg_main b
	ON a.main_ocid = b.ocid
WHERE a.main_ocid IS NOT NULL
AND TRIM(a.main_ocid) <> ''
AND b.id IS NULL;
/*The query tests whether main_ocid in the stg_contracts table has a matching record
in the stg_main table. The results of the query returns no rows, which is evidence
that every non-null main_ocid in stg_contracts has a matching record in the stg_main
table.*/

SELECT
	COUNT(*) AS unmatched_contracts
FROM stg_contracts a
LEFT JOIN stg_main b
	ON a.main_ocid = b.ocid
WHERE a.main_ocid IS NOT NULL
AND NOT EXISTS (
	SELECT 1
    FROM stg_main c
    WHERE c.ocid = a.main_ocid
);
/*The query counts contracts that have no corresponding records in the stg_main
table. The query returns no rows, which supports the previous observation that
all the main_ocid in stg_contract match a record in stg_main.*/

SELECT
	COUNT(ocid) AS non_null_ocids,
    COUNT(DISTINCT ocid) AS unique_ocid
FROM stg_main;
/*This query compares the total number of ocids in stg_main to the number of unique
ocids in the same table. For ocid to be used in a referential relationship between
tables, it must be unique. However, the results of this query show that unique ocids
are slightly less than the total ocids in stg_main. For this reason, ocid does not
qualify as a row identifer and should not be used in the relationship between stg_main
and other tables in this dataset.*/

-- How about main_id, can it be used as a unique identifer for stg_main?
SELECT
	COUNT(id) AS non_null_ids,
    COUNT(DISTINCT id) AS unique_ids
FROM stg_main;
/*This query compares the total number of ids in stg_main to unique ids in the
same table. The results of the query shows that the number of non-null ids is
the same as the number of unique ids. This outcome supports the observation that
id is a potential primary key that uniquely identifies each row in the stg_main
table. Given this finding, the id of this table can be used in referential
relationships with other tables.*/

SELECT
	main_id,
    COUNT(*) AS contracts
FROM stg_contracts
GROUP BY main_id
ORDER BY contracts DESC;
/*The query attempts to find the number of contracts associated with each id of
the stg_main table. Its output shows that a main_id may be associated with at least
one or multiple contracts. At the highest, a main_id has 236 contracts. At the
lowest, a main_id has one contract. Given this output, stg_main and stg_contracts
appears to have a one-to-many cardinality.*/

SELECT
	COUNT(*) AS unmatched_contracts
FROM stg_contracts a
LEFT JOIN stg_main b
	ON a.main_id = b.id
WHERE a.main_id IS NOT NULL
AND NOT EXISTS (
	SELECT 1
    FROM stg_main c
    WHERE c.id = a.main_id
);
/*The query counts orphan contracts that do not have a corresponding record in the
stg_main table. It outputs no rows, which means that each main_id in stg_contracts
has a matching record in the stg_main table.*/

-- After confirming the relationship between tables, the next step is cleaning the data in stg_contracts
-- whitespaces
SELECT
	COUNT(*)
FROM (
SELECT
	id
FROM stg_contracts
WHERE TRIM(id) <> id
) x;
/*The query identifies those ids with whitespaces. Around 798 ids contain whitespaces that must be
trimmed before loading the data into normalized tables.*/

SELECT
	id AS original,
    TRIM(id) AS fixed_id
FROM stg_contracts;

UPDATE stg_contracts
SET id = TRIM(id);

SELECT
	id
FROM stg_contracts
WHERE TRIM(id) <> id;
/*The query validates that the id column has no whitespaces. The query returns no rows,
which confirms that the column has been updated accordingly.*/

SELECT
	title AS original,
    TRIM(title) AS fixed_title
FROM stg_contracts
WHERE title <> TRIM(title);
/*The query identifies those titles that have whitespaces and need to be trimmed.*/

UPDATE stg_contracts
SET title = TRIM(title);

SELECT
	title AS original,
    TRIM(title) AS fixed_title
FROM stg_contracts
WHERE title <> TRIM(title);
/*The query validates whether the whitespaces have been removed. As such, it returns
no rows, which shows that the title column no longer has whitespaces.*/

SELECT
	COUNT(*) AS untrimmed
FROM (
	SELECT
		awardid,
        TRIM(awardid)
	FROM stg_contracts
    WHERE awardid <> TRIM(awardid)
) x;
/*The query finds those awardids with whitespaces. The query returns no rows, which means
this column has no whitespaces.*/

SELECT
	COUNT(*) AS untrimmed_count
FROM (
	SELECT
		value_amount,
        TRIM(value_amount)
	FROM stg_contracts
    WHERE value_amount <> TRIM(value_amount)
) x;
/*The query finds those value amounts that have whitespaces. This query returns no rows,
which means that the column does not contain any whitespaces.*/

SELECT
	COUNT(*)
FROM (
	SELECT
		value_currency,
        TRIM(value_currency)
	FROM stg_contracts
    WHERE value_currency <> TRIM(value_currency)
) x;
/*The query finds those value currency rows with whitespaces. The query outputs a count
of zero, which means that this specific column has no whitespaces.*/

SELECT
	COUNT(*) AS untrimmed
FROM (
	SELECT
		period_startdate,
        TRIM(period_startdate)
	FROM stg_contracts
    WHERE period_startdate <> TRIM(period_startdate)
) x;
/*The query goes through the period_startdate column to identify those rows with whitespaces. The
query outputs a count of zero, implying that the column does not have whitespaces.*/

SELECT
	COUNT(*) AS untrimmed
FROM (
	SELECT
		main_ocid,
        TRIM(main_ocid)
	FROM stg_contracts
    WHERE main_ocid <> TRIM(main_ocid)
) x;
/*The query evaluates the main_ocid column to identify those rows with whitespaces. Since the
query outputs a count of zero, implying that this specific column does not have whitespaces.*/

SELECT
	COUNT(*) AS untrimmed
FROM (
	SELECT
		main_id,
        TRIM(main_id)
	FROM stg_contracts
    WHERE main_id <> TRIM(main_id)
) x;
/*The query evaluates the main_id column to identify those rows with whitespaces. Since the query
outputs a count of zero, it implies that this specific column has no whitespaces in its values.*/

SELECT
	COUNT(*) AS untrimmed
FROM (
	SELECT
		date_signed,
        TRIM(date_signed)
	FROM stg_contracts
    WHERE date_signed <> TRIM(date_signed)
) x;
/*The query evaluates the date_signed column to identify those values with whitespaces. Since the
query outputs a zero, it implies that this specific column has no whitespaces in its values.*/


SELECT
	COUNT(*) AS untrimmed
FROM (
	SELECT
		period_enddate,
        TRIM(period_enddate)
	FROM stg_contracts
    WHERE period_enddate <> TRIM(period_enddate)
) x;
/*The query evaluates the period_enddate column for whitespaces. Since the query outputs a zero,
it means that this column does not have whitespaces.*/

SELECT
	COUNT(*) AS untrimmed
FROM (
	SELECT
		description,
        TRIM(description)
	FROM stg_contracts
    WHERE description <> TRIM(description)
) x;
/*The query evaluates the description column to identify those fields containing whitespaces. Its
output suggests that there are 517 rows with trimmable whitespaces.*/

UPDATE stg_contracts
SET description = TRIM(description);
/*After updating the table, the description column no longer has whitespaces.*/

SELECT
	COUNT(*) AS untrimmed
FROM (
	SELECT
		status,
        TRIM(status)
	FROM stg_contracts
    WHERE status <> TRIM(status)
) x;
/*The query evalutes the status column for whitespaces. Since the query outputs
a count of zero, it implies that this column has no whitespaces.*/

-- blanks/nulls

SELECT
	COUNT(*)
FROM (
SELECT
	date_signed
FROM stg_contracts
WHERE date_signed = ''
) x;
/*The date signed contained 1489 blank cells. Deleting these cells is not recommended because
these rows may contain useful information. Therefore, the best step is to convert the
blank cells to null.*/

UPDATE stg_contracts
SET date_signed = NULL
WHERE date_signed = '';
/*After the update, all the blank cells were converted to null.*/

SELECT
	COUNT(*) AS blanks
FROM (
	SELECT
		period_startdate
	FROM stg_contracts
    WHERE period_startdate = ''
) x;
/*The query counts blank cells in the period_startdate column. Its output shows that there
are 3406 blank cells in this column. Deleting them is not recommended because the rows
may contain useful information. Thus, converting them to null is the best way to go.*/

UPDATE stg_contracts
SET period_startdate = NULL
WHERE period_startdate = '';
/*After the update, there are no more blank cells because all of them have been converted to nulls.*/

SELECT
	COUNT(*)
FROM (
	SELECT
		period_enddate
	FROM stg_contracts
    WHERE period_enddate = ''
) x;
/*The query counts blank cells in the period_enddate column. Its output confirmed that 11,411 fields
contain blank cells. Instead of deleting them outright, I will convert them to nulls.*/

UPDATE stg_contracts
SET period_enddate = NULL
WHERE period_enddate = '';
/*After the update, there are no more blank cells because they have all been converted to nulls.*/

SELECT
	COUNT(*) AS blanks
FROM (
	SELECT
		description
	FROM stg_contracts
    WHERE description = ''
) x;
/*The query counts blank cells in the description column. Its output confirms that 103,937 fields are blanks.
Deleting them outright could result in loss of important information, which means the best step is to convert
them to nulls.*/

UPDATE stg_contracts
SET description = NULL
WHERE description = '';
/*After the update, there are no more blank cells ebcause they have all been converted to nulls.*/

SELECT * FROM stg_contracts LIMIT 10;
SELECT
	COUNT(*) AS blanks
FROM (
	SELECT
		status
	FROM stg_contracts
    WHERE status = ''
) x;
/*The query counts blank cells in the status column. Its output shows that there are 109020 blank cells.
Deleting them outright would lead in loss of important data. Therefore, converting them to nulls is the
recommended step.*/

UPDATE stg_contracts
SET status = NULL
WHERE status = '';

-- invalid dates
SELECT * FROM stg_contracts LIMIT 10;

SELECT
	COUNT(*)
FROM (
SELECT
	date_signed
FROM stg_contracts
WHERE date_signed REGEXP '[^0-9:T\\-\\+]'
) x;
/*The date_signed column contains timestamps with the usual symbols (e.g., 0-9, :, T, -, +). The
query counts those dates in this column that contains characters other than the expected. The query
returns zero, implying that all dates in this column contain expected characters. */

SELECT
	date_signed AS original_date,
    STR_TO_DATE(LEFT(date_signed, 10), '%Y-%m-%d') AS dates
FROM stg_contracts
WHERE date_signed IS NOT NULL;
/*The column contains valid dates. This query extracts the date part and presents them without
the timestamp.*/

SELECT
	date_signed AS original_date,
    STR_TO_DATE(date_signed, '%Y-%m-%dT%H:%i:%s+%#') AS fixed_date
FROM stg_contracts
WHERE date_signed IS NOT NULL;
/*The data contains a timezone of '+3' and this query truncates this part of the timestamp. To ensure
that the offset is preserved, it is essential to set the database connection's timezone to match the
date_signed column (and any other date-related column).*/

SET time_zone = '+03:00';

UPDATE stg_contracts
SET date_signed = STR_TO_DATE(LEFT(date_signed, 19), '%Y-%m-%dT%H:%i:%s')
WHERE date_signed IS NOT NULL;
/*Since the timezon of the current database connection already accounts for '+03:00', the date_signed
column was updated without the offset and converted to the datetime datatype.*/

SELECT
	COUNT(*)
FROM (
SELECT
	period_startdate
FROM stg_contracts
WHERE period_startdate REGEXP '[^0-9:T\\-\\+]'
) x;
/*The period_startdate column contains timestamps with the usual symbols (e.g., 0-9, :, T, -, +). The
query counts those dates in this column that contains characters other than the expected. The query
returns zero, implying that all dates in this column contain expected characters.*/

SELECT * FROM stg_contracts LIMIT 10;

SELECT
	period_startdate,
    STR_TO_DATE(LEFT(period_startdate, 19), '%Y-%m-%dT%H:%i:%s') AS fixed_date
FROM stg_contracts;
/*Because the current database connection already accounts for the timezone offset, this query focuses
on converting the period_startdate column to date by removing the offset from the column and converting
it to an actual datetime column.*/

UPDATE stg_contracts
SET period_startdate = TRIM(STR_TO_DATE(LEFT(period_startdate, 19), '%Y-%m-%dT%H:%i:%s'));

SELECT
	period_enddate,
    STR_TO_DATE(LEFT(period_enddate, 19), '%Y-%m-%dT%H:%i:%s') AS fixed_date
FROM stg_contracts
WHERE period_enddate IS NOT NULL;
/*Because the current database connection already accounts for the timezone offset, this query focuses
on converting the period_enddate column to date by removing the offset from the column and converting
it to an actual datetime column.*/

UPDATE stg_contracts
SET period_enddate = TRIM(STR_TO_DATE(LEFT(period_enddate, 19), '%Y-%m-%dT%H:%i:%s'));

-- Proper case in text fields using my customized initcap function
SELECT
	title AS original_title,
    initcap2(title) AS proper_case_title
FROM stg_contracts;

UPDATE stg_contracts
SET title = TRIM(initcap2(title));

SELECT title
FROM stg_contracts
LIMIT 10;

SELECT
	value_amount
FROM stg_contracts
WHERE value_amount REGEXP '[^0-9\\.]';

SELECT * FROM stg_contracts LIMIT 10;