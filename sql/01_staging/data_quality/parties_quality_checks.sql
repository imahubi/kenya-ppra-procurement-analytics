SELECT * FROM stg_parties LIMIT 10;

-- Whitespaces
SELECT
	COUNT(*) AS untrimmed_ids
FROM stg_parties
WHERE id <> TRIM(id);
/*The query counts those ids with whitespaces. Since the query returns a count of zero,
it means that there are no fields in this column containing whitespaces.*/

SELECT
	COUNT(*) AS untrimmed_names
FROM stg_parties
WHERE name <> TRIM(name);
/*The query counts those names that contain whitespaces. Its output shows that 61365 names
in this column contain whitespaces, necessitating trimming.*/

UPDATE stg_parties
SET name = TRIM(name);

SELECT
	COUNT(*) AS untrimmed_roles
FROM stg_parties
WHERE roles <> TRIM(roles);
/*The query counts those roles with whitespaces. Since the query returns a count of zero,
it means that there are no fields in this column containing whitespaces.*/

SELECT
	COUNT(*) AS untrimmed_region
FROM stg_parties
WHERE address_region <> TRIM(address_region);
/*The query counts those address_regions with whitespaces. Since the query returns a count of zero,
it means that there are no fields in this column containing whitespaces.*/

SELECT
	COUNT(*) AS untrimmed_locality
FROM stg_parties
WHERE address_locality <> TRIM(address_locality);
/*The query counts those address_locality with whitespaces. Since the query returns a count of zero,
it means that there are no fields in this column containing whitespaces.*/

SELECT
	COUNT(*) AS untrimmed_country
FROM stg_parties
WHERE address_countryname <> TRIM(address_countryname);
/*The query counts those address_countryname with whitespaces. Since the query returns a count of zero,
it means that there are no fields in this column containing whitespaces.*/

SELECT
	SUM(CASE WHEN id <> TRIM(id) THEN 1 ELSE 0 END) AS untrimmed_id,
    SUM(CASE WHEN name <> TRIM(name) THEN 1 ELSE 0 END) AS untrimmed_name,
    SUM(CASE WHEN roles <> TRIM(roles) THEN 1 ELSE 0 END) AS untrimmed_roles,
    SUM(CASE WHEN address_region <> TRIM(address_region) THEN 1 ELSE 0 END) AS untrimmed_region,
    SUM(CASE WHEN address_locality <> TRIM(address_locality) THEN 1 ELSE 0 END) AS untrimmed_locality,
    SUM(CASE WHEN address_countryname <> TRIM(address_countryname) THEN 1 ELSE 0 END) AS untrimmed_country,
    SUM(CASE WHEN identifier_id <> TRIM(identifier_id) THEN 1 ELSE 0 END) AS untrimmed_identifier,
    SUM(CASE WHEN identifier_scheme <> TRIM(identifier_scheme) THEN 1 ELSE 0 END) AS untrimmed_scheme,
    SUM(CASE WHEN identifier_legalname <> TRIM(identifier_legalname) THEN 1 ELSE 0 END) AS untrimmed_legalname,
    SUM(CASE WHEN main_ocid <> TRIM(main_ocid) THEN 1 ELSE 0 END) AS untrimmed_main_ocid,
    SUM(CASE WHEN main_id <> TRIM(main_id) THEN 1 ELSE 0 END) AS untrimmed_main_id,
    SUM(CASE WHEN address_postalcode <> TRIM(address_postalcode) THEN 1 ELSE 0 END) AS untrimmed_postalcode,
    SUM(CASE WHEN address_streetaddress <> TRIM(address_streetaddress) THEN 1 ELSE 0 END) AS untrimmed_streetaddress,
    SUM(CASE WHEN contactpoint_name <> TRIM(contactpoint_name) THEN 1 ELSE 0 END) AS untrimmed_contactpoint_name,
    SUM(CASE WHEN contactpoint_email <> TRIM(contactpoint_email) THEN 1 ELSE 0 END) AS untrimmed_email,
    SUM(CASE WHEN contactpoint_telephone <> TRIM(contactpoint_telephone) THEN 1 ELSE 0 END) AS untrimmed_telephone
