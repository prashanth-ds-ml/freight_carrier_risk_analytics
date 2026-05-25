# Current Project Status

This document records the detailed state of the project as of May 24, 2026. It is intended to be the main reference for understanding what has already been done, what design decisions were taken, what technical issues were encountered, and what the current BI-ready model looks like.

## 1. Project Goal

The project is a freight carrier risk analytics workflow built on public FMCSA datasets.

The business objective is to help freight operations teams:

- evaluate whether a carrier record is complete enough to trust,
- identify status or authority concerns,
- measure inspection and out-of-service risk,
- measure crash-history signals,
- surface carriers that should be prioritized for review.

The project is framed as:

- carrier screening,
- operational risk monitoring,
- data quality exception reporting,
- decision support.

The project is not framed as:

- fraud confirmation,
- shipment-level freight analysis,
- predictive modeling of cargo loss,
- employer-specific internal operations.

## 2. Source Data Used

The raw source data comes from public FMCSA datasets:

- Company Census File
- Vehicle Inspection File
- Crash File

Local raw files present in `data/raw`:

- `Company_Census_File.csv`
- `Vehicle_Inspection_File.csv`
- `Crash_File.csv`

Previously confirmed source scale:

- Company Census: 4,437,569 rows and 147 columns
- Vehicle Inspection: 8,205,573 rows and 63 columns
- Crash: 4,941,856 rows and 59 columns

## 3. Environment and Database Setup

Completed setup steps:

- created local `.venv`
- installed Python tooling as needed
- imported all three raw CSV files into MySQL database `feright_risk_analysis`

MySQL working database:

- host: `127.0.0.1`
- port: `3306`
- database: `feright_risk_analysis`

Imported raw tables:

- `raw_company_census`
- `raw_vehicle_inspection`
- `raw_crash`

## 4. Problems Encountered During Raw-Data Work

Several practical issues occurred while trying to work directly from the full raw data.

### 4.1 Large-file import constraints

The raw files are large enough that:

- naive local repo storage is undesirable,
- GitHub LFS was considered but intentionally not used,
- import performance and query design matter immediately.

### 4.2 MySQL `LOAD DATA LOCAL INFILE` was disabled

Initial bulk-load logic attempted to use `LOAD DATA LOCAL INFILE`, but MySQL returned an error indicating local infile loading was disabled on the client/server side.

Action taken:

- the import script was modified to fall back to batched Python inserts.

Impact:

- import became slower,
- but the raw data was still successfully loaded into MySQL.

### 4.3 MySQL Workbench connection-loss issues

When running heavy exploratory SQL directly against the full raw tables, MySQL Workbench repeatedly lost connection after roughly 30 seconds.

This happened especially when attempting:

- large `CREATE TABLE AS SELECT` operations,
- wide `UNION ALL` missingness queries,
- heavy interactive profiling over the 4.4M-row census table.

Impact:

- interactive full-table profiling in Workbench was not practical,
- the workflow needed to shift away from raw-table brute-force analysis.

## 5. What Was Learned from the Raw Schema

The first SQL-first step was schema inventory.

Saved query:

- `sql/01_column_inventory.sql`

Confirmed schema roles:

- `raw_company_census` is the carrier master table
- `raw_vehicle_inspection` is the inspection event table
- `raw_crash` is the crash event table

Confirmed join key:

- `DOT_NUMBER` is the main carrier-level key shared across the three datasets

Interpretation of the tables:

- the census table tells us who the carrier is,
- the inspection table tells us how the carrier performs operationally,
- the crash table tells us about crash exposure and severity history.

## 6. Column Prioritization Decisions

Because the census table contains 147 columns, not all columns were treated equally.

The decision was to classify fields into:

- primary columns,
- secondary columns,
- low-priority columns.

Primary `raw_company_census` fields selected for first-pass analysis:

- `DOT_NUMBER`
- `LEGAL_NAME`
- `DBA_NAME`
- `STATUS_CODE`
- `DOCKET1_STATUS_CODE`
- `PHY_STREET`
- `PHY_CITY`
- `PHY_STATE`
- `PHY_ZIP`
- `CARRIER_OPERATION`
- `BUSINESS_ORG_DESC`
- `POWER_UNITS`
- `TRUCK_UNITS`
- `TOTAL_DRIVERS`
- `TOTAL_CDL`
- `HM_Ind`
- `ADD_DATE`
- `MCS150_DATE`
- `SAFETY_RATING`
- `SAFETY_RATING_DATE`
- `EMAIL_ADDRESS`

Why these were selected:

- they cover carrier identity,
- carrier status and authority,
- location completeness,
- fleet and driver scale,
- hazmat exposure,
- record recency,
- direct safety signal.

## 7. Why the Workflow Shifted

The original thought was to do broad null profiling and table creation directly from the raw census data in Workbench.

That approach was abandoned for practical reasons:

- too slow for the available timeline,
- repeated connection-loss issues,
- not necessary for building a strong BI project,
- not the best path to a resume-ready output.

