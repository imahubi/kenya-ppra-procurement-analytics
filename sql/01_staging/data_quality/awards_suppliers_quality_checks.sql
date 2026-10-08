-- stg_awards_suppliers table
-- total row count
SELECT
	COUNT(*) AS total_rows
FROM stg_awards_suppliers; -- there are 79832 records in this table, same as the source file

-- Distinct identifiers
	-- the id column appears to be a unique identifier for the table
SELECT
	COUNT(DISTINCT id) AS unique_ids
FROM stg_awards_suppliers;
-- There are 63939 unique ids in this table
-- Either the id is not unique and there exists duplicates in the records

SELECT
	COUNT(DISTINCT name) AS unique_names
FROM stg_awards_suppliers;
-- The names repeat in this table considering there are only 38885 unique names in this table

SELECT
	COUNT(DISTINCT main_id) AS unique_main_ids,
    COUNT(DISTINCT main_ocid) AS unique_main_ocids,
    COUNT(DISTINCT awards_id) AS unique_awards_ids
FROM stg_awards_suppliers;
/*The table contains 79832 records, matching the source file. The id column contains
63939 distinct values, indicating that id does not uniquely identify every row. Supplier
names repeat, which is expected because a supplier can be associated with multiple awards.
main_id and main_ocid also repeat, consistent with their roles as identifiers linking
multiple supplier records to procurement records. The uniqueness and relationship of
awards_id require further validation before determining whether it uniquely identifies
an award-supplier record or represents the relationship between awards and suppliers.*/

SELECT
	awards_id,
    COUNT(*) AS supplier_count
FROM stg_awards_suppliers
GROUP BY awards_id
HAVING supplier_count > 1
ORDER BY supplier_count DESC;
/*The query shows that no awards_id value repeats in the table. Each awards_id
is associated with exactly one record in the stg_awards_suppliers table.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(awards_id) AS non_null_awards_ids,
    COUNT(DISTINCT awards_id) AS unique_awards_ids
FROM stg_awards_suppliers;
/*total_rows, non_null_awards_ids, and unique_awards_ids all return 79832.
This confirms that every record has a non-null awards_id and that every awards_id
is unique. This is unexpected if awards_id is intended to function as a foreign key
to stg_awards, where multiple supplier records would normally be associated with the
same award. The relationship between stg_awards and stg_awards_suppliers therefore
requires further investigation before proceeding with normalization.*/

SELECT
	COUNT(*) AS total_suppliers,
    COUNT(DISTINCT s.awards_id) AS unique_supplier_awards_ids,
    COUNT(DISTINCT a.id) AS matched_award_ids
FROM stg_awards_suppliers s
LEFT JOIN stg_awards a
	ON s.awards_id = a.id;
/*The query confirms that all 79832 awards_id values in stg_awards_suppliers have a
corresponding id in stg_awards. This indicates that every supplier record is linked to
an existing award record. Since stg_awards contains 109125 records, some awards may
not have an associated supplier record in stg_awards_suppliers.*/

SELECT
	s.awards_id,
    COUNT(*) AS occurrences
FROM stg_awards_suppliers s
LEFT JOIN stg_awards a
	ON s.awards_id = a.id
WHERE a.id IS NULL
GROUP BY s.awards_id;
/*The query returns no rows, confirming that there are no awards_id values in the stg_awards_suppliers
table without a corresponding id in the stg_awards table. Therefore, all supplier records have a valid
reference to an award in stg_awards.*/

SELECT
	COUNT(*) AS awards_without_suppliers
FROM stg_awards a
LEFT JOIN stg_awards_suppliers b
	ON a.id = b.awards_id
WHERE b.awards_id IS NULL;
/*The query confirms that 29293 awards are not associated with a supplier record in the stg_awards_suppliers
table.*/

-- The relationship between stg_awards and stg_awards_suppliers exists through the awards_id foreign key
-- There are other potential relationships with the stg_main table, through main_id and main_ocid

SELECT
	COUNT(*) AS total_rows,
    COUNT(a.main_id) AS non_null_main_ids,
    COUNT(DISTINCT a.main_id) AS unique_main_ids,
    COUNT(DISTINCT b.id) AS matched_main_ids
FROM stg_awards_suppliers a
LEFT JOIN stg_main b
	ON a.main_id = b.id;
/*The query shows that there are 79832 non-null main_ids and 67523 unique ones from the stg_awards_suppliers
table. Also, 67523 distinct ids from the main table matched with the main_ids in the stg_awards_suppliers
table.*/

SELECT
	a.main_id,
    COUNT(*) AS occurrences
FROM stg_awards_suppliers a
LEFT JOIN stg_main b
	ON a.main_id = b.id
