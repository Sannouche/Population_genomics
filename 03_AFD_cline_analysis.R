# Do an heatmap for outliers snps

### libraries
library(data.table)
library(tidyverse)
library(RColorBrewer)

### Set working directory
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/04_Allelic_Frequency/")

### Load matrix of allele frequency by pop

all_pop <- fread("freshwater_BSP_AFD_outliers_09-18-2024.txt")[,-1]

# Affect type to snps
snps_name <- all_pop$snps
snps_sorted <- all_pop %>% 
  separate(snps, into = c("chromosome", "position"), sep = "_")
snps_sorted <- cbind(snps = snps_name, snps_sorted)
snps_sorted$position <- as.numeric(snps_sorted$position)

# Function to filter SNPs
filter_snps <- function(df) {
  selected_snps <- data.frame()
  while (nrow(df) > 0) {
    # Take the first SNP in the remaining list
    current_snp <- df[1, ]
    region_start <- current_snp$position
    region_end <- region_start + 50000
    
    # Identify all SNPs within 50kb of the current SNP
    region_snps <- df %>%
      filter(chromosome == current_snp$chromosome &
               position >= region_start &
               position <= region_end)
    
    # Randomly select one SNP from this region
    selected_snp <- region_snps %>% sample_n(1)
    selected_snps <- rbind(selected_snps, selected_snp)
    
    # Remove the selected SNPs from the original DataFrame
    df <- df %>%
      filter(!(chromosome == current_snp$chromosome &
                 position >= region_start &
                 position <= region_end))
  }
  return(selected_snps)
}

# Step 3: Apply the filtering function to each chromosome separately
filtered_snps <- snps_sorted %>%
  group_by(chromosome) %>%
  do(filter_snps(.)) %>%
  ungroup()

# Output the filtered SNPs
print(filtered_snps)

#write.table(filtered_snps, "filtered_marine_BSP_outliers_19-09-2024.txt", col.names = TRUE, quote = FALSE)


neutral_pop <- fread("BSP_AFD_neutral_09-19-2024.txt")

neutral_pop$dif <- "neutral"
filtered_snps$dif <- "outlier"

neutral_pop <- neutral_pop %>% 
  select(snps, freq_BERG, freq_BET, freq_BSP, freq_CHAT, freq_CR, freq_FOR, freq_IV, freq_KAM,
         freq_KAM,freq_LEV, freq_PNF, freq_POC, freq_RIM, dif)

pop_order <- c("PNF", "LEV", "CR" , "BSP", "POC", "KAM", "FOR", "IV", "RIM", "BERG", "CHAT", "BET")
dist_to_CR <- c(-41453.544, -6473.675, 0.000, 99684.135, 120682.424, 160953.007, 271335.67, 215797.51, 270244.60, 215009.82, 441891.1, 318282.61)


selected_snps<- filtered_snps %>% 
  select(snps, freq_BERG, freq_BET, freq_BSP, freq_CHAT, freq_CR, freq_FOR, freq_IV, freq_KAM,
         freq_KAM,freq_LEV, freq_PNF, freq_POC, freq_RIM, dif)

selected_alleles_pop_df <- t(selected_snps)
selected_alleles_pop_df <- as.data.frame(selected_alleles_pop_df)
selected_alleles_pop_df <- selected_alleles_pop_df[-c(1,14,15),]

selected_alleles_pop_df$pop <- c("BERG", "BET", "BSP", "CHAT", "CR", "FOR", "IV", "KAM", "LEV", "PNF", "POC", "RIM")

selected_alleles_pop_df <- selected_alleles_pop_df %>% 
  arrange(factor(pop, levels = pop_order))

colnames(selected_alleles_pop_df) <- selected_snps$snps
selected_alleles_pop_df$dist <- dist_to_CR
selected_alleles_pop_df$type <- "outlier"

# Transform in long format and do the plot
selected_alleles_long <- reshape2::melt(selected_alleles_pop_df, id.vars = c("dist", "type"))
colnames(selected_alleles_long)<- c("dist", "type","snps", "AFD")


neutral_alleles_pop_df <- t(neutral_pop)
neutral_alleles_pop_df <- as.data.frame(neutral_alleles_pop_df)
neutral_alleles_pop_df <- neutral_alleles_pop_df[-c(1,14,15),]

neutral_alleles_pop_df$pop <- c("BERG", "BET", "BSP", "CHAT", "CR", "FOR", "IV", "KAM", "LEV", "PNF", "POC", "RIM")

pop_order <- c("PNF", "LEV", "CR" , "BSP", "POC", "KAM", "FOR", "IV", "RIM", "BERG", "CHAT", "BET")

neutral_alleles_pop_df <- neutral_alleles_pop_df %>% 
  arrange(factor(pop, levels = pop_order))

colnames(neutral_alleles_pop_df) <- neutral_pop$snps
neutral_alleles_pop_df$dist <- dist_to_CR
neutral_alleles_pop_df$type <- "neutral"

# Transform in long format and do the plot
neutral_alleles_long <- reshape2::melt(neutral_alleles_pop_df, id.vars = c("dist", "type"))
colnames(neutral_alleles_long)<- c("dist", "type","snps", "AFD")

# Merged both
all_alleles_long <- rbind(selected_alleles_long, neutral_alleles_long)
all_alleles_long$type <- factor(all_alleles_long$type, levels = c("neutral", "outlier"))

cline <- ggplot(all_alleles_long, aes(x = dist, y = as.numeric(AFD), group = snps, color = type)) +
  geom_line(data = subset(all_alleles_long, type == "neutral"), 
            aes(color = type), linewidth = 1, alpha = 0.4) +
  geom_line(data = subset(all_alleles_long, type == "outlier"), 
            aes(color = type), linewidth = 1, alpha = 0.4) +
  scale_color_manual(values = c("grey", "#D95F02")) +
  labs(x = "Distance to Portneuf", y = "Allelic Frequency") +
  theme_bw() +
  geom_vline(aes(xintercept = 95000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed") +
  geom_vline(aes(xintercept = 200000), linewidth = 1.5,
             color = "firebrick", linetype = "dashed")

ggsave("Marine_BSP_outliers_alongEstuary_09-19-2024.png", cline,  width = 25, height = 20, units = "cm")
