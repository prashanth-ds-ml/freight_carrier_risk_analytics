# Freight Carrier Identity and Risk Analytics

BI analytics project for carrier identity verification, operational risk monitoring, and data quality exception reporting using public FMCSA datasets.

## Business Problem

A freight risk team needs to screen carriers and identify potential operational risk before carriers are trusted for daily freight movements.

This project does not claim confirmed fraud detection. It builds a carrier risk monitoring framework using public FMCSA data to identify:

- incomplete or inconsistent carrier identity fields,
- inactive or unclear authority/status indicators,
- high inspection violation or out-of-service rates,
- crash-history signals,
- data quality exceptions that should be escalated for review.

## Dataset

| Item | Details |
|---|---|
| Provider | Federal Motor Carrier Safety Administration / U.S. DOT |
| Company Census | https://catalog.data.gov/dataset/company-census-file |
| Vehicle Inspections | https://catalog.data.gov/dataset/vehicle-inspection-file |
| Crash File | https://catalog.data.gov/dataset/crash-file |
| Grain | Carrier-level census, inspection events, crash events |
| Row Counts | 4.44M carrier records, 8.20M inspection records, 4.94M crash records |

Large raw files are not committed to GitHub. Use the official source links above to download the latest data, then place files under `data/raw/` for local analysis.

### Dataset Notes

As of May 19, 2026, all three source listings were marked as last updated on May 19, 2026.

- Company Census File: contains records for active, inactive, and pending entities registered with FMCSA. The file centers on the USDOT number and includes entity identity, business operations, equipment, driver, and carrier review fields.
- Vehicle Inspection File: contains public inspection activity from the FMCSA MCMIS inspection files. Driver-level details are excluded from the public release due to privacy restrictions. Severe violations may lead to vehicle and/or driver out-of-service outcomes.
- Crash File: contains public crash-report data received from state police crash reports involving motor carriers operating in the U.S. Public files exclude driver data for privacy reasons. A single crash can appear in multiple records when multiple commercial motor vehicles were involved; the crash report number is needed to distinguish related records.

## Tools Used

- SQL: primary analysis workflow for schema inventory, data quality checks, cleaning, KPI calculations, joins, and risk logic
- Python: import automation, profiling, and MySQL execution support
- Power BI: dashboarding and DAX measures

## Current Working Approach

- Raw FMCSA files were imported into MySQL under `feright_risk_analysis`
- The project shifted from raw-table exploration to a BI-ready summary-layer design
- The current reporting layer uses only curated `pbi_*` views
- The dashboard is designed page-by-page with business-focused sources rather than a single overloaded model

## Documentation Map

For detailed supporting documentation, see:

- `docs/business_problem.md`
- `docs/analysis_questions.md`
- `docs/data_dictionary.md`
- `docs/data_quality_report.md`
- `docs/eda_summary.md`
- `docs/metric_definitions.md`
- `docs/insights.md`
- `docs/recommendations.md`
- `outputs/weekly_review/week_01_summary.md`
- `powerbi/dax_measures.md`

## Repository Structure

```text
freight_carrier_risk_analytics/
├── data/
│   ├── raw/
│   ├── processed/
│   └── README.md
├── docs/
│   ├── analysis_questions.md
│   ├── business_problem.md
│   ├── data_dictionary.md
│   ├── data_quality_report.md
│   ├── insights.md
│   ├── metric_definitions.md
│   └── recommendations.md
├── powerbi/
│   └── dax_measures.md
├── scripts/
│   ├── import_fmcsa_to_mysql.py
│   ├── profile_fmcsa_csvs.py
│   └── run_mysql_script.py
├── sql/
│   ├── 02_cleaning.sql
│   ├── 03_build_summary_tables.sql
│   ├── 03_kpi_queries.sql
│   ├── 04_deep_dive_queries.sql
│   ├── 05_analysis_questions.sql
│   └── 07_powerbi_safe_views.sql
├── Feright_Risk_Analysis.pdf
└── README.md
```

## Dashboard Pages

1. Carrier Risk Overview
Source:
`pbi_carrier_risk_summary`

2. Identity and Authority Exceptions
Source:
`pbi_identity_authority_exceptions`

3. Inspection Risk
Source:
`pbi_inspection_risk`

4. Crash Risk
Source:
`pbi_crash_risk`

## Live Dashboard

Published Power BI report:

- https://app.fabric.microsoft.com/view?r=eyJrIjoiNTk3ODRjZjItODJkNy00ZDUzLWJjNDktODUyMjY4YmNhMWZmIiwidCI6IjBkNGYwMzExLWYwMmUtNDE2MS05ZTc4LTg3M2ZmYTk5OWIwOCJ9&pageName=1ab999bf3db81567e975

## Published Dashboard Summary

The currently published report contains four pages:

1. `Freight Carrier Risk Analytics` overview page
2. `Identity and Authority Exceptions`
3. `Inspection Risk`
4. `Crash Risk`

The report is built on curated MySQL reporting views and focuses on KPI cards, state-level concentration charts, carrier-operation segmentation, and business-facing review tables.

## Power BI Source Objects

Current recommended MySQL objects for Power BI:

- reporting views:
  - `pbi_carrier_risk_summary`
  - `pbi_carrier_profile`
  - `pbi_identity_authority_exceptions`
  - `pbi_inspection_risk`
  - `pbi_crash_risk`
  - `pbi_high_risk_carriers`

Internal MySQL build objects that support the reporting layer:

- `inspection_summary_by_carrier`
- `crash_summary_by_carrier`
- `carrier_risk_summary`

All currently used DAX measures are documented in `powerbi/dax_measures.md`.

## Key Metrics

- Total carriers
- Active carrier %
- Missing identity field %
- Total inspections
- Violation rate
- Out-of-service rate
- Crash count
- High-risk carrier count
- Risk score




