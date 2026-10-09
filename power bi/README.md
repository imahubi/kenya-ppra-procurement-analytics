# Power BI Procurement Analytics Report

## Overview

This Power BI report analyzes Kenya PPRA procurement data to examine procurement activity, award values, supplier participation, contract conversion, and procurement methods.

The report translates the SQL analysis into seven pages, combining summary metrics and visual analysis to communicate procurement patterns and key findings.

## Report Pages

### 1. Procurement Executive Overview
Provides a high-level summary of procurement activity through key performance indicators and overall trends.

### 2. Procurement Profile
Examines procurement volumes and the distribution of procurement activity across categories and other procurement characteristics.

### 3. Award Value Analysis
Compares award values across procurement categories and examines the concentration of awarded value among high-value awards.

### 4. Supplier Analysis
Explores supplier participation and the distribution of awards and awarded value across suppliers.

### 5. Contracts and Award Conversion
Examines the relationship between procurement awards and contract records to assess award-to-contract conversion patterns.

### 6. Procurement Methods
Analyzes the distribution of procurement methods and their contribution to overall procurement activity.

### 7. Summary: Key Findings
Consolidates the principal findings into a concise overview of procurement volumes, award values, and procurement method usage.

## Key Findings

- **Highest average award value:** Works, at approximately 31.65 million.
- **Award value concentration:** The top 1% of Works awards account for 76.59% of total awarded value in the Works category.
- **Highest award volume:** Goods, with 48,719 awards.
- **Works award volume:** 35,679 awards, compared with 48,719 for Goods.
- **Highest procurement count:** Works, with 73,240 procurements.
- **Most frequently used procurement method:** Open procurement, accounting for 90.41% of all procurements.

Procurement counts and award counts represent different entities and should be interpreted separately. Award value concentration describes the distribution of recorded value, not the cause of that distribution.

## Screenshots

The `screenshots/` directory contains visual previews of the seven report pages.

- [Procurement Executive Overview](screenshots/procurement_executive_overview.png)
- [Procurement Profile](screenshots/procurement_profile.png)
- [Award Value Analysis](screenshots/award_value_analysis.png)
- [Supplier Analysis](screenshots/supplier_analysis.png)
- [Contracts and Award Conversion](screenshots/contracts_and_award_conversion.png)
- [Procurement Methods](screenshots/procurement_methods.png)
- [Summary: Key Findings](screenshots/summary_key_findings.png)

## Tools

- Microsoft Power BI
- DAX
- MySQL

## Notes

The findings are based on the available source records and the documented data preparation process. Data quality limitations may affect some results. Monetary values should be interpreted using the currency recorded in the source dataset.

For the full methodology, database design, SQL scripts, and data quality assessment, see the [project root README](../README.md).