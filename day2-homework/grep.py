#!/usr/bin/env python3

import sys
gene = sys.argv[1]

my_file = open( sys.argv[2] ) 
for line in my_file:
     line = line.rstrip("\n")
     if gene in line:
           print( line )
my_file.close()