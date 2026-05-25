# DAX Measures

This file records the DAX measures currently used in the Power BI dashboard. The measures are grouped by dashboard page and are written against the Power BI-safe MySQL views imported into Power BI.

## Main Table Naming Note

Although the MySQL source object is `feright_risk_analysis.pbi_carrier_risk_summary`, Power BI DAX usually references only the imported table name:

- `pbi_carrier_risk_summary`
- `pbi_identity_authority_exceptions`
- `pbi_inspection_risk`
- `pbi_crash_risk`

## Page 1: Carrier Risk Overview

Source:

- `pbi_carrier_risk_summary`

Published page note:

- the live report uses KPI cards for total carriers, active carriers, carriers with inspections, carriers with crashes, and high-risk carriers

### Total Carriers

```DAX
Total Carriers = COUNTROWS(pbi_carrier_risk_summary)
```

### Active Carriers

```DAX
Active Carriers =
CALCULATE(
    COUNTROWS(pbi_carrier_risk_summary),
    pbi_carrier_risk_summary[status_code] = "A"
)
```

### Carriers With Inspections

```DAX
Carriers With Inspections =
CALCULATE(
    COUNTROWS(pbi_carrier_risk_summary),
    pbi_carrier_risk_summary[inspection_count] > 0
)
```

### Carriers With Crashes

```DAX
Carriers With Crashes =
CALCULATE(
    COUNTROWS(pbi_carrier_risk_summary),
    pbi_carrier_risk_summary[crash_count] > 0
)
```

### High-Risk Carriers

```DAX
High-Risk Carriers =
CALCULATE(
    COUNTROWS(pbi_carrier_risk_summary),
    pbi_carrier_risk_summary[risk_score] >= 3
)
```

## Page 2: Identity and Authority Exceptions

Source:

- `pbi_identity_authority_exceptions`

Published page note:

- the live report uses the `Authority Status Group` calculated column to replace blank authority statuses with `Missing / Unknown`

### Total Exception Carriers

```DAX
Total Exception Carriers = COUNTROWS(pbi_identity_authority_exceptions)
```

### Missing Identity Carriers

```DAX
Missing Identity Carriers =
CALCULATE(
    COUNTROWS(pbi_identity_authority_exceptions),
    pbi_identity_authority_exceptions[missing_identity_flag] = 1
)
```

### Authority Issue Carriers

```DAX
Authority Issue Carriers =
CALCULATE(
    COUNTROWS(pbi_identity_authority_exceptions),
    pbi_identity_authority_exceptions[authority_issue_flag] = 1
)
```

### Non-Active Exception Carriers

```DAX
Non-Active Exception Carriers =
CALCULATE(
    COUNTROWS(pbi_identity_authority_exceptions),
    pbi_identity_authority_exceptions[inactive_or_nonactive_status_flag] = 1
)
```

### Authority Status Group

This is a calculated column used to replace blank authority status values with a business-friendly label in charts.

```DAX
Authority Status Group =
IF(
    ISBLANK(pbi_identity_authority_exceptions[docket1_status_code]),
    "Missing / Unknown",
    pbi_identity_authority_exceptions[docket1_status_code]
)
```

## Page 3: Inspection Risk

Source:

- `pbi_inspection_risk`

Published page note:

- the final page design uses bar and table visuals instead of a scatter plot for clarity and business friendliness

### Inspection Carriers

```DAX
Inspection Carriers = COUNTROWS(pbi_inspection_risk)
```

### Total Inspections

```DAX
Total Inspections = SUM(pbi_inspection_risk[inspection_count])
```

### Total Violations

```DAX
Total Violations = SUM(pbi_inspection_risk[total_violations])
```

### Total OOS

```DAX
Total OOS = SUM(pbi_inspection_risk[total_oos])
```

### High OOS Carriers

```DAX
High OOS Carriers =
CALCULATE(
    COUNTROWS(pbi_inspection_risk),
    pbi_inspection_risk[high_oos_flag] = 1
)
```

### High Violation Carriers

```DAX
High Violation Carriers =
CALCULATE(
    COUNTROWS(pbi_inspection_risk),
    pbi_inspection_risk[high_violation_flag] = 1
)
```

## Page 4: Crash Risk

Source:

- `pbi_crash_risk`

Published page note:

- the live report emphasizes crash-linked carrier counts, injury crashes, fatal crashes, and carrier-operation/state concentration views

### Crash-Linked Carriers

```DAX
Crash-Linked Carriers = COUNTROWS(pbi_crash_risk)
```

### Total Crashes

```DAX
Total Crashes = SUM(pbi_crash_risk[crash_count])
```

### Injury Crashes

```DAX
Injury Crashes = SUM(pbi_crash_risk[injury_crash_count])
```

### Fatal Crashes

```DAX
Fatal Crashes = SUM(pbi_crash_risk[fatal_crash_count])
```

### Tow-Away Crashes

```DAX
Tow-Away Crashes = SUM(pbi_crash_risk[tow_away_count])
```

### Federal Recordable Crashes

```DAX
Federal Recordable Crashes = SUM(pbi_crash_risk[federal_recordable_count])
```
