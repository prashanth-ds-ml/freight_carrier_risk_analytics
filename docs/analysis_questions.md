# Analysis Questions

This document defines the official version 1 analysis questions for the project. These questions were chosen to ensure all three FMCSA source files are used properly and that the outputs remain relevant for carrier screening, operational risk monitoring, exception management, and BI dashboarding.

## Why These Questions Were Chosen

The project uses three different source datasets with different purposes:

- `raw_company_census`: carrier identity, status, authority, geography, size, and business profile
- `raw_vehicle_inspection`: operational enforcement and out-of-service history
- `raw_crash`: crash history and crash severity exposure

The selected questions were designed to:

- cover all three files meaningfully,
- stay focused on business-relevant screening and risk logic,
- produce KPI and dashboard-friendly outputs,
- be answerable using the MySQL summary layer without heavy raw-table queries.

## Official Version 1 Questions

### A. Census-focused questions

#### 1. How many total carriers do we have?

Why this matters:

- establishes the size of the carrier universe
- serves as the denominator for several KPIs

#### 2. How many are active vs non-active?

Why this matters:

- carrier activity status is a core screening condition
- separates currently usable carriers from problematic, inactive, or unclear records

#### 3. How many carriers have missing identity information?

Why this matters:

- incomplete identity fields are a direct screening and data-quality risk
- supports exception monitoring and record-quality review

#### 4. How many carriers have authority issues?

Why this matters:

- authority status is critical for operational trust and compliance review
- complements carrier activity status

#### 5. How are carriers distributed by state, carrier operation, and business organization?

Why this matters:

- provides structural understanding of the carrier base
- supports segmentation and later drill-down analysis

### B. Inspection-focused questions

#### 6. How many carriers have inspection activity?

Why this matters:

- shows how much operational enforcement history is observable
- gives context on coverage of inspection-based risk

#### 7. What is the overall violation rate and OOS rate?

Why this matters:

- these are core operational safety KPIs
- they summarize inspection performance at the portfolio level

#### 8. How many carriers are high OOS or high violation?

Why this matters:

- converts inspection outcomes into actionable exception counts
- supports prioritization and review workflows

#### 9. Which states and carrier types have the highest inspection risk?

Why this matters:

- makes inspection data comparative and analytically useful
- supports geographic and business-type risk segmentation

### C. Crash-focused questions

#### 10. How many carriers have crash history?

Why this matters:

- establishes crash-linked carrier coverage
- provides baseline historical safety context

#### 11. How many have injury crashes or fatal crashes?

Why this matters:

- crash severity matters more than crash existence alone
- improves the practical value of crash analysis

#### 12. Which states and carrier types have the highest crash exposure?

Why this matters:

- supports concentration analysis
- helps identify segments with elevated crash history

### D. Integrated questions

#### 13. How many carriers appear in census only vs census plus inspections/crashes?

Why this matters:

- shows overlap and coverage across the three data sources
- proves the project is using all files properly and understands data availability

#### 14. How many carriers are high-risk by the combined risk score?

Why this matters:

- this is the main integrated project KPI
- summarizes identity, status, inspection, and crash signals into one prioritization metric

#### 15. Which carriers should be prioritized for manual review?

Why this matters:

- this is the actionable output of the project
- turns analysis into an operational review queue

## How These Questions Use All Three Files Properly

### Company Census contribution

The census file supports:

- total carrier counts
- activity status
- authority checks
- identity completeness
- geography
- carrier type segmentation
- business organization segmentation
- size and hazmat context

### Vehicle Inspection contribution

The inspection file supports:

- inspection coverage
- inspection counts
- total violations
- out-of-service metrics
- inspection-based risk flags
- state and carrier-type inspection risk segmentation

### Crash contribution

The crash file supports:

- crash coverage
- crash counts
- injury and fatal crash history
- crash severity indicators
- state and carrier-type crash exposure segmentation

### Combined contribution

When all three are integrated, the project supports:

- overlap analysis
- rule-based risk scoring
- manual review prioritization
- dashboard-ready carrier-level monitoring

## Current SQL Delivery Strategy

To keep the analysis easy to run in MySQL Workbench:

- questions should be answered from `carrier_risk_summary` and related summary-layer objects,
- heavy raw-table profiling should be avoided in Workbench,
- SQL should remain standalone and easy to execute without stored procedures or dynamic SQL.

Current primary script:

- `sql/05_analysis_questions.sql`