FROM stg_parties;
/*The query blank cells in each column. Its result shows that the legal name contains 34058 fields with whitespaces.
The postalcode contains 1574 fields with whitespaces and the street address contains 4891 fields with whitespaces. The
contactpoint name, email and telephone contain 1783 fields, 4 fields, and 10 fields with whitespaces, respectively.*/

UPDATE stg_parties
SET
identifier_legalname = TRIM(identifier_legalname),
address_postalcode = TRIM(address_postalcode),
address_streetaddress = TRIM(address_streetaddress),
contactpoint_name = TRIM(contactpoint_name),
contactpoint_email = TRIM(contactpoint_email),
contactpoint_telephone = TRIM(contactpoint_telephone);
/*After the update, all columns have no whitespaces.*/

SELECT
	SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS null_ids,
    SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS null_names,
    SUM(CASE WHEN roles IS NULL THEN 1 ELSE 0 END) AS null_roles,
    SUM(CASE WHEN address_region IS NULL THEN 1 ELSE 0 END) AS null_regions,
    SUM(CASE WHEN address_locality IS NULL THEN 1 ELSE 0 END) AS null_locality,
    SUM(CASE WHEN address_countryname IS NULL THEN 1 ELSE 0 END) AS null_locality,
    SUM(CASE WHEN identifier_id IS NULL THEN 1 ELSE 0 END) AS null_identifiers,
    SUM(CASE WHEN identifier_scheme IS NULL THEN 1 ELSE 0 END) AS null_schemes,
    SUM(CASE WHEN identifier_legalname IS NULL THEN 1 ELSE 0 END) AS null_legalnames,
    SUM(CASE WHEN main_ocid IS NULL THEN 1 ELSE 0 END) AS null_main_ocids,
    SUM(CASE WHEN main_id IS NULL THEN 1 ELSE 0 END) AS null_main_ids,
    SUM(CASE WHEN address_postalcode IS NULL THEN 1 ELSE 0 END) AS null_postalcodes,
    SUM(CASE WHEN address_streetaddress IS NULL THEN 1 ELSE 0 END) AS null_streetaddress,
    SUM(CASE WHEN contactpoint_name IS NULL THEN 1 ELSE 0 END) AS null_contactpoint_names,
    SUM(CASE WHEN contactpoint_email IS NULL THEN 1 ELSE 0 END) AS null_emails,
    SUM(CASE WHEN contactpoint_telephone IS NULL THEN 1 ELSE 0 END) AS null_telephones
FROM stg_parties;
/*The query evaluates every column in the stg_parties table and counts up null fields per column.
It outputs zero for every count, suggesting that the table does not contain any null values.*/

SELECT
	SUM(CASE WHEN id = '' THEN 1 ELSE 0 END) AS null_ids,
    SUM(CASE WHEN name = '' THEN 1 ELSE 0 END) AS null_names,
    SUM(CASE WHEN roles = '' THEN 1 ELSE 0 END) AS null_roles,
    SUM(CASE WHEN address_region = '' THEN 1 ELSE 0 END) AS null_regions,
    SUM(CASE WHEN address_locality = '' THEN 1 ELSE 0 END) AS null_locality,
    SUM(CASE WHEN address_countryname = '' THEN 1 ELSE 0 END) AS null_countryname,
    SUM(CASE WHEN identifier_id = '' THEN 1 ELSE 0 END) AS null_identifiers,
    SUM(CASE WHEN identifier_scheme = '' THEN 1 ELSE 0 END) AS null_schemes,
    SUM(CASE WHEN identifier_legalname = '' THEN 1 ELSE 0 END) AS null_legalnames,
    SUM(CASE WHEN main_ocid = '' THEN 1 ELSE 0 END) AS null_main_ocids,
    SUM(CASE WHEN main_id = '' THEN 1 ELSE 0 END) AS null_main_ids,
    SUM(CASE WHEN address_postalcode = '' THEN 1 ELSE 0 END) AS null_postalcodes,
    SUM(CASE WHEN address_streetaddress = '' THEN 1 ELSE 0 END) AS null_streetaddress,
    SUM(CASE WHEN contactpoint_name = '' THEN 1 ELSE 0 END) AS null_contactpoint_names,
    SUM(CASE WHEN contactpoint_email = '' THEN 1 ELSE 0 END) AS null_emails,
    SUM(CASE WHEN contactpoint_telephone = '' THEN 1 ELSE 0 END) AS null_telephones
