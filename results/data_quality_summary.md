# Data Quality and Exploratory Analysis Summary

## 1. Overview

This document summarizes data-quality checks and exploratory data analysis (EDA) performed on the Kenya PPRA procurement dataset using MySQL.

The assessment covers the structure and integrity of the normalized tables, reconciliation with staging data, date validity, award-value distributions, procurement categories and methods, supplier participation, buyer activity, procurement duration, and award-to-contract relationships.

The purpose is to document the reliability of the available data and highlight findings relevant to procurement analysis.

## 2. Database Structure and Integrity

### 2.1 Normalized table structure

The normalized database contains procurement, award, contract, supplier, party, role, category, and method tables, together with junction tables that represent relationships between entities.

The main tables have defined primary keys, while the junction tables use composite primary keys to identify unique relationships.

### 2.2 Row counts and identifier uniqueness

| Table | Row count | Identifier validation |
|---|---:|---|
| `awards` | 109,125 | All award IDs are non-null and unique. |
| `awards_suppliers` | 79,813 | All award-supplier combinations are unique. |
| `contracts` | 109,125 | All contract IDs are non-null and unique. |
| `parties` | 811,754 | All party IDs are non-null and unique. |
| `procurement` | 259,132 | All procurement IDs are non-null and unique. |
| `procurement_parties` | 811,754 | All procurement-party-role combinations are unique. |
| `suppliers` | 37,629 | All supplier IDs are non-null and unique. |

These checks indicate that the tested primary-key fields and composite keys satisfy the expected uniqueness conditions. They do not, on their own, establish that all non-key fields are complete or that every relationship is valid.

### 2.3 Reconciliation between staging and normalized tables

The row-count comparisons identified the following outcomes:

| Table comparison | Staging rows | Normalized rows | Outcome |
|---|---:|---:|---|
| Awards | 109,125 | 109,125 | All records retained. |
| Contracts | 109,125 | 109,125 | All records retained. |
| Parties | 811,754 | 811,754 | All records retained. |
| Main procurement records | 259,132 | 259,132 | All records retained. |
| Award-supplier relationships | 79,832 | 79,813 | 19 records excluded. |

The 19 excluded award-supplier records had missing supplier names and were not loaded into the normalized supplier relationship table because they could not be associated with a valid supplier entity.

This exclusion should be documented as a data-handling decision. The corresponding awards remain in the awards table, so exclusion from the relationship table does not mean the awards themselves were removed.

### 2.4 Nullability and schema observations

Schema inspections confirmed that primary-key fields are defined separately from descriptive attributes, many of which permit NULL values. The `awards_suppliers` and `procurement_parties` junction tables use composite keys that require the key fields to be present.

Consequently, uniqueness of identifiers should be distinguished from completeness of descriptive data. Additional field-level completeness checks are necessary where missing values may affect analysis.

## 3. Date Validity

### 3.1 Procurement date inconsistencies

The most significant date-quality issue occurs in the `procurement` table.

| Date validation metric | Result |
|---|---:|
| Records with both start and end dates | 258,880 |
| Start date later than end date | 113,628 |
| Percentage with start date later than end date | 43.89% |
| Start date equal to end date | 108,100 |
| Start date earlier than end date | 37,152 |

Approximately 43.89% of procurement records with both dates populated have a start date later than the recorded end date. Only 37,152 records have a strictly increasing date range, while 108,100 have equal start and end dates.

The same pattern was found in the source staging data, suggesting that the inconsistency originated in the source records rather than being introduced solely by normalization.

The invalid date combinations are concentrated in several year pairs, particularly:

- 2025 start year and 2024 end year: 19.26% of records with invalid date order.
- 2025 start year and 2023 end year: 17.23%.
- 2026 start year and 2026 end year: 13.24%.
- 2025 start year and 2025 end year: 11.29%.
- 2025 start year and 2022 end year: 10.07%.

