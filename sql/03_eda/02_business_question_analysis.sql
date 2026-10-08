-- Step 1: Understanding tables' roles
	-- Table: Parties
		-- Purpose: Stores information about organizations and other entities involved in the procurement process
		-- Grain: One row per party
		-- Primary Key: party_id
		-- Foreign Keys: None
		-- Important attributes: name, identifier_id, legalname, contact_email, address_postalcode, streetaddress
        
	-- Table: Roles
		-- Purpose: Defines the roles that parties can play in a procurement
        -- Grain: One row per role
        -- Primary Key: role_id
        -- Foreign Key: None
        -- Importnt attributes: role_name

	-- Table: Procurement
        -- Purpose: Documents individual procurement process
        -- Grain: One row per procurement process
        -- Primary Key: procurement_id
        -- Foreign Keys: procurement_category_id, procurement_method_id
        -- Important attributes: ocid, tender_id, tender_title, procurement_category_id, procurement_method_id
        
	-- Table: Awards
        -- Purpose: Stores awards associated with procurement processes
        -- Grain: One row per award
        -- Primary Key: award_id
        -- Foreign Keys: procurement_id
        -- Important attributes: title, value_amount, startdate, enddate
    
    -- Table: Contracts
		-- Purpose: Stores contracts associated with awards
        -- Grain: One row per contract
        -- Primary Key: contract_id
        -- Foreign Key: award_id
        -- Important attributes: title, value_amount, date_signed, startdate, enddate, status
	
    -- Table: Awards_suppliers
		-- Purpose: Links awards to their associated suppliers
        -- Grain: One row per unique award-supplier record
        -- Primary Key: award_id, supplier_id
        -- Foreign Key: award_id, supplier_id
    
    -- Table: Suppliers
		-- Purpose: Stores suppliers associated with procurement awards
        -- Grain: One row per supplier
        -- Primary Key: supplier_id
        -- Foreign Key: None
        -- Important attributes: supplier_name
	
	-- Table: Procurement_categories
		-- Purpose: Classifies procurement by category (i.e., goods, services, works)
        -- Grain: One row per procurement category
        -- Primary Key: category_id
        -- Foreign Key: None
        -- Important attributes: category_name
        
	-- Table: Procurement_methods
		-- Purpose: Classifies procurement according to their procurement method
        -- Grain: One row per procurement method
        -- Primary Key: method_id
        -- Foreign Key: None
        -- Important attributes: method_name
        
	-- Table: Procurement_parties
		-- Purpose: Links parties to procurements and records the role each party plays in the procurement
        -- Grain: One row per unique procurement-party relationship
        -- Primary Keys: procurement_id, party_id, role_id
        -- Foreign Keys: procurement_id, party_id, role_id

-- Step 2: Row Count and Basic Structure
	-- Awards
SELECT
	COUNT(*) AS total_count
FROM awards; -- 109125 rows

DESCRIBE awards;
/*The awards table has 8 columns With all but the primary key
 allowing nulls. All the data types match the data in the columns
 as well.*/
 
SELECT
	COUNT(*) AS total_rows,
    COUNT(award_id) AS non_null_ids,
    COUNT(DISTINCT award_id) AS unique_ids
FROM awards;
/*Total rows equals the number of non-null ids and unique ids for
this table. This result implies that each row in the awards table
has a unique identifier.*/

-- awards_suppliers
SELECT
	COUNT(*) AS total_rows
FROM awards_suppliers; -- 79813 total rows

DESCRIBE awards_suppliers;
/*The table has 2 columns and a composite primary key comprising
a combination of award_id and supplier_id. These columns do not
allow for nulls.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(CONCAT(award_id, '|', supplier_id)) AS total_id_combinations,
    COUNT(DISTINCT CONCAT(award_id, '|', supplier_id)) AS distinct_id_combinations
FROM awards_suppliers;
/*As previously mentioned, this table has a composite primary key. To
determine whether their combinations is unique for each row, then the total
row count must match the id combinations and distinct id combinations. This
is what the query finds.*/

	-- contracts
SELECT
	COUNT(*)
FROM contracts; -- 109125 total rows

DESCRIBE contracts;
/*The contracts table has 10 columns, which constitutes one primary key and
one foreign key column. The other columns, including the foreign key, allow
for nulls.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(contract_id) AS non_null_ids,
    COUNT(DISTINCT contract_id) AS unique_ids
FROM contracts;
/*The number of rows in the contracts table matches the count of non-null
ids and unique ids. This means that this table has a unique identifier for
each row.*/

	-- parties
SELECT COUNT(*) FROM parties; -- 811754 total rows

DESCRIBE parties;
/*The parties table has 14 columns with one primary key. The table has no
foreign keys. Also, except for the primary key, the other columns accept
nulls.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(party_id) AS non_null_ids,
    COUNT(DISTINCT party_id) AS unique_ids
FROM parties;
/*The parties table has 811754 total rows, which is the same count for
non-null ids and unique ids. This means that the table has a unique identifier
for each row.*/

	-- procurement
SELECT
	COUNT(*)
FROM procurement; -- 259132 total rows


DESCRIBE procurement;
/*The procurement table has 13 columns. It has one primary key and two foreign keys.
Aside from the primary key, all the other columns accept null values and duplicates.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(procurement_id) AS non_null_ids,
    COUNT(DISTINCT procurement_id) AS unique_ids
FROM procurement;
/*The procurement table has 259132 rows. The number of non-null ids equalsthe count of
unique ids, implying that each row has a unique identifier.*/

	-- procurement_parties
SELECT
	COUNT(*)
FROM procurement_parties; -- 811754 total rows