WHERE b.id IS NULL
GROUP BY a.main_id
ORDER BY occurrences DESC;
/*The query returns no rows, confirming that there are no orphan main_ids in the stg_awards_suppliers table. This
outcome also confirms that every main_id in the stg_awards_suppliers table corresponds to a record in the stg_main
table.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(a.main_ocid) AS non_null_main_ocids,
    COUNT(DISTINCT a.main_ocid) AS unique_main_ocids,
    COUNT(DISTINCT b.ocid) AS matched_ocids
FROM stg_awards_suppliers a
LEFT JOIN stg_main b
	ON a.main_ocid = b.ocid;
/*The query reveals 79835 total records with 79835 non-null main ocids, which contradicts the total number of
records in the stg_awards_suppliers table (79832 records). It also shows that there are 67522 unique main ocids
and 67522 ocids from the main table matched with the main_ocids in the stg_awards_suppliers table.*/

SELECT
	ocid,
    COUNT(*) AS occurrences
FROM stg_main
GROUP BY ocid
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;
/*The query reveals that ocid in the stg_main table is not unique and has multiple occurrences in some cases.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(ocid) AS non_null_ocids,
    COUNT(DISTINCT ocid) AS unique_ocids
FROM stg_main;
/*The query confirms that ocids is not unique. A distinct count of ocids in the stg_main table is slightly less
than the number of total records (259117 vs 259132). */

SELECT
	a.main_ocid,
    COUNT(*) AS occurrences
FROM stg_awards_suppliers a
LEFT JOIN stg_main b
	ON a.main_ocid = b.ocid
WHERE b.ocid IS NULL
GROUP BY a.main_ocid;
/*The query returns no rows, suggesting that all the main_ocids in the stg_awards_suppliers table match with
records in the stg_main table.*/

SELECT
	a.ocid,
    COUNT(*) AS occurrences
FROM stg_main a
LEFT JOIN stg_awards_suppliers b
	ON a.ocid = b.main_ocid
WHERE b.main_ocid IS NULL
GROUP BY a.ocid;
/*The query shows that there are ocid from the stg_main table that are not associated with any record in the
stg_awards_suppliers table. */

SELECT
	a.awards_id,
    a.main_id,
    a.main_ocid,
    b.id AS matched_main_id,
    b.ocid AS matched_main_ocid
FROM stg_awards_suppliers a
JOIN stg_main b
	ON a.main_id = b.id
WHERE NOT a.main_ocid <=> b.ocid;
/*The query returns no rows, confirming that both identifiers (main_id and main_ocid) consistently point to
the same records in the stg_main table.*/

SELECT
	main_id,
    COUNT(*) AS award_supplier_records,
    COUNT(DISTINCT awards_id) AS unique_awards
FROM stg_awards_suppliers
GROUP BY main_id
ORDER BY unique_awards DESC;
/*The query shows that multiple awards belong to the same main_id in the stg_awards_suppliers table. An
important note is that the number of award_supplier_records is exactly the same as unique awards (confirmed).*/

SELECT
	main_id,
    COUNT(*) AS award_count
FROM stg_awards
GROUP BY main_id
ORDER BY award_count DESC;
/*The query shows that multiple awards belong to the same main_id in the stg_awards table, similar to
the stg_awards_suppliers table.*/

SELECT
	name,
    COUNT(*) AS occurrences,
    COUNT(DISTINCT main_id) AS procurement_count,
    COUNT(DISTINCT awards_id) AS award_count
FROM stg_awards_suppliers
GROUP BY name
HAVING occurrences > 1
ORDER BY occurrences DESC;
/*The query confirms that supplier names repeat in the stg_awards_suppliers table. This result means
that a supplier may be involved in multiple procurement procedures and be assigned multiple awards.*/

SELECT
	a.main_ocid,
    COUNT(*) AS matched_main_records
FROM stg_awards_suppliers a
JOIN stg_main b
	ON a.main_ocid = b.ocid
GROUP BY a.main_ocid
HAVING COUNT(*) > 1
ORDER BY matched_main_records DESC;
/*The query shows that some main_ocid from the stg_awards_suppliers matches multiple ocid from the stg_main
table. This occurs because ocid is not unique in stg_main, meaning that main_ocid cannot be used as a unique
identifier for the corresponding record in the stg_main table.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(id) AS non_null_ids,
    COUNT(DISTINCT id) AS unique_ids
FROM stg_main;
/*The query returns the same value for all three columns (259132). As such, stg_main.id is a unique identifier
for each row, supported further by the fact that it does not contain any null values.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(id) AS non_null_ids,
    COUNT(DISTINCT id) AS unique_ids
FROM stg_awards;
/*The query returns the same value for all columns (109125). This query shos that stg_awards.id uniquely
identifies each award, supported further by the fact that the column does not contain any null values.*/