The project therefore shifted to a summary-layer design.

This was a deliberate engineering and delivery decision, not a compromise in analytical quality.

## 8. Current Working Strategy

The project now uses a layered design:

1. raw tables remain the source of truth
2. a selected carrier-master layer narrows the census table
3. inspection events are aggregated to the carrier level
4. crash events are aggregated to the carrier level
5. all three are joined into a final carrier-level BI summary

This is the correct design for:

- Power BI,
- fast KPI analysis,
- explainable interview storytelling,
- operational risk monitoring.

## 9. BI-Ready Objects Created in MySQL

The following SQL build was created and executed:

- `sql/03_build_summary_tables.sql`

This created the following analytical objects.

### 9.1 `inspection_summary_by_carrier`

Type:

- physical MySQL table

Purpose:

- aggregate inspection history by carrier

Metrics included:

- `inspection_count`
- `total_violations`
- `total_oos`
- `driver_oos_total`
- `vehicle_oos_total`
- `hazmat_oos_total`
- `post_accident_inspection_count`
- `latest_insp_date`

Current row count:

- 660,563

Interpretation:

- this is the number of carriers with inspection activity linked by `DOT_NUMBER`

### 9.2 `crash_summary_by_carrier`

Type:

- physical MySQL table

Purpose:

- aggregate crash history by carrier

Metrics included:

- `crash_count`
- `injury_crash_count`
- `fatal_crash_count`
- `tow_away_count`
- `federal_recordable_count`
- `latest_crash_date`

Current row count:

- 713,175

Important design rule:

- only DOT-linked crashes are included in this carrier-level table

Why:

- crash rows without `DOT_NUMBER` cannot be reliably joined back to the carrier master

### 9.3 `carrier_risk_summary`

Type:

- physical MySQL table

Purpose:

- final BI-ready carrier-level dataset

Current row count:

- 4,437,569

This table is the integrated carrier-level summary built from selected carrier-master logic plus inspection and crash aggregates.

Join key:

- `dot_number`

## 10. Current Risk Logic

The first-pass risk model is transparent and rule-based.

Flags in `carrier_risk_summary`:

- `missing_identity_flag`
- `inactive_or_nonactive_status_flag`
- `authority_issue_flag`
- `high_oos_flag`
- `high_violation_flag`
- `crash_history_flag`
- `hazmat_flag`

### Flag definitions

`missing_identity_flag`

- 1 if legal name or physical city/state/zip is missing

`inactive_or_nonactive_status_flag`

- 1 if `status_code` is null or not equal to `A`

`authority_issue_flag`

- 1 if `docket1_status_code` is null or not equal to `A`

`high_oos_flag`

- 1 if `total_oos / inspection_count >= 0.3`

`high_violation_flag`

- 1 if `total_violations / inspection_count >= 2`

`crash_history_flag`

- 1 if `crash_count > 0`

`hazmat_flag`

- 1 if `hm_ind = 'Y'`

### Risk score

`risk_score` is currently the sum of selected risk flags.

Why this approach was chosen:

- fast to build,
- easy to explain,
- transparent in interviews,
- sufficient for prioritization,
- does not require a predictive model.

## 11. Current Summary Metrics

Confirmed metrics after the summary build:

- total carriers in `carrier_risk_summary`: 4,437,569
- active carriers: 2,192,273
- carriers with inspections: 660,255
- carriers with crashes: 711,402
- high-risk carriers with `risk_score >= 3`: 329,821

Interpretation:

- the full carrier universe is much larger than the subset with observable inspection or crash activity
- this validates the decision to work at the carrier-summary layer instead of trying to dashboard raw event tables directly

## 12. SQL Assets Saved So Far

Current important SQL files:

- `sql/01_column_inventory.sql`
- `sql/03_build_summary_tables.sql`
- `sql/03_kpi_queries.sql`
- `sql/04_deep_dive_queries.sql`
- `sql/05_analysis_questions.sql`
- `sql/06_powerbi_helper_views.sql`
- `sql/07_powerbi_safe_views.sql`
- `sql/08_drop_legacy_reporting_views.sql`

Purpose of each:

- `01_column_inventory.sql`: confirm raw schema
- `03_build_summary_tables.sql`: build BI-ready analytical model
- `03_kpi_queries.sql`: run KPI-level checks against the summary table
- `04_deep_dive_queries.sql`: run deeper prioritization and segmentation queries
- `05_analysis_questions.sql`: run the official Workbench-safe version 1 business questions
- `06_powerbi_helper_views.sql`: create the earlier helper-view reporting layer
- `07_powerbi_safe_views.sql`: create Power BI-safe reporting views with explicit casts
- `08_drop_legacy_reporting_views.sql`: remove older reporting/helper views and keep only the final `pbi_*` reporting layer

## 13. Documentation Updated So Far

The following docs have already been updated to reflect the current state:

