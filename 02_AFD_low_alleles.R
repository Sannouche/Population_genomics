# Identify mostly differentiated alleles between low and high estuary based on Allelic Frequency
# THen check their frequency in each mid estuary populations
# Part II : Calculate the proportion of allele

### libraries
library(data.table)
library(tidyverse)
library(RColorBrewer)

### Set working directory
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/04_Allelic_Frequency/")

### Load matrix of allele frequency by estuary zone and individual mid estuary pop
all_estuary <- fread("Estuary_frq.txt")[,-1]

### Determinate low and high salinity alleles
all_estuary <- all_estuary %>% 
  mutate(AFD = 1/2* abs(freq_High - freq_Low))

my_threshold <- quantile(all_estuary$AFD, 0.999, na.rm = T)

# Subsample them
all_estuary <- all_estuary %>% mutate(dif = ifelse(abs(AFD) > my_threshold, "differenciated", "neutral"))
all_estuary <- all_estuary %>% mutate(Allele_type = ifelse(freq_High > freq_Low, "high", "low"))
all_estuary %>% group_by(dif) %>% tally()

# Create a list of neutral alleles
neutral_alleles <- all_estuary %>% 
  filter(dif == "neutral") %>% 
  sample_n(200, replace = FALSE)
write.table(neutral_alleles[,c(-17,-18)], "BSP_AFD_neutral_09-19-2024.txt", col.names = TRUE, quote = FALSE)


# Create a list of low and high differenciated alleles.
low_alleles <- all_estuary %>% filter(Allele_type == "low") %>% filter(dif == "differenciated")
colnames(low_alleles) <- c("snps", "count_Low", "count_CR", "count_BSP", "count_POC", "count_KAM", "count_RIM", "count_High", "Low", "CR", "BSP", "POC", "KAM", "RIM", "High", "AFD", "dif", "Allele_type")

high_alleles <- all_estuary %>% filter(Allele_type == "high") %>% filter(dif == "differenciated")
colnames(high_alleles) <- c("snps", "count_Low", "count_CR", "count_BSP", "count_POC", "count_KAM", "count_RIM", "count_High","Low", "CR", "BSP", "POC", "KAM", "RIM", "High", "AFD", "dif", "Allele_type")

### Do an heatmap with all outliers alleles 

freq_mat_low <- as.matrix(low_alleles[,2:8])
row.names(freq_mat_low) <- low_alleles$snps
freq_mat_high <- as.matrix(high_alleles[,2:8])
row.names(freq_mat_high) <- high_alleles$snps

h <- heatmap(freq_mat_low, xlab = "Populations", ylab = "SNPs", margins = c(5,2), labRow = FALSE, keep.dendro = TRUE, Colv = NA)
h2 <- heatmap(freq_mat_high, xlab = "Populations", ylab = "SNPs", margins = c(5,2), labRow = FALSE, keep.dendro = TRUE, Colv = NA)

