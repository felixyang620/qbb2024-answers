#!/usr/bin/env python3

# Exercise 1.5
genome_size = 1000000
coverage = 10
read_length = 100
# Calculate number of reads to sequence a genome with 3X coverage
number_of_reads = genome_size * coverage // read_length
print(number_of_reads)
# There are 100,000

# import the tool package
import numpy
# create empty array for genome coverage to set up counting later
genome_coverage = numpy.zeros(genome_size, dtype=int)
# creating an array to keep track of the coverage at each position in the genome
start_position=numpy.random.randint(0,genome_size - read_length + 1, size = number_of_reads) 

# set up loop for counting the genome coverage
for i in start_position:
  genome_coverage[i:i+read_length] += 1
numpy.savetxt("Genome_Coverage_10.txt",genome_coverage,fmt="%d")



