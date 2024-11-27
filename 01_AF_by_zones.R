# Identify mostly differentiated alleles between low and high estuary based on Allelic Frequency
# THen check their frequency in each mid estuary populations
# Part I : Create dataset

### libraries
library(data.table)
library(tidyverse)
library(RColorBrewer)

### Set working directory
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/04_Allelic_Frequency/")

### Load matrix of allele frequency by estuary zone and individual mid estuary pop
# High
high_estuary <- fread("Marine_Estuary.frq")
colnames(high_estuary) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
high_estuary <- high_estuary %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq = ifelse(freq1 > freq2, "freq1", "freq2"))

## Identify the most frequent allele and keep only this one for each population to be sure to compare the same allele
most_freq <- high_estuary$most_freq
high_estuary <- high_estuary %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(high_estuary) <- c("snp", "count_High" ,"freq_High")

# Low
low_estuary <- fread("Fluvial_Estuary.frq")
colnames(low_estuary) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
low_estuary <- low_estuary %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(low_estuary) <- c("snp", "count_Low" ,"freq_Low")

### Load AF for each mid estuary pop
CR <- fread("CR.frq")
colnames(CR) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
CR <- CR %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(CR) <- c("snp", "count_CR" ,"freq_CR")

BSP <- fread("BSP.frq")
colnames(BSP) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
BSP <- BSP %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(BSP) <- c("snp", "count_BSP" ,"freq_BSP")

POC <- fread("POC.frq")
colnames(POC) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
POC <- POC %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(POC) <- c("snp", "count_POC" ,"freq_POC")

KAM <- fread("KAM.frq")
colnames(KAM) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
KAM <- KAM %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(KAM) <- c("snp", "count_KAM" ,"freq_KAM")

RIM <- fread("RIM.frq")
colnames(RIM) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
RIM <- RIM %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(RIM) <- c("snp", "count_RIM" ,"freq_RIM")


# Bind all datasets
snps <- high_estuary$snp 
all_estuary <- cbind(snps, low_estuary,CR,BSP,KAM,POC,RIM,high_estuary)
all_estuary <- all_estuary %>% 
  select(snps,count_Low, count_CR, count_BSP, count_POC, count_KAM, count_RIM, count_High,freq_Low, freq_CR, freq_BSP, freq_POC, freq_KAM, freq_RIM, freq_High)
all_estuary$freq_BSP <- as.numeric(all_estuary$freq_BSP)
all_estuary$freq_POC <- as.numeric(all_estuary$freq_POC)
all_estuary$freq_KAM <- as.numeric(all_estuary$freq_KAM)
all_estuary$freq_CR <- as.numeric(all_estuary$freq_CR)
all_estuary$freq_RIM <- as.numeric(all_estuary$freq_RIM)
all_estuary$freq_Low <- as.numeric(all_estuary$freq_Low)
all_estuary$freq_High <- as.numeric(all_estuary$freq_High)

write.table(all_estuary, "Estuary_frq.txt", col.names = TRUE, quote = FALSE)


### Determinate low and high salinity alleles
all_estuary <- all_estuary %>% 
  mutate(AFD = 1/2* abs(high - low))
mean(abs(all_estuary$AFD)) + 3*sd(all_estuary$AFD) # = 0.31 (baseline to determine outliers alleles)
# Subsample them
all_estuary <- all_estuary %>% mutate(dif = ifelse(abs(AFD) > 0.31, "differenciated", "neutral"))
all_estuary <- all_estuary %>% mutate(Allele_type = ifelse(high > low, "high", "low"))
all_estuary %>% group_by(dif) %>% tally()

# Create a list of low and high differenciated alleles.
low_alleles <- all_estuary %>% filter(Allele_type == "low") %>% filter(dif == "differenciated")
high_alleles <- all_estuary %>% filter(Allele_type == "high") %>% filter(dif == "differenciated")

### Do an heatmap with all outliers alleles 

freq_mat_low <- as.matrix(low_alleles[,2:6])
row.names(freq_mat_low) <- low_alleles$snps
freq_mat_high <- as.matrix(high_alleles[,2:6])
row.names(freq_mat_high) <- high_alleles$snps

h <- heatmap(freq_mat_low, xlab = "Populations", ylab = "SNPs", margins = c(5,2), labRow = FALSE, keep.dendro = TRUE, Colv = NA)
h2 <- heatmap(freq_mat_high, xlab = "Populations", ylab = "SNPs", margins = c(5,2), labRow = FALSE, keep.dendro = TRUE, Colv = NA)

