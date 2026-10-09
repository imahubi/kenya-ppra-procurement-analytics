# Kenya PPRA Procurement Analytics

**End-to-end procurement data analysis using MySQL, SQL, and Power BI**

## Project Overview

This project analyzes Kenyan public procurement data to investigate procurement activity, award volumes, awarded values, supplier participation, procurement methods, and the conversion of awards into contracts.

The project follows an end-to-end analytical workflow, beginning with raw CSV data ingestion and staging, followed by data quality assessment, relational database normalization, data validation, exploratory data analysis, and Power BI reporting.

The objective is to transform raw procurement records into a structured analytical dataset and communicate meaningful findings through an interactive business intelligence report.

## Project Objectives

- Assess the completeness, consistency, and validity of raw procurement data.
- Create and load staging tables in MySQL.
- Identify missing values, duplicate identifiers, invalid dates, and other data quality issues.
- Design and implement a normalized relational database.
- Validate row counts, primary keys, foreign keys, and relationships.
- Investigate procurement activity and award values using SQL.
- Examine award value concentration across procurement categories.
- Analyze supplier participation and procurement methods.
- Examine the relationship between awards and contracts.
- Present findings through a multi-page Power BI report.

## Tools and Technologies

| Technology | Application |
|---|---|
| MySQL 8.0 | Data storage, transformation, validation, and analysis |
| MySQL Workbench | SQL development, database management, and EER modeling |
| SQL | Data quality checks, normalization, data loading, and EDA |
| Power BI | Interactive reporting and data visualization |
| DAX | Analytical measures and calculations |
| Git and GitHub | Version control, documentation, and portfolio presentation |

## Data Source

The project uses a Kenya PPRA procurement dataset containing procurement processes, awards, suppliers, contracts, and related information.

- **Source:** https://data.open-contracting.org/en/publication/147
- **Format:** CSV
- **Database:** MySQL
- **Reporting tool:** Power BI

The raw dataset is not included in this repository unless its redistribution terms permit it. Refer to [`data/README.md`](data/README.md) for source information and setup instructions.

## Project Pipeline

The analysis was organized into the following stages.

### 1. Data ingestion and staging

The source CSV files were imported into MySQL staging tables designed to preserve the structure of the original data.

Activities included:

- Creating staging tables.
- Importing CSV data.
- Checking imported row counts.
- Comparing total rows with distinct identifiers.
- Assessing the initial structure and completeness of the data.

The staging layer provided a controlled starting point for data profiling and transformation.

**Scripts:** [`sql/01_staging/`](sql/01_staging/)

### 2. Staging data quality assessment

The staging tables were examined for data quality issues before normalization.

Checks covered:

- Missing and null values.
- Duplicate and repeated identifiers.
- Date parsing and implausible date ranges.
- Unusual monetary values and numeric formats.
- Unmatched identifiers across related tables.
- Supplier name inconsistencies.
- Procurement start dates occurring after end dates.

Examples of issues identified included missing supplier names, repeated identifiers, scientific notation in some monetary values, unusual dates, and inconsistent procurement date sequences.

These issues were assessed before transformation. Anomalies were not automatically treated as errors that should be deleted, since some required further interpretation.

**Scripts:** [`sql/01_staging/data_quality/`](sql/01_staging/data_quality/)

### 3. Relational database design and normalization

The staging data was organized into a normalized relational schema to separate procurement entities, reduce unnecessary duplication, and support structured analysis.

The principal tables include:

- `procurement`
- `procurement_categories`
- `procurement_methods`
- `awards`
- `contracts`
- `roles`
- `parties`
- `suppliers`
- `procurement_parties`
- `awards_suppliers`

The design distinguishes procurement processes from awards and contracts, while representing categories, procurement methods, parties, roles, and suppliers through related tables.

Primary keys, foreign keys, and relationship cardinalities were considered during implementation. Validation queries were used to assess relationships and identify records that could not be loaded as expected.

### Entity Relationship Diagram

The EER diagram illustrates the normalized database structure, including its tables, keys, and relationships.

![Kenya PPRA Procurement Analytics EER Diagram](/docs/images/EER%20Diagram.png)

[View the EER diagram](/docs/images/EER%20Diagram.png)

**Scripts:** [`sql/02_normalization/`](sql/02_normalization/)

### 4. Loading and relationship validation

The normalized tables were populated from the staging data using separate SQL loading scripts.

Post-load validation examined:

- Source and destination row counts.
- Distinct identifiers.
- Primary key uniqueness.
- Foreign key matching.
- Unmatched records.
- Consistency between related tables.

This stage helped assess how the normalized data compared with the source and documented any discrepancies requiring attention.

### 5. Exploratory Data Analysis 1: Structure and validity

The first EDA stage established the structure and analytical suitability of the normalized data.

The analysis covered:

- Table roles and purpose.
- Table structures and data types.
- Row counts and distinct records.
- Missing values and completeness.
- Domain and validity checks.
- Date and monetary value plausibility.
- Key uniqueness and referential integrity.

The results informed the interpretation of subsequent business analyses and highlighted limitations that needed to be considered.

### 6. Exploratory Data Analysis 2: Business questions

The second EDA stage investigated procurement patterns and answered questions such as:

1. Which procurement categories have the highest procurement and award volumes?
2. Which categories have the highest average award values?
3. How is awarded value distributed across procurement categories?
4. What proportion of awarded value is attributable to the top 1%, 5%, and 10% of awards?
5. Which suppliers participate in procurement activity and receive awards?
6. How are procurement methods distributed across procurement processes?
7. How do award and contract counts compare?
8. What differences emerge between procurement volume and awarded value?