FROM stg_parties;
/*The query evaluates all columns in the table and counts up all blank cells in each column.
The name column has 224 blank values, address_region has 260412 blank values, address_locality
has 260412 blank values, address_countryname has 260412 blank values, identifer_id has 260412
blank values, identifer_scheme has 260412 blank values, identifier_legalname has 260636 blank
values, address_postalcode has 691019 blank values, address_streetaddress has 686859 blank values,
contactpoint_name has 672255 blank values, contactpoint_email has 695488 blank values, and 
contactpoint_telephone has 706522 blank values. Deleting these fields is not recommended
because of the potential loss of valuable information. Therefore, I opted to convert these
blank cells to nulls instead.*/

UPDATE stg_parties
SET name = NULL
WHERE name = '';

UPDATE stg_parties
SET identifier_legalname = NULL
WHERE identifier_legalname = '';

UPDATE stg_parties
SET address_region = NULL
WHERE address_region = '';

UPDATE stg_parties
SET address_locality = NULL
WHERE address_locality = '';

UPDATE stg_parties
SET address_countryname = NULL
WHERE address_countryname = '';

UPDATE stg_parties
SET identifier_id = NULL
WHERE identifier_id = '';

UPDATE stg_parties
SET identifier_scheme = NULL
WHERE identifier_scheme = '';

UPDATE stg_parties
SET identifier_legalname = NULL
WHERE identifier_legalname = '';

UPDATE stg_parties
SET address_postalcode = NULL
WHERE address_postalcode = '';

UPDATE stg_parties
SET address_streetaddress = NULL
WHERE address_streetaddress = '';

UPDATE stg_parties
SET contactpoint_name = NULL
WHERE contactpoint_name = '';

UPDATE stg_parties
SET contactpoint_email = NULL
WHERE contactpoint_email = '';

UPDATE stg_parties
SET contactpoint_telephone = NULL
WHERE contactpoint_telephone = '';

-- I will use my initcap stored function to fix the caps in name columns
SELECT
	name AS original_name,
    initcap2(name) AS fixed_name,
    identifier_legalname AS original_legalname,
    initcap2(identifier_legalname) AS fixed_legalname
FROM stg_parties;

UPDATE stg_parties
SET name = TRIM(initcap2(name));

UPDATE stg_parties
SET identifier_legalname = TRIM(initcap2(identifier_legalname));

SELECT * FROM stg_parties LIMIT 10;

-- There are potential candidate keys in the stg_parties table
	-- main_id

SELECT
	main_id,
    COUNT(*) AS parties
FROM stg_parties
GROUP BY main_id
ORDER BY parties DESC;
/*The query counts the number of parties for each main_id. Its output shows
that each main_id can have multiple parties involved, upwards of 758 parties.
From this finding, it can be deduced that the relationship between stg_main and
stg_parties has a cardinality of one-to-many.*/

SELECT
	COUNT(*) AS orphaned_parties
FROM stg_parties a
LEFT JOIN stg_main b
	ON a.main_id = b.id
WHERE NOT EXISTS (
	SELECT 1
    FROM stg_main c
    WHERE a.main_id = c.id
);
/*The query identifies those parties whose records are not existent in the
stg_main table. It outputs a zero, which implies that there are no orphan
party records. This means that all main_ids in the stg_parties table have a
corresponding record in the stg_main table.*/

SELECT * FROM stg_parties LIMIT 10;

