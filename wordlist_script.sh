#!/usr/bin/env bash

# * Setup folder structure
# Run script to set up folder structure and purge older downloaded databases.
./folder_setup.sh
# * Download the databases

### ATTENTION: ###
# You need to register (free) on the LPSN website, then update the LPSN python script with your login credentials.

# ** ICTV
# 1) Download the data. This can be done with a curl.
# Check if it is the current version: https://ictv.global/msl/current
curl -o downloaded_datafiles/ictv/ICTV.xlsx https://ictv.global/sites/default/files/MSL/ICTV_Master_Species_List_2024_MSL40.v1.xlsx
# 2) Python will later handle export to csv
# ** LPSN
# 1) Download the data. LPSN have an API. We interact with it and download the data with this python script:
python3 lpsnapi.py

# ** MycoBank
# 1) Download the data. This can be done with curl.
curl -o downloaded_datafiles/mycobank/mycobank.zip https://www.mycobank.org/images/MBList.zip
# 2) Unzip the archive, can be done like this:
unzip downloaded_datafiles/mycobank/mycobank.zip -d downloaded_datafiles/mycobank
# 3) Python will later handle the export to csv

# ** GBIF Backbone
# 1) Download the data. This can be done with curl.
curl -o downloaded_datafiles/gbif/backbone.zip https://hosted-datasets.gbif.org/datasets/backbone/current/backbone.zip
# 2) Unzip the archive, can be done like this:
unzip downloaded_datafiles/gbif/backbone.zip -d downloaded_datafiles/gbif/

# ** Catalogue of Life
# 1) Download the data. curl did not work for me in this case, so I use wget instead.
wget -O downloaded_datafiles/col/col.zip https://download.checklistbank.org/col/monthly/2023-11-24_coldp.zip
# 2) Unzip the archive, can be done like this:
unzip downloaded_datafiles/col/col.zip -d downloaded_datafiles/col/col_unzipped

# ** Zoobank
# 1) Download the data
wget -O downloaded_datafiles/zoobank/zoobank.zip http://ipt.bishopmuseum.org:8080/ipt/archive.do?r=zoobank
# 2) Unzip the archive, can be done like this:
unzip downloaded_datafiles/zoobank/zoobank.zip -d downloaded_datafiles/zoobank

# ** The World Flora Online
# 1) Download the data
# The -k skips the certificate, as it is not valid any more.
# curl -k -O downloaded_datafiles/wfo/WFO_Backbone.zip https://files.worldfloraonline.org/files/WFO_Backbone/_WFOCompleteBackbone/WFO_Backbone.zip --compressed
curl -k  https://files.worldfloraonline.org/files/WFO_Backbone/_WFOCompleteBackbone/WFO_Backbone.zip > downloaded_datafiles/wfo/WFO_Backbone.zip

# 2) Unzip the archive, can be done like this:
unzip downloaded_datafiles/wfo/WFO_Backbone.zip -d downloaded_datafiles/wfo

# ** Inform of process
echo 'download of data finished\nStarting taxon extraction'

# ** Python script for exporting csv for downloaded excel files.
python3 csvexport.py
wait

# * ICTV
# The next line selects the variables containing taxon information.  # Use sed to remove commas then move every word on to a new line. Afterwards pipe to unique and save under new filename.
cut -f2-16 -d, downloaded_datafiles/ictv/ictv.csv | sed 's/,/ /g' | sed 's/ /\n/g' | sort | uniq > modified_datafiles/ictv/ictv_uniq


# * LPSN
# Use sed to move every word on to a new line. Afterwards pipe to unique and save under new filename.
sed 's/ /\n/g' downloaded_datafiles/lpsn/lpsn | sort | uniq > modified_datafiles/lpsn/lpsn_uniq

# * MycoBank
# Here we only need the second column # Then use sed to move every word on to a new line. Afterwards pipe to unique and save under new filename.
cut -f2 -d, downloaded_datafiles/mycobank/mycobank.csv | sed 's/ /\n/g' | sort | uniq > modified_datafiles/mycobank/myco_uniq

# * GBIF Backbone
# We need coloumn 8 to 11 and 18 to 23 for the taxonomic information.
cut -f8-11,18-23 downloaded_datafiles/gbif/Taxon.tsv > modified_datafiles/gbif/taxon.tsv

# Use sed to change tabs and spaces with new lines, then pipe to unique and save as a new file
sed 's/\t/\n/g' modified_datafiles/gbif/taxon.tsv | sed 's/ /\n/g' | sort | uniq > modified_datafiles/gbif/backbone

# * Catalogue of Life
# We need coloumn 8 and 12
cut -f8,12 downloaded_datafiles/col/col_unzipped/NameUsage.tsv > modified_datafiles/col/cat_cut

# Then remove all tabs
sed 's/\t/\n/g' modified_datafiles/col/cat_cut > modified_datafiles/col/cat_nl
# Remove the first two lines that is the header in the original file.
sed '1d;2d' modified_datafiles/col/cat_nl > modified_datafiles/col/cat_nl2
# Remove all spaces and filter dublicates
sed 's/ /\n/g' modified_datafiles/col/cat_nl2 | sort | uniq > modified_datafiles/col/cat_space

# * Zoobank
 # The taxonomic data are in coloumn  18 though 26
cut -f18-26 downloaded_datafiles/zoobank/taxon.txt > modified_datafiles/zoobank/zoo_cut
# Remove tabs and spaces, then filter dublicates
sed 's/ /\n/g' modified_datafiles/zoobank/zoo_cut | sed 's/\t/\n/g' | sort | uniq > modified_datafiles/zoobank/zoo_done

# * World flora online
# We need from column 8 to 15.
cut -f8-15 downloaded_datafiles/wfo/classification.csv > modified_datafiles/wfo/wfo_cut

# Remove tabs and spaces, then filter dublicates
sed 's/ /\n/g' modified_datafiles/wfo/wfo_cut | sed 's/\t/\n/g' | sort | uniq > modified_datafiles/wfo/wfo_done

# * Merge the databases
echo 'Merging extracted taxons'

cat modified_datafiles/lpsn/lpsn_uniq > dictionary_files/taxonomy_wordlist
cat modified_datafiles/ictv/ictv_uniq >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/mycobank/myco_uniq >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/gbif/backbone >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/col/cat_space >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/zoobank/zoo_done >> dictionary_files/taxonomy_wordlist
cat modified_datafiles/wfo/wfo_done >> dictionary_files/taxonomy_wordlist

# Remove words that contain non-letter characters
sed -E '/[^a-z|A-Z]/d' dictionary_files/taxonomy_wordlist > dictionary_files/taxonomy_wordlist_non_letter

# Then sort and remove duplicates
sort dictionary_files/taxonomy_wordlist_non_letter | uniq > dictionary_files/taxonomy

# * Make the dictionary file
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
    - Zoobank
    - World Flora Online

    Version: 1.0.4

    Check out https://github-com/kbagge/taxonomy_dictionary for documentation.

    License: GNU GPLv3. There should be a copy of this license included with every distribution of this dictionary.
" >> dictionary_files/taxonomy.dic

# Lastly we add all the words generated above to the .dic file
cat dictionary_files/taxonomy >> dictionary_files/taxonomy.dic
