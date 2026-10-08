# Data Documentation

## Source

This project uses the Kenya PPRA procurement dataset obtained from [this link](https://data.open-contracting.org/en/publication/147).

## Data Usage

The source dataset is not included in this repository. Refer to the original source for access and applicable usage or redistribution terms.

## Import Instructions

1. Download the dataset from the source.
2. Review the expected file names and formats.
3. Create the staging tables using the SQL scripts in `sql/01_staging/`.
4. Follow the documented loading instructions.
5. Run the staging data quality checks before proceeding to normalization.

## Data Limitations

The source data contains quality issues that are assessed in the project's SQL scripts. These include missing values, duplicate identifiers, unusual dates, and potential inconsistencies in procurement records.