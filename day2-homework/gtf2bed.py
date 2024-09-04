#! /usr/bin/env python3

import sys

my_file = open ( sys.argv[1] )

for line in my_file:
    line = line.rstrip("\n")
    if "##" in line:
        continue
    line = line.split("\t")
    line2 = line[8].split(";")[2]
    line3 = line2.lstrip("gene_name \"").rstrip("\"")
    print(line[0],"\t",line[3],"\t",line[4],"\t",line3)


my_file.close()