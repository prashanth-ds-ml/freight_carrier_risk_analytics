# Project README and Documentation Template

Use this template for each portfolio project. Copy the relevant sections into the project `README.md` and supporting files under `docs/`.

## Project Title

Example: `Freight Carrier Identity and Risk Analytics`

## 1. Business Problem

Describe the decision this project supports.

```md
## Business Problem

[Stakeholder/team] needs to [monitor/analyze/identify] [business problem] so they can [decision/action].

This project uses [dataset/source] to build a BI workflow that helps answer:

- Question 1
- Question 2
- Question 3
```

## 2. Dataset

```md
## Dataset

| Item | Details |
|---|---|
| Source | [Dataset name and link] |
| Provider | [Government agency / platform] |
| Grain | [One row per carrier/order/vehicle/month/etc.] |
| Date Range | [Start date] to [End date] |
| Raw Row Count | [Count] |
| Key Fields | [Primary keys and important dimensions] |
| Refresh Status | [Static / monthly / daily / unknown] |
```

Include source links and local file paths.

## 3. Tools Used

```md
## Tools Used

- SQL: data modeling, cleaning, KPI queries, validation
- Python: EDA, profiling, data quality checks, exports
- Power BI: dashboarding, data model, DAX measures
- Excel: exception tracker or weekly review summary
```

## 4. Repository Structure

```text
project-name/
├── data/
│   ├── raw/
│   ├── processed/
│   └── README.md
├── notebooks/
│   └── 01_eda.ipynb
├── sql/
│   ├── 00_schema.sql
│   ├── 01_data_quality.sql
│   ├── 02_cleaning.sql
│   ├── 03_kpi_queries.sql
│   └── 04_deep_dive_queries.sql
├── powerbi/
│   ├── dashboard.pbix
│   ├── dax_measures.md
│   ├── model_diagram.png
│   └── screenshots/
├── docs/
│   ├── business_problem.md
│   ├── data_dictionary.md
│   ├── data_quality_report.md
│   ├── metric_definitions.md
│   ├── insights.md
│   ├── recommendations.md
│   └── resume_bullets.md
├── outputs/
│   ├── cleaned_tables/
│   ├── sql_exports/
│   └── weekly_review/
├── README.md
└── PROJECT_LOG.md
```

## 5. Data Model

```md
## Data Model

### Fact Tables

| Table | Grain | Purpose |
|---|---|---|
| fact_table_name | One row per ... | ... |

### Dimension Tables

| Table | Key | Purpose |
|---|---|---|
| dim_date | date_key | Date filtering and time intelligence |
| dim_location | location_key | State/city/region analysis |

### Join Keys

| From Table | Key | To Table | Key |
|---|---|---|---|
| table_a | id | table_b | id |
```

## 6. Data Quality Checks

```md
## Data Quality Checks

| Check | Result | Action Taken |
|---|---:|---|
| Missing primary keys | [count/%] | [action] |
| Duplicate records | [count] | [action] |
| Invalid dates | [count] | [action] |
| Orphan records after joins | [count/%] | [action] |
| Inconsistent categories | [count] | [action] |
| Outliers | [summary] | [action] |
```

Required evidence:

- `sql/01_data_quality.sql`
- `docs/data_quality_report.md`
- Python notebook profiling section

## 7. Metric Definitions

```md
## Metric Definitions

| Metric | Formula | Business Meaning |
|---|---|---|
| Metric Name | numerator / denominator | What this tells stakeholders |
```

Examples:

```md
| OOS Rate | Out-of-service inspections / total inspections | Share of inspections resulting in out-of-service events |
| EV Share % | EV vehicles / total vehicles | EV adoption within total vehicle sales |
| Profit Margin % | Profit / Sales | Profitability after sales and discounting effects |
```

## 8. SQL Analysis

```md
## SQL Analysis

The SQL layer includes:

- schema creation
- data quality validation
- KPI calculations
- trend analysis
- ranking and segmentation
- deep-dive queries

Important query examples:

| File | Purpose |
|---|---|
| `sql/01_data_quality.sql` | Nulls, duplicates, invalid dates, join checks |
| `sql/03_kpi_queries.sql` | Main dashboard KPIs |
| `sql/04_deep_dive_queries.sql` | Root-cause and segment analysis |
```

## 9. Python EDA

