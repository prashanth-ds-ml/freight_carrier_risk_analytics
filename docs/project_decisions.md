# Project Decisions

This file records major working decisions, why they were taken, and how they affect the next steps. It should be updated as the project evolves so the reasoning stays interview-ready and traceable.

## 2026-05-23

### Decision: Use MySQL as the working database

Why:

- the raw FMCSA files are large
- the project requires joins and repeatable SQL analysis
- MySQL provides a practical local environment for raw landing tables and staged cleaning

Impact:

- raw data is analyzed from `feright_risk_analysis`
- SQL files in this repo should assume MySQL unless explicitly noted otherwise

### Decision: Keep the workflow SQL-first from this stage onward

Why:

- the current goal is to understand, validate, and clean the imported raw tables step by step
- SQL is the most direct way to inspect schema, nulls, join keys, and cleaning logic
- this makes the project easier to explain in interviews because the transformation path is explicit

Impact:

- SQL becomes the primary workflow for analysis and cleaning
- Python remains a support tool for import automation and earlier profiling only

### Decision: Keep the business framing general and employer-neutral

Why:

- the project should be reusable across interviews, applications, and portfolio contexts
- the carrier-screening problem applies broadly to freight operations, logistics, brokerage, and risk teams
- the analysis can still be designed to demonstrate the type of operational reasoning expected in strong logistics and transportation roles without naming a specific employer

Impact:

- documentation should refer to freight operations teams, carrier screening, and freight movements in general terms
- the project should avoid explicit employer references unless a custom interview version is created separately

### Decision: Inventory columns before null checks or cleaning

Why:

- no reliable cleaning or data-quality check should start before confirming the exact imported schema
- the raw source documentation is not enough; the MySQL tables are the real source of truth for the project
- later queries depend on exact column names and actual field presence

Impact:

- first saved SQL step is `sql/01_column_inventory.sql`
- this confirmed:
  - `raw_company_census` has 147 columns
  - `raw_crash` has 59 columns
  - `raw_vehicle_inspection` has 63 columns

### Decision: Treat the three raw tables as one master table plus two event tables

Why:

- the imported columns clearly show different business roles
- the census table contains carrier identity, status, fleet, and authority attributes
- the inspection table contains inspection events and enforcement outcomes
- the crash table contains crash events and severity information

Impact:

- `raw_company_census` is the carrier master base
- `raw_vehicle_inspection` is the inspection event fact table
- `raw_crash` is the crash event fact table
- `DOT_NUMBER` is the current primary cross-table join key

### Decision: Delay broad cleaning until raw structure and relevance are understood

Why:

- the census table is very wide and includes many potential low-value or sparse columns
- cleaning everything at once would create avoidable noise
- it is better to identify the business-relevant subset first, then clean with purpose

Impact:

- next steps focus on null and blank analysis, then column prioritization
- cleaning should start with core identity, status, location, date, and KPI fields

### Decision: Build a summary-layer BI model instead of profiling the full raw tables interactively

Why:

- the raw FMCSA tables are large enough to cause repeated MySQL Workbench connection-loss issues during heavy ad hoc profiling
- the project must be completed quickly enough to be resume-ready
- Power BI is better served by carrier-level analytical tables than by the raw event tables

Impact:

- `company_census_selected` remains a focused carrier-master view
- `inspection_summary_by_carrier` is created as a physical MySQL summary table
- `crash_summary_by_carrier` is created as a physical MySQL summary table
- `carrier_risk_summary` is created as the main BI-ready fact table for dashboards

### Decision: Use DOT-linked crashes only for carrier-level crash metrics

Why:

- crash rows without `DOT_NUMBER` cannot be joined back to the carrier master reliably
- carrier-level BI metrics must be consistent and joinable

Impact:

- `crash_summary_by_carrier` uses only rows with non-null `DOT_NUMBER`
- all-crash reporting can still be analyzed separately later if needed

### Decision: Use a first-pass rule-based risk score instead of a complex model

Why:

- a transparent scoring system is faster to deliver and easier to explain in interviews
- the current goal is prioritization, not predictive modeling

Impact:

- `carrier_risk_summary` includes interpretable flags and a summed `risk_score`
- the score can be revised later without changing the core BI structure

### Decision: Finalize a 15-question version 1 analysis framework

Why:

- the project needs a clear, interview-ready analytical narrative
- the question set must prove that the census, inspection, and crash files are all being used properly
- a fixed question set prevents low-value scope creep during dashboard and documentation work

Impact:

- official analysis questions are documented in `docs/analysis_questions.md`
- `sql/05_analysis_questions.sql` is the first Workbench-safe script aligned to that framework

### Decision: Add MySQL helper views for Power BI page-specific modeling

Why:

- Power BI dashboards are easier to build when each page can point to a narrower business object
- views simplify field lists and reduce repeated logic inside Power BI

Impact:

- helper views are defined in `sql/06_powerbi_helper_views.sql`
- the main Power BI model can use `carrier_risk_summary` plus focused helper views where helpful
