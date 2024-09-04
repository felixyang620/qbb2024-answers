
# Q1: Browse data dictionary

#Downloaded the necessary data files

# Q2: Prepare your working environment

library("tidyverse")

read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")


# Q3: Wrangle the sample metadata

df <- df %>%
  mutate( SUBJECT=str_extract( SAMPID, "[^-]+-[^-]+" ), .before=1 )


# Q4: Which two SUBJECTs have the most samples? The least?

df %>%
  group_by(SUBJECT) %>%
  summarise(count=n()) %>%
  arrange(desc(count))
# K-562 and GTEX-NPJ8 have the most samples, with 217 and 72 samples respectively. 

df %>%
  group_by(SUBJECT) %>%
  summarise(count=n()) %>%
  arrange((count))
# GTEX-1JMI6 and GTEX-1PAR6 have the least samples with 1 each.


# Q5: Which two SMTSDs (tissue types) have the most samples? The least? Why?

df %>%
  group_by(SMTSD) %>%
  summarise(count=n()) %>%
  arrange(desc(count))
# Whole Blood and Muscle-Skeletal have the most samples.

df %>%
  group_by(SMTSD) %>%
  summarise(count=n()) %>%
  arrange((count))
# Kidney - Medulla and Cervix - Ectocervix have the least samples, with 4 and 9 respectively. 


# Q6: For subject GTEX-NPJ8, Which tissue has the most samples? For that tissue, what is different between the samples?
df_npj8 <- df %>%
  filter(SUBJECT== "GTEX-NPJ8") %>%
    group_by(SMTSD) %>%
    summarise(count=n()) %>%
    arrange(desc(count))
View(df_npj8)
#Whole Blood has the most tissue samples.

df_SMTSD <- df %>%
  filter(SUBJECT == "GTEX-NPJ8")%>%
  filter(SMTSD=="Whole Blood")
View(df_SMTSD)
# Their collection dates and analysing methods are different. 
# Their sequencing methods are different, with either DNA isolation by QIAGEN Puregene, or 	
# RNA isolation_PAXgene Blood RNA method.


# Q7 Part 1: Explore SMATSSCR (autolysis score), How many SUBJECTs have a mean SMATSSCR score of 0? 

df_SMATSSCR <- df %>%
  group_by(SUBJECT) %>%
  filter( !is.na(SMATSSCR)) %>%
  summarize(mean(SMATSSCR)) %>%
  filter(`mean(SMATSSCR)`==0) 
# 15 subjects have a mean SMATSSCR score of 0. 

# Q7 Part 2: # What other observations can you make about the distribution of mean scores? 
# What are possible ways to present this information in a report?
df_SMATSSCR <- df %>%
  group_by(SUBJECT) %>%
  filter( !is.na(SMATSSCR)) %>%
  summarize(mean(SMATSSCR))
View(df_SMATSSCR)
# The mean values are all around 1, min is 0, max is less than 2. 
# We can plot the data with a diagram to show the distribution of data points.
# I think boxplot that shows the distribution of mean score for each subject is a good way to compare. 

  