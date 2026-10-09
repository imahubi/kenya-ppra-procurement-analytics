# Data Dictionary: Kenya PPRA Procurement Analytics

## 1. Purpose

This document describes the normalized MySQL database used for the Kenya PPRA Procurement Analytics project. It summarizes the purpose of each table, key fields, and relationships between entities.

The database was designed to organize procurement, award, contract, and supplier information into related tables to reduce redundancy and support reliable analysis in SQL and Power BI.

**Note:** Field names and relationships should be checked against the final MySQL schema. This document describes the known structure and conceptual roles of the fields, not a substitute for the actual `CREATE TABLE` definitions.

## 2. Database Structure

The normalized database contains the following tables:

| Table | Purpose |
|---|---|
| `procurement` | Stores procurement records and tender-related information. |
| `procurement_categories` | Stores procurement category classifications, such as goods, works, and services. |
| `procurement_methods` | Stores procurement method classifications. |
| `awards` | Stores award records and associated award values and dates. |
| `contracts` | Stores contract information associated with procurement records. |
| `parties` | Stores party information, including party names and identifiers. |
| `roles` | Defines party roles, such as buyer or supplier. |
| `procurement_parties` | Links procurement records to parties and their roles. |
| `suppliers` | Stores supplier-related records used in the procurement model. |
| `awards_suppliers` | Connects award records with supplier records. |

## 3. Table and Field Descriptions

### 3.1 `procurement`

**Purpose:** Central table containing procurement-level information.

| Field | Description |
|---|---|
| `procurement_id` | Internal primary key identifying a procurement record. |
| `ocid` | Original procurement identifier from the source data. |
| `tag` | Source classification or record tag. |
| `startdate` | Recorded procurement start date. |
| `enddate` | Recorded procurement end date. |
| Tender-related fields | Store information describing the tender, its classification, or its procedure. |
| Category foreign key | Links a procurement record to `procurement_categories`. |
| Method foreign key | Links a procurement record to `procurement_methods`. |

The exact names and data types of the tender-related fields and foreign keys should be taken from the final table definition.

### 3.2 `procurement_categories`

**Purpose:** Maintains the available procurement category classifications.

| Field | Description |
|---|---|
| Primary key | Uniquely identifies a category. |
| Category name | Describes the procurement category, such as goods, works, or services. |

### 3.3 `procurement_methods`

**Purpose:** Maintains procurement method classifications.

| Field | Description |
|---|---|
| Primary key | Uniquely identifies a procurement method. |
| Method name | Describes the procurement procedure, such as open procurement. |

### 3.4 `awards`

**Purpose:** Stores award-level information used to analyse award volumes and values.

| Field | Description |
|---|---|
| Primary key | Uniquely identifies an award record. |
| Procurement reference or foreign key | Connects the award to its associated procurement record. |
| Award value | Recorded monetary value of the award. |
| Award date fields | Store relevant award dates where available. |

The actual column names, date fields, and relationship key should be verified against the final schema.

### 3.5 `contracts`

**Purpose:** Stores contract-level information for analysing the relationship between procurement activity and contract records.

| Field | Description |
|---|---|
| Primary key | Uniquely identifies a contract record. |
| Procurement reference or foreign key | Links the contract to its associated procurement record. |
| Contract date fields | Store contract-related dates where available. |
| Other contract attributes | Store additional contract information retained from the source. |

### 3.6 `parties`

**Purpose:** Stores information about entities participating in procurement activities.

| Field | Description |
|---|---|
| Primary key | Uniquely identifies a party in the normalized model. |
| Party name | Records the name of the organization or entity. |
| Source identifier, if retained | Preserves a link to the original party record. |

### 3.7 `roles`

**Purpose:** Defines the roles parties perform in procurement records.

| Field | Description |
|---|---|
| Primary key | Uniquely identifies a role. |
| Role name | Describes the role, such as buyer or supplier. |

### 3.8 `procurement_parties`

**Purpose:** Implements the relationship between procurement records and parties, including the role associated with each relationship.

| Field | Description |
|---|---|
| Procurement foreign key | References a procurement record. |
| Party foreign key | References a party. |
| Role foreign key | References a role in `roles`. |

This table supports analysis involving buyers and other participants without storing party names repeatedly in every procurement record.

### 3.9 `suppliers`

**Purpose:** Stores supplier-related information used in award and supplier analysis.

| Field | Description |
|---|---|
| Primary key | Uniquely identifies a supplier record. |
| Supplier name | Stores the supplier's recorded name. |
| Source identifier, if retained | Links the supplier record to its source representation. |

Supplier identifiers and party identifiers should not be assumed to be interchangeable unless the implemented schema explicitly establishes that relationship.

### 3.10 `awards_suppliers`

**Purpose:** Connects award records to their associated supplier records.

| Field | Description |
|---|---|
| Award foreign key | References an award record. |
| Supplier foreign key | References a supplier record. |
| Additional retained attributes | Any supplier-award attributes preserved from the source data. |

The precise cardinality and uniqueness constraints should be confirmed against the implemented keys.

## 4. Key Relationships

The intended relational structure includes the following relationships:

- One procurement category can classify multiple procurement records.
- One procurement method can be associated with multiple procurement records.
- A procurement record can be associated with award and contract records.
- `procurement_parties` connects procurement records with parties and their roles.
- `awards_suppliers` connects awards with supplier records.

The exact one-to-one or one-to-many cardinalities depend on the final primary keys, foreign keys, and uniqueness constraints.

## 5. Data Quality Considerations

The source and staging data were assessed for issues that could affect analysis, including:

- Missing or blank values.
- Duplicate identifiers and repeated records.
- Invalid or implausible dates.
- Inconsistent supplier-name formatting.
- Monetary values represented in scientific notation.
- Records that could not be matched across related tables.

These issues should be interpreted alongside the SQL validation scripts and the documented cleaning decisions.

## 6. Related Documentation

- [Project Overview](project_overview.md)
- [Methodology](methodology.md)
- [Root README](../README.md)