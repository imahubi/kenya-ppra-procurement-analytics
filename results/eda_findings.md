# Exploratory Data Analysis Findings

## 1. Overview

This document summarizes the main findings from exploratory data analysis of the Kenya PPRA procurement dataset using MySQL. The analysis examines award values, procurement categories and methods, supplier and buyer activity, procurement duration, and the relationship between awards and contracts.

The findings are descriptive. They identify patterns in the available records but do not, on their own, establish procurement inefficiency, misconduct, or regulatory non-compliance.

## 2. Award Value Distribution

The dataset contains 109,125 award records, with the following overall award-value statistics:

| Metric | Result |
|---|---:|
| Minimum award value | KSh 0.00 |
| Maximum award value | KSh 161,000,000,000.00 |
| Average award value | KSh 15,417,490.29 |
| Total recorded award value | KSh 1,682,433,627,833.92 |

The substantial difference between the average and maximum values indicates that the distribution of award values is highly skewed. A relatively small number of very high-value awards can have a considerable effect on total expenditure and average award value.

Consequently, the average should be interpreted alongside the median, distribution plots, and concentration measures where available.

## 3. Procurement Category Analysis

### 3.1 Distribution of total award value

The analysis found that works account for the largest share of recorded award value.

| Procurement category | Share of total award value | Average award value |
|---|---:|---:|
| Works | 67.11% | Approximately KSh 31.65 million |
| Services | 18.51% | Approximately KSh 12.64 million |
| Goods | 14.38% | Approximately KSh 4.96 million |

Works account for approximately two-thirds of total recorded award value. Services account for 18.51%, while goods account for 14.38%.

This distribution suggests that the works category represents the largest component of recorded procurement expenditure in the dataset.

### 3.2 Award volumes and average values

The category analysis reported the following award counts:

| Procurement category | Number of awards | Share of all awards | Average award value relative to overall average |
|---|---:|---:|---:|
| Goods | 48,719 | Approximately 44.64% | 0.32× |
| Works | 35,679 | Approximately 32.70% | 2.05× |
| Services | 24,642 | Approximately 22.58% | 0.82× |

Goods have the highest award count, but works have the highest average award value. This distinction shows why award frequency and award value should be assessed separately.

The higher average for works may reflect differences in the scale or nature of projects in that category. The available analysis does not establish the causes of the difference.

## 4. Concentration of Works Award Values

The analysis examined how much of the total recorded works award value is represented by the highest-value awards.

| Highest-value works awards | Share of total works award value |
|---|---:|
| Top 1% | 76.59% |
| Top 5% | 87.76% |
| Top 10% | 91.50% |

The top 1% of works awards account for 76.59% of the category's total recorded award value. The top 10% account for 91.50%.

This is a substantial concentration of award value. It also helps explain why the average works award value is sensitive to extreme observations.

The finding supports further examination of the largest awards, including verification of their values and source records. Concentration alone does not establish irregularity or inappropriate procurement.

## 5. Procurement Method Analysis

The procurement method distribution was reported as follows:

| Procurement method | Share of method records |
|---|---:|
| Open | 89.96% |
| Selective | 6.63% |
| Direct | 3.37% |
| Specially permitted | 0.02% |
| Alternative selection | 0.02% |
| Community participation | Approximately 0% |

The open method is the dominant classification, accounting for approximately 90% of the records represented in the analysis. Selective and direct methods are considerably less common.

These figures describe the recorded distribution of procurement methods. Further information about applicable procurement rules, permitted exceptions, and the context of individual procurements would be required to evaluate compliance or the appropriateness of method selection.

## 6. Supplier Analysis

### 6.1 Suppliers with the most awards

Toyota Kenya Limited was identified as the supplier with the highest award count in the supplied SQL analysis.

| Metric | Result |
|---|---:|
| Award count | 299 |
| Share of all awards | Approximately 0.27% |
| Total recorded award value | KSh 1,235,716,412.64 |
| Share of total award value | Approximately 0.07% |

The result illustrates that receiving the highest number of awards does not necessarily correspond to receiving the greatest total award value.

### 6.2 Suppliers with the highest total award values

The value-based ranking identified suppliers with relatively few awards but high cumulative recorded values.

