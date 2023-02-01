# Python script to download lpsn data via their API

import lpsn  # install first with 'pip install lpsn'
from datetime import date
today = date.today()
print(today)    

client = lpsn.LpsnClient('***LOGIN***', '***PASSWORD***')

# the prepare method fetches all LPSN-IDs matching your query
# and returns the number of IDs found
count = client.search(date_option = 'before', date = today)
print(count, 'entries found in LPSN.')

LPSN_list = []
# the retrieve method lets you iterate over all results
# and returns the full entry as dict
# Entries can be further filtered using a list of keys (e.g. ['keywords'])
for entry in client.retrieve():
    LPSN_list.append(entry)

# We know have a list of python dictionaries. Let's make a function to extract the taxonomic name from each element in the list.
def name(list):
    output = []
    for i in list:
        output.append(i['full_name'])
    return(output)
        
shortlist = name(LPSN_list)
        
print(len(shortlist), 'species downloaded.')

# Writing to file
file = open('downloaded_datafiles/lpsn/lpsn', 'w')
for i in shortlist:
    file.write(i+"\n")
file.close()
print('Done')
