#!/usr/bin/env python
# This short python script will export csv files from the relevant excel sheets for Mycobank and ICTV.

# importing pandas as pd
import pandas as pd

# Open the files:
ictv = pd.read_excel(
    io='./downloaded_datafiles/ictv/ICTV.xlsx', sheet_name=2)
myco = pd.read_excel(
    io='./downloaded_datafiles/mycobank/MBList.xlsx')

# Export them to csv
ictv.to_csv(r'downloaded_datafiles/ictv/ictv.csv', index=None, header=False)
myco.to_csv(r'downloaded_datafiles/mycobank/mycobank.csv',
            index=None, header=False)