SELECT DISTINCT
	contactpoint_name,
    contactpoint_email,
    contactpoint_telephone
FROM stg_parties;

SELECT COUNT(*)
FROM stg_parties
WHERE contactpoint_email NOT REGEXP '^[A-Za-z0-9._%+-[''][&]]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

SELECT COUNT(*)
FROM stg_parties
WHERE contactpoint_email REGEXP '[^A-Za-z0-9._%+-[&]]+@';

SELECT
	contactpoint_email AS original,
    REPLACE(contactpoint_email, '!', '') AS fixed_email
FROM stg_parties
WHERE contactpoint_email LIKE '%!%';

UPDATE stg_parties
SET contactpoint_email = REPLACE(contactpoint_email, '!', '')
WHERE contactpoint_email LIKE '%!%';

SELECT
	contactpoint_email,
    REPLACE(contactpoint_email, ' @', '@') AS fixed
FROM stg_parties
WHERE contactpoint_email LIKE '% @%';

UPDATE stg_parties
SET contactpoint_email = REPLACE(contactpoint_email, ' @', '@')
WHERE contactpoint_email LIKE '% @%';

SELECT contactpoint_email
FROM stg_parties
WHERE contactpoint_email NOT REGEXP '^[A-Za-z0-9._%+-[''][&]]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

SELECT contactpoint_email
FROM stg_parties
WHERE contactpoint_email LIKE '%''%';

UPDATE stg_parties
SET contactpoint_email = REPLACE(contactpoint_email, '=', '')
WHERE contactpoint_email LIKE 'D=%';

UPDATE stg_parties
SET	contactpoint_email = REPLACE(contactpoint_email, 'C0M','COM')
WHERE contactpoint_email LIKE '%c0_';

SELECT
	contactpoint_email,
    REGEXP_REPLACE(contactpoint_email, '\.com[A-Za-z0-9]$', '.com') AS fixed_email
FROM stg_parties
WHERE contactpoint_email REGEXP '\.com[A-Za-z0-9]$';

UPDATE stg_parties
SET contactpoint_email = REGEXP_REPLACE(contactpoint_email, '\.com[A-Za-z0-9]$', '.com')
WHERE contactpoint_email REGEXP '\.com[A-Za-z0-9]$';

SELECT
	contactpoint_email
FROM stg_parties
WHERE contactpoint_email LIKE '%?%';

UPDATE stg_parties
SET contactpoint_email = REPLACE(contactpoint_email, '?', '')
WHERE contactpoint_email LIKE '%?%';

SELECT
	contactpoint_email,
    SUBSTRING_INDEX(contactpoint_email, ';', 1) AS fixed_email
FROM stg_parties
WHERE contactpoint_email LIKE '%;%';

UPDATE stg_parties
SET contactpoint_email = SUBSTRING_INDEX(contactpoint_email, ';', 1)
WHERE contactpoint_email LIKE '%;%';

UPDATE stg_parties
SET contactpoint_email = NULL
WHERE contactpoint_email NOT REGEXP '^[A-Za-z0-9._%+-[''][&]]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$';

SELECT
	contactpoint_telephone
FROM stg_parties
WHERE contactpoint_telephone NOT REGEXP '\\+[0-9]+$';

SELECT
	contactpoint_telephone,
    CASE
		WHEN contactpoint_telephone LIKE '+%' THEN contactpoint_telephone
        WHEN contactpoint_telephone REGEXP '^[1-9][0-9]{7,14}$' THEN CONCAT('+', contactpoint_telephone)
        WHEN contactpoint_telephone REGEXP '^0[127][0-9]{8}' THEN CONCAT('+254', SUBSTRING(contactpoint_telephone, 2))
        ELSE contactpoint_telephone
	END AS fixed_no
FROM stg_parties
WHERE contactpoint_telephone NOT LIKE '+%'
AND contactpoint_telephone REGEXP '^[0-9]{10}';

SELECT
	contactpoint_telephone
FROM stg_parties
WHERE contactpoint_telephone LIKE '%/%';

