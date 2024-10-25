install.packages("ggfortify")
install.packages("hexbin")

library(DESeq2)
library(vsn)
library(matrixStats)
library(readr)
library(dplyr)
library(tibble)
library(hexbin)
library(ggfortify)

# Load the data file here.
data = readr::read_tsv("salmon.merged.gene_counts.tsv")
# Use the column gene_names in this data file as row names to transpose the data set.
data = column_to_rownames(data, var="gene_name")
# Since there is an extra row of "gene_id" which does not have related data, remove gene_id shown in the table
data = data %>% dplyr::select(-gene_id)
# Convert all numbers to integers for DESeq2 to functino properly.
data = data %>% dplyr::mutate_if(is.numeric, as.integer)
# Filter low expression genes out by only showing genes with at least 100 reads.
data = data[rowSums(data)> 100,]
# Pull out broad region samples
narrow = data %>% dplyr::select("A1-3_Rep1":"P2-4_Rep3")
# Create metadata design
metadata = tibble(tissue=c("A1-3","A1-3","A1-3", "CuLFCFe","CuLFCFe","CuLFCFe", "P1-4","P1-4","P1-4","A1","A1","A1","A2-3","A2-3","A2-3","Cu","Cu","Cu","LFCFe","LFCFe","LFCFe","Fe","Fe","Fe","P1","P1","P1","P2-4","P2-4","P2-4"), 
                  rep=c("Rep1","Rep2","Rep3","Rep1","Rep2","Rep3","Rep1","Rep2","Rep3","Rep1","Rep2","Rep3","Rep1","Rep2","Rep3","Rep1","Rep2","Rep3","Rep1","Rep2","Rep3","Rep1","Rep2","Rep3","Rep1","Rep2","Rep3","Rep1","Rep2","Rep3"))
ddsNarrow = DESeqDataSetFromMatrix(countData=narrow, colData=metadata, design=~tissue)

# Look at mean by variance
meanSdPlot(assay(ddsNarrow))

#log transform of data
# logNarrow = normTransform(ddsNarrow)
#Look at log mean by variance 
# meanSdPlot(assay(logNarrow))

#Apply VST
vstNarrow = vst(ddsNarrow)
#Look at vst (variation stabilizing transform) mean by variance 
meanSdPlot(assay(vstNarrow))

# Perform PCA on log
# logPCAdata = plotPCA(logNarrow, intgroup=c('rep','tissue'),returnData=TRUE)
# ggplot(logPCAdata, aes(PC1, PC2, color = tissue, shape = rep)) + geom_point(size = 5)

# Perform PCA on vst
logPCAdata = plotPCA(vstNarrow, intgroup=c('rep','tissue'),returnData=TRUE)
ggplot(logPCAdata, aes(PC1, PC2, color = tissue, shape = rep)) + geom_point(size = 5)

# Filter the genes by variance.
matNarrow = as.matrix(assay(vstNarrow))
combined = matNarrow[,seq(1,9,3)] # Skip every 3, to take only 1st sample and total is 3 samples
combined = combined + matNarrow[,seq(2,9,3)] # Skip every 3, to take only 2nd sample and total is 3 samples
combined = combined + matNarrow[,seq(3,9,3)] # Skip every 3, to take only 3rd sample and total is 3 samples
combined = combined / 3 #get average of replicates within each sample and each fragment.

# K mean clustering 
set.seed(42)
# Perform K Mean and then return into 12 clusters
k = kmeans(matNarrow, centers=12)$cluster
ordering = order(k)
k = k[ordering]
matNarrow = matNarrow[ordering,]
heatmap(matNarrow, Rowv=NA, Colv=NA, RowSideColors=RColorBrewer::brewer.pal(12, "Paired")[k])

# Get the gene names for ontology analysis.
genes = rownames(matNarrow[k == 2,])

write.table(genes,'cluster2.txt',sep="\n", quote=FALSE, row.names=FALSE, col.names=FALSE)
