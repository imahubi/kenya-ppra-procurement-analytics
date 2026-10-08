/*The MySQL Workbench Table Data Import Wizard was initially used to load the source
CSV files into staging tables. However, multiple files failed to load completely because
of CSV formatting characteristics such as quoted fields and embedded line breaks.

The ingestion process was therefore changed to MySQL's LOAD DATA LOCAL INFILE statement.
The source files were loaded directly into staging tables using UTF-8 encoding and
CSV-specific field handling.

The CSV files did not all use the same line-ending format. "awards.csv" required '\r\n'
while "awards_suppliers.csv", "contracts.csv", "main.csv", and "parties.csv" used '\n'.

All staging tables were subsequently validated against their respective source files. The
final imports completed successfully without any warnings.*/

-- Note that I obscured my username from the local link for privacy purposes. 
-- Loading data into stg_awards (the staging table for awards) using direct load data option:

LOAD DATA LOCAL INFILE 'C:/Users/[***]/Downloads/kenya_ppra_full.csv/full/awards.csv'
INTO TABLE stg_awards
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(id, title, value_amount, value_currency, contractperiod_startdate, main_ocid, main_id, contractperiod_enddate, description);

-- Loading data into stg_awards_suppliers (the staging table for awards_suppliers):

LOAD DATA LOCAL INFILE 'C:/Users/[***]/Downloads/kenya_ppra_full.csv/full/awards_suppliers.csv'
INTO TABLE stg_awards_suppliers
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, name, main_ocid, main_id, awards_id);

-- Loading data into stg_contracts (the staging table for contracts):

LOAD DATA LOCAL INFILE 'C:/Users/[***]/Downloads/kenya_ppra_full.csv/full/contracts.csv'
INTO TABLE stg_contracts
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id, title, awardid, value_amount, value_currency, period_startdate, main_ocid, main_id, date_signed, period_enddate, description, status);

-- Loading data into stg_main (the staging table for the main file):

LOAD DATA LOCAL INFILE 'C:/Users/[***]/Downloads/kenya_ppra_full.csv/full/main.csv'
INTO TABLE stg_main
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id,
tag,
date,
ocid,
language,
initiationtype,
buyer_id,
buyer_name,
tender_id,
tender_title,
tender_mainprocurementcategory,
tender_mainprocurementmethod,
tender_tenderperiod_enddate,
tender_tenderperiod_startdate,
tender_awardcriteria);

-- Loading data into stg_parties (the staging table for parties): 

LOAD DATA LOCAL INFILE 'C:/Users/[***]/Downloads/kenya_ppra_full.csv/full/parties.csv'
INTO TABLE stg_parties
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(id,
name,
roles,
address_region,
address_locality,
address_countryname,
identifier_id,
identifier_scheme,
identifier_legalname,
main_ocid,
main_id,
address_postalcode,
address_streetaddress,
contactpoint_name,
contactpoint_email,
contactpoint_telephone);