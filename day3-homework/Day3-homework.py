#! /usr/bin/env python


import sys

import numpy

# open file
fs = open( sys.argv[1], mode='r' )

# skip 2 lines
fs.readline()
fs.readline()

# split column header by tabs and skip first two entries
line = fs.readline()
fields = line.strip("\n").split("\t")
tissues = fields[2:]

# create way to hold gene names
# create way to hold gene IDs
# create way to hold expression values
gene_names = []
gene_IDs = []
expression = []

# for each line
for line in fs:

# split line
    fields = line.strip("\n").split("\t")

#     save field 0 into gene IDs
    gene_IDs.append(fields[0])
#     save field 1 into gene names
    gene_names.append(fields[1])
#     save 2+ into expression values
    expression.append(fields[2:])

fs.close()

tissues = numpy.array(tissues)
gene_IDs = numpy.array(gene_IDs)
gene_names = numpy.array(gene_names)
expression = numpy.array(expression, dtype=float)

# print(tissues)
# print(gene_IDs)
# print(gene_names)
# print(expression)

#4 find the mean of expression across the tissues
row_mean = numpy.mean(expression, axis=1)
print(row_mean)

#5 compare median and mean for the whole data set
expression_median = numpy.median(expression)
expression_mean = numpy.mean(expression)

print(expression_median)
print(expression_mean)
# the mean and the median can be drastically different, they can not represent each other, median is 0.027, mean is 16.557.

#6 log transformation

normalized_pseudo_dataset = numpy.log2(expression + 1)

normalized_median = numpy.median(normalized_pseudo_dataset)
normalized_mean = numpy.mean(normalized_pseudo_dataset)

print(normalized_median)
print(normalized_mean)

# now the mean and the median are much closer to each other, being median 0.0385 and mean 1.115.

#7 Expression gap for each gene

expression_copy = numpy.copy(normalized_pseudo_dataset)
sorted_expression = numpy.sort(expression_copy, axis = 1)
print(sorted_expression)

diff_array = sorted_expression[:,-1]- sorted_expression[:,-2]
print(diff_array)

# 8 Highly specific genes

Number_of_specific_genes = numpy.sum(diff_array >= 10)
print(Number_of_specific_genes)


#9 





