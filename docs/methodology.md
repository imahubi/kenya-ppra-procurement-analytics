# Methodology: Kenya PPRA Procurement Analytics

## 1. Overview

This project uses a structured data analytics workflow to examine Kenya PPRA procurement records. MySQL is used for data staging, quality assessment, cleaning, normalization, and exploratory data analysis. Power BI is used to model the prepared data, calculate analytical measures, and present findings through an interactive report.

The methodology emphasizes data integrity, traceable transformations, and transparent interpretation of results.

## 2. Data Import and Staging

The analysis begins with source CSV files imported into MySQL staging tables.

The main staging tables include:

- `stg_main`
- `stg_awards`
- `stg_awards_suppliers`

Staging preserves the source records in a form suitable for validation before they are loaded into the normalized database.

Initial validation includes comparing imported row counts with expected counts, inspecting import warnings, checking identifier uniqueness, and identifying missing or malformed values.

Import discrepancies are investigated before the data is used for downstream analysis.

## 3. Data Quality Assessment

Data quality checks are conducted before and during normalization.

### 3.1 Completeness

Queries identify missing or blank values in relevant fields, including dates, supplier names, and relationship identifiers.

Missing values are evaluated according to their analytical importance. They are not automatically replaced with assumed values.

### 3.2 Uniqueness and duplicates

Identifiers are checked for uniqueness and repeated records. Where an identifier occurs more than once, the associated records are inspected to determine whether they represent duplicate data or distinct records sharing an identifier.

Records are not removed solely because an identifier is repeated without first considering the available attributes and intended table grain.

### 3.3 Date validity

Date fields are checked for parsing errors, implausible values, and inconsistencies such as a recorded start date occurring after the end date.

The source contains date-quality issues, including dates outside the expected procurement reporting period. These records require explicit validation and documented handling rather than silent correction.

### 3.4 Monetary values

Award values are inspected for missing values, unusual magnitudes, and scientific notation.

Values represented in scientific notation are examined to ensure that they can be interpreted and stored correctly. Extremely large values are not automatically classified as errors without further evidence.

### 3.5 Supplier-name consistency

Supplier names are inspected for inconsistent spacing, capitalization, and malformed punctuation. Standardization is applied where justified, while preserving the distinction between formatting differences and genuinely different entities.

### 3.6 Referential integrity

Foreign-key relationships are checked to identify records that do not match the expected parent table. Unmatched records are investigated, and their handling is documented rather than assumed.

## 4. Data Cleaning and Normalization

After the initial quality assessment, the data is organized into related tables.

The normalized design separates procurement categories, procurement methods, parties, roles, suppliers, awards, and contracts into appropriate entities. Linking tables are used to represent relationships between procurement records and parties, and between awards and suppliers.

This design supports more consistent analysis by reducing repeated descriptive information and establishing explicit relationships between entities.

Primary keys and foreign keys are used where defined in the implemented schema. Validation queries are used to check the integrity of the loaded data.

Cleaning decisions are based on the actual source values and observed quality issues. The project does not assume that every missing value can be recovered or that every repeated identifier represents a duplicate.

## 5. Exploratory Data Analysis

SQL queries are used to investigate the structure and distribution of the prepared data before report development.

The analysis covers:

- Record counts and completeness across major tables.
- Procurement volumes by category and method.
- Award counts and recorded award values.
- Average award values across procurement categories.
- The distribution and concentration of award values.
- Supplier participation and award relationships.
- Relationships between procurement records, awards, and contracts.
- The effect of date validity and other quality issues on analytical results.

Extreme award values are considered separately from typical values because a small number of very large awards can materially affect totals and averages.

Where award-value distributions are highly skewed, histograms and logarithmic transformations can help reveal patterns that are difficult to observe on a raw-value scale. A logarithmic view changes how differences are displayed and must not be interpreted as the original monetary scale.

## 6. Power BI Data Modeling and Reporting

The normalized MySQL data is connected to Power BI for data modeling and visualization.

DAX measures are used to calculate report metrics, while report filters and slicers support analysis across available dimensions and time periods.

The report is organized into seven pages:

1. **Procurement Executive Overview:** Presents high-level indicators.
2. **Procurement Profile:** Examines procurement activity and composition.
3. **Award Value Analysis:** Explores award-value distributions and concentration.
4. **Supplier Analysis:** Examines supplier participation and award-related patterns.
5. **Contracts and Award Conversion:** Investigates the relationship between procurement records, awards, and contracts.
6. **Procurement Methods:** Compares procurement methods and their representation in the dataset.
7. **Summary: Key Findings:** Consolidates the main analytical observations.

The interpretation of each visual depends on its underlying measure, filter context, and the relationships in the Power BI data model. Totals and averages are interpreted in light of the level of detail represented by the relevant tables.

## 7. Interpretation of Findings

The analysis identified the following patterns in the available data:

- Works awards have an average recorded award value of approximately 31.65 million monetary units.
- The highest-value 1% of works awards account for approximately 76.59% of total recorded works award value.
- Goods account for 48,719 awards, while works account for 35,679 awards.
- There are 73,240 procurement records categorized as works.
- The open procurement method accounts for approximately 90.41% of procurement records.

These findings describe observed data patterns, not causal relationships or definitive assessments of procurement performance. In particular, high award values or concentrated expenditure do not independently establish irregularity or misconduct.

## 8. Limitations

The reliability and scope of the findings are affected by source-data quality, missing information, repeated identifiers, date inconsistencies, and unusually large monetary values.

Other limitations include:

- Incomplete information may prevent some records from being matched across entities.
- Results depend on the implemented cleaning rules and reporting filters.
- Award counts and procurement counts represent different units of analysis and should not be treated as interchangeable.
- Averages can be disproportionately influenced by extreme award values.
- Monetary values should not be assigned a specific currency unless this is confirmed by the source documentation.
- Findings from the available dataset should not automatically be generalized to all Kenyan public procurement activity.

## 9. Reproducibility

The project is organized into SQL scripts covering staging, data-quality assessment, normalization, validation, and exploratory analysis. Power BI documentation and report screenshots provide supporting evidence of the reporting stage.

To reproduce the analysis, a user should:

1. Obtain the source dataset and review its terms of use.
2. Execute the staging-table creation and import workflow.
3. Run the documented quality checks and review their results.
4. Create and populate the normalized tables.
5. Execute the relationship-validation and exploratory analysis scripts.
6. Connect Power BI to the prepared data and verify the model relationships, measures, and filters.

Exact execution order and environment-specific import settings should be followed as documented in the repository's SQL files.

## 10. Tools

- MySQL Workbench for SQL development and database management.
- MySQL for data preparation, validation, and exploratory analysis.
- Power BI for data modeling and reporting.
- DAX for analytical measures and report calculations.