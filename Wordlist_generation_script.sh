#!/usr/bin/env bash

## Make some directories to hold the data files
mkdir -p downloaded_datafiles/ictv
mkdir -p downloaded_datafiles/lpsn
mkdir -p downloaded_datafiles/mycobank
mkdir -p downloaded_datafiles/col
mkdir -p downloaded_datafiles/gbif
mkdir -p downloaded_datafiles/zoobank
mkdir -p downloaded_datafiles/wfo
mkdir -p modified_datafiles/ictv
mkdir -p modified_datafiles/lpsn
mkdir -p modified_datafiles/mycobank
mkdir -p modified_datafiles/col
mkdir -p modified_datafiles/gbif
mkdir -p modified_datafiles/zoobank
mkdir -p modified_datafiles/wfo
mkdir -p dictionary_files

## WARNING ##
# The following section needs a lot of manual preperation before the script can run
# This is neccesary as some of the databases have to be downloaded manually, others needs to be exported from .xlsx to .csv format

## Download the files ##
## ICTV
# 1) Download the data. This can be done with a curl.
# curl -o downloaded_datafiles/ictv/ICTV.xlsx -J https://talk.ictvonline.org/files/master-species-lists/m/msl/12314/download
# 2) Open up the file in excel and export as ictv.csv

## LPSN
# 1) The data needs to be downloaded manually from here: https://lpsn.dsmz.de/text/approved-lists
# You need to make a login before the data is accesible. Save it in the downloaded_datafiles/lpsn folder.

## MycoBank
# 1) Download the data. This can be done with curl.
# curl -o downloaded_datafiles/mycobank/mycobank.zip https://www.mycobank.org/images/MBList.zip
# 2) Unzip the archive, can be done like this:
# unzip downloaded_datafiles/mycobank/mycobank.zip -d downloaded_datafiles/mycobank
# 3) Manually open up the file in excel and export as mycobank.csv

## GBIF Backbone
# 1) Must be downloaded manually from here: https://hosted-datasets.gbif.org/datasets/backbone/current/
# Save it in downloaded_datafiles/gbif
# 2) Afterwards unzip

## Catalogue of Life
# 1) Must be downloaded manually from here: https://www.catalogueoflife.org/data/download - select the ColDP Archive version
# Save it as downloaded_datafiles/col/col.zip
# 2) Unzip the archive, can be done like this:
# unzip downloaded_datafiles/col/col.zip -d downloaded_datafiles/col/col_unzipped

## Zoobank
# 1) Must be downloaded manually from here: https://www.gbif.org/dataset/c8227bb4-4143-443f-8cb2-51f9576aff14
# Save it as downloaded_datafiles/zoobank/dwca-zoobank-v1.7.zip
# 2) Unzip the archive, can be done like this:
# unzip downloaded_datafiles/zoobank/dwca-zoobank-v1.7.zip

## The World Flora Online
# 1) Must be downloaded manually from here: http://www.worldfloraonline.org/downloadData;jsessionid=7DD9F11BC04922A2BD3C3DBEEAA40D68
# Save it as  downloaded_datafiles/wfo/WFO_Backbone.zip
# 2) Unzip the archive, can be done like this:
# unzip downloaded_datafiles/wfo/WFO_Backbone.zip

### ATTENTION: ###
# After the steps above the script should be able to run and generate the dictionary file - have fun.

## ICTV
# The next line selects the variables containing taxon information.
cut -f2-16 -d, downloaded_datafiles/ictv/ictv.csv > modified_datafiles/ictv/ictv.csv

# Use sed to remove commas then move every word on to a new line. Afterwards pipe to unique and save under new filename.
sed 's/,/ /g' modified_datafiles/ictv/ictv.csv | sed 's/ /\n/g' | sort | uniq > modified_datafiles/ictv/ictv_uniq

## LPSN

# We need coloumn 1-3 for the taxonomic entries. Watch out for the file name since the last step was manual.
cut -f1-3 -d, downloaded_datafiles/lpsn/lpsn_gss_2021-10-29.csv > modified_datafiles/lpsn/lpsn.csv

# Use sed to remove commas then move every word on to a new line. Afterwards pipe to unique and save under new filename.
sed 's/,/ /g' modified_datafiles/lpsn/lpsn.csv | sed 's/ /\n/g' | sort | uniq > modified_datafiles/lpsn/lpsn_uniq

