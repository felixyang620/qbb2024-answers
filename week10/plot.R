library(dplyr)
library(ggplot2)
library(tidyverse)

signal <- read_tsv("~/qbb2024-answers/week10/plot_data.txt")

ggplot(data = signal, mapping = aes(x = Gene, y = nascentRNA)) + 
  geom_violin(fill = "skyblue") +
  labs(title = "Nascent RNA", 
       y = "Nascent RNA signal intensity",
       x = "knock-down genes")

ggplot(data = signal, mapping = aes(x = Gene, y = PCNA)) + 
  geom_violin(fill = "skyblue") +
  labs(title = "PCNA", 
       y = "PCNA  signal intensity",
       x = "knock-down genes")

ggplot(data = signal, mapping = aes(x = Gene, y = log2ratio)) + 
  geom_violin(fill = "skyblue") +
  labs(title = "Transcription to translation ratio", 
       y = "Log2(nascentRNA/PCNA)",
       x = "knock-down genes")