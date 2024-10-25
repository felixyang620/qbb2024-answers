### Q 1.1 ###
# Q: Can you think of a reason why this sample does not match the expected GC content distribution and base content at the beginning of sequences?
# A: For both the sample 1 and 2 files, they showed the problematic base sequence content and the GC distribution. The sequencing methods can have an effect on this since for some methods, such as Illumina that has well-kown issue with its low diversity at the front of the sequencing, which can distort the base composition and therefore the GC content at the front. 

### Q 1.2 ###
# Q: What is the origin of the most overrepresented sequence in this sample? Does it make sense?
# A: The top overrepresented sequence is from Drosophila melanogaster strain Canton S serine protease 3, serine protease 1 (SER1), or possibally serine protease 2 (SER2) genes. This makes sense since the serine proteases are the second largest family of genes in Drosophila malenogaster genome with broad range of functions such as immune system, digestion, and metabolism, etc. 

### Q 2 ###
# Q: If you were to reject any samples with the percentage of unique reads less than 45%, how many samples would you keep?
# A: 0. No sample is remained since the highest unique reads percentage is 35.2%. 
# Q: Can you see the blocks of triplicates clearly? Try adjusting the min slider up. Does this suggest anything about consistency between replicates?
# A: The triplicates on the heat map is not very distinguishabble. This means that the variation between the replicates is minimal and the general pattern is the same between the replicates, in other words, the consistency between the replicates are very high. 

### Q 3.3 ###
# What does the PCA plot suggest to you about the data? Why?
# The current PCA plot looks messy without any obvious correlation or grouping between the segments of the sample. This plot is not much meaningful as for data analysis, this may due to the variation of replicates within each sample. 

### Q 3.6 ###
# Do the categories of enrichments make sense? Why?
# The enrichments (which include lipid transport, localization, proteolysis and metabolic process) make perfect senese as these gene sample sequence readings were from Drosophila melanogaster midguts, where it does mostly the lipid absorption, digestions and metabolism to transport to other parts of the body. So the enrichment analysis proved the function and popular gene expresion in the gut. 
