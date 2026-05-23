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

- SQL: joins, data quality checks, KPI calculations, risk flag logic
- Python: EDA, profiling, outlier checks, risk-score exploration
- Power BI: carrier risk dashboard and DAX measures
- Excel: exception tracker and weekly review summary

## Repository Structure

```text
freight_carrier_risk_analytics/
├── data/
│   ├── raw/
│   ├── processed/
│   └── README.md
├── docs/
│   ├── business_problem.md
│   ├── data_dictionary.md
│   ├── data_quality_report.md
│   ├── metric_definitions.md
│   ├── insights.md
│   ├── recommendations.md
│   └── resume_bullets.md
├── notebooks/
│   └── 01_eda.ipynb
├── outputs/
│   └── weekly_review/
├── powerbi/
│   ├── dax_measures.md
│   └── screenshots/
├── sql/
│   ├── 00_schema.sql
│   ├── 01_data_quality.sql
│   ├── 02_cleaning.sql
│   ├── 03_kpi_queries.sql
│   └── 04_deep_dive_queries.sql
├── PROJECT_LOG.md
└── README.md
```

## Planned Dashboard Pages

1. Carrier Risk Overview
2. Identity and Authority Exceptions
3. Inspection and Out-of-Service Risk
4. Crash History
5. Data Quality Monitor

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

## Resume Bullet

Built a carrier risk analytics workflow using FMCSA company census, inspection, and crash data to identify carrier identity gaps, authority status issues, inspection risk, crash history, and data quality exceptions.