### Calculate AFD between pairs of groups for outliers
colnames(all_estuary) <- c("snps", "Low", "CR", "BSP", "POC", "KAM", "RIM", "High", "AFD", "dif", "Allele_type")
## CR
CR_AFD <- all_estuary %>% 
  mutate(AFD_high = (CR - High)) %>% 
  mutate(AFD_low = (CR - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
CR_AFD %>% group_by(type) %>% tally()
CR_AFD <- high_alleles %>% 
  mutate(AFD_high = (CR - High)) %>% 
  mutate(AFD_low = (CR - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
CR_AFD %>% group_by(type) %>% tally()
CR_AFD <- low_alleles %>% 
  mutate(AFD_high = (CR - High)) %>% 
  mutate(AFD_low = (CR - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
CR_AFD %>% group_by(type) %>% tally()
## There is 0 outliers less differenciated with high than low estuary and 2333 that have the opposite pattern
## When considering all SNPs, there is 630449 SNPs closer to high estuary and 1702303 closer to low estuary

## BSP
BSP_AFD <- high_alleles %>% 
  mutate(AFD_high = (BSP - High)) %>% 
  mutate(AFD_low = (BSP - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
BSP_AFD %>% group_by(type) %>% tally()

freshwater_alleles_BSP_p1 <- BSP_AFD %>% 
  filter(type == "low") 
marine_alleles_BSP_p1 <- BSP_AFD %>% 
  filter(type == "high") 

BSP_AFD <- low_alleles %>% 
  mutate(AFD_high = (BSP - High)) %>% 
  mutate(AFD_low = (BSP - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
BSP_AFD %>% group_by(type) %>% tally()

freshwater_alleles_BSP_p2 <- BSP_AFD %>% 
  filter(type == "low") 
marine_alleles_BSP_p2 <- BSP_AFD %>% 
  filter(type == "high") 

freshwater_alleles_BSP <- rbind(freshwater_alleles_BSP_p1, freshwater_alleles_BSP_p2)
marine_alleles_BSP <- rbind(marine_alleles_BSP_p1, marine_alleles_BSP_p2)
## There is 2201 outliers less differenciated with high than low estuary and 132 that have the opposite pattern

## POC
POC_AFD <- low_alleles %>% 
  mutate(AFD_high = (POC - High)) %>% 
  mutate(AFD_low = (POC - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
POC_AFD %>% group_by(type) %>% tally()
POC_AFD <- high_alleles %>% 
  mutate(AFD_high = (POC - High)) %>% 
  mutate(AFD_low = (POC - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
POC_AFD %>% group_by(type) %>% tally()

## There is 2272 outliers less differenciated with high than low and 63 that have the opposite

## KAM
KAM_AFD <- high_alleles %>% 
  mutate(AFD_high = (KAM - High)) %>% 
  mutate(AFD_low = (KAM - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
KAM_AFD %>% group_by(type) %>% tally()
KAM_AFD <- low_alleles %>% 
  mutate(AFD_high = (KAM - High)) %>% 
  mutate(AFD_low = (KAM - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
KAM_AFD %>% group_by(type) %>% tally()

## There is 2314 outliers less differenciated with high than low and 19 that have the opposite

## RIM
RIM_AFD <- all_estuary %>% 
  mutate(AFD_high = (RIM - High)) %>% 
  mutate(AFD_low = (RIM - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
RIM_AFD %>% group_by(type) %>% tally()

RIM_AFD <- high_alleles %>% 
  mutate(AFD_high = (RIM - High)) %>% 
  mutate(AFD_low = (RIM - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
RIM_AFD %>% group_by(type) %>% tally()
RIM_AFD <- low_alleles %>% 
  mutate(AFD_high = (RIM - High)) %>% 
  mutate(AFD_low = (RIM - Low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
RIM_AFD %>% group_by(type) %>% tally()

## There is 2333 outliers less differenciated with high than low and 0 that have the opposite
## When considering all SNPs, there is 1653328 SNPs closer to high estuary and 679424 closer to low estuary

## Representation of AF across the population with freshwater alleles in BSP

pop_order <- c("Low","CR", "BSP", "POC", "KAM", "RIM", "High")
# Create a dataset with frehwater alleles and frequency for each pop
freshwater_snps <- all_estuary %>%
  semi_join(freshwater_alleles_BSP, by = "snps")
freshwater_pop_df <- t(freshwater_snps)
freshwater_pop_df <- as.data.frame(freshwater_pop_df)
freshwater_pop_df <- freshwater_pop_df[-c(1,9,10,11),]

colnames(freshwater_pop_df) <- freshwater_snps$snps

freshwater_pop_df$pop <- c("Low","CR", "BSP", "POC", "KAM", "RIM", "High")

freshwater_pop_df <- freshwater_pop_df %>% 
  arrange(factor(pop, levels = pop_order))

# Transform in long format and do the plot
freshwater_long <- reshape2::melt(freshwater_pop_df, id.vars = c("pop"))
colnames(freshwater_long)<- c("pop","snps", "Freq")

ggplot(freshwater_long, aes(x = pop, y = as.numeric(Freq), group = snps)) +
  geom_line(linewidth = 1, alpha = 0.4) +
  labs(x = "Population along the gradient", y = "Allelic Frequency") +
  theme_bw() +
  scale_x_discrete(limits=c("Low","CR", "BSP", "POC", "KAM", "RIM", "High")) +
  geom_vline(aes(xintercept = 95000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed") +
  geom_vline(aes(xintercept = 200000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed")

## Representation of AF across the population with marine alleles in BSP

# Create a dataset with frehwater alleles and frequency for each pop
marine_snps <- all_estuary %>%
  semi_join(marine_alleles_BSP, by = "snps")
marine_pop_df <- t(marine_snps)
marine_pop_df <- as.data.frame(marine_pop_df)
marine_pop_df <- marine_pop_df[-c(1,9,10,11),]

colnames(marine_pop_df) <- marine_snps$snps

marine_pop_df$pop <- c("Low","CR", "BSP", "POC", "KAM", "RIM", "High")

marine_pop_df <- marine_pop_df %>% 
  arrange(factor(pop, levels = pop_order))

# Transform in long format and do the plot
marine_long <- reshape2::melt(marine_pop_df, id.vars = c("pop"))
colnames(marine_long)<- c("pop","snps", "Freq")

ggplot(marine_long, aes(x = pop, y = as.numeric(Freq), group = snps)) +
  geom_line(linewidth = 1, alpha = 0.4) +
  labs(x = "Population along the gradient", y = "Allelic Frequency") +
  theme_bw() +
  scale_x_discrete(limits=c("Low","CR", "BSP", "POC", "KAM", "RIM", "High")) +
  geom_vline(aes(xintercept = 95000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed") +
  geom_vline(aes(xintercept = 200000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed")

# Save list 
write.table(marine_snps[,c(-17,-18)], "marine_BSP_AFD_outliers_09-17-2024.txt", col.names = TRUE, quote = FALSE)
write.table(freshwater_snps[,c(-17,-18)], "freshwater_BSP_AFD_outliers_09-17-2024.txt", col.names = TRUE, quote = FALSE)
