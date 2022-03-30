# The Taxonomy Dictionary

The purpose of this dictionary is to include **all** taxonomic names, so that it can be used from your preferred text editor and correct your spelling mistakes. It should be of good use to anyone working with biology and frequently using taxonomic names in their writing. It will not check if *italics* is used properly, so please be aware of that yourself. It has been built from five sources, and the goal is to include every taxon described:

- [GBIF backbone](https://www.gbif.org/dataset/d7dddbf4-2cf0-4f39-9b2a-bb099caae36c) [^1]
- [Catalogue of life](https://www.catalogueoflife.org/) [^2] 
- [ICTV](https://talk.ictvonline.org/) [^3]
- [LPSN](https://lpsn.dsmz.de/text/introduction) [^4]
- [Mycobank](https://www.mycobank.org/) [^5]

All taxonomic entries in the above databases have been aggregated, so every single species and subspecies that figures in one of the databases are included. It has been deduplicated, so every word appears only once. The result is a dictionary consisting of 1,410,103 taxonomic words.
It is massive, for a comparison the english dictionary have around 130,000 words. It will mark the words you spell wrong. And you can rely on that the words that are not marked are mostly spelled correct. As a consequence of it's size the autosuggestions for correcting a word is not always on spot. This depends on the spelling engine you use and not the dictionary. Many times it will however suggest a reasonable correction.

The GBIF backbone and Catalogue of lige are already giant sources that should be sufficient for most. My background is in microbiology, so I wanted to make sure that the taxons for bacteria, virus and fungi were up to date, and therefore added LPSN, ICTV and MycoBank. If you find any species lacking or have suggestions for a relevant database to add, please let me know and I will try to incorporate it.

## Installation
### Linux:
The following instructions work if you are using the [hunspell](https://hunspell.github.io/) dictionary.
Download the taxonomy.dic file and place it in `~/Library/Spelling`.
You can now use the dictionary called taxonomy. Hunspell can check a file for multiple languages at the same time. If you would like to use it on a file, and also check for spelling errors for the English language you can use this command:

    $ hunspell -d en_US,taxonomy myFile.txt

### Microsoft Word:
Download the taxonomy.dic file.
I had some troubles with Word not recognizing the taxonomy.dic file as unicode (UTF-8) even though it is. Because of this, the easiest way to add the dictionary, is to make a custom dictionary for the user. [Here](https://support.microsoft.com/en-us/office/add-or-edit-words-in-a-spell-check-dictionary-56e5c373-29f8-4d11-baf6-87151725c0dc) are instructions for how to create a custom dictionary. You can call it my_taxonomy or whatever, to identify it later.  
On windows the custom dictionaries are stored at this location: (Be aware that AppData is a hidden directory)

    C:\Users\<username>\AppData\Roaming\Microsoft\UProof

Afterwards open the downloaded dictionary and the newly created using notepad. Then copy/paste all the content from one to the other using CTRL+a, CTRL+c and CTRL+v.  
At last make sure that the new dictionary is enabled in Word, it should be automatically after creation, if not, there is also instructions for that in the link above.

## Version
Version 1 (March 30, 2022). This version have been built with the following versions of the source databases.
- GBIF backbone: version from December 9, 2021
- Catalogue of Life: 2022-03-21 - ChecklistBank 9812
- ICTV: Master Species List 2020.v1 [^6]
- LPSN: genera, species and subspecies list (GSS) downloaded 2021-10-29 
- Mycobank: version 8th of June 2021. 

## Acknowledgement
Thanks to Jose Alfredo Samaniego Castruita that showed me how to use the sed and awk commands to handle the data and obtain the desired result.
Thanks to every one that has contributed to the databases used for this project.

## References
[^1]: Registry-Migration.Gbif.Org. “GBIF Backbone Taxonomy.” GBIF Secretariat, 2021. https://doi.org/10.15468/39OMEI.

[^2]: Bánki, O., Roskov, Y., Döring, M., Ower, G., Vandepitte, L., Hobern, D., Remsen, D., Schalk, P., DeWalt, R. E., Keping, M., Miller, J., Orrell, T., Aalbu, R., Adlard, R., Adriaenssens, E. M., Aedo, C., Aescht, E., Akkari, N., Alfenas-Zerbini, P., et al. (2022). Catalogue of Life Checklist (Version 2022-03-21). Catalogue of Life. https://doi.org/10.48580/dfpd

[^3]: Lefkowitz, Elliot J., Donald M. Dempsey, Robert Curtis Hendrickson, Richard J. Orton, Stuart G. Siddell, and Donald B. Smith. “Virus Taxonomy: The Database of the International Committee on Taxonomy of Viruses (ICTV).” Nucleic Acids Research 46, no. D1 (January 4, 2018): D708–17. https://doi.org/10.1093/nar/gkx932.

[^4]: Parte, Aidan C., Joaquim Sardà Carbasse, Jan P. Meier-Kolthoff, Lorenz C. Reimer, and Markus Göker. “List of Prokaryotic Names with Standing in Nomenclature (LPSN) Moves to the DSMZ.” International Journal of Systematic and Evolutionary Microbiology 70, no. 11 (November 1, 2020): 5607–12. https://doi.org/10.1099/ijsem.0.004332.

[^5]: Robert, Vincent, Duong Vu, Ammar Ben Hadj Amor, Nathalie van de Wiele, Carlo Brouwer, Bernard Jabas, Szaniszlo Szoke, et al. “MycoBank Gearing up for New Horizons.” IMA Fungus 4, no. 2 (December 2013): 371–79. https://doi.org/10.5598/imafungus.2013.04.02.16.

[^6]: Walker, Peter J., Stuart G. Siddell, Elliot J. Lefkowitz, Arcady R. Mushegian, Evelien M. Adriaenssens, Donald M. Dempsey, Bas E. Dutilh, et al. “Changes to Virus Taxonomy and the Statutes Ratified by the International Committee on Taxonomy of Viruses (2020).” Archives of Virology 165, no. 11 (November 2020): 2737–48. https://doi.org/10.1007/s00705-020-04752-x.