```md
## Python EDA

Notebook: `notebooks/01_eda.ipynb`

EDA covered:

- row and column profiling
- missing value analysis
- duplicate checks
- date range validation
- category distribution
- outlier detection
- trend exploration
- relationship/correlation checks where relevant

Key EDA findings:

1. Finding 1
2. Finding 2
3. Finding 3
```

## 10. Power BI Dashboard

```md
## Power BI Dashboard

Power BI file: `powerbi/dashboard.pbix`

Dashboard pages:

1. Executive Overview
2. Trend Analysis
3. Segment / Category Analysis
4. Risk / Diagnostic View
5. Data Quality Monitor

Screenshots:

| Page | Screenshot |
|---|---|
| Executive Overview | `powerbi/screenshots/overview.png` |
| Data Model | `powerbi/model_diagram.png` |
```

## 11. DAX Measures

```md
## DAX Measures

Key measures are documented in `powerbi/dax_measures.md`.

Example:

```DAX
Total Records = COUNTROWS('fact_table')
Rate % = DIVIDE([Numerator], [Denominator])
```
```

## 12. Key Insights

Use business language. Avoid writing only chart descriptions.

```md
## Key Insights

1. [Insight]: [Evidence from metric/query/dashboard].
2. [Insight]: [Evidence from metric/query/dashboard].
3. [Insight]: [Evidence from metric/query/dashboard].
```

Bad: `The chart shows sales by category.`

Better: `Technology generated the highest sales, but Furniture had weaker margin performance, indicating that revenue growth did not translate equally into profit.`

## 13. Recommendations

```md
## Recommendations

1. [Action]: [Reason based on insight].
2. [Action]: [Reason based on insight].
3. [Action]: [Reason based on insight].
```

Recommendations should sound like actions a stakeholder could take.

## 14. Weekly Review Narrative

For the Amazon Middle Mile role, include at least one weekly-style review note.

File: `outputs/weekly_review/week_01_summary.md`

```md
# Weekly Review - Week 01

## What Changed

- ...

## Top Exceptions

- ...

## Root Cause Hypothesis

- ...

## Recommended Actions

- ...

## Escalations

| Issue | Owner / Team | Priority | Reason |
|---|---|---|---|
| ... | ... | ... | ... |
```

## 15. Excel Deliverable

For role alignment, include one Excel-style artifact.

Examples:

- carrier exception tracker
- KPI reconciliation workbook
- pivot summary by state/category/status
- lookup-based review sheet

Document it:

```md
## Excel / Analyst Review Artifact

File: `outputs/weekly_review/exception_tracker.xlsx`

Purpose:

- supports manual review
- summarizes exceptions
- provides pivot-style reporting
```

## 16. How To Reproduce

```md
## How To Reproduce

1. Download raw data from the source links.
2. Place raw files in `data/raw/`.
3. Run SQL scripts in order:
   - `sql/00_schema.sql`
   - `sql/01_data_quality.sql`
   - `sql/02_cleaning.sql`
   - `sql/03_kpi_queries.sql`
4. Run Python EDA notebook:
   - `notebooks/01_eda.ipynb`
5. Open Power BI file:
   - `powerbi/dashboard.pbix`
```

## 17. Limitations

```md
## Limitations

- [Dataset limitation]
- [Missing business field]
- [Assumption made]
- [Known issue]
```

This section improves credibility. It shows you understand the boundary of the data.

## 18. Resume Bullets

```md
## Resume Bullets

- Bullet 1
- Bullet 2
- Bullet 3
```

Rules:

- Start with action verbs.
- Mention tool stack.
- Mention business problem.
- Quantify only when real.
- Do not claim impact you did not measure.

## 19. Project Log

Create `PROJECT_LOG.md`.

```md
# Project Log

## YYYY-MM-DD

Owner:

Completed:

Issues Found:

Decision Made:

Next Action:
```

## Portfolio-Ready Checklist

A project is ready to show only when all are complete:

- [ ] README with business problem and screenshots
- [ ] source links and data notes
- [ ] data dictionary
- [ ] data quality report
- [ ] SQL scripts
- [ ] Python EDA notebook
- [ ] EDA summary
- [ ] Power BI file or dashboard screenshots
- [ ] DAX measures documented
- [ ] metric definitions
- [ ] insights
- [ ] recommendations
- [ ] weekly review narrative
- [ ] resume bullets
- [ ] project log

