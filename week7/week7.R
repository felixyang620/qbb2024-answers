
### Exercise 1: Perform principal component analysis ###

### Step 1.1 Loading data and importing libraries ###
library(tidyverse)
library(broom) #take output of statistical models to format into tables
library(DESeq2) #Statistical test package.

setwd("~/qbb2024-answers/week7") # Set the working directory 

counts_df <- read_delim("gtex_whole_blood_counts_downsample.txt") # load the gene expression counts

counts_df2 <- column_to_rownames(counts_df, var = "GENE_NAME") # move the gene_id column to rownames

metadata_df <- read_delim("gtex_metadata_downsample.txt") # load the metadata

metadata_df2 <- column_to_rownames(metadata_df, var = "SUBJECT_ID") # move the sample IDs from the first column to rownames

counts_df2[1:5,] # look at first five rows
metadata_df2[1:5,] # Visualize the metadata set 

### Step 1.2 Create a DESeq2 object ###

colnames(counts_df2) == rownames(metadata_df2) # Check to see if the column and rows have the same components in order
table(colnames(counts_df2) == rownames(metadata_df2)) # To compare and check if the two tibbles match, and the feedback was all true.

dds <- DESeqDataSetFromMatrix(countData = counts_df2,
                              colData = metadata_df2,
                              design = ~ SEX + AGE + DTHHRDY) # To include AGE, SEX, and way of death as shown in colDATA to be included as variables. 

vsd <- vst(dds) # apply VST normalization before differential expression analysis to check 

# apply and plot principal components PCA plot
plotPCA(vsd, intgroup = "SEX")
plotPCA(vsd, intgroup = "AGE")
plotPCA(vsd, intgroup = "DTHHRDY")
plotPCA(vsd, intgroup = c("SEX", "AGE","DTHHRDY"))

# There is a 48% variance in PC1, and 7% variance in PC2. The major variance/PC1 seems to be related to the way of death, the minor variance/PC2 seems to be related to the sex. 

# Exercise 2:Perform differential expression analysis
# Step 2.1: Perform a “homemade” test for differential expression between the sexes

# extract the vst expression matrix and bind it to metadata
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()

vsd_df <- bind_cols(metadata_df2, vsd_df)

# Step 2.1.1 
# examine the distribution of expression for a given gene
hist(vsd_df$WASH7P)

# apply multiple linear regression to a given gene
lm(data = vsd_df, formula = WASH7P ~ AGE + SEX + DTHHRDY) %>%
  summary() %>%
  tidy()
# 2.1.1: The WASH7p gene is not showing significant evidence of sex-differential expression. As shown in the analysis here that for SEX the p value is 2.79e -1, which is higher than 0.05, so it is not significant for in sex variable's perspective. 

# 2.1.2: repeat for SLC25A47 gene. 
# apply multiple linear regression to it.
lm(data = vsd_df, formula = SLC25A47 ~ AGE + SEX + DTHHRDY) %>%
  summary() %>%
  tidy()
# SLC25A47 does show significant evidence of sex-differential expression. As shown in the analysis, the P value for sex linkage is 2.57e-2, which is less than 0.05. 

# Step 2.2
dds <- DESeq(dds) # use DESeq2 to perform differential expression analysis across all genes

# Step 2.3 Extract and interpret the results for sex differential expression
sex_res <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_NAME")

sex_res <- sex_res %>%
  filter(!is.na(padj)) %>%
  arrange(padj)

sex_res # Have a brief view of the tibble just created. 

# Check the sum of rows that has the padj=Q value to be less than 0.1, which is 10% false positive range.
sex_res %>%
  filter(padj<0.1) %>%
  nrow()

# Q 2.3.2: With the analysis, it is showing that there are 262 genes exhibiting significant differential expression between males and females at a 10% FDR.

# Step 2.3.3 
gene_location <- read_delim("gene_locations.txt") # load the gene location file
result <- left_join(gene_location, sex_res, by = "GENE_NAME") %>%
  arrange(padj)

result # Visualize the mapping results. 
# The results of mapping between gene location list to the exrepssion differential analysis results, it is showing that the sex chromosomes ChrY and ChrX are the major chromosomes that encode genes that are strongly upregulated in males vs females, respectively.
# There are more male-upregulated genes near the top of the list. The p values of the top genes in the list are the smalledst, which means that those genes have the most distinct level of expression between males and females. This result is showing that in the sex variable, the male sex-related gens are more upregulated than females. 

# Step 2.3.4: By locating the information corresponding to WASH7P and SLC25A47 in this list, they are broadly consistent with their previous results. WASH7P has p values that are higher than 0.05, which is approximately consistent as before that indicates its irrelevnace to sex linked significance. Howver SLC25A47 is showing consistent less than 0.05 p valu that supports its significant role in sex-linked variance. 

### Step 2.4 ###
# Step 2.4.1
dds <- DESeq(dds) # use DESeq2 to perform differential expression analysis across all genes

# Step 2.3 Extract and interpret the results for sex differential expression
death_res <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes") %>%
  as_tibble(rownames = "GENE_NAME")

death_res <- death_res %>%
  filter(!is.na(padj)) %>%
  arrange(padj)

death_res # Have a brief view of the tibble just created. 

# Check the sum of rows that has the padj=Q value to be less than 0.1, which is 10% false positive range.
death_res %>%
  filter(padj<0.1) %>%
  nrow()
# According to the analysis, there are 16069 genes that are differentially expressed according to death classification at a 10% FDR.

# 2.4.2: From the previous PCA analysis, which I concluded that the PC1 element of significance is the way of death, it is consistent with the current analysis! As shown here there are much more genes that are upregulated or different given the way of death background, comparing to merely 262 genes significantly related to the SEX variable, which can be potentialy on PC2 element on PCA analysis.Overall, this is perfeclty consistent with my previous PCA analysis conclusion. 


### Step 3: Visualization ###

ggplot(data = sex_res, aes(x = log2FoldChange, y = -log10(pvalue))) +
  geom_point(aes(color = (abs(log2FoldChange) > 1 & pvalue < 1e-20))) +
  geom_text(data = sex_res %>% filter(abs(log2FoldChange) > 1 & pvalue < 1e-20),
            aes(x = log2FoldChange, y = -log10(pvalue) + 5, label = GENE_NAME), size = 3,) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("darkgray", "coral")) +
  labs(y = expression(-log[10]("p-value")), x = expression(log[2]("fold change")))



