library(tidyverse)
library(ggthemes)

snpenrichments <- read.delim("~/qbb2024-answers/week2/snp_counts.txt") 

snpenrichments <- snpenrichments %>% mutate(logEnrichment = log2(Enrichment)) # Do the log2 transformation for plotting to show the trend

other <- snpenrichments %>% filter(Feature == "other")
cCREs <- snpenrichments %>% filter(Feature == "cCREs")
exons <- snpenrichments %>% filter(Feature == "exons")
introns <- snpenrichments %>% filter(Feature == "introns")


ggplot() +
  geom_line(data=exons,aes(MAF,logEnrichment,color="Exons")) + 
  geom_line(data=introns,aes(MAF,logEnrichment,color="Introns")) + 
  geom_line(data=cCREs,aes(MAF,logEnrichment,color="cCREs")) + 
  geom_line(data=other,aes(MAF,logEnrichment,color="Other")) + 
  scale_color_colorblind() + 
  labs(color="Legend",x="Minor Allele Frequency",y="Log2 of SNP Enrichment",title="SNP Enrichment in Genome") + 
  ggsave(filename = "~/qbb2024-answers/week2/snp_enrichments.pdf") 