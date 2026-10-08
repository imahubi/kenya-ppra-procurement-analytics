-- Distribution Analysis
SELECT
	ROUND(MIN(value_amount), 2) AS minimum,
    ROUND(MAX(value_amount), 2) AS maximum,
    ROUND(AVG(value_amount), 2) AS average,
    ROUND(SUM(value_amount), 2) AS total
FROM awards;
/*An award has a minimum value of KSH0.00 and a maximum value of KSH161000000000.00,
and an average value of KSH15417490.29. The total value of awards in this
dataset is around KSH1682433627833.92.*/

-- Which procurement categories receive the most spending?
SELECT
	a.category_name,
    ROUND(SUM(b.value_amount), 2) AS total_award_value,
    ROUND(100 * SUM(b.value_amount) / SUM(SUM(b.value_amount)) OVER (), 2) AS pct_of_total
FROM procurement_categories a
LEFT JOIN procurement c ON a.category_id = c.procurement_category_id
LEFT JOIN awards b ON c.procurement_id = b.procurement_id
GROUP BY a.category_id, a.category_name
ORDER BY total_award_value DESC;
/*The works category receives the bulk of expenditure, evidenced by the fact that the
awards that fall in this category have the highest total representing 67.11% of the total.
Services and goods account for the remaining award value, 18.51% and 14.38% respectively,
implying that these categories receive considerably less spending than the works-related
projects.*/

SELECT
	pc.category_name,
    COUNT(c.contract_id) AS contract_count,
    COUNT(c.award_id) AS award_count,
    ROUND(SUM(a.value_amount), 2) AS total_award_value,
    ROUND(100 * SUM(a.value_amount) / SUM(SUM(a.value_amount)) OVER (), 2) AS pct_total_award_value,
    ROUND(SUM(c.value_amount), 2) AS total_contract_value,
    ROUND(100 * SUM(c.value_amount) / SUM(SUM(c.value_amount)) OVER (), 2) AS pct_total_contract_value
FROM procurement_categories pc
LEFT JOIN procurement p
	ON pc.category_id = p.procurement_category_id
LEFT JOIN awards a
	ON p.procurement_id = a.procurement_id
LEFT JOIN contracts c
	ON a.award_id = c.award_id
GROUP BY pc.category_id, pc.category_name
ORDER BY total_award_value DESC;
/*The total contract value matches the total award value. Works contracts have the greatest value of
all three categories of 67.11%, followed by services at 18.52%, and then goods at 14.38%.*/

-- Which procurement methods are used frequently?
SELECT
	pm.method_name,
    COUNT(*) AS method_count,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM procurement_methods pm
LEFT JOIN procurement p
	ON pm.method_id = p.procurement_method_id
GROUP BY pm.method_id, pm.method_name
ORDER BY method_count DESC;
/*The open approach is the most applied procurement method in this dataset, accounting for 89.96% of all
occurrences of procurement methods. The selective and direct approaches are the second and third most
frequently used methods, occurring 6.63% and 3.37% of the time. All the other 3 methods have almost
negligible counts: speciallypermitted (0.02%), alternativeselection (0.02%), and community participation (0%).*/

-- Which suppliers receive the highest award values?
SELECT
	s.supplier_id,
    s.supplier_name,
    COUNT(*) AS award_count,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM awards), 2) AS pct_count,
    ROUND(SUM(a.value_amount), 2) AS award_value,
    ROUND(100 * SUM(a.value_amount) / (SELECT SUM(value_amount) FROM awards), 4) AS pct_award_value
FROM suppliers s
LEFT JOIN awards_suppliers sa
	ON s.supplier_id = sa.supplier_id
LEFT JOIN awards a
	ON sa.award_id = a.award_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY award_count DESC
LIMIT 10;
/*The query identifies the top 10 suppliers who received the most
awards. Toyota Kenya Limited is the supplier with the most awards (299 awards or 0.27%),
amounting to a total award value of 1235716412.64 or 0.07% of the total.*/

SELECT
	s.supplier_id,
    s.supplier_name,
    COUNT(*) AS award_count,
    ROUND(100 * COUNT(*) / (SELECT COUNT(*) FROM awards), 2) AS pct_count,
    ROUND(SUM(a.value_amount), 2) AS award_value,
    ROUND(100 * SUM(a.value_amount) / (SELECT SUM(value_amount) FROM awards), 4) AS pct_award_value
