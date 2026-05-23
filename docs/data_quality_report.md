# Data Quality Report

Planned checks:

| Check | Purpose |
|---|---|
| Missing DOT numbers | Validate carrier join keys |
| Duplicate DOT numbers in census extract | Identify duplicate carrier master records |
| Missing legal names | Identity completeness check |
| Missing physical state/city/zip | Location completeness check |
| Invalid or future dates | Date quality validation |
| Inspection records without matching carrier | Join quality check |
| Crash records without matching carrier | Join quality check |
| Null violation/OOS fields | KPI reliability check |

This file will be updated after SQL profiling and Python EDA are completed.

