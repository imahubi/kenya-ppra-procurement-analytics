INSERT INTO procurement_categories (
	category_name
)
SELECT DISTINCT
	tender_mainprocurementcategory
FROM stg_main
WHERE tender_mainprocurementcategory IS NOT NULL
ORDER BY tender_mainprocurementcategory;

INSERT INTO procurement_methods (
	method_name
)
SELECT distinct
	tender_mainprocurementmethod
FROM stg_main
WHERE tender_mainprocurementmethod IS NOT NULL
ORDER BY tender_mainprocurementmethod;

INSERT INTO roles (
	role_name
)
SELECT DISTINCT
	roles
FROM stg_parties
WHERE roles IS NOT NULL
ORDER BY roles;

INSERT INTO parties (
	source_party_id,
    name,
    identifier_id,
    scheme,
    legalname,
    address_region,
    address_locality,
    address_country,
    address_postalcode,
    streetaddress,
    contact_name,
    contact_email,
    contact_telephone
)
SELECT
	id,
    name,
    identifier_id,
    identifier_scheme,
    identifier_legalname,
    address_region,
    address_locality,
    address_countryname,
    address_postalcode,
    address_streetaddress,
    contactpoint_name,
    contactpoint_email,
    contactpoint_telephone
FROM stg_parties;


INSERT INTO suppliers (
	supplier_name
)
SELECT DISTINCT
	name
FROM stg_awards_suppliers
WHERE name IS NOT NULL
AND TRIM(name) <> ''
ORDER BY name;

INSERT INTO procurement (
	procurement_id,
    ocid,
    tag,
    procurement_date,
    language,
    initiationtype,
    tender_id,
    tender_title,
    procurement_category_id,
    procurement_method_id,
    award_criteria,
    startdate,
    enddate
)
SELECT
	a.id,
    a.ocid,
    a.tag,
    a.date,
    a.language,
    a.initiationtype,
    a.tender_id,
    a.tender_title,
    b.category_id,
    c.method_id,
    a.tender_awardcriteria,
    a.tender_tenderperiod_startdate,
    a.tender_tenderperiod_enddate
FROM stg_main a
LEFT JOIN procurement_categories b
	ON a.tender_mainprocurementcategory = b.category_name
LEFT JOIN procurement_methods c
	ON a.tender_mainprocurementmethod = c.method_name;

INSERT INTO awards (
	award_id,
    title,
    procurement_id,
    value_amount,
    currency,
    startdate,
    enddate,
    description
)
SELECT
	a.id,
    a.title,
    b.procurement_id,
    a.value_amount,
    a.value_currency,
    a.contractperiod_startdate,
    a.contractperiod_enddate,
    a.description
FROM stg_awards a
LEFT JOIN procurement b
	ON a.main_id = b.procurement_id
WHERE a.id IS NOT NULL
AND TRIM(a.id) <> '';

INSERT INTO contracts (
	contract_id,
    award_id,
    title,
    value_amount,
    currency,
    date_signed,
    startdate,
    enddate,
    description,
    status
)
SELECT
	a.id,
    b.award_id,
    a.title,
    a.value_amount,
    a.value_currency,
    a.date_signed,
    a.period_startdate,
    a.period_enddate,
    a.description,
    a.status
FROM stg_contracts a
LEFT JOIN awards b
	ON a.awardid = b.award_id;

INSERT INTO procurement_parties (
	procurement_id,
    party_id,
    role_id
)
SELECT DISTINCT
	b.procurement_id,
    a.party_id,
    c.role_id
FROM stg_parties s
JOIN procurement b
	ON s.main_id = b.procurement_id
JOIN parties a
	ON s.id = a.party_id
JOIN roles c
	ON s.roles = c.role_name;
    
INSERT INTO awards_suppliers (
	award_id,
    supplier_id
)
SELECT
	a.award_id,
    b.supplier_id
FROM stg_awards_suppliers sas
JOIN awards a
	ON sas.awards_id = a.award_id
JOIN suppliers b
	ON sas.name = b.supplier_name;
/*There are 19 award-suppliers records that contain no supplier names and,
as a result, were excluded from the final normalized supplier relaationship
table.*/

SELECT
	COUNT(*) AS staging_rows,
    COUNT(sas.awards_id) AS rows_with_awards_id,
    COUNT(sas.name) AS rows_with_supplier_name,
    COUNT(a.award_id) AS matched_awards,
    COUNT(s.supplier_id) AS matchedd_suppliers
FROM stg_awards_suppliers sas
LEFT JOIN awards a
	ON sas.awards_id = a.award_id
LEFT JOIN suppliers s
	ON sas.name = s.supplier_name;