### Calculate AFD between pairs of groups for outliers
## CR
CR_AFD <- all_estuary %>% 
  mutate(AFD_high = (CR - high)) %>% 
  mutate(AFD_low = (CR - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
CR_AFD %>% group_by(type) %>% tally()
CR_AFD <- high_alleles %>% 
  mutate(AFD_high = (CR - high)) %>% 
  mutate(AFD_low = (CR - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
CR_AFD %>% group_by(type) %>% tally()
CR_AFD <- low_alleles %>% 
  mutate(AFD_high = (CR - high)) %>% 
  mutate(AFD_low = (CR - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
CR_AFD %>% group_by(type) %>% tally()
## There is 0 outliers less differenciated with high than low estuary and 10329 that have the opposite pattern
## When considering all SNPs, there is 604676 SNPs closer to high estuary and 1728076 closer to low estuary

## BSP
BSP_AFD <- high_alleles %>% 
  mutate(AFD_high = (BSP - high)) %>% 
  mutate(AFD_low = (BSP - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
BSP_AFD %>% group_by(type) %>% tally()
BSP_AFD <- low_alleles %>% 
  mutate(AFD_high = (BSP - high)) %>% 
  mutate(AFD_low = (BSP - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
BSP_AFD %>% group_by(type) %>% tally()
## There is 8618 outliers less differenciated with high than low estuary and 1711 that have the opposite pattern
## When considering all SNPs, there is 1368930 SNPs closer to high estuary and 963822 closer to low estuary
freshwater_snps_BSP_p1 <- BSP_AFD %>% 
  filter(type == "low")
freshwater_snps_BSP_p2 <- BSP_AFD %>% 
  filter(type == "low")
freshwater_snps_BSP <- rbind(freshwater_snps_BSP_p1, freshwater_snps_BSP_p2)

## POC
POC_AFD <- low_alleles %>% 
  mutate(AFD_high = (POC - high)) %>% 
  mutate(AFD_low = (POC - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
POC_AFD %>% group_by(type) %>% tally()
POC_AFD <- high_alleles %>% 
  mutate(AFD_high = (POC - high)) %>% 
  mutate(AFD_low = (POC - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
POC_AFD %>% group_by(type) %>% tally()

## There is 9008 outliers less differenciated with high than low and 1321 that have the opposite
## When considering all SNPs, there is 1435645 SNPs closer to high estuary and 897107 closer to low estuary

## KAM
KAM_AFD <- high_alleles %>% 
  mutate(AFD_high = (KAM - high)) %>% 
  mutate(AFD_low = (KAM - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
KAM_AFD %>% group_by(type) %>% tally()
KAM_AFD <- low_alleles %>% 
  mutate(AFD_high = (KAM - high)) %>% 
  mutate(AFD_low = (KAM - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
KAM_AFD %>% group_by(type) %>% tally()
## There is 9208 outliers less differenciated with high than low and 1121 that have the opposite
## When considering all SNPs, there is 1487628 SNPs closer to high estuary and 845124 closer to low estuary

## KAM
RIM_AFD <- all_estuary %>% 
  mutate(AFD_high = (RIM - high)) %>% 
  mutate(AFD_low = (RIM - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
RIM_AFD %>% group_by(type) %>% tally()

RIM_AFD <- high_alleles %>% 
  mutate(AFD_high = (RIM - high)) %>% 
  mutate(AFD_low = (RIM - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
RIM_AFD %>% group_by(type) %>% tally()
RIM_AFD <- low_alleles %>% 
  mutate(AFD_high = (RIM - high)) %>% 
  mutate(AFD_low = (RIM - low)) %>% 
  select(snps, AFD_low, AFD_high) %>% 
  mutate(type = ifelse(abs(AFD_low) > abs(AFD_high), "high", "low"))
RIM_AFD %>% group_by(type) %>% tally()
## There is 9353 outliers less differenciated with high than low and 976 that have the opposite
## When considering all SNPs, there is 1636706 SNPs closer to high estuary and 696046 closer to low estuary

## Representation of AF across the population with low alleles
# create a dataframe with distance to Cap-Rouge 
all_pop <- fread("all_pop_frq.txt")
#low_alleles_pop <- all_pop %>% 
#  semi_join(low_alleles, by = "snps") 
#snps <- low_alleles$snps
low_alleles_pop <- all_pop %>% 
  semi_join(freshwater_snps_BSP, by = "snps") 
snps <- freshwater_snps_BSP$snps
low_alleles_pop <- low_alleles_pop[,-c(1,2)]
low_alleles_pop <- t(low_alleles_pop)
colnames(low_alleles_pop) <- snps


h_Bsp <- as.matrix(low_alleles_pop)
ordered_h_BSP <- h_Bsp[,c("CR", "LEV", "PNF", "BSP", "POC", "KAM", "FOR", "IV", "RIM", "BERG", "CHAT", "BET")]
rownames(ordered_h_BSP) <- snps
h <- heatmap(ordered_h_BSP, xlab = "Populations", ylab = "SNPs", margins = c(5,2), labRow = FALSE, keep.dendro = TRUE, Colv = NA)


# Affect type to snps

low_alleles_pop_df <- as.data.frame(low_alleles_pop)
low_alleles_pop_df$pop <- c("BERG", "BET", "BSP", "CHAT", "CR", "FOR", "IV", "KAM", "LEV", "PNF", "POC", "RIM")

pop_order <- c("CR", "LEV", "PNF", "BSP", "POC", "KAM", "FOR", "IV", "RIM", "BERG", "CHAT", "BET")
dist_to_CR <- c(0.000, 6473.675, 41453.54, 99684.13, 120682.42, 160953.01, 271335.67, 215797.51, 270244.60, 215009.82, 441891.1, 318282.61)

low_alleles_pop_df <- low_alleles_pop_df %>% 
  arrange(factor(pop, levels = pop_order))

low_alleles_pop_df$dist <- dist_to_CR

# Transform in long format and do the plot
low_alleles_long <- reshape2::melt(low_alleles_pop_df, id.vars = "dist")
colnames(low_alleles_long)<- c("dist", "snps", "AFD")
low_alleles_long <- low_alleles_long[,c(-4,-5)]

ggplot(low_alleles_long, aes(x = dist, y = as.numeric(AFD), group = snps)) +
  geom_line(linewidth = 1, alpha = 0.4) +
  labs(x = "Distance to Cap-Rouge", y = "Allelic Frequency") +
  theme_bw() +
  geom_vline(aes(xintercept = 95000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed") +
  geom_vline(aes(xintercept = 200000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed")


## Representation of AF across the population with high alleles
# create a dataframe with distance to Cap-Rouge 
high_alleles_pop <- all_pop %>% 
  semi_join(high_alleles, by = "snps") 
snps <- high_alleles$snps
high_alleles_pop <- high_alleles_pop[,-c(1,2)]
high_alleles_pop <- t(high_alleles_pop)
colnames(high_alleles_pop) <- snps

# Affect type to snps

high_alleles_pop_df <- as.data.frame(high_alleles_pop)
high_alleles_pop_df$pop <- c("BERG", "BET", "BSP", "CHAT", "CR", "FOR", "IV", "KAM", "LEV", "PNF", "POC", "RIM")

pop_order <- c("CR", "LEV", "PNF", "BSP", "POC", "KAM", "FOR", "IV", "RIM", "BERG", "CHAT", "BET")
dist_to_CR <- c(0.000, 6473.675, 41453.54, 99684.13, 120682.42, 160953.01, 271335.67, 215797.51, 270244.60, 215009.82, 441891.1, 318282.61)

high_alleles_pop_df <- high_alleles_pop_df %>% 
  arrange(factor(pop, levels = pop_order))

high_alleles_pop_df$dist <- dist_to_CR

# Transform in long format and do the plot
high_alleles_long <- reshape2::melt(high_alleles_pop_df, id.vars = "dist")
colnames(high_alleles_long)<- c("dist", "snps", "AFD")
high_alleles_long <- high_alleles_long[,c(-4,-5)]

ggplot(high_alleles_long, aes(x = dist, y = as.numeric(AFD), group = snps)) +
  geom_line(linewidth = 1, alpha = 0.4) +
  labs(x = "Distance to Cap-Rouge", y = "Allelic Frequency") +
  theme_bw() +
  geom_vline(aes(xintercept = 95000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed") +
  geom_vline(aes(xintercept = 200000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed")



