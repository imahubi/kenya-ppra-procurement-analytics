# Project Overview: Kenya PPRA Procurement Analytics

## 1. Project Background

Public procurement involves substantial public expenditure, making transparency, accountability, and effective resource allocation important. This project analyses procurement records from Kenya's Public Procurement Regulatory Authority (PPRA) dataset to examine procurement activity, awarded contract values, supplier participation, and procurement methods.

The project uses MySQL for data preparation, quality assessment, normalization, and exploratory analysis, followed by Power BI for interactive reporting and visualization.

## 2. Project Objectives

The project aims to:

- Assess the structure, completeness, consistency, and validity of the source data.
- Clean and normalize the raw data into related relational tables.
- Examine procurement volumes and trends across procurement categories, methods, and time periods.
- Analyse the distribution of award values and identify categories with high-value or highly concentrated awards.
- Explore supplier participation and relationships between procurement records, awards, and contracts.
- Translate the analysis into an interactive Power BI report that communicates findings clearly.

## 3. Data and Scope

The analysis uses procurement, award, contract, and supplier-related records from the source dataset. The workflow begins with staging tables that preserve the imported data for validation and cleaning. The data is then organized into normalized tables connected through primary and foreign keys.

The analytical scope includes:

- Procurement activity and reporting-period trends.
- Award counts and awarded-value distributions.
- Differences between goods, works, and services.
- Procurement method distribution.
- Supplier participation and award relationships.
- Relationships between procurements, awards, and contracts.
- Data quality limitations that may affect interpretation.

The reporting period and any date exclusions should be interpreted according to the filters and validation rules documented in the SQL scripts and Power BI report.

## 4. Methodology

The project follows a reproducible analytical workflow:

1. **Data staging:** Import the source files into MySQL staging tables.
2. **Data quality assessment:** Check missing values, duplicate identifiers, invalid dates, unusual monetary values, and inconsistent records.
3. **Data cleaning and normalization:** Standardize selected fields and structure the data into related tables to reduce redundancy and improve analytical consistency.
4. **Relationship validation:** Check key integrity and identify records that cannot be matched across tables.
5. **Exploratory data analysis:** Use SQL queries to investigate procurement volumes, award values, category differences, and other relevant patterns.
6. **Power BI reporting:** Develop measures, visualizations, and report pages to communicate the findings interactively.

## 5. Power BI Report

The Power BI report is organized into seven pages:

1. **Procurement Executive Overview:** High-level procurement indicators and summary metrics.
2. **Procurement Profile:** Procurement activity across relevant categories and dimensions.
3. **Award Value Analysis:** Award-value distributions, comparisons, and concentration patterns.
4. **Supplier Analysis:** Supplier participation and award-related analysis.
5. **Contracts and Award Conversion:** Relationships between procurement records, awards, and contracts.
6. **Procurement Methods:** Distribution and comparison of procurement methods.
7. **Summary: Key Findings:** Main analytical observations and conclusions.

## 6. Preliminary Findings

The analysis identified several notable patterns:

- Works awards have an average award value of approximately 31.65 million in the dataset's recorded monetary units.
- The highest-value 1% of works awards account for approximately 76.59% of the total recorded award value for works.
- Goods account for 48,719 awards, compared with 35,679 works awards.
- The dataset contains 73,240 procurement records categorized as works.
- The open procurement method accounts for approximately 90.41% of procurement records.

These results describe patterns in the available dataset. They should not, by themselves, be interpreted as evidence of misconduct, inefficiency, or non-compliance. Further investigation and contextual evidence would be required for such conclusions.

## 7. Limitations

Data quality issues may affect the completeness and reliability of some analyses. Identified issues include missing values, duplicated identifiers, invalid or implausible dates, and unusually large monetary values.

The findings are therefore dependent on the source data, the cleaning and validation rules applied, and the filters used in the report. Award values should not be assumed to represent a particular currency unless the source data or documentation confirms it.

## 8. Tools Used

- **MySQL:** Data staging, cleaning, normalization, validation, and exploratory analysis.
- **Power BI:** Data modeling, DAX measures, visualization, and interactive reporting.
- **SQL and DAX:** Data transformation, analytical calculations, and reporting metrics.

For the full project documentation, SQL scripts, data-quality checks, and implementation details, see the [root project README](../README.md).