FROM suppliers s
LEFT JOIN awards_suppliers sa
	ON s.supplier_id = sa.supplier_id
LEFT JOIN awards a
	ON sa.award_id = a.award_id
GROUP BY s.supplier_id, s.supplier_name
ORDER BY award_value DESC
LIMIT 10;
/*Despite having among the lowest award count in this dataset of 4 (almost 0%), Causeway Engineering Solutions Limited
recorded the highest award value of 161202559567.60 or 9.5815% of the total value. Liaison Group and Minet Kenya Insurance
Brokers Limited exihibit a similar trend with award counts of 10 (0.01%) and 18 (0.02%), which amounted to award values of
140323490458.00 (8.3405%) and 88926806253.00 (5.2856%), respectively. This outcome confirms that the highest number of
awards does not necessarily mean the highest award value because there are some awards with exponentially higher values.*/

-- Which buyers issue the most procurements?
SELECT
	ps.party_id,
    ps.name AS buyer_name,
    COUNT(*) AS procurement_count,
    ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS pct_of_total
FROM parties ps
JOIN procurement_parties pp
	ON ps.party_id = pp.party_id
JOIN procurement p
	ON pp.procurement_id = p.procurement_id
JOIN roles r
	ON r.role_id = pp.role_id
WHERE r.role_name = 'buyer'
GROUP BY ps.party_id, ps.name
ORDER BY procurement_count DESC
LIMIT 5;
/*The query counts the number of procurements issued by buyers, identifying the
top 5. The East African Portland Cement Company holds the top spot as the
buyer with the highest procurements, accounting for 7.85% of total procurements.
The next notable supplier, Council of Governors, has 1.95% of all procurements,
which is a significant gap.*/

-- How long do procurement processes take?
SELECT
	COUNT(*) AS procurement_count,
    ROUND(AVG(duration_days), 2) avg_duration,
    MIN(duration_days) AS min_days,
    MAX(duration_days) AS max_days
FROM (
	SELECT
		TIMESTAMPDIFF(DAY, startdate, enddate) AS duration_days
	FROM procurement
    WHERE startdate IS NOT NULL
    AND enddate IS NOT NULL
    AND startdate <= enddate
) x;
/*There are 145252 procurements captured in this dataset that have
valid date ranges (i.e., startdate is <= enddate). On average,
a procurement process takes 337.37 days to complete. The shortest
duration a procurement process may take is 0 days (i.e., startdate =
enddate). The longest that a procurement process may take is 738891 days.
However, this query excludes all invalid date ranges where the startdate
occurs before the enddate.*/

-- How often do awards result in contracts?
SELECT
	COUNT(DISTINCT c.award_id) AS awards_with_contracts,
    ROUND(100 * COUNT(DISTINCT c.award_id) / (SELECT COUNT(*) FROM awards), 2) AS share_pct
FROM contracts c
WHERE c.award_id IS NOT NULL;

SELECT
	COUNT(*) AS total_awards,
    COUNT(DISTINCT c.award_id) AS awards_with_contracts,
    ROUND(100 * COUNT(DISTINCT c.award_id) / COUNT(*), 2) AS share_pct
FROM awards a
LEFT JOIN contracts c
	ON a.award_id = c.award_id;
/*The query calculates the total number of awards (109125) and the number of
awards that led to contracts (109104). As such, it was determined that 99.98%
of the time awards lead to a contract.*/

-- Which procurement categories have unusually high average award values?
SELECT
	pc.category_name,
    COUNT(a.award_id) AS award_count,
    ROUND(100 * COUNT(a.award_id) / (SELECT COUNT(award_id) FROM awards), 2) AS share_pct_awards,
    ROUND(AVG(a.value_amount)) AS avg_award_value,
    ROUND(AVG(a.value_amount) / (SELECT AVG(value_amount) FROM awards WHERE value_amount IS NOT NULL), 2) AS multiple_of_overall_avg
FROM procurement_categories pc
JOIN procurement p
	ON pc.category_id = p.procurement_category_id
JOIN awards a
	ON p.procurement_id = a.procurement_id
