library(tidyverse) # Load the library tools

AF <- read_tsv("~/qbb2024-answers/week3/AF.txt") # Load the data into file script
DP <- read_tsv("~/qbb2024-answers/week3/DP.txt") # Load the data into this script

# For AF Plot
ggplot(AF, aes(x = Allele_Frequency)) +
  geom_histogram(bins = 11) +
  labs(x = "Allele Frequency",
       y = "Variations Amount",
       title = "Allele Frequency")
ggsave("~/qbb2024-answers/week3/Allele_Frequency_Plot.png")

### Q3.1 ###
# This is expected with a normal distribution. As for allele frequency, it is very often true that most important info are stored in the center to prevent the shorting and less frequent transcription by nature of those replication mechanism, this provides a safe environment to allow sequences to be maintained in the population

# For DP Plot
ggplot(DP, aes(x = Read_Depth)) +
  geom_histogram(bins = 21) +
  xlim(0,20)+
  labs(x = "Read Depth",
       y = "Variants Amount",
       title = "Read Depth")
ggsave("~/qbb2024-answers/week3/Read_Depth_Plot.png")

# As for reading depth, this is a poisson distribution. Since from the previous analysis, the average coverage here is 4, which means it is possible that there is more frequent reading in certain region than other, it is also by nature that the less frequent reading to happen with longer length.


  
  



