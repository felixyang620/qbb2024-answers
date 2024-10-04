#!/usr/bin/env python3

import sys

# I used less -S in terminal to have a look at the actual file format and the position of the columns to be used later in this script.
# Create empty array for both AF and DP later to be appended by the extracted info later
AF = [ ] 
DP = [ ]
for line in open(sys.argv[1]): # Read the file at position 1 in terminal command line later, which is going to be the VCF file 
    if line.startswith("#"): # use If loop to skip all the metadata and the header on the first several rows. 
        continue # Skip those lines without any action.
    else: # If the line starts with any number or letter, which are the rows we actually need to analyze, do the following commands
        fields = line.rstrip('\n').split('\t') # parse the fields by tab for defining the target column later
        INFO_Field = fields[7] #The INFO column is on field position 7, so define it with this variable to be used later for processing
        Column1 = INFO_Field.rstrip('\n').split(';') # since there are multiple elements within this column that I only need to extract out AF info, so I need to parse again to assign by semicolon to define the field i want further within this field
        AF.append(Column1[3]) # Since AF info is on position 3 within this field, need to extract out and directly append to the empty array created before for AF
        for Variant in range(9,19):  # to define the rest of the columns, I am not sure how to do from 9 to "the end" script, so had to manually count the columns till the last one.   
            Column2= fields[Variant] # Use a variable to define the fields I want to extract data out of it later
            Read_Depth_Data = Column2.rstrip('\n').split(':') # Since the rest of the row are all separated by colon, do the colon parse agian to split them
            DP.append(Read_Depth_Data[2]) # Select the column with DP data only for each field, which is at position 3, and append directly to the empty array created for DP.
with open(f"AF.txt", "w") as file: # To create a file to store all those data saved to AF array, and write it with the data extracted out
    file.write("Allele_Frequency\n") # write the data into the file with a header line
    for Frequency in AF: 
        file.write(f"{Frequency[3:]}\n") # To write the data into the file with the corresponding data sets collected
# Do the same thing for DP to create file and write in the data with corresponding header
with open(f"DP.txt", "w") as file:
    file.write("Read_Depth\n")
    for Depth in DP:
        file.write(f"{Depth}\n")





        



