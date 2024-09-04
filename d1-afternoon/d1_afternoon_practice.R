
# Q1 Load package

library(tidyverse)
read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
df <- read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

# Q2 Use the glimpse() function to examine the data types and first entries of all of the columns.

View(df)
glimpse(df)

# Q3 subset the dataset to only the RNA-seq data by selecting rows for which the SMGEBTCHT column contains the value "TruSeq.v1"

df_SMGEBTCHT <- df %>% 
  filter(SMGEBTCHT == "TruSeq.v1")
View(df_SMGEBTCHT)

# Q4 Plot the number of samples from each tissue (SMTSD) as a barplot. 

ggplot(data = df_SMGEBTCHT, mapping = aes(SMTSD)) + geom_bar() + 
theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) + labs(x="Tissue type", y = "Number of samples")

# Q5 What type of plot is best for visualizing a single continuous distribution? 

ggplot(data = df_SMGEBTCHT, aes(x = SMRIN)) + geom_density() + labs(x="RNA Integrity Number", y = "Distribution")

# The shape of the distributino is unimodal as it has a major peak in the center part of x axis. 

# Q6 Copy your code from above, but now plot the distribution of RIN, stratified by tissue.

ggplot(data = df_SMGEBTCHT, aes(x = SMRIN, y = SMTSD)) + geom_boxplot() + labs(x="RNA Integrity Number", y = "Tissue Type")

# Answers: There are variation of RNA degradation level between tissue types. There are certain outliers such as kidney-medulla with very low SMRIN,
# there are also tissues with very high SMRIN value such as CML, cultured fibroblasts and EBV-transformed lymphocytes.
# Overall, I think cell types that need more frequent regeneration and replenishment have higher level of DNA/RNA expression, to ensure 
# better RNA quality and readout, with less degradation. 

# Q7 Visualize the number of genes detected per sample, stratifying by tissue. Again consider what type of plot is best for contrasting continuous distributions across multiple groups.
ggplot(data = df_SMGEBTCHT, aes(x = SMTSD, y = SMGNSDTC)) + geom_boxplot() + labs(x="Tissue Type", y = "Number of genes detected") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Answers: With boxplot clearly showing the different expression RNA degradation levels, it is the better plot to contrast the difference between the tissues.
# The box lot also shows the continuous distribution of data for each single tissue while main the integrity of comparison between each tissue set. 
# This plot agrees with the conclusion drew from Q6, with outliers mentioned above. Tissues with higher frequency of replication need higher DNA/RNA expression, 
# so that it has higher novel DNA/RNA level, which ensures the RNA quality and very low RNA degradation level overall. 

# Q8 Plot the relationship between ischemic time and RIN.What relationships do you notice? Does the relationship depend on tissue?

ggplot(data = df_SMGEBTCHT, mapping = aes(x = SMTSISCH, y = SMRIN)) + 
  geom_point(size = 0.5, alpha = 0.5) + 
  geom_smooth(method = "lm") +
  facet_wrap("SMTSD") + labs(x="Ischemic Time", y = "RNA Integrity Number")

# The longer the ischemic time, the higher the RNA degradation level across tissues, with various extent though.
# There are certain tissue types that are more prone to longer ischemic time with steeper downward slopes, such as cervix tissues, colon tissue cell types, and fallopian tube cells. 

# Q9 Copy your answer from question 8 above, but modify it to color your points by autolysis score (SMATSSCR). 
# What relationships do you notice? Does the relationship depend on tissue?

ggplot(data = df_SMGEBTCHT, mapping = aes(x = SMTSISCH, y = SMRIN)) + 
  geom_point( size = 0.5, alpha = 0.5, aes(color = SMATSSCR)) + 
  geom_smooth(method = "lm") +
  facet_wrap("SMTSD") + labs(x="Ischemic Time", y = "RNA Integrity Number")
# There is a negative correlation between ischemic time and SMRIN overall across the tissues. Though certain tissues have much higher correlation than others such as bladder, fallopian tube cells and cervix tissue cells. 