- `README.md`
- `docs/business_problem.md`
- `docs/data_dictionary.md`
- `docs/data_quality_report.md`
- `docs/metric_definitions.md`
- `docs/insights.md`
- `docs/recommendations.md`
- `docs/project_decisions.md`
- `PROJECT_LOG.md`

## 14. Why the Current Design Is Strong for Interviews

This design is defensible because it shows:

- ability to work with large raw public datasets,
- practical database engineering decisions under time constraints,
- ability to identify the correct analytical grain,
- ability to convert raw operational data into BI-ready summary tables,
- ability to design transparent risk logic,
- ability to prioritize delivery over unnecessary perfection.

A strong interview explanation is:

"I used large public FMCSA carrier, inspection, and crash files as raw source data in MySQL, then built a carrier-level analytical layer with selected carrier-master fields, inspection aggregates, crash aggregates, and transparent risk flags so the output could be used efficiently in Power BI for carrier screening and operational risk monitoring."

## 15. Current Dashboard Design

The dashboard is now structured into four business-focused pages.

### Page 1: Carrier Risk Overview

Source:

- `pbi_carrier_risk_summary`

Purpose:

- portfolio-level carrier and risk snapshot

Published page content:

- KPI cards for total carriers, carriers with crashes, carriers with inspections, high-risk carriers, and active carriers
- carrier status split
- risk score distribution
- high-risk carriers by state
- carrier count by carrier operation
- top high-risk carriers review table

### Page 2: Identity and Authority Exceptions

Source:

- `pbi_identity_authority_exceptions`

Purpose:

- surface record-quality, authority, and non-active status exceptions

Published page content:

- KPI cards for total exception carriers, missing identity carriers, authority issue carriers, and non-active exception carriers
- exceptions by state
- exceptions by status code
- exceptions by authority status
- exception review table

### Page 3: Inspection Risk

Source:

- `pbi_inspection_risk`

Purpose:

- show violation and out-of-service concentration for carriers with inspection activity

Published page content:

- KPI cards for carriers with inspection activity, total inspections, total OOS, total violations, high OOS carriers, and high violation carriers
- inspection risk by state
- total OOS by state
- inspection risk by carrier operation
- high OOS carriers by state
- inspection review table

### Page 4: Crash Risk

Source:

- `pbi_crash_risk`

Purpose:

- show crash-linked carrier coverage and severity concentration

Published page content:

- KPI cards for crash-linked carriers, total crashes, injury crashes, fatal crashes, tow-away crashes, and federal recordable crashes
- crash-linked carriers by state
- injury crashes by state
- fatal crashes by carrier operation
- crash-linked carriers by carrier operation
- crash review table

Reference:

- `powerbi/dax_measures.md`

Published report link:

- https://app.fabric.microsoft.com/view?r=eyJrIjoiNTk3ODRjZjItODJkNy00ZDUzLWJjNDktODUyMjY4YmNhMWZmIiwidCI6IjBkNGYwMzExLWYwMmUtNDE2MS05ZTc4LTg3M2ZmYTk5OWIwOCJ9&pageName=1ab999bf3db81567e975

## 16. Current Recommended Next Steps

The highest-value next steps are:

1. publish the Power BI report
2. capture screenshots for the repo
3. add the public report link to the documentation
4. write final insight summaries based on the dashboard outputs
5. tighten resume bullet and project summary

## 17. Official Analysis Framework

The project now has a fixed version 1 analysis framework with 15 official questions.

The question groups are:

- census-focused questions,
- inspection-focused questions,
- crash-focused questions,
- integrated carrier-risk questions.

Reference:

- `docs/analysis_questions.md`

Why this matters:

- it ensures all three source files are used properly,
- it gives the project a stable analytical narrative,
- it prevents low-value scope creep while building dashboards.

## 18. Power BI View Strategy

The project now includes a Power BI-safe reporting view strategy.

Recommended Power BI objects:

- `pbi_carrier_risk_summary`
- `pbi_carrier_profile`
- `pbi_identity_authority_exceptions`
- `pbi_inspection_risk`
- `pbi_crash_risk`
- `pbi_high_risk_carriers`

Definition script:

- `sql/07_powerbi_safe_views.sql`

Why this matters:

- views simplify page-specific field selection,
- they reduce repeated logic inside Power BI,
- they make the demo and handoff easier,
- explicit casts reduce MySQL connector type-mismatch issues in Power BI.

Cleanup note:

- older reporting views (`vw_*`) and the earlier `company_census_selected` view were removed from MySQL to keep the reporting layer unambiguous.

## 19. What Was Intentionally Not Done Yet

The following were deliberately deferred:

- full null-percentage profiling for every raw census column
- broad raw-table interactive quality analysis in Workbench
- deep decoding of every coded source field
- complete cleaning of all 147 census columns
- pushing anything to GitHub before the user approved it

Why:

- these tasks were lower-value than building a usable BI model under time pressure
- they can still be done later if needed

## 20. Current Project State in One Sentence

The project has successfully moved from raw FMCSA ingestion to a BI-ready carrier-level MySQL summary model and is ready for KPI analysis and Power BI dashboard development.
