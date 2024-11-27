### Script to determine which cline model is the best. 

# Libraries
library(tidyverse)
library(data.table)

# Set working directory 
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/04_Allelic_Frequency")

# Load datasets
marine <- fread("result_cline_model_marine_BSP_outliers.txt")[,-1]
marine <- marine %>% 
  rename(snps = "snp_name")

freshwater <- fread("result_cline_model_freshwater_BSP_outliers.txt")[,-1]
freshwater <- freshwater %>% 
  rename("snps" = snp_name)
snps <- fread("filtered_freshwater_BSP_outliers_19-09-2024.txt")
freshwater_filtered <- freshwater %>% 
  semi_join(snps, by = "snps")

neutral <- fread("result_cline_model_neutral_loci.txt")[,-1]

# Merge freshwater and marine outliers into one dataframe.
outliers <- rbind(marine, freshwater_filtered)

# Compare the most represented models with a fisher test
neutral_counts <- table(neutral$model)
outliers_counts <- table(outliers$model)
c_table <- rbind(neutral = neutral_counts, outlier = outliers_counts)

fisher_test <- fisher.test(c_table)

fisher_test

# Do the same for freshwater and marine loci
marine_counts <- table(marine$model)
marine_counts
fresh_counts <- table(freshwater_filtered$model)
fresh_counts

c_table_2 <- rbind(fresh = fresh_counts, marine = marine_counts)

# Identify the cline width and the cline center
left <- outliers %>% 
  filter(model == "left")
mean(left$width)
mean(left$center)

both <- outliers %>% 
  filter(model == "both")
mean(both$center)

none <- outliers %>% 
  filter(model == "none")
mean(none$center)
