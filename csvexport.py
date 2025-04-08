#!/usr/bin/env python
# This short python script will export csv files from the relevant excel sheets for Mycobank and ICTV.

import polars as pl

# Open the files with polars:
ictv = pl.read_excel(source="./downloaded_datafiles/ictv/ICTV.xlsx", sheet_name="MSL")
myco = pl.read_excel(source="./downloaded_datafiles/mycobank/MBList.xlsx")

# Export them to csv
ictv.write_csv(file="downloaded_datafiles/ictv/ictv.csv", include_header=False)
myco.write_csv(file="downloaded_datafiles/mycobank/mycobank.csv", include_header=False)
