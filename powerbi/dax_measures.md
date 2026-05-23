# DAX Measures

Planned measures:

```DAX
Total Carriers = DISTINCTCOUNT(carriers[dot_number])

Total Inspections = COUNTROWS(inspections)

Total Crashes = COUNTROWS(crashes)

OOS Rate = DIVIDE(SUM(inspections[oos_total]), [Total Inspections])

Violation Rate = DIVIDE(SUM(inspections[viol_total]), [Total Inspections])
```

