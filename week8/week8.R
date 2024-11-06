
BiocManager::install("zellkonverter")
library("zellkonverter")
library("scuttle")
library("scater")
library("scran")
library("ggplot2")
setwd("~/qbb2024-answers/week8/")

### Step 1
gut <- readH5AD("v2_fca_biohub_gut_10x_raw.h5ad")
assayNames(gut) <- "counts"
gut <- logNormCounts(gut)
gut
### Question 1: There are 13407 genes being quantitated. There are 11788 cells in the dataset. There are PCA, TSNE and UMAP dataset present for dimension reduction. 

colData(gut)
colnames(colData(gut))
set.seed(42) 
plotReducedDim(gut, "X_umap", color="broad_annotation")
### Question 2: There are 39 columns in the colData(gut). Broad_annotation gives the specific cell type such as epithelial cell or gut cell, while tissue and sex columns are also interesting as they provide potential PC factors that contribute to the clustering. 

### Step 2
genecounts <- rowSums(assay(gut))

summary(genecounts)
sort(genecounts, TRUE)[1:3] # To show the top three genes being expressed. 
### Question 3:Mean is 3185, median is 254. This means that the major part of the genes are not highly expressed but only a few genes. 
### The three top genes with the highest expressions are sromega, CR45845 and roX1. They are all RNAs though they are different types of RNAs. 

cellcounts <- colSums(assay(gut))
hist(cellcounts)
summary(cellcounts)
### Question 4a: The mean number of counts per cell is 3622. The cells with much higher total counts means they are not specially enriched in any genes but expressing a generally high number of genes, they are likely the common cell types. 

celldetected <- colSums(assay(gut)>0)
hist(celldetected)
summary(celldetected)
1059/13407 * 100 # divide gene detected by the previously identified total genes being quantitated to get percentage
### Quesiton 4b: The mean number of genes detected per cell is 1059. 7.89% of total number of genes this represents. 

mito <- grep("^mt:",rownames(gut),value=TRUE)
df <- perCellQCMetrics(gut,subsets=list(Mito=mito))
df <- as.data.frame((df))
summary(df)
colData(gut) <- cbind( colData(gut), df )
plotColData(object = gut, y = "subsets_Mito_percent", x = "broad_annotation") + theme( axis.text.x=element_text( angle=90 )) + labs(x= "Cell Type", y= "Percentage of mitochondrial gene expression", title= "Expression of mitochondrial genes across cells")
### Question 5: Enteroendocrine cells, gland, and maybe muscle cells are in need of energy the most, as they are either producing a lot of molecules such as signaling molecules or hormones to be released to the body system or use energy to do work such as muscle movement. 

### Step 3
coi <- colData(gut)$broad_annotation == "epithelial cell"
epi <- gut[,coi]
plotReducedDim(epi, "X_umap", color="broad_annotation") + labs(title = "Umap of epithelial cells")
marker.info <- scoreMarkers( epi, colData(epi)$annotation )
chosen <- marker.info[["enterocyte of anterior adult midgut epithelium"]]
ordered <- chosen[order(chosen$mean.AUC, decreasing=TRUE),]
head(ordered[1:6])
### Question 6: The six top marker genes in the anterior midgut are Mal-A6, Men-b, vnd, betaTry, Mal-A1 and Nhe2. Since this is the anterior midgut, it is likely to majorly digest carbohydrates as its first digestino process overall. 

plotExpression(epi,c("Mal-A6","Men-b","vnd","betaTry","Mal-A1","Nhe2"),x="annotation") + labs(x="Annotation", y = "Expression", title="Expression of the top marker genes") + theme( axis.text.x=element_text( angle=90 ) )

cellofinterest = colData(gut)$broad_annotation == "somatic precursor cell"
epi2 = gut[,cellofinterest]
epi2.marker.info = scoreMarkers( epi2, colData(epi2)$annotation )
chosen_epi2 = epi2.marker.info[["intestinal stem cell"]]
ordered_epi2 <- chosen_epi2[order(chosen_epi2$mean.AUC, decreasing=TRUE),]
goi = rownames(ordered_epi2)[1:6]
plotExpression(epi2,goi,x="annotation")  + labs(x= "Annotation",y="Expression",title = "Expression of the top marker genes") + theme( axis.text.x=element_text( angle=90 ) )
### Question 7: The enteroblast and the intestinal stem cell have more similar expression based on these markers. The DI marker looks to be unique for intestinal stem cells as its pattern of expression is the most different among all markers for gene expression. 



