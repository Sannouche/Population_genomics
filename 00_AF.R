# Creation of allele frequency matrix

### libraries
library(data.table)
library(tidyverse)
library(RColorBrewer)

### Set working directory
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/04_Allelic_Frequency/")

### Load matrix of allele frequency by estuary zone and individual mid estuary pop
PNF <- fread("PNF.frq")
colnames(PNF) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
PNF <- PNF %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq = ifelse(freq1 > freq2, "freq1", "freq2"))

most_freq <- PNF$most_freq

PNF <- PNF %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(PNF) <- c("snp", "count_PNF" ,"freq_PNF")

BERG <- fread("BERG.frq")
colnames(BERG) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
BERG <- BERG %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(BERG) <- c("snp", "count_BERG" ,"freq_BERG")

BET <- fread("BET.frq")
colnames(BET) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
BET <- BET %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(BET) <- c("snp", "count_BET" ,"freq_BET")

BSP <- fread("BSP.frq")
colnames(BSP) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
BSP <- BSP %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(BSP) <- c("snp", "count_BSP" ,"freq_BSP")

CHAT <- fread("CHAT.frq")
colnames(CHAT) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
CHAT <- CHAT %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(CHAT) <- c("snp", "count_CHAT" ,"freq_CHAT")

CR <- fread("CR.frq")
colnames(CR) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
CR <- CR %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(CR) <- c("snp", "count_CR" ,"freq_CR")

FOR <- fread("FOR.frq")
colnames(FOR) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
FOR <- FOR %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(FOR) <- c("snp", "count_FOR" ,"freq_FOR")

IV <- fread("IV.frq")
colnames(IV) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
IV <- IV %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(IV) <- c("snp", "count_IV" ,"freq_IV")

KAM <- fread("KAM.frq")
colnames(KAM) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
KAM <- KAM %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(KAM) <- c("snp", "count_KAM" ,"freq_KAM")

LEV <- fread("LEV.frq")
colnames(LEV) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
LEV <- LEV %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(LEV) <- c("snp", "count_LEV" ,"freq_LEV")


POC <- fread("POC.frq")
colnames(POC) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
POC <- POC %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(POC) <- c("snp", "count_POC" ,"freq_POC")

RIM <- fread("RIM.frq")
colnames(RIM) <- c("chr", "pos", "alleles", "count", "freq1", "freq2")
RIM <- RIM %>% 
  mutate(snp = paste0(chr,"_",pos)) %>% 
  separate(freq1, c("allele1", "freq1"), sep = ":") %>% 
  separate(freq2, c("allele2", "freq2"), sep = ":") %>% 
  mutate(most_freq2 = ifelse("freq1" == most_freq, freq1, freq2)) %>% 
  dplyr::select(snp, count, most_freq2)
colnames(RIM) <- c("snp", "count_RIM" ,"freq_RIM")

### Create a dataframe with all pop combined
all_pop <- cbind(BERG, BET, BSP, CHAT, CR, FOR, IV, KAM, LEV, PNF, POC, RIM)
all_pop <- all_pop %>% 
  dplyr::select(count_BERG, count_BET, count_BSP, count_CHAT, count_CR, count_FOR, count_IV, count_KAM, count_LEV, count_PNF, count_POC, count_RIM, freq_BERG, freq_BET, freq_BSP, freq_CHAT, freq_CR, freq_FOR, freq_IV, freq_KAM, freq_LEV, freq_PNF, freq_POC, freq_RIM)

snps <- BERG$snp
all_pop <- cbind(snps, all_pop)
all_pop$freq_BERG <- as.numeric(all_pop$freq_BERG)
all_pop$freq_BET <- as.numeric(all_pop$freq_BET)
all_pop$freq_BSP <- as.numeric(all_pop$freq_BSP)
all_pop$freq_CHAT <- as.numeric(all_pop$freq_CHAT)
all_pop$freq_CR <- as.numeric(all_pop$freq_CR)
all_pop$freq_FOR <- as.numeric(all_pop$freq_FOR)
all_pop$freq_IV <- as.numeric(all_pop$freq_IV)
all_pop$freq_KAM <- as.numeric(all_pop$freq_KAM)
all_pop$freq_LEV <- as.numeric(all_pop$freq_LEV)
all_pop$freq_PNF <- as.numeric(all_pop$freq_PNF)
all_pop$freq_POC <- as.numeric(all_pop$freq_POC)
all_pop$freq_RIM <- as.numeric(all_pop$freq_RIM)


### Determinate low and high salinity alleles
write.table(all_pop, "all_pop_frq.txt", col.names = TRUE, quote = FALSE)

freshwater <- fread("freshwater_BSP_AFD_outliers_09-17-2024.txt")
marine <- fread("marine_BSP_AFD_outliers_09-17-2024.txt")

freshwater_complete_snps <- all_pop %>%
  semi_join(freshwater, by = "snps")
write.table(freshwater_complete_snps, "freshwater_BSP_AFD_outliers_09-18-2024.txt", col.names = TRUE, quote = FALSE)

marine_complete_snps <- all_pop %>%
  semi_join(marine, by = "snps")
write.table(marine_complete_snps, "marine_BSP_AFD_outliers_09-18-2024.txt", col.names = TRUE, quote = FALSE)

neutral_complete_snps <- all_pop %>% 
  semi_join(neutral_alleles, by ="snps")
write.table(neutral_complete_snps, "BSP_AFD_neutral_09-19-2024.txt", col.names = TRUE, quote = FALSE)
