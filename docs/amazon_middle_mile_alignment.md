# Amazon Middle Mile Risk Specialist Alignment

This is the most directly aligned project for the Amazon Middle Mile Risk Specialist role.

## Relevant JD Requirements

| JD Requirement | Project Evidence |
|---|---|
| Identity verification / fraud mitigation | Carrier identity, authority/status, and exception framework |
| Daily freight movement risk | Carrier risk monitoring before freight assignment |
| Complex SQL across datasets | Planned joins across census, inspections, and crashes |
| Heterogeneous sources | FMCSA carrier, inspection, and crash datasets |
| Data quality issues | missing identity fields, unmatched records, invalid dates, null KPI fields |
| Deep-dive reports | carrier risk tiers, state concentration, inspection/OOS drilldowns |
| Dashboards | planned Power BI carrier risk dashboard |
| Excel reporting | exception tracker and weekly review output |
| Written weekly findings | `outputs/weekly_review/week_01_summary.md` |

## Interview Positioning

Use this explanation:

> I designed this project around a carrier-risk workflow. The public FMCSA datasets do not provide confirmed fraud labels, so I framed the project as identity and operational risk monitoring rather than fraud prediction. The work focuses on joining carrier master data with inspection and crash history, identifying data quality gaps, creating risk flags, and producing a dashboard plus exception report for review.
