CREATE TABLE IF NOT EXISTS procurement_categories (
	category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(20) UNIQUE
);

CREATE TABLE IF NOT EXISTS procurement_methods (
	method_id INT PRIMARY KEY AUTO_INCREMENT,
    method_name VARCHAR(30) UNIQUE
);

CREATE TABLE IF NOT EXISTS roles (
	role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(10) UNIQUE
);

CREATE TABLE IF NOT EXISTS parties (
	party_id INT PRIMARY KEY,
    name VARCHAR(500),
    identifier_id INT,
    scheme VARCHAR(8),
    legalname VARCHAR(500),
    address_region VARCHAR(20),
    address_locality VARCHAR(20),
    address_country VARCHAR(20),
    address_postalcode VARCHAR(50),
    streetaddress VARCHAR(500),
    contact_name VARCHAR(500),
    contact_email VARCHAR(255),
    contact_telephone VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS suppliers (
	supplier_id INT PRIMARY KEY AUTO_INCREMENT,
    supplier_name VARCHAR(500)
);

CREATE TABLE IF NOT EXISTS procurement (
	procurement_id VARCHAR(500) PRIMARY KEY,
    ocid VARCHAR(500),
    tag VARCHAR(10),
    procurement_date DATETIME,
    language VARCHAR(5),
    initiationtype VARCHAR(10),
    tender_id VARCHAR(500),
    tender_title TEXT,
    procurement_category_id INT,
    procurement_method_id INT,
    award_criteria VARCHAR(10),
    startdate DATETIME,
    enddate DATETIME,
    FOREIGN KEY (procurement_category_id) REFERENCES procurement_categories(category_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
    FOREIGN KEY (procurement_method_id) REFERENCES procurement_methods(method_id)
    ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS awards (
	award_id VARCHAR(255) PRIMARY KEY,
    title TEXT,
    procurement_id VARCHAR(255),
    value_amount DECIMAL(20,6),
    currency CHAR(3),
    startdate DATETIME,
    enddate DATETIME,
    description TEXT,
    FOREIGN KEY (procurement_id) REFERENCES procurement(procurement_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS contracts (
	contract_id VARCHAR(500) PRIMARY KEY,
    award_id VARCHAR(255),
    title TEXT,
    value_amount DECIMAL(20,9),
    currency CHAR(3),
    date_signed DATETIME,
    startdate DATETIME,
    enddate DATETIME,
    description TEXT,
    status VARCHAR(15),
    FOREIGN KEY (award_id) REFERENCES awards(award_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS procurement_parties (
	procurement_id VARCHAR(255),
    party_id INT,
    role_id INT,
    PRIMARY KEY (procurement_id, party_id, role_id),
    FOREIGN KEY (procurement_id) REFERENCES procurement(procurement_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (party_id) REFERENCES parties(party_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (role_id) REFERENCES roles(role_id)
    ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS awards_suppliers (
	award_id VARCHAR(255),
    supplier_id INT,
    PRIMARY KEY (award_id, supplier_id),
    FOREIGN KEY (award_id) REFERENCES awards(award_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
    ON DELETE CASCADE ON UPDATE CASCADE
);