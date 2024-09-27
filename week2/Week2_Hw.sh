#!/bin/bash

echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt  #Creat initial file to be filled in with data later

for MAF in 0.1 0.2 0.3 0.4 0.5 # Define the file scanning range and specificity
do
   Maf_File=chr1_snps_${MAF}.bed # define the variable with file names before the loop
   bedtools coverage -a genome_chr1.bed -b ${Maf_File} > temp_file${MAF}.txt # use bedtools to find coverage of SNPs at different MAF level.
   SNP_amount=$(awk '{s+=$4}END{print s}' temp_file${MAF}.txt) # Sum the number of SNPs found in the genome
   Base_amount=$(awk '{s+=$6}END{print s}' temp_file${MAF}.txt) # Sum the number of bases found in the genome
   echo $SNP_amount # Print out the number to check
   echo $Base_amount #Print out the number to check
   background_density=$(bc -l -e ${SNP_amount} / ${Base_amount}) # Calculate the background density of SNPs in the genome
   for Feature in exons introns cCREs other # Check the feature files processed from problem 1
   do 
      Featurefile=${Feature}_chr1.bed # set the variable with designated files to be processed in loop later
      bedtools coverage -a ${Featurefile} -b ${Maf_File} > coverage_${MAF}_${Feature}.txt # find the coverage of SNPs on a given feature and store in a temperary file to be read later
      Feature_SNP=$(awk '{s+=$4}END{print s}' coverage_${MAF}_${Feature}.txt) # Sum all the number of SNPs found to be stored in the corresponding temperary file
      Feature_base=$(awk '{s+=$6}END{print s}' coverage_${MAF}_${Feature}.txt) # Sum all the number of bases found to be stored in the temp file
      echo $Feature_SNP # Print out the number of check 
      echo $Feature_base # Print out the number of check
      Feature_density=$(bc -l -e ${Feature_SNP} / ${Feature_base}) # Calculate the density of SNPs in the feature
      Enrichment=$(bc -l -e ${Feature_density} / ${background_density}) # Calculate the enrichmented SNPs 
      echo -e "${MAF}\t${Feature}\t${Enrichment}" >> snp_counts.txt # Store the data into the newly created file.
   done
done
