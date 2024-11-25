# PyTorch – How much data is needed?
### 1a. What is the accuracy using 60,000 images? 30,000? 6,000? 3,000? 600?
For 60,000 images it is 98%, 30,000 is 97%. 6,000 is 92%, 3000 is 85%, 600 is 22%. 

### 1b. How do the weights looks different when trained with 60,000 vs 600?
Weights when trained with 600 is very chaotic / random without much ovbious or representative feature with any processing as shown in the grid images. However, with training of 60,000 images, the weights look like with a trend in each image as it is comparably easy to tell what feature it is representing, the images are also much better organized with the "pixels". This makes sense as more images are processed for training, the computer knows better with more defined feature and weights to distinguish the digit it is processing, so the accuracy goes up a lot. 

# 2. BioImage – How well does segmentation work?
### 2a. Explain the parameters provided to watershed(). What happens when you remove mask? What happens when you remove markers?
After removing the mask, there is no more boundary lines in between each colored area. After removing markers, there is no defiend grouping for each area, the color is just a gradient from top to bottom without specific clustering. 

### 2b. Compare how well segmentation works for cyto, endo, mito, and nucl. What types of samples work well? Not as well?

The segmentation works well for cyto as it distinguishes the cluster and areas with clear boundary and well defined shapes. It does not work as well for endo. It works very well for mito. It works also well for nucl. Overall, the samples with well-defined and normal shape are best segmentated, in contrast, such as the endo sample, they don't have a very consistent and defined shape, so the segmentation does not really work for it. 

