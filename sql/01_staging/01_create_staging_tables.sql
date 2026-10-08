-- The first staging table is "parties"
-- This table identifies organizations involved in the procurement process (e.g., suppliers and buyers)

CREATE TABLE stg_parties (
	id VARCHAR(15),
    name TEXT,
    roles VARCHAR(15),
    address_region VARCHAR(15),
    address_locality VARCHAR(15),
    address_countryname VARCHAR(15),
    identifier_id VARCHAR(15),
    identifier_scheme VARCHAR(15),
    identifier_legalname TEXT,
    main_ocid TEXT,
    main_id TEXT,
    address_postalcode TEXT,
    address_streetaddress TEXT,
    contactpoint_name TEXT,
    contactpoint_email TEXT,
    contactpoint_telephone TEXT
);

-- Next is the main table, an entity that captures the actual tendering process

CREATE TABLE stg_main (
	id TEXT,
    tag VARCHAR(15),
    date TEXT,
    ocid TEXT,
    language VARCHAR(10),
    initiationtype VARCHAR(15),
    buyer_id VARCHAR(15),
    buyer_name TEXT,
    tender_id TEXT,
    tender_title TEXT,
    tender_mainprocurementcategory VARCHAR(15),
    tender_mainprocurementmethod TEXT,
    tender_tenderperiod_enddate TEXT,
    tender_tenderperiod_startdate TEXT,
    tender_awardcriteria VARCHAR(15)
);

-- Next is the awards table, which captures the outcome of the tendering process

CREATE TABLE stg_awards (
	id VARCHAR(255),
    title VARCHAR(500),
    value_amount VARCHAR(200),
    value_currency VARCHAR(30),
    contractperiod_startdate VARCHAR(200),
    main_ocid VARCHAR(400),
    main_id VARCHAR(200),
    contractperiod_enddate VARCHAR(200),
    description TEXT
);

-- Next is the awards_suppliers table, showcasing the relationship between awards and suppliers

CREATE TABLE stg_awards_suppliers (
	id VARCHAR(20),
    name TEXT,
    main_ocid TEXT,
    main_id TEXT,
    awards_id TEXT
);

-- Next is the contracts table, capturing the formal agreement between buyers and suppliers after an award

CREATE TABLE stg_contracts (
	id TEXT,
    title TEXT,
    awardid TEXT,
    value_amount VARCHAR(20),
    value_currrency VARCHAR(10),
    period_startdate TEXT,
    main_ocid TEXT,
    main_id TEXT,
    date_signed TEXT,
    period_enddate TEXT,
    description TEXT,
    status VARCHAR(15)
);