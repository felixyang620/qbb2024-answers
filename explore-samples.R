library("tidyverse")

read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SubjectPhenotypesDS.txt")
df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

df <- df %>%
  mutate( SUBJECT=str_extract( SAMPID, "[^-]+-[^-]+" ), .before=1 )

df %>%
  group_by(SUBJECT) %>%
  summarise(count=n()) %>%
  arrange(desc(count))
# K-562 and GTEX-NPJ8 have the most samples. GTEX-QDT8 has the least samples. 

df %>%
  group_by(SMTSD) %>%
  summarise(count=n()) %>%
  arrange(desc(count))
# Whole Blood and Muscle-Skeletal have the most samples, skin-Not Sun Exposed (Suprapubic) has the least samples.

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

df_SMATSSCR <- df %>%
  group_by(SUBJECT) %>%
  filter( !is.na(SMATSSCR)) %>%
  summarize(mean(SMATSSCR)) %>%
  filter(`mean(SMATSSCR)`==0) 
# 15 subjects have a mean SMATSSCR score of 0. 

df_SMATSSCR <- df %>%
  group_by(SUBJECT) %>%
  filter( !is.na(SMATSSCR)) %>%
  summarize(mean(SMATSSCR))
# the mean values are all around 1, min is 0, max is less than 2. 
# we can plot the data with a diagram to show the distributino of data points.

  