| Supplier | Award count | Total recorded award value | Share of total award value |
|---|---:|---:|---:|
| Causeway Engineering Solutions Limited | 4 | KSh 161,202,559,567.60 | 9.5815% |
| Liaison Group | 10 | KSh 140,323,490,458.00 | 8.3405% |
| Minet Kenya Insurance Brokers Limited | 18 | KSh 88,926,806,253.00 | 5.2856% |

These results demonstrate the importance of distinguishing between supplier award frequency and supplier award value.

The supplier-level figures should be verified against the underlying award records before publication. In particular, the reported total for Causeway Engineering Solutions Limited is slightly higher than the maximum individual award value reported in the overall award summary. This may reflect multiple awards or a data or join issue that requires investigation.

## 7. Buyer Analysis

The buyer analysis identified East African Portland Cement Company as the buyer with the highest procurement count in the supplied query. Its reported share was 7.85%, followed by the Council of Governors at 1.95%.

The difference suggests that the recorded procurement activity is concentrated among certain buyers rather than being evenly distributed.

The percentages should be validated against distinct procurement identifiers and the intended denominator. A procurement record associated with multiple buyer relationships could otherwise affect the interpretation of the counts.

## 8. Procurement Duration

The duration analysis calculated an average of 337.37 days among records meeting the query's date-order condition. The reported minimum was zero days, while the maximum was 738,891 days.

The maximum duration is implausibly large for an ordinary procurement process and may distort the average. In addition, the source data contains many records in which the procurement start date occurs after the end date.

The current average should therefore be treated as provisional. Before drawing conclusions about procurement speed or efficiency, the date fields should be validated and extreme durations investigated. A revised analysis should document the reporting period, valid date criteria, and any duration limits used.

## 9. Award-to-Contract Relationship

The relationship analysis reported that 109,104 of 109,125 awards were associated with contracts.

| Metric | Result |
|---|---:|
| Total awards | 109,125 |
| Awards associated with contracts | 109,104 |
| Awards without a matched contract | 21 |
| Share associated with contracts | 99.98% |

This indicates that almost all awards in the normalized dataset have a corresponding contract record according to the tested `award_id` relationship.

The result measures the presence of a linked contract record. It does not confirm that the contract is complete, valid, signed, or fully implemented.

## 10. Main Insights

The SQL analysis supports the following observations:

1. **Works dominate recorded award value.** The category accounts for 67.11% of total award value and has the highest average award value.
2. **Award frequency and award value tell different stories.** Goods have the highest award count, whereas works have the highest average award value.
3. **Works award value is highly concentrated.** The top 1% of works awards account for 76.59% of total works award value.
4. **Open procurement is the dominant recorded method.** It represents approximately 90% of method records.
5. **Supplier rankings depend on the metric used.** The supplier with the most awards is not necessarily the supplier with the highest cumulative award value.
6. **Buyer activity varies substantially.** The leading buyer's reported procurement share is considerably higher than that of the next buyer in the query results.
7. **Most awards have linked contract records.** The reported relationship coverage is 99.98%.
8. **Date quality limits duration analysis.** Reversed dates and implausibly long durations need to be addressed before drawing conclusions about procurement timelines.

## 11. Further Analysis Required

Before these findings are treated as final, the following work is recommended:

- Verify the largest individual award values against the source records.
- Reconcile supplier totals with award-supplier relationships to rule out join-related duplication.
- Confirm the procurement method percentages and ensure they use the same denominator as the Power BI report.
- Validate buyer counts using distinct procurement identifiers.
- Investigate reversed procurement dates and extreme durations before reporting a definitive average.
- Compare the median award value with the mean to better characterize skewness.
- Examine award-value concentration across goods and services, where appropriate.
- Ensure Power BI measures reproduce the validated SQL results under equivalent filters.

## 12. Conclusion

The exploratory analysis indicates that recorded award value is concentrated in the works category and among a relatively small proportion of high-value works awards. Goods account for the greatest number of awards, demonstrating that the most frequent category is not necessarily the category with the greatest financial value. Open procurement is the dominant recorded method, and nearly all awards have an associated contract record.

The findings provide a basis for interactive procurement reporting, but the date-quality issues and unusually large monetary values require further validation. Supplier, buyer, and category metrics should also be checked for consistent counting and join behavior before being used to support broader conclusions.