# Exercise 1 (Also in separate python script file)
#!/usr/bin/env python3
# 1.1 
genome_size = 1000000
coverage = 3
read_length = 100
# Calculate number of reads to sequence a genome with 3X coverage
number_of_reads = genome_size * coverage // read_length
print(number_of_reads)
# There are 30,000

# 1.2 Coding
# import the tool package
import numpy
# create empty array for genome coverage to set up counting later
genome_coverage = numpy.zeros(genome_size, dtype=int)
# creating an array to keep track of the coverage at each position in the genome
start_position=numpy.random.randint(0,genome_size - read_length + 1, size = number_of_reads) 

# set up loop for counting the genome coverage
for i in start_position:
  genome_coverage[i:i+read_length] += 1
numpy.savetxt("Genome_Coverage.txt",genome_coverage,fmt="%d")

# 1.3 See R code file

# 1.4 Coding for calcualtion is in corresponding R files, fow answering questions, please read the following:
# 1: In your simulation, how much of the genome has not been sequenced (has 0x coverage)? 
# Answer: In my estimation, around 4.9483 percent of the genome has not been sequenced. 

# 2: How well does this match Poisson expectations? How well does the normal distribution fit the data?
# Answer: Since the Poisson estimation is about 0.0498, which is 4.98%, our estimation here is pretty close to it. The normal distribution gives a general idea and picture of how the population distributes but is not accurately depicting the data especially at low count genome range.


# 1.5.1 Python Coding for simulation (Also in separate python script file)
#!/usr/bin/env python3
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

# Exercise 1.5.2 : See R coding file and png image

# Exercise 1.5.3 :
# Answer: Proportion of genome with 10x coverage now is 0.0058%. Now the coverage data estimation lies even closer to the Poisson estimation, which is 0.0045%. They align each other very nicely till this step. Now the normal distribution mean curve fits with the histogram pattern really well as well, however there is still some little obvious deviation from the curvature of the overall pattern. 

# Exervice 1.6.1 Python coding for simulation (Also in separate python script file)
#!/usr/bin/env python3

# Exercise 1.5
genome_size = 1000000
coverage = 30
read_length = 100
# Calculate number of reads to sequence a genome with 30X coverage
number_of_reads = genome_size * coverage // read_length
print(number_of_reads)
# There are 300,000.

# import the tool package
import numpy
# create empty array for genome coverage to set up counting later
genome_coverage = numpy.zeros(genome_size, dtype=int)
# creating an array to keep track of the coverage at each position in the genome
start_position=numpy.random.randint(0,genome_size - read_length + 1, size = number_of_reads) 

# set up loop for counting the genome coverage
for i in start_position:
  genome_coverage[i:i+read_length] += 1
numpy.savetxt("Genome_Coverage_30.txt",genome_coverage,fmt="%d")

# Exercise 1.6.2 See R file for coding and graph

# Exercise 1.6.3 : Percentage calculation code is in corresponding R file for graphing.

# Answer: Proportion of genome with 30x coverage now is 0.004%. Now the coverage data estimation lies extremely close to the Poisson estimation, which is almost 0%. Basically the Poisson estimation overlaps the actual genome distributino from the simulation data. At the same time, the normal distribution mean curve fits much better with the histogram pattern with nearly identify curvature and pattern. 

# Exercise 2.1 See the corresponding Python script file and txt file.

# Exercise 2.2
conda create -n graphviz -c conda-forge graphviz
conda activate graphviz

# Exercise 2.3 
# Modified the 2.1 code to make it dot format readable. 

# Exsercise 2.4 Now, use dot to produce a directed graph. 
(qb24) cmdb@QuantBio-06 homework % conda activate graphviz
(graphviz) cmdb@QuantBio-06 homework % dot -Tpng debruijn_graph.dot -o ex2_digraph.png

# Exercise 2.5 
# One possible sequence can be: CATTGATTCTTAT

# Exercise 2.6
# 1. Ensure a full length reading of the whole genome to rule out the 0 sequence reading situation
# 2. Find the proper reading length, if it is too short, the reading can be inaccurate and end up in repeating circles, if it is too long, then there needs to be more data to allow this to work properly. 
# 3. To avoid the above mentioned repeating circles and patterns, it is better to use algorithms such as the de Bruijn graph to sort the pattern out for contineous reading