DESCRIBE procurement_parties;
/*This is a junction table with only 3 columns, intended for keeping records of the roles
that parties in each procurement transaction.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(CONCAT_WS('|', procurement_id, party_id, role_id)) AS non_null_pk,
    COUNT(DISTINCT CONCAT_WS('|', procurement_id, party_id, role_id)) AS unique_pk_combi
FROM procurement_parties;
/*Since the table uses a composite primary key, each row must have a unique combination
of the three columns (i.e., procurement_i, party_id, and role_id). The procurement_parties
table has 811754 total rows, which is the same for the count of unique column combination. 
This means each row is unique.*/

	-- suppliers
SELECT
	COUNT(*)
FROM suppliers; -- 37629 total rows

DESCRIBE suppliers;
/*This table has 2 columns, one primary key and no foreign keys. The supplier_name column
allows for nulls and duplicates while the supplier_id (PK) is unique.*/

SELECT
	COUNT(*) AS total_rows,
    COUNT(supplier_id) AS non_null_ids,
    COUNT(DISTINCT supplier_id) AS unique_ids
FROM suppliers;
/*The total row count is the same for non-null ids and unique ids, which means every
row has a unique identifier.*/

-- Reconciling normalized data against staging
	-- stg_awards vs awards
SELECT
	COUNT(*) AS total_rows
FROM stg_awards
UNION ALL
SELECT
	COUNT(*)
FROM awards;
/*The number of awards in the staging and normalized tables remains the same. This means
all the award records survived the cleaning process.*/

	-- awards_suppliers
SELECT
	COUNT(*) AS total_rows
FROM stg_awards_suppliers
UNION ALL
SELECT
	COUNT(*)
FROM awards_suppliers;
/*At the staging level, there were 79832 awards_suppliers records. 19 records were dropped
during the normalization stage because they missed supplier names. A relationship cannot
reference a supplier entity that does not exist.*/

	-- contracts
SELECT
	COUNT(*) AS total_rows
FROM stg_contracts
UNION ALL
SELECT
	COUNT(*)
FROM contracts;
/*All the contract records survived the normalization step (109125 v 109125).*/

	-- parties
SELECT
	COUNT(*) AS total_rows
FROM stg_parties
UNION ALL
SELECT
	COUNT(*)
FROM parties;
/*All the records from the staging parties table survived the normalization process.*/

	-- stg_main vs procuremet
SELECT
	COUNT(*) AS total_rows
FROM stg_main
UNION ALL
SELECT
	COUNT(*)
FROM procurement;
/*All the records of procurement survived the normalization process (259132 v 259132).*/

-- Domain and validity Checks
	-- Date columns
    -- checking for instances where startdate is more recent than the enddate
SELECT
	COUNT(*) AS invalids
FROM awards
WHERE startdate > enddate; -- no invalids

SELECT
	COUNT(*) AS invalids
FROM contracts
WHERE startdate > enddate; -- no invalids

SELECT
	COUNT(*) AS invalids
FROM procurement
WHERE startdate > enddate
AND startdate IS NOT NULL
AND enddate IS NOT NULL;
/*The are 113628 invalids in the procurement table where the startdate is more
recent than the enddate. */

SELECT
	COUNT(*)
FROM (
SELECT
	startdate,
    enddate
FROM procurement
WHERE startdate > enddate
) x;

SELECT
	COUNT(*) AS total_rows,
    COUNT(startdate) AS startdates,
    COUNT(enddate) AS enddates,
    SUM(startdate > enddate) AS start_after_end,
    SUM(startdate = enddate) AS same_date,
    SUM(startdate < enddate) AS valid_ranges
FROM procurement
WHERE startdate IS NOT NULL
AND enddate IS NOT NULL;
/*For all non-null dates (i.e., startdates and enddates), there are 258880 startdates
and 258880 enddates, which match the totl number of rows. There are also 113628 instances
where the startdate are greater than the enddate. There are also 108100 instances where
the startdates and enddates are the same. So far, only 37152 can be considered valid ranges,
in that the startdate is less than the enddate.*/

SELECT
	COUNT(*) AS total_rows,
    SUM(startdate > enddate) AS start_after_end,
    ROUND(100 * SUM(startdate > enddate) / COUNT(*), 2) AS pct_start_after_end
FROM procurement
WHERE startdate IS NOT NULL
AND enddate IS NOT NULL;
/*Instances where startdates are more recent than enddates represent about 43.89%. */

SELECT
	COUNT(*) AS total_rows,
    SUM(tender_tenderperiod_startdate > tender_tenderperiod_enddate) AS start_after_end,
    ROUND(100 * SUM(tender_tenderperiod_startdate > tender_tenderperiod_enddate) / COUNT(*), 2) AS pct
FROM stg_main
WHERE tender_tenderperiod_startdate IS NOT NULL
AND tender_tenderperiod_enddate IS NOT NULL;
/*The instances where startdates are more recent than their corresponding enddates arise
from the source tables. As shown in this query, 43.89% of all startdates in the stg_main
table exhibit this behaviour.*/

SELECT
	YEAR(startdate) AS start_year,
    YEAR(enddate) AS end_year,
    COUNT(*) AS records,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM procurement WHERE startdate > enddate), 2) AS pct_of_total
FROM procurement
WHERE startdate > enddate
GROUP BY start_year, end_year
ORDER BY records DESC;
/*The instances where the startdate occurs after the enddate are concentrated for 2025-2024 combinations,
where 2025 is the start year and 2024 is the end year (19.26%). Other year combinations of interest include
2025-2023 (17.23%), 2026-2026 (13.24%), 2025-2025 (11.29%), 2025-2022 (10.07%), 2025-2021 (6.39%), and
2026-2025 (5.87%).*/

