# Data Notes

Raw source files are not committed because the FMCSA datasets are large. Download the latest files from the official sources:

- Company Census: https://catalog.data.gov/dataset/company-census-file
- Vehicle Inspection File: https://catalog.data.gov/dataset/vehicle-inspection-file
- Crash File: https://catalog.data.gov/dataset/crash-file

Recommended local filenames:

- `data/raw/Company_Census_File.csv`
- `data/raw/Vehicle_Inspection_File.csv`
- `data/raw/Crash_File.csv`

If full raw exports are too large for your machine, use the official Socrata API export options to download selected columns needed for carrier identity, inspection, and crash-history analysis.

## Source Summary

Catalog snapshot referenced by this project:

- Catalog last checked: May 19, 2026 at 11:06 PM
- Dataset last updated: May 19, 2026

### Company Census File

- Published by Federal Motor Carrier Safety Administration | Department of Transportation
- Contains active, inactive, and pending entities registered with FMCSA
- Primary identifier is the USDOT number
- Includes entity identity data, business operations data, equipment and driver data, and carrier review data

### Vehicle Inspection File

- Published by data.transportation.gov | Department of Transportation
- Contains interstate and intrastate inspection activity for motor carriers and hazardous materials carriers
- Source system is the FMCSA MCMIS inspection data files
- Driver information is excluded from public releases because of privacy restrictions
- Severe violations may produce vehicle or driver out-of-service outcomes

### Crash File

- Published by Federal Motor Carrier Safety Administration | Department of Transportation
- Contains 59 public data elements derived from state police crash reports involving motor carriers operating in the U.S.
- Public release excludes driver data because of privacy restrictions
- A crash can produce multiple records when more than one commercial motor vehicle is involved
- Related records should be distinguished using the crash report number