## MycoBank

# Here we only need the second coloumn
cut -f2 downloaded_datafiles/mycobank/mycobank.csv > modified_datafiles/mycobank/myco.csv

# Use sed to move every word on to a new line. Afterwards pipe to unique and save under new filename.
sed 's/ /\n/g' modified_datafiles/mycobank/myco.csv | sort | uniq > modified_datafiles/mycobank/myco_uniq

## GBIF Backbone

# We need coloumn 8 to 10 and 18 to 23 for the taxonomic information.
cut -f8-10,18-23 downloaded_datafiles/gbif/backbone/Taxon.tsv > modified_datafiles/gbif/taxon.tsv

# Use sed to change tabs and spaces with new lines, then pipe to unique and save as a new file
sed 's/\t/\n/g' modified_datafiles/gbif/taxon.tsv | sed 's/ /\n/g' | sort | uniq > modified_datafiles/gbif/backbone

## Catalogue of Life

# We need coloumn 6 and 10
cut -f6,10 downloaded_datafiles/col/col_unzipped/NameUsage.tsv > modified_datafiles/col/cat_cut

# Then remove all tabs
sed 's/\t/\n/g' modified_datafiles/col/cat_cut > modified_datafiles/col/cat_nl
# Remove the first two lines that is the header in the original file.
sed '1d;2d' modified_datafiles/col/cat_nl > modified_datafiles/col/cat_nl2
# Remove all spaces and filter dublicates
sed 's/ /\n/g' modified_datafiles/col/cat_nl2 | sort | uniq > modified_datafiles/col/cat_space

## Zoobank
 # The taxonomic data are in coloumn  18 though 24
 cut -f18-24 downloaded_datafiles/zoobank/dwca-zoobank-v1.7/taxon.txt > modified_datafiles/zoobank/zoo_cut
# Remove tabs and spaces, then filter dublicates
sed 's/ /\n/g' modified_datafiles/zoobank/zoo_cut | sed 's/\t/\n/g' | sort | uniq > modified_datafiles/zoobank/zoo_done

## World flora online

# We need from column 8 to 13.
cut -f8-13 downloaded_datafiles/wfo/WFO_Backbone/classification.txt > modified_datafiles/wfo/wfo_cut

# Remove tabs and spaces, then filter dublicates
sed 's/ /\n/g' modified_datafiles/wfo/wfo_cut | sed 's/\t/\n/g' | sort | uniq > modified_datafiles/wfo/wfo_done

## Merge the databases

cat modified_datafiles/lpsn/lpsn_uniq > dictionary_files/taxonomy_wordlist
cat modified_datafiles/ictv/ictv_uniq >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/mycobank/myco_uniq >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/gbif/backbone >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/col/cat_space >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/zoobank/zoo_done >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/wfo/wfo_done >> dictionary_files/taxonomy_wordlist

# Then sort and remove duplicates
sort dictionary_files/taxonomy_wordlist | uniq > dictionary_files/taxonomy_wordlist_uniq

# Remove all lines that does not contain a single letter.
sed -E '/[a-z]|[A-Z]/!d' dictionary_files/taxonomy_wordlist_uniq > dictionary_files/taxonomy

## Make the dictionary file
# The formats normally used require the first line to contain the number of words in the dicionary - Let's insert that in the top:
wc -l dictionary_files/taxonomy | sed 's/ dictionary_files\/taxonomy//g' > dictionary_files/taxonomy.dic

# Then let's insert some descriptive text, so any one finding this file later knows what it is and where it came from. None of the words will be added to the dictionary since we start out with tabs on each line.
echo "
    This is the dictionary file of The Taxonomy Dictionary

    The word list was compiled from the following sources:
    - GBIF-backbone
    - Catalogue of life
    - ICTV
    - LPSN
    - MycoBank

    Version 1 (March 30, 2022)

    Check out https://github-com/kbagge/taxonomy_dictionary for documentation.

    License: GNU GPLv3. There should be a copy of this license included with every distribution of this dictionary.
" >> dictionary_files/taxonomy.dic

# Lastly we add all the words generated above to the .dic file
cat dictionary_files/taxonomy >> dictionary_files/taxonomy.dic