SELECT
	main_id,
    COUNT(*) AS award_count
FROM stg_awards
WHERE main_id IS NOT NULL AND TRIM(main_id) <> ''
GROUP BY main_id
ORDER BY award_count DESC;
/*The query shows that multiple awards can be linked to the same main_id, suggesting a one-to-many
relationship between stg_main and stg_awards.*/

SELECT
	COUNT(*) AS main_ids_with_awards,
    MIN(award_count) AS minimum_awards,
    MAX(award_count) AS maximum_awards,
    ROUND(AVG(award_count), 2) AS average_awards
FROM (
	SELECT
		main_id,
        COUNT(*) AS award_count
	FROM stg_awards
    GROUP BY main_id
) awards_data;
/*The query shows that 91524 main_ids in the stg_awards table are associated with
an award. At minimum, a main_id has 1 award. At maximum, a main_id has 236 awards
linked to it. This leads to an average of 1.19 awards per main_id. This outcome
supports the earlier assumption that stg_main and stg_awards share a one-to-many
association. */

SELECT
	a.id AS awards_id,
    COUNT(b.awards_id) AS supplier_records
FROM stg_awards a
LEFT JOIN stg_awards_suppliers b
	ON a.id = b.awards_id
GROUP BY a.id
ORDER BY supplier_records DESC;
/*The query shows an awards_id from stg_awards is associated, at most, with only
one supplier records (from the stg_awards_supplier table) and, at the very least,
zero records.*/

SELECT
	supplier_records,
    COUNT(*) AS award_count
FROM (
	SELECT
		a.id AS awards_id,
        COUNT(b.awards_id) AS supplier_records
	FROM stg_awards a
    LEFT JOIN stg_awards_suppliers b
		ON a.id = b.awards_id
	GROUP BY a.id
) awards_data
GROUP BY supplier_records
ORDER BY supplier_records DESC;
/*The query confirms the finding that an awards_id has, at most, 1 supplier record
from the stg_awards_suppliers table. There are some awards with no suppliers (i.e., zero
supplier records). Thus, although some further investigation may be necessary, a one-to-zero or one
relationship may be possible for stg_awards and stg_awards_suppliers.*/

SELECT
	main_id,
    COUNT(*) AS award_supplier_records,
    COUNT(DISTINCT awards_id) AS unique_awards
FROM stg_awards_suppliers
GROUP BY main_id
ORDER BY unique_awards DESC;
/*As previously shown, a single main_id is associated with multiple supplier records in the
stg_awards_supplier table. Also, it is linked to multiple unique awards, upwards of 236 awards.*/

SELECT
	awards_supplier_records,
    COUNT(*) AS main_count
FROM (
	SELECT
		main_id,
        COUNT(*) AS awards_supplier_records
	FROM stg_awards_suppliers
    GROUP BY main_id
) x
GROUP BY awards_supplier_records
ORDER BY awards_supplier_records;
/*The query shows that a single record in stg_award_supplier is associated with multiple main_ids.
The majority of main_ids (61640) have only one record, even though there are some main_ids with
multiple awards_supplier records (upwards of 236). Thus, the relationship between stg_main and
stg_awards_suppliers has a one-to-many cardinality. */

-- Checking for white spaces in the data
SELECT
	id
FROM stg_awards_suppliers
WHERE id <> TRIM(id);
-- the id column has no whitespaces

SELECT
	name
FROM stg_awards_suppliers
WHERE name <> TRIM(name);
-- The name column has whitespaces

UPDATE stg_awards_suppliers
SET name = TRIM(name);
-- The name column has been updated to remove any whitespaces

SELECT
	main_ocid
FROM stg_awards_suppliers
WHERE main_ocid <> TRIM(main_ocid);
-- The main_ocid column has no whitespaces

SELECT
	main_id
FROM stg_awards_suppliers
WHERE main_id <> TRIM(main_id);
-- The main_id column has no whitespaces

SELECT
	awards_id
FROM stg_awards_suppliers
WHERE awards_id <> TRIM(awards_id);
-- The awards_id column has no whitespaces

SELECT * FROM stg_awards_suppliers LIMIT 20;

/*The name column in this table has mixed casing. Since MySQL does not have a
built-in function to handle proper capitalization of text and variable characters,
I opted to create a stored function that uses WHILE loop to capitalize each word
contained in a string.*/

