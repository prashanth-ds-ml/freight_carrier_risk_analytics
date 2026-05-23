# Data Notes

Raw source files are not committed because the FMCSA datasets are large. Download the latest files from the official sources:

- Company Census: https://catalog.data.gov/dataset/company-census-file
- Vehicle Inspection File: https://catalog.data.gov/dataset/vehicle-inspection-file
- Crash File: https://catalog.data.gov/dataset/crash-file

Recommended local filenames:

- `data/raw/fmcsa_company_census.csv`
- `data/raw/fmcsa_vehicle_inspections.csv`
- `data/raw/fmcsa_crashes.csv`

If full raw exports are too large for your machine, use the official Socrata API export options to download selected columns needed for carrier identity, inspection, and crash-history analysis.