These findings warrant caution when interpreting procurement timelines. The year-pair results describe the distribution of records with invalid date order, not necessarily the true dates on which procurement activities occurred.

### 3.2 Award and contract dates

The checks found no records where `startdate` was later than `enddate` in either the `awards` or `contracts` table.

This specific validation does not establish that every award and contract date is historically plausible. Other checks, such as minimum and maximum date ranges and comparisons with the expected reporting period, are needed to identify implausible values.

### 3.3 Procurement duration

Using records with non-null dates and `startdate <= enddate`, the duration analysis reported:

| Metric | Result |
|---|---:|
| Records included | 145,252 |
| Average duration | 337.37 days |
| Minimum duration | 0 days |
| Maximum duration | 738,891 days |

The average duration is approximately 337 days, but the maximum of 738,891 days is implausibly large for a typical procurement process and may materially distort the average.

These results indicate that satisfying the date-order condition alone is insufficient to establish date validity. The unusually long durations should be investigated before the average is used as a performance indicator. The stated record count should also be reconciled with the date-validity counts above.

## 4. Award-Value Distribution

### 4.1 Overall award values

The award-value analysis reported the following:

| Metric | Result |
|---|---:|
| Number of awards | 109,125 |
| Minimum recorded value | KSh 0.00 |
| Maximum recorded value | KSh 161,000,000,000.00 |
| Average recorded value | KSh 15,417,490.29 |
| Total recorded award value | KSh 1,682,433,627,833.92 |

The range between the minimum and maximum is substantial. The maximum award value is several orders of magnitude greater than the average, indicating a strongly skewed distribution.

Because very large awards can influence totals and averages, these measures should be interpreted alongside distributional analysis, including raw-value and logarithmic histograms.

### 4.2 Spending by procurement category

The category-level analysis found the following distribution of total award value:

| Category | Share of total award value | Average award value |
|---|---:|---:|
| Works | 67.11% | Approximately KSh 31.65 million |
| Services | 18.51% | Approximately KSh 12.64 million |
| Goods | 14.38% | Approximately KSh 4.96 million |

Works account for the largest share of recorded award value. Their average award value is approximately 2.05 times the overall average, compared with 0.82 times for services and 0.32 times for goods.

This suggests that works awards are associated with substantially higher recorded values in this dataset. It does not independently establish the reasons for those differences or demonstrate statistical outliers.

### 4.3 Concentration of works award values

A ranking analysis examined the share of total works award value accounted for by the highest-value awards.

| Highest-value works awards | Share of total works award value |
|---|---:|
| Top 1% | 76.59% |
| Top 5% | 87.76% |
| Top 10% | 91.50% |

The results show a high concentration of recorded award value among a relatively small proportion of works awards. The top 1% account for over three-quarters of total works award value, while the top 10% account for more than nine-tenths.

This concentration helps explain why average award values can be sensitive to extreme observations. It is a descriptive finding, not evidence by itself of improper procurement or supplier favoritism.

## 5. Procurement Method Distribution

The procurement-method analysis reported the following shares:

| Procurement method | Share of method records |
|---|---:|
| Open | 89.96% |
| Selective | 6.63% |
| Direct | 3.37% |
| Specially permitted | 0.02% |
| Alternative selection | 0.02% |
| Community participation | Approximately 0% |

The open method is the dominant method in the dataset, accounting for approximately nine-tenths of the reported method records.

These percentages describe the distribution of method classifications in the data. They should not be interpreted as evidence of compliance or non-compliance with procurement regulations without additional context about applicable rules and exceptions.

## 6. Supplier Analysis

### 6.1 Supplier with the most awards

Toyota Kenya Limited was identified as the supplier with the highest award count in the supplier query.

| Metric | Result |
|---|---:|
| Award count | 299 |
| Share of all awards | Approximately 0.27% |
| Total recorded award value | KSh 1,235,716,412.64 |
| Share of total award value | Approximately 0.07% |

The result illustrates that the supplier with the highest number of awards does not necessarily receive the highest total award value.

