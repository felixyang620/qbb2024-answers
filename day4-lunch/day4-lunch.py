#!/usr/bin/env python3

import sys

import numpy

# 1 Load the gene-tissue profile
# get tissue text file name
filename = sys.argv[1]
# open file
fs = open(filename,mode='r')
# create dirct to hold samples for gene-tissue pairs
relevant_samples = {}
# step through file
for line in fs:
    # Split line into fields
    fields = line.rstrip("\n").split("\t")
    # create key from gene and tissue
    key = fields[0]
    value = fields[2]
    # initialize dict from key with list to hold samples
    relevant_samples.setdefault(key,value)
fs. close()

#2 Matching Tissue with corresponding sample IDs. 
# get metadata file name
filename2 = sys.argv[2]
# open file
fs = open(filename2,mode='r')
# Skip line
fs.readline()
# create dirct to hold samples for tissue names
tissue_samples = {}
# step through file
for line in fs:
    # Split line into fields
    fields = line.rstrip("\n").split("\t")
    # create key from gene and tissue
    key = fields[6]
    value = fields[0]
    # initialize dict from key with list to hold samples
    tissue_samples.setdefault(key, [])
    tissue_samples[key].append(value)

fs. close()

#3
# get gene expression file name
filename3 = sys.argv[3]
# open file
fs = open(filename3,mode='r')
# Skip the first 2 lines
fs.readline()
fs.readline()
header = fs.readline().rstrip("\n").split("\t")
# on the third row, split by tab to split columns in sections
header = header[2:]
#define header as content(sample IDs) in columns after position 2. 

#4 Matching Sample IDs with data set
# Create dictionary to be inserted by data  
tissue_columns = {}
# screen for previously selected sample IDs, then include it into the dictionary just created.
for tissue, samples in tissue_samples.items():
    tissue_columns.setdefault(tissue, [])
    for sample in samples:
        # For sample IDs appeared in "header" data set previously selected
        if sample in header:
            #define position with sampleID index number
            position = header.index(sample)
            # add the index number of the sample ID to the dictionary just created
            tissue_columns[tissue].append(position)
#To show the result
#print(tissue_columns)

#5
#Creat tissue dictionary
tissue_number = {}
#Set up for loop to search through the tissue names and sample IDs associated.
for tissue, lengths in tissue_columns.items():
    #check if the sample ID exists in the column ID index dictionary 
    tissue_number.setdefault(tissue, [])
    #if it exists, add to the correct tissue list
    tissue_lengths = len(tissue_columns[tissue])
    #check the expression data sample amount for each tissue 
    tissue_number[tissue] = tissue_lengths

#Check which tissue type has the most samples
longest_list_tissue = max(tissue_number, key=tissue_number.get)
#The tissue with the most column is skeletal muscle

#Check which tissue type has the least samples
shortest_list_tissue = min(tissue_number, key=tissue_number.get)
#The tissue with the least column is Leukemia cell line cells 

#To show up the results
print(longest_list_tissue)
print(shortest_list_tissue)


#6 Create gene name vs expression 
#Create lists for gene names and expression
gene_name = []
gene_ex = []

for line in fs:
    #Split the remaining expression data into fields
    linesplit = line.rstrip("\n").split("\t")
    #The first field is the gene names 
    gene_name.append(linesplit[0])
    #The third field and on are expression data
    gene_ex.append(linesplit[2:])

#Create an array 
gene_ex_data = numpy.array(gene_ex, dtype = float)

#Create lists to catalogue the genes in the list and their position, create dictionary to store expression data
gene_sample_pos = []
i = 0
gene_ex_value = {}


#Using in to determine if the gene is in the gene list 
for gene in gene_name:
    if gene in relevant_samples:
        #Note position of expression value by the gene 
        gene_sample_pos.append(i)
        tissue_relevent = relevant_samples[gene]
        tissue_column = tissue_columns[tissue_relevent]
        #Create a key using gene id and tissue name 
        key = (gene, tissue_relevent)
        #Create empty value list
        gene_ex_value.setdefault(key, [])
        ex_value = gene_ex_data[i][tissue_column]
        #Combine key and value
        gene_ex_value[key].append(ex_value)
    i += 1

print(gene_ex_value)

#7 Create a .tsv file
tsv_file = open("Expression_values.tsv", mode = "w")
#Sort by key first 
for key, value in gene_ex_value.items():
    #Sort by the expression value by espression array
    for i in range(len(value)):
        for j in range(len(value[i])):
            line = str(key[0]) + "\t" + str(key[1]) + "\t" + str(value[i][0]) + "\n"
            tsv_file.write(line)

fs.close()
tsv_file.close()