DELIMITER $$
CREATE FUNCTION initcap2(str TEXT)
RETURNS TEXT
DETERMINISTIC
BEGIN
	DECLARE result TEXT DEFAULT '';
    DECLARE word TEXT;
    DECLARE remainder TEXT;
    DECLARE pos INT;
    
    SET remainder = TRIM(LOWER(str));
    
    WHILE remainder <> '' DO
		SET pos = LOCATE(' ', remainder);
        
        IF pos = 0 THEN
			SET word = remainder;
            SET remainder = '';
		ELSE
			SET word = LEFT(remainder, pos - 1);
            SET remainder = LTRIM(SUBSTRING(remainder, pos + 1));
		END IF;
        
        IF  word IN ('( KENYA )', '( KENYA)') THEN 
			SET word = REPLACE(REPLACE(word, '( ', '('), ' )', ')');
		ELSEIF word = '((E.A)' THEN
			SET word = REPLACE(word, '((', '(');
		ELSEIF word LIKE '%(%' THEN
			SET word = CONCAT(SUBSTRING_INDEX(word, '(', 1), '(', UPPER(SUBSTRING(SUBSTRING_INDEX(word, '(', -1), 1, 1)), SUBSTRING(SUBSTRING_INDEX(word, '(', -1), 2));
		END IF;
        
        SET result = CONCAT(
			result,
            CASE
				WHEN result = '' THEN ''
				ELSE ' '
			END,
			CASE
				WHEN word IN ('FM', 'M/S', 'HBDC', 'AAR', 'IT', 'ABNO', 'CIC', '(E.A)', '(E.A.)', '(EA)', '(AGPO)', '(KCD', '(I.B)', '(GKB826Y)', '(LLC)', '(EPZ)') THEN UPPER(word)
                WHEN word IN ('(k)', '(K)', '(kenya)', '(KENYA)', '(A)', '(ATS)', '(East', '(h', '(t') THEN CONCAT(SUBSTRING_INDEX(word, '(', 1), '(', UPPER(SUBSTRING(word, 2, 1)), LOWER(SUBSTRING(word, 3)))
				ELSE CONCAT(UPPER(LEFT(word, 1)), SUBSTRING(word, 2))
            END
		);
	END WHILE;
    RETURN result;
END$$
DELIMITER ;

SELECT
	name AS original_name,
    INITCAP(name) AS formatted_name
FROM stg_awards_suppliers;

SELECT
	name AS original_name,
    initcap2(name) AS formatted_name
FROM stg_awards_suppliers;

-- unwanted characters
SELECT
	initcap2(name)
FROM stg_awards_suppliers
WHERE name REGEXP '[^A-Za-z\\ \\.\&]';

SELECT
	name
FROM stg_awards_suppliers
WHERE name REGEXP '[^A-Za-z\\ \\.\\&\\,\\(\\)]';

SELECT
	name AS original_name,
    CASE
		WHEN name REGEXP '[A-Za-z][)]ltd' THEN REGEXP_REPLACE(name, ' ([A-Za-z0-9][)]ltd)', ' ($1) LTD')
        WHEN name REGEXP '[)]ltd' THEN REGEXP_REPLACE(name, '[)]ltd', ') LTD')
        ELSE name
	END AS fixed_name
FROM stg_awards_suppliers
WHERE name REGEXP '[)]ltd';

SELECT
	name AS original_name,
    CASE
		WHEN name REGEXP '[A-Za-z][)]ltd' THEN REGEXP_REPLACE(name, ' ([A-Za-z][)]ltd)', ' ($1) LTD')
        ELSE name
	END AS fixed_name
FROM stg_awards_suppliers
WHERE name REGEXP '[)]ltd';

SELECT
	name AS original_name,
	initcap2(REGEXP_REPLACE(	
        REGEXP_REPLACE(
			REGEXP_REPLACE(
				REGEXP_REPLACE(
					CASE
						WHEN name NOT LIKE '%(%' AND name LIKE '%)%' THEN
                        REPLACE(name, ')', ' ')
                        ELSE name
					END,
                    '[[:space:]]*\\(', ' ('),
                    '\\)[[:space:]]*', ') '),
                    '[[:space:]]+', ' '),
                    '\\([[:space:]]+', '(')) AS fixed_name
FROM stg_awards_suppliers
WHERE name LIKE '%(%' OR name LIKE '%)%';


UPDATE stg_awards_suppliers
SET name = TRIM(initcap2(REGEXP_REPLACE(	
        REGEXP_REPLACE(
			REGEXP_REPLACE(
				REGEXP_REPLACE(
					CASE
						WHEN name NOT LIKE '%(%' AND name LIKE '%)%' THEN
                        REPLACE(name, ')', ' ')
                        ELSE name
					END,
                    '[[:space:]]*\\(', ' ('),
                    '\\)[[:space:]]*', ') '),
                    '[[:space:]]+', ' '),
                    '\\([[:space:]]+', '(')))
WHERE name LIKE '%(%' OR name LIKE '%)%';

