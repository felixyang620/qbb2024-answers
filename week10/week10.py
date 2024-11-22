#!/usr/bin/env python

import numpy
import scipy
import matplotlib.pyplot as plt
import imageio
import plotly
import plotly.express as px
na = numpy.newaxis

# Define variables with file name content, the genes, fields and the channels.
genes = ["APEX1","PIM2","POLR2B","SRSF1"]
fields = ["field0","field1"]
channels = ["DAPI","nascentRNA","PCNA"]

img = imageio.v3.imread("APEX1_field0_DAPI.tif") # To set a variable for image size reference

# Create an empty array for adding images in later, for loop following with image reading and loading commands
images = []
for gene in genes:
    for field in fields:
        imgArray = numpy.zeros((img.shape[0], img.shape[1], 3), numpy.uint16) # Set image size with previous reference when creating an empty array with 3 dimensions
        for i, channel in enumerate(channels):
                imgArray[:, :, i] = imageio.v3.imread(f"{gene}_{field}_{channel}.tif")
                #imgArray[:, :, i] -= numpy.amin(imgArray[:, :, i])
                #imgArray[:, :, i] /= numpy.amax(imgArray[:, :, i])

        # Adding image readings for each channel into that 3rd layer of 3D array
        #imgArray[:, :, 0] = imageio.v3.imread(f"{gene}_{field}_DAPI.tif").astype(numpy.uint16)
        #imgArray[:, :, 1] = imageio.v3.imread(f"{gene}_{field}_nascentRNA.tif").astype(numpy.uint16)
        #imgArray[:, :, 2] = imageio.v3.imread(f"{gene}_{field}_PCNA.tif").astype(numpy.uint16)

        # Add the imgArray 
        images.append(imgArray)
#images = numpy.array(images)


# Check to see if the above coding works or not:if the images were loaded.
plt.imshow(imgArray)
plt.show()

# Use DAPI channel as a reference for setting up mask parameters.

mask = []
for i in range(len(images[:])):
    mask.append(images[i][:,:,0] >= numpy.average(images[i][:,:,0]))
#mask = numpy.array(mask)

# Copy from the live-coding syntax, to find nuclear bodies by masking

def find_labels(mask):
    # Set initial label
    l = 0
    # Create array to hold labels
    labels = numpy.zeros(mask.shape, numpy.int32)
    # Create list to keep track of label associations
    equivalence = [0]
    # Check upper-left corner
    if mask[0, 0]:
        l += 1
        equivalence.append(l)
        labels[0, 0] = l
    # For each non-zero column in row 0, check back pixel label
    for y in range(1, mask.shape[1]):
        if mask[0, y]:
            if mask[0, y - 1]:
                # If back pixel has a label, use same label
                labels[0, y] = equivalence[labels[0, y - 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[0, y] = l
    # For each non-zero row
    for x in range(1, mask.shape[0]):
        # Check left-most column, up  and up-right pixels
        if mask[x, 0]:
            if mask[x - 1, 0]:
                # If up pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 0]]
            elif mask[x - 1, 1]:
                # If up-right pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[x, 0] = l
        # For each non-zero column except last in nonzero rows, check up, up-right, up-right, up-left, left pixels
        for y in range(1, mask.shape[1] - 1):
            if mask[x, y]:
                if mask[x - 1, y]:
                    # If up pixel has label, use that label
                    labels[x, y] = equivalence[labels[x - 1, y]]
                elif mask[x - 1, y + 1]:
                    # If not up but up-right pixel has label, need to update equivalence table
                    if mask[x - 1, y - 1]:
                        # If up-left pixel has label, relabel up-right equivalence, up-left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x - 1, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x - 1, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    elif mask[x, y - 1]:
                        # If left pixel has label, relabel up-right equivalence, left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    else:
                        # If neither up-left or left pixels are labeled, use up-right equivalence label
                        labels[x, y] = equivalence[labels[x - 1, y + 1]]
                elif mask[x - 1, y - 1]:
                    # If not up, or up-right pixels have labels but up-left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x - 1, y - 1]]
                elif mask[x, y - 1]:
                    # If not up, up-right, or up-left pixels have labels but left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x, y - 1]]
                else:
                    # Otherwise, add new label
                    l += 1
                    equivalence.append(l)
                    labels[x, y] = l
        # Check last pixel in row
        if mask[x, -1]:
            if mask[x - 1, -1]:
                # if up pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -1]]
            elif mask[x - 1, -2]:
                # if not up but up-left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -2]]
            elif mask[x, -2]:
                # if not up or up-left but left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x, -2]]
            else:
                # Otherwise, add new label
                l += 1
                equivalence.append(l)
                labels[x, -1] = l
    equivalence = numpy.array(equivalence)
    # Go backwards through all labels
    for i in range(1, len(equivalence))[::-1]:
        # Convert labels to the lowest value in the set associated with a single object
        labels[numpy.where(labels == i)] = equivalence[i]
    # Get set of unique labels
    ulabels = numpy.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[numpy.where(labels == j)] = i
    return labels

# Create an empty label array to be added with label readings
label_array = []
for i in range(len(mask[:])):
    label = find_labels(mask[i])
    label_array.append(label)

# Filter label by size
def filter_by_size(labels, minsize, maxsize):
    # Find label sizes
    sizes = numpy.bincount(labels.ravel())
    # Iterate through labels, skipping background
    for i in range(1, sizes.shape[0]):
        # If the number of pixels falls outsize the cutoff range, relabel as background
        if sizes[i] < minsize or sizes[i] > maxsize:
            # Find all pixels for label
            where = numpy.where(labels == i)
            labels[where] = 0
    # Get set of unique labels
    ulabels = numpy.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[numpy.where(labels == j)] = i
    return labels


# Filter out the out of range (defined to be 100-1000000000000) pixels to get rid of noise.
label_array = numpy.array(label_array)
for i in range(len(label_array[:])):
    label_array[i] = filter_by_size(label_array[i],100,100000000000)

# Filter again setting range to be within 1 standard deviation from the mean 
for i in range(len(label_array[:])):
    sizes = numpy.bincount(label_array[i].ravel())
    #print(sizes[1:])
    mean = numpy.average(sizes[1:])
    #print(mean)
    sd = numpy.std(sizes[1:])
    print(sd) # Check the calculated sd to see if it makes sense or not in general
    label_array[i] = filter_by_size(label_array[i],mean-sd,mean+sd)

# Exercise 3
#Print the header
print("Gene", "nascentRNA", "PCNA", "log2ratio", sep = "\t")

# Find total number of nuclei
for i in range(8):
    #print(len(images[:]))
    #print(i)
    analyzed_image = images[i]
    DAPI_image = analyzed_image[:,:,0]
    nascent_image = analyzed_image[:,:,1]
    PCNA_image = analyzed_image[:,:,2]
    num_nuclei = numpy.amax(label_array)
    num_nuclei = num_nuclei + 1
    for j in range(1, num_nuclei):
        where = numpy.where(label_array[i] == j)
        nascent_signal = numpy.mean(nascent_image[where])
        PCNA_signal = numpy.mean(PCNA_image[where])
        log2ratio = numpy.log2(nascent_signal / PCNA_signal)
        if i in [0, 1]: 
            Gene = "APEX1"
        if i in [2, 3]:
            Gene = "PIM2"
        if i in [4,5]:
            Gene = "POLR2B"
        if i in [6,7]: 
            Gene = "SRSF1"
        print(Gene, nascent_signal, PCNA_signal, log2ratio, sep = "\t")

#./week10.py > plot_data.txt