The analysis was used to develop the metrics and findings presented in Power BI.

**Scripts:** [`sql/03_eda/`](sql/03_eda/)

## Power BI Report

The Power BI report contains seven pages, each designed to examine a different aspect of procurement activity.

The screenshots below provide a visual overview of the report. Replace the image paths if your exported screenshot filenames differ.

### 1. Procurement Executive Overview

Provides a high-level view of procurement activity through key performance indicators and summary metrics.

![Procurement Executive Overview](/power%20bi/screenshots/procurement_executive_overview.png)

### 2. Procurement Profile

Examines procurement activity across categories and procurement characteristics, providing context for the distribution of procurement processes.

![Procurement Profile](/power%20bi/screenshots/procurement_profile.png)

### 3. Award Value Analysis

Investigates awarded values across procurement categories, including differences in average award value and the concentration of awarded value among the largest awards.

![Award Value Analysis](/power%20bi/screenshots/award_value_analysis.png)

### 4. Supplier Analysis

Examines supplier participation and award-related activity to explore how procurement awards are distributed across suppliers.

![Supplier Analysis](/power%20bi/screenshots/supplier_analysis.png)

### 5. Contracts and Award Conversion

Examines the relationship between awards and contracts, helping assess how award records relate to subsequent contract records in the available data.

![Contracts and Award Conversion](/power%20bi/screenshots/contracts_and_award_conversion.png)

### 6. Procurement Methods

Analyzes the distribution of procurement methods and their contribution to overall procurement activity.

![Procurement Methods](/power%20bi/screenshots/procurement_methods.png)

### 7. Summary: Key Findings

Consolidates the main analytical findings into a concise summary of procurement volumes, award values, and procurement method patterns.

![Summary: Key Findings](/power%20bi/screenshots/summary_key_findings.png)

## Key Findings

The analysis identified several notable patterns in procurement activity.

### Award volumes and procurement categories

- **Goods recorded the highest award volume**, with 48,719 awards.
- Works recorded 35,679 awards, fewer than Goods.
- Works had the highest procurement count, with 73,240 procurements.

Procurement counts and award counts represent different entities and should not be interpreted as equivalent measures.

### Award values and concentration

- **Works had the highest average award value**, at approximately 31.65 million.
- The top 1% of Works awards accounted for **76.59% of total awarded value in the Works category**.

This indicates a highly concentrated distribution of awarded value within Works. A relatively small proportion of awards accounts for a large share of the category's total awarded value.

### Procurement methods

- **Open procurement accounted for 90.41% of all procurements**, making it the most widely used method in the analyzed dataset.

These findings describe patterns in the available records. They do not independently establish procurement efficiency, fairness, compliance, or the reasons for award value concentration.

Monetary values should be interpreted using the currency recorded in the source data and the documented data preparation decisions.

## Repository Structure

```text
kenya-ppra-procurement-analytics/
├── README.md
├── .gitignore
├── docs/
│   ├── project_overview.md
│   ├── data_dictionary.md
│   ├── methodology.md
│   └── images/
│       └── EER Diagram.png
├── data/
│   └── README.md
├── sql/
│   ├── 01_staging/
│   │   └── data_quality/
│   ├── 02_normalization/
│   ├── 03_eda/
│   └── 04_reporting/
├── powerbi/
│   ├── README.md
│   └── screenshots/
│       ├── procurement_executive_overview.png
│       ├── procurement_profile.png
│       ├── award_value_analysis.png
│       ├── supplier_analysis.png
│       ├── contracts_and_award_conversion.png
│       ├── procurement_methods.png
│       └── summary_key_findings.png
└── results/
    ├── data_quality_summary.md
    └── eda_findings.md
```

This is the intended organization. The actual repository may contain additional scripts or slightly different filenames.

## Reproducing the Analysis

To reproduce the workflow:

1. Install MySQL and MySQL Workbench.
2. Obtain the source dataset using the instructions in `data/README.md`.
3. Create the staging tables.
4. Import the source data into staging.
5. Run the staging data quality checks.
6. Create the normalized database tables.
7. Execute the normalized data loading scripts in the documented order.
8. Run relationship and integrity validation queries.
9. Execute EDA 1 to assess data structure and validity.
10. Execute EDA 2 to reproduce the business analyses.
11. Connect Power BI to the resulting database.
12. Refresh the report and verify the reported metrics.

The exact execution order, database setup requirements, and any environment-specific import settings should be documented alongside the SQL scripts.

## Limitations

The analysis is subject to the limitations of the source data, including missing values, repeated identifiers, unusual dates, and inconsistent fields.

Some records may require further investigation before being used in specific analyses. Data preparation decisions can also affect row counts and aggregate results.

The distinction between procurements, awards, contracts, and suppliers is important when interpreting counts and relationships. Award value concentration describes the distribution of value across awards, but does not establish why that concentration exists.

Findings should therefore be interpreted in conjunction with the documented data quality checks and analytical definitions.

## Skills Demonstrated

- SQL data ingestion and transformation.
- Data profiling and data quality assessment.
- Relational database design and normalization.
- Primary key, foreign key, and relationship validation.
- Exploratory data analysis.
- Business-oriented SQL analysis.
- Procurement and award value analysis.
- Power BI dashboard development.
- DAX measures and analytical calculations.
- Technical documentation and version control.

## Author

**Name:** Ian Mahubi

**GitHub:** [My Github Profile](https://github.com/imahubi)

**LinkedIn:** [My LinkedIn Profile](https://www.linkedin.com/in/ian-mahubi-54a66a416/)