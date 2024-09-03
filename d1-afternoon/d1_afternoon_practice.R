
# Q1

library(tidyverse)
read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
df <- read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

# Q2

View(df)
glimpse(df)

# Q3

df_SMGEBTCHT <- df %>% 
  filter(SMGEBTCHT == "TruSeq.v1")
View(df_SMGEBTCHT)

# Q4

ggplot(data = df_SMGEBTCHT, mapping = aes(SMTSD)) + geom_bar() + 
theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

# Q5

ggplot(data = df_SMGEBTCHT, aes(x = SMRIN)) + geom_density()

# The shape of the distributino is unimodal as it has a major peak in the center part of x axis. 

# Q6 

ggplot(data = df_SMGEBTCHT, aes(x = SMRIN, y = SMTSD)) + geom_boxplot()

# There are variation of RNA degradation level between tissue types. There are certain outliers such as kidney-medulla with very low SMRIN,
# there are also tissues with very high SMRIN value such as CML, cultured fibroblasts and EBV-transformed lymphocytes.
# Overall, I think cell types that need more frequent regeneration and replenishment have higher level of DNA/RNA expression, to ensure 
# better RNA quality and readout, with less degradation. 

# Q7 

# With boxplot clearly showing the different expression RNA degradation levels, it is the better plot to contrast the difference between the tissues.
# The box lot also shows the continuous distribution of data for each single tissue while main the integrity of comparison between each tissue set. 
# This plot agrees with the conclusion drew from Q6, with outliers mentioned above. Tissues with higher frequency of replication need higher DNA/RNA expression, 
# so that it has higher novel DNA/RNA level, which ensures the RNA quality and very low RNA degradation level overall. 

# Q8

ggplot(data = df_SMGEBTCHT, mapping = aes(x = SMTSISCH, y = SMRIN)) + 
  geom_point(size = 0.5, alpha = 0.5) + 
  geom_smooth(method = "lm") +
  facet_wrap("SMTSD") 

# The longer the ischemic time, the higher the RNA degradation level across tissues, with various extent though.
# There are certain tissue types that are more prone to longer ischemic time with steeper downward slopes, such as cervix tissues, colon tissue cell types, and fallopian tube cells. 

# Q9
ggplot(data = df_SMGEBTCHT, mapping = aes(x = SMTSISCH, y = SMRIN)) + 
  geom_point( size = 0.5, alpha = 0.5, aes(color = SMATSSCR)) + 
  geom_smooth(method = "lm") +
  facet_wrap("SMTSD") 
# There is a negative correlation between ischemic time and SMRIN overall across the tissues. Though certain tissues have much higher correlation than others such as bladder, fallopian tube cells and cervix tissue cells. 



