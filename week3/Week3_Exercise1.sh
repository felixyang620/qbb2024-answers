#!/bin bash

### Q 1.1 ###
echo " " > readlength.txt
awk 'NR % 4 == 2 { print length($0) }' A01_09.fastq > readlength.txt # use awk to count the reading length for each sequence piece
# Sequence reading length is 76. 

### Q 1.2 ###
number_of_reads= wc -l readlength.txt # Use wc -l command to count the rows of the reading number from the text file generated
echo $number_of_reads
# There are 669548 reads within the file.

### Q 1.3 length of the S. cerevisiae reference genome = 12.1Mb ###
reference_genome_length=12100000  # define the reference genome length with a variable
total_read_length=`awk '{s+=$1} END {print s}' readlength.txt` # count the total reading length by adding all the reading numbers together
echo $total_read_length # print out the number for self confirming purpose
echo $reference_genome_length # print out the number for self confirming purpose
depth_of_coverage=$(bc -l -e "${total_read_length} / ${reference_genome_length}") # Use bc command to calculate the ratio to find depth of coverage index number
echo $depth_of_coverage # Print out the coverage depth to answer the question
# The average depth of coverage is 4.2X

### Q 1.4 ###
du -h *.fastq # Use du command to list out the file size for all the fastq files in the folder here.
# The A01_35.fastq has the largest file size with 146Mb. The A01_27.fastq has the smallest file size with 110Mb. 

### Q 1.5 ###
Fastqc A01_09.fastq # Use fastq to generate html page for checking the answer
# The median base quality along the read is around 35, given some are 36 and soem are 35. This means that probability of an errorous base is between 0.1% and 0.01% at that position. Even though the box plot is showing not much variatino among the different positions along the sequence reading,  The error bars under the box in the plot show some degree of variation, the possiblity of error decreases overall and the bar is shortened with a somewhat distributino pattern with less in the center part of the reading and a little higher possibility of error on both ends. 



