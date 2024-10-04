#!/bin bash

### Q 2.1 ###
#wget https://hgdownload.cse.ucsc.edu/goldenPath/sacCer3/bigZips/sacCer3.fa.gz
#gunzip sacCer3.fa.gz
bwa index sacCer3.fa
# There are 17 chromosomes in the yeast genome.

### Q 2.2 ###
for number in 09 11 23 24 27 31 35 39 62 63 # I tried to use A01_*.fastq for the loop but somehow it doesn't work, i have another test.sh file in this folder to test, if possible, could you please briefly let me know whats the general probelm? Thank you. 
do
    file=`basename A01_${number}.fastq` # define the files to be processed with name assigned with numbers
    bwa mem -t 4 -R "@RG\tID:${number}\tSM:${number}" sacCer3.fa A01_${number}.fastq > sacCer_A01_${number}.sam # do the allignment for each file
    samtools sort -@ 4 -O bam -o sacCer_A01_${number}.bam sacCer_A01_${number}.sam # For Q2.4, sorting each sam file and output the bam file at the same time
    samtools index sacCer_A01_${number}.bam # For Q 2.4, index each of the bam file created just now originated from each fastq file
done

#### Answer for Q 2.2 ###
# Use the below script to find the read length, however with less -S, I noticed that there are 20 header lines that should not be counted in.
less -S sacCer_A01_09.sam 
wc -l sacCer_A01_09.sam 
# So the final answer for Q 2.2 is the number generated from the script 669568 - 20 (header line #) = 669548. 

### Answer for Q 2.3 ###
grep -w "chrIII" sacCer_A01_09.sam | wc -l # use grep to extract out all the readings with chrIII on it because it means the reading is from the chromosome III, then wc -l to count all amount
# There are 18196 on chr III. 

#### Q 2.4 ###
# Script as above. The coverage is approximately in the same range as shown in IGV, but they are generally not uniformally distributed. So there are coverage for certain gene for more than 6, but some section with only 1 or 2. So I think if I average out everything in IGV, they should be similar of what I got in 1.3.

### Q 2.5 ###
# Script as above. There should be 2 SNPs existing. However, there are more weaker bands showing up, which I think is caused by more likely sequencing error instead of real SNPs between the genes. The 2 substantial ones are more likely to be real because they happen in multiple sequencing segments. 

### Q 2.6 ###
# The position of SNP in this window is on chrIV:825,834. It is not in a gene, it is between SCC2 and SAS4. 