### 6.2 Suppliers with the highest award values

The award-value ranking identified several suppliers with relatively few awards but very high cumulative values.

| Supplier | Award count | Total recorded award value | Share of total award value |
|---|---:|---:|---:|
| Causeway Engineering Solutions Limited | 4 | KSh 161,202,559,567.60 | 9.5815% |
| Liaison Group | 10 | KSh 140,323,490,458.00 | 8.3405% |
| Minet Kenya Insurance Brokers Limited | 18 | KSh 88,926,806,253.00 | 5.2856% |

These results reinforce the importance of analysing both award frequency and award value. Supplier rankings based only on award count would not reveal the concentration of value among these suppliers.

The figures should be verified against the underlying award-supplier relationships and the treatment of missing or repeated supplier records before being used for conclusions about supplier concentration.

## 7. Buyer Analysis

The buyer analysis used the `parties`, `procurement_parties`, `procurement`, and `roles` tables to count procurement records associated with parties whose role is classified as buyer.

East African Portland Cement Company was identified as the buyer with the highest procurement count, accounting for 7.85% of the procurements in the query's denominator. The Council of Governors was reported next, accounting for 1.95%.

The difference between the reported shares indicates that procurement activity is not evenly distributed among the buyers in the top results.

The SQL denominator should be reviewed before presenting these percentages as shares of all procurement records. The query divides buyer-linked procurement counts by the total of buyer-linked counts, which may differ from the number of distinct procurement records if a procurement has multiple buyer relationships.

## 8. Award-to-Contract Relationship

The award-to-contract analysis found:

| Metric | Result |
|---|---:|
| Total awards | 109,125 |
| Awards associated with contracts | 109,104 |
| Awards without a matched contract | 21 |
| Share of awards associated with contracts | 99.98% |

Nearly all award records were associated with a contract record through the `award_id` relationship.

This is a strong relationship-coverage result for the available data. It does not independently prove that every contract is complete, valid, signed, or successfully implemented.

## 9. Key Data Quality Risks

The checks identify several areas that require attention before drawing operational or policy conclusions:

1. **Procurement date order:** 43.89% of records with both dates have a start date later than the end date.
2. **Extreme durations:** The maximum reported duration is 738,891 days, suggesting that further date validation is necessary.
3. **Extreme award values:** A small proportion of works awards account for most of the category's total recorded value.
4. **Missing supplier information:** Nineteen staging award-supplier records were excluded from the normalized relationship table because supplier names were missing.
5. **Relationship interpretation:** Buyer-linked counts and award-supplier relationships require careful handling to avoid double-counting.
6. **Validation scope:** Unique primary keys do not guarantee complete descriptive fields, plausible dates, or valid relationships across all tables.

## 10. Recommended Follow-up Checks

Before finalizing the Power BI report, the following checks are recommended:

- Investigate the source of reversed procurement dates and decide whether affected records should be excluded from duration analysis.
- Examine extremely long durations and validate the date range against the dataset's intended reporting period.
- Confirm the maximum award values against the source data and document any verified corrections.
- Reconcile supplier and buyer metrics with distinct award or procurement identifiers to avoid unintended double-counting.
- Confirm that the category-level award and contract values use comparable record grains and are not inflated by joins.
- Verify the denominators used in percentage calculations and ensure that null or unmatched records are handled consistently.
- Preserve the SQL scripts that generated the published results so that the analysis can be reproduced.

## 11. Conclusion

The normalized database demonstrates strong identifier uniqueness in the tested tables and retains all records in the main procurement, award, contract, and party tables. The award-supplier relationship table excludes 19 records with missing supplier names.

The principal data quality concern is the high proportion of procurement records with reversed start and end dates, together with implausibly long calculated durations. The exploratory analysis also shows that works account for the largest share of recorded award value and that value is highly concentrated among a small proportion of works awards.

These findings provide a useful foundation for procurement analytics, provided that the documented data-quality limitations and validation requirements remain visible in the final report.