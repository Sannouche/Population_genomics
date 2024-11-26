# Script to check for identity by missingess
# library
library(tidyverse)
library(data.table)
library(gplots)

# Set working directory 
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/00_Filter_dataset/")

# Load and re-arrange dataset
## mds data
mds <- fread("stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_IBM.mds", header = TRUE) %>% 
  as.tibble(.)
names(mds)
names(mds) = c( "ID", "IID", "SOL", "C1" , "C2", "C3", "C4")

## Sexe and pop
stickleback_info <- fread("ID_POP_SEX.txt", header = TRUE) %>% 
  as.tibble(.)

## Coverage
cov <- fread("stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_info.idepth", header = TRUE) %>% 
  as.tibble(.) 
colnames(cov) <- c("ID", "n", "depth")

## frequency of missingness 
missing_indv <- fread("stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_info.imiss") %>% 
  as.tibble(.) 
colnames(missing_indv) <- c("ID", "n", "n_geno_filtered", "n_miss", "f_miss")

## Merging all dataset
mds_modified <- merge(mds, stickleback_info, by = "ID")
mds_modified <- merge(mds_modified, cov, by = "ID")
mds_modified <- merge(mds_modified, missing_indv, by = "ID")

# Plot 
plot_ibm = ggplot(mds_modified, aes(x = C1, y = C2, colour = POP)) + 
  geom_point() +
  geom_text(aes(label = ID))

plot_ibm

## Filtered IBM
filtered_IBM <- mds_modified %>% 
  arrange(desc(f_miss)) %>% 
  filter(f_miss > (mean(f_miss) + 3*sd(f_miss))) %>% 
  select(ID)

write.table(filtered_IBM,"IBM_outliers.txt", row.names = FALSE, quote = FALSE, sep = "\t")