UPDATE stg_parties
SET contactpoint_telephone = NULL
WHERE TRIM(UPPER(contactpoint_telephone)) LIKE 'n/a';

UPDATE stg_parties
SET contactpoint_telephone = SUBSTRING_INDEX(contactpoint_telephone, '/', 1)
WHERE contactpoint_telephone LIKE '%/%';

UPDATE stg_parties
SET contactpoint_telephone = 
	CASE
		WHEN contactpoint_telephone LIKE '$%' THEN contactpoint_telephone
        WHEN contactpoint_telephone REGEXP '^[1-9][0-9]{7,14}$' THEN CONCAT('+', contactpoint_telephone)
        WHEN contactpoint_telephone REGEXP '^0[127][0-9][8]$' THEN CONCAT('+254', SUBSTRING(contactpoint_telephone, 2))
        ELSE contactpoint_telephone
	END;
    
SELECT contactpoint_telephone, COUNT(*)
FROM stg_parties
WHERE LENGTH(contactpoint_telephone) < 10
GROUP BY contactpoint_telephone;

UPDATE stg_parties
SET contactpoint_telephone = NULL
WHERE LENGTH(contactpoint_telephone) < 10;

SELECT
	contactpoint_telephone,
    COUNT(*)
FROM stg_parties
WHERE contactpoint_telephone REGEXP '^00[0-9]+'
GROUP BY contactpoint_telephone;

UPDATE stg_parties
SET contactpoint_telephone = CONCAT('+', SUBSTRING(contactpoint_telephone, 3))
WHERE contactpoint_telephone LIKE '00%';

SELECT
	contactpoint_telephone, COUNT(*)
FROM stg_parties
WHERE contactpoint_telephone LIKE '%-%'
GROUP BY contactpoint_telephone;

UPDATE stg_parties
SET contactpoint_telephone = REPLACE(contactpoint_telephone, '-', '')
WHERE contactpoint_telephone LIKE '%-%';

SELECT
	contactpoint_telephone
FROM stg_parties
WHERE contactpoint_telephone REGEXP '^[0-9]{9}$';

UPDATE stg_parties
SET contactpoint_telephone = CONCAT('+254', contactpoint_telephone)
WHERE contactpoint_telephone REGEXP '^[0-9]{9}';

SELECT
	contactpoint_telephone
FROM stg_parties
WHERE contactpoint_telephone LIKE '%254254%';

UPDATE stg_parties
SET contactpoint_telephone = CONCAT('+254', SUBSTRING(contactpoint_telephone, 8))
WHERE contactpoint_telephone LIKE '+254254%';

SELECT
	contactpoint_telephone
FROM stg_parties
WHERE contactpoint_telephone LIKE '% %';

UPDATE stg_parties
SET contactpoint_telephone = REPLACE(contactpoint_telephone, ' ', '')
WHERE contactpoint_telephone LIKE '% %';

SELECT
	contactpoint_telephone,
    CASE
		WHEN contactpoint_telephone REGEXP '^[2][0-9]+$' THEN CONCAT('+', contactpoint_telephone)
        WHEN contactpoint_telephone REGEXP '^[7][0-9]+$' THEN CONCAT('+254', contactpoint_telephone)
        WHEN contactpoint_telephone REGEXP '^07[0-9]+$' THEN CONCAT('+254', SUBSTRING(contactpoint_telephone, 2))
        ELSE contactpoint_telephone
	END AS fixed
FROM stg_parties
WHERE contactpoint_telephone NOT LIKE '+%';

UPDATE stg_parties
SET contactpoint_telephone = CONCAT('+91', SUBSTRING(contactpoint_telephone, 2, 3), SUBSTRING(contactpoint_telephone, 5))
WHERE contactpoint_telephone LIKE '0253%';

UPDATE stg_parties
SET contactpoint_telephone = CONCAT('+4420', SUBSTRING(contactpoint_telephone, 4))
WHERE contactpoint_telephone LIKE '020%';
