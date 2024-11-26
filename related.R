# Script to filter related individuals based on --relatednes2 output of vcftools

setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/00_Filter_dataset/")
library(tidyverse)
library(data.table)
library(plinkQC)

data <- fread("relatedness_oskur.relatedness2")

ggplot(data, aes(x = RELATEDNESS_PHI)) +
  geom_histogram(binwidth = 0.01) +
  xlim(0, 0.2) +
  ylim(0, 10000)

mean(data$RELATEDNESS_PHI) + 3*sd(data$RELATEDNESS_PHI)

## Remove self-self
data_noself <- data %>% 
  subset(INDV1 != INDV2)

## Find pairs that exceed our relatedness treshold
data_related <- data_noself %>% 
  subset(RELATEDNESS_PHI > 0.1)

## Keep only one individual by group
data_mirror <- data_related %>% 
  group_by(INDV1) %>% 
  summarise(n_distinct(INDV2))

data_related$sorted_pair <- apply(data_related[,c("INDV1", "INDV2")], 1, function(x) paste(sort(x), collapse = "-"))

data_unique <- data_related[!duplicated(data_related$sorted_pair), ]

data_min <- data_related %>% 
  group_by(INDV1) %>% 
  summarize(INDV2 = INDV2[which.min(RELATEDNESS_PHI)], RELATEDNESS_PHI = RELATEDNESS_PHI[which.min(RELATEDNESS_PHI)]) 


## Used function pre determined
filter_related <- relatednessFilter(relatedness = data_noself, relatednessTh = 0.1, relatednessIID1 = "INDV1", relatednessIID2 = "INDV2", relatednessRelatedness = "RELATEDNESS_PHI")
related_ind <- filter_related$failIDs$IID

write.table(related_ind,"Related_tofilter.txt", row.names = FALSE, quote = FALSE)
