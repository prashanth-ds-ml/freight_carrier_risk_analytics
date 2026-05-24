# Project Log

## 2026-05-23

Owner: Prashanth / project team

Completed:

- Selected final portfolio direction.
- Added official FMCSA source links.
- Created project documentation scaffold.
- Created local `.venv`.
- Confirmed the raw FMCSA files exist locally.
- Profiled the three raw files and confirmed:
  - Company Census: 4,437,569 rows and 147 columns
  - Crash: 4,941,856 rows and 59 columns
  - Vehicle Inspection: 8,205,573 rows and 63 columns
- Imported the three raw files into MySQL database `feright_risk_analysis`.
- Saved the first SQL-first schema inventory query in `sql/01_column_inventory.sql`.
- Updated documentation to reflect the current raw-table understanding and SQL-first workflow.
- Built the first BI-ready MySQL summary layer:
  - `company_census_selected` view
  - `inspection_summary_by_carrier` table
  - `crash_summary_by_carrier` table
  - `carrier_risk_summary` table
- Created `sql/05_analysis_questions.sql` as the first Workbench-safe analysis script built only on the summary layer.
- Finalized the official 15-question version 1 analysis framework and documented the reasoning.
- Created Power BI helper views using `sql/06_powerbi_helper_views.sql`.
- Confirmed summary-layer row counts:
  - `company_census_selected`: 4,437,569
  - `inspection_summary_by_carrier`: 660,563
  - `crash_summary_by_carrier`: 713,175
  - `carrier_risk_summary`: 4,437,569
- Confirmed first headline metrics:
  - active carriers: 2,192,273
  - carriers with inspections: 660,255
  - carriers with crashes: 711,402
  - high-risk carriers (`risk_score >= 3`): 329,821

Issues Found:

- Full raw FMCSA exports can be large, so selected-column official API extracts may be more practical for local analysis.
- `LOAD DATA LOCAL INFILE` was disabled in MySQL, so the importer needed a batch-insert fallback.
- The census table is very wide and will require deliberate column prioritization before broad cleaning.
- Heavy raw-table profiling in MySQL Workbench caused repeated connection-loss timeouts, making interactive full-table analysis impractical.

Decision Made:

- Keep raw data outside GitHub and document official dataset links so anyone can reproduce the project.
- Use MySQL as the working database for analysis.
- Use a SQL-first workflow from this stage onward.
- Inventory the imported schema before null checks, cleaning, or aggregation.
- Treat the raw tables as:
  - `raw_company_census` = carrier master
  - `raw_crash` = crash event table
  - `raw_vehicle_inspection` = inspection event table
- Keep the business framing employer-neutral so the project can be used broadly while still demonstrating strong freight carrier screening and risk-analysis skills.
- Shift delivery focus to a carrier-level BI summary layer instead of broad raw-table interactive profiling.
- Use DOT-linked crashes only for carrier-level crash metrics in the first version.
- Use a transparent flag-based `risk_score` for first-pass prioritization.
- Use a fixed 15-question framework to keep the analysis focused and ensure all three files are used properly.
- Use Power BI helper views to simplify dashboard page design and field exposure.

Next Action:

- Run KPI and deep-dive queries against `carrier_risk_summary`.
- Connect Power BI to the summary-layer objects and build the first dashboard pages.
- Refine docs with actual insight outputs and screenshots.
- Run `sql/05_analysis_questions.sql` and capture the outputs for final insight writing and dashboard design.
- Connect Power BI to `carrier_risk_summary` and the helper views, then build the first dashboard pages.

Reference:

- Detailed current-state documentation is maintained in `docs/current_project_status.md`.