WHERE a.value_amount IS NOT NULL
GROUP BY pc.category_id, pc.category_name
ORDER BY avg_award_value DESC;
/*The query compares each category's average award value with the overall average award value. From
the calculation, works awards average at 31.6 million, which is 2.05 times the overall average. Services
awards average at 12.6 million, which is 0.82 times the overall average. Goods awards average at 4.96
million, which is 0.32 times the overall average. This is indication thaat works awards have an
unusually high average award value compared to the other procurement categories. In addition,
works category also accounts for 32.7% of all awards with an average that is 2.05 times the
overall average. This result suggests that the works category is more capital intensive than
the other procurement categories. A point of note is that this query uses average award value
and does not calculate statistical outliers. */

-- Are the high works averages driven by a small number of extreme awards?
WITH works_awards AS (
	SELECT
		a.award_id,
        a.value_amount
	FROM awards a
    JOIN procurement p
		ON a.procurement_id = p.procurement_id
	JOIN procurement_categories pc
		ON p.procurement_category_id = pc.category_id
	WHERE pc.category_name = 'works'
    AND a.value_amount IS NOT NULL
)
SELECT
	COUNT(*) AS works_awards_above_overall_avg
FROM works_awards
WHERE value_amount > (
	SELECT
		AVG(value_amount)
	FROM awards
	WHERE value_amount IS NOT NULL
);

WITH works_awards AS (
	SELECT
		a.value_amount
	FROM awards a
    JOIN procurement p
		ON a.procurement_id = p.procurement_id
	JOIN procurement_categories pc
		ON p.procurement_category_id = pc.category_id
	WHERE pc.category_name = 'works'
    AND a.value_amount IS NOT NULL
)
SELECT
	COUNT(*) AS award_count,
    ROUND(AVG(value_amount), 2) AS avg_award_value,
    ROUND(MIN(value_amount), 2) AS min_award_value,
    ROUND(MAX(value_amount), 2) AS max_award_value
FROM works_awards;

/*The query compares the maximum and minimum values against the average for
the works category. There is a large gap between the maximum value amount
and the category's average (161000000000.00 vs 31645234.04), roughly
5087 times. This is an indication that the works averages is driven by a small
number of extreme values. However, it is not yet clear how much of the average
comes from those extreme awards.*/

SELECT
	a.award_id,
    a.title,
    a.value_amount
FROM awards a
JOIN procurement p
	ON a.procurement_id = p.procurement_id
JOIN procurement_categories pc
	ON p.procurement_category_id = pc.category_id
WHERE pc.category_name = 'works'
AND a.value_amount IS NOT NULL
ORDER BY a.value_amount DESC
LIMIT 20;
/*The query identifies those awards with the highest value amounts, particularly
the top 20.*/

WITH works_awards AS (
	SELECT
		a.award_id,
        a.value_amount,
        ROW_NUMBER() OVER (ORDER BY a.value_amount DESC) AS award_rank,
        COUNT(*) OVER () AS total_awards
	FROM awards a
    JOIN procurement p
		ON a.procurement_id = p.procurement_id
	JOIN procurement_categories pc
		ON p.procurement_category_id = pc.category_id
	WHERE pc.category_name = 'works'
    AND a.value_amount IS NOT NULL
)
SELECT
	ROUND(100 * 
		SUM(CASE
			WHEN award_rank <= total_awards * 0.01 THEN value_amount
            ELSE 0
            END) / SUM(value_amount), 2
    ) AS top_1_pct_share,
    ROUND(100 *
		SUM(CASE
			WHEN award_rank <= total_awards * 0.05 THEN value_amount
            ELSE 0
            END) / SUM(value_amount), 2
    ) AS top_5_pct_share,
    ROUND(100 *
		SUM(CASE
			WHEN award_rank <= total_awards * 0.10 THEN value_amount
            ELSE 0
            END) / SUM(value_amount), 2
    ) AS top_10_pct_share
FROM works_awards;
/*The query is designed to assess the concentration of award values. It shows that the
largest 1% of works awards account for 76.59% of total awarded value, the largest 5%
of works awards accounts for 87.76% of total awarded value, while the largest
10% account for 91.50% of total awarded value. This is indication of substantial concetration
of awarded value among a relatively small number of awards.*/