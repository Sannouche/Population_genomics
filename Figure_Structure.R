### Figure Pop Structure
library(tidyverse)
library(data.table)
library(reshape2)
library(magrittr)
library(RColorBrewer)
library(corrplot)
library(ggpubr)

# Set working directory
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/01_Structure/")

# PCA
## read data
pca <- read_table2("pca/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM_pruned.eigenvec", col_names= FALSE)
eigenval <- scan("pca/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM_pruned.eigenval")

# Sort out pca data
## Remove nuisance column
pca <- pca[,-1]

## Set names 
names(pca)[1] <- "ind"
names(pca)[2:ncol(pca)] <- paste0("PC", 1:(ncol(pca)-1))

# Sort out individual populations 
loc <- rep(NA, length(pca$ind))
loc[grep("BERG", pca$ind)] <- "Bergeronnes"
loc[grep("BSP", pca$ind)] <- "Baie-Saint-Paul"
loc[grep("BET", pca$ind)] <- "Betsiamites"
loc[grep("RIM", pca$ind)] <- "Rimouski"
loc[grep("CHAT", pca$ind)] <- "Cap-Chat"
loc[grep("CR", pca$ind)] <- "Cap-Rouge"
loc[grep("LEV", pca$ind)] <- "Levis"
loc[grep("FOR", pca$ind)] <- "Forestville"
loc[grep("IV", pca$ind)] <- "Isle-Verte"
loc[grep("KAM", pca$ind)] <- "Kamouraska"
loc[grep("PNF", pca$ind)] <- "Portneuf"
loc[grep("POC", pca$ind)] <- "Pocatiere"

#Estuary region 
ER <- rep(NA, length(pca$ind))
ER[grep("BERG", pca$ind)] <- "Marine"
ER[grep("BSP", pca$ind)] <- "Middle"
ER[grep("BET", pca$ind)] <- "Marine"
ER[grep("RIM", pca$ind)] <- "Marine"
ER[grep("CHAT", pca$ind)] <- "Marine"
ER[grep("CR", pca$ind)] <- "Fluvial"
ER[grep("LEV", pca$ind)] <- "Fluvial"
ER[grep("FOR", pca$ind)] <- "Marine"
ER[grep("IV", pca$ind)] <- "Marine"
ER[grep("KAM", pca$ind)] <- "Middle"
ER[grep("PNF", pca$ind)] <- "Fluvial"
ER[grep("POC", pca$ind)] <- "Middle"

# Remake data.frame
pca <- as.tibble(data.frame(pca, loc, ER))

# Convert eigenvalue into percentage variance explained
pve <- data.frame(PC=1:20, pve= eigenval/sum(eigenval)*100)

# Plot PCs 1&2
color_palette <- brewer.pal(12, "Set3")
pca$loc <- factor(pca$loc, levels = c("Portneuf", "Levis", "Cap-Rouge", "Baie-Saint-Paul", "Pocatiere", "Kamouraska", "Bergeronnes",
                                      "Forestville", "Isle-Verte", "Rimouski", "Betsiamites", "Cap-Chat"))
pca$ER <- factor(pca$ER, levels = c("Fluvial", "Middle", "Marine"))

PC1_loc_SNP <- ggplot(pca, aes(PC1, PC2, col=loc, shape=ER)) +
  geom_point(size=2) +
  scale_colour_manual(values =color_palette, name = "Sites") +
  theme_bw() +
  theme(legend.position = "none") +
  labs(shape= "Estuary zone",
       loc= "Sites") +
  xlab(paste0("PC1 (", signif(pve$pve[1], 3), "%)")) +
  ylab(paste0("PC2 (", signif(pve$pve[2], 3), "%)"))

# Fst
## create a lign for each pop

BERG <- c(0, 0.0022711, 0.008139, 0.0038971, 0.018922, 0.0012058, 0.00089979, 0.001523, 0.016562, 0.020569, 0.0022667, 0.002363)
BET <- c(0, 0, 0.0081281, 0.0049606, 0.018811, 0.00068, 0.0021688, 0.0024018, 0.016873, 0.020646, 0.0034626, 0.0027838)
BSP <- c(0, 0, 0, 0.01136, 0.019514, 0.0070038, 0.0076044, 0.0054933, 0.017312, 0.021377, 0.0040993, 0.0083401)
CHAT <- c(0, 0, 0, 0, 0.020417, 0.0034692, 0.0040406, 0.0051553, 0.01806, 0.021695, 0.0051238, 0.0040158)
CR <- c(0, 0, 0, 0, 0, 0.018003, 0.018614, 0.017105, 0.00067086, 0.00014673, 0.014397, 0.019365)
FOR <- c(0, 0, 0, 0, 0, 0, 0.0011006, 0.0014124, 0.015774, 0.019686, 0.0021396, 0.0020664)
IV <- c(0, 0, 0, 0, 0, 0, 0, 0.00069806, 0.016362, 0.020345, 0.0016235, 0.0017518)
KAM <- c(0, 0, 0, 0, 0, 0, 0, 0, 0.014916, 0.018852, 0.00072337, 0.0022422)
LEV <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0.00075792, 0.012073, 0.017296)
PNF <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.015832, 0.021374)
POC <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0.0033517)
RIM <- c(0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0)



pop <- c("Bergeronnes", "Betsiamites", "Baie-Saint-Paul", "Cap-Chat", "Cap-Rouge", "Forestville", "Isle-Verte", "Kamouraska", "Levis", "Portneuf", "Pocatiere", "Rimouski")

all_pop <- rbind(BERG,BET,BSP,CHAT,CR,FOR,IV,KAM,LEV,PNF,POC,RIM)
colnames(all_pop) <- pop
rownames(all_pop) <- pop

## Make a symetric matrix for Fst data : function
makeSymm <- function(m, position) {
  # Add symetrical triangle matrix (upper or lower)
  if (position == 'upper'){
    m[upper.tri(m)] <- t(m)[upper.tri(m)]
    return(m)
  }
  if (position == 'lower'){
    m[lower.tri(m)] <- t(m)[lower.tri(m)]
    return(m)
  }
}

## Construct a simetrical matrix
fst.mat<- all_pop %>%
  as.matrix(.) %>%
  makeSymm(., 'lower')

fst.melt <- reshape2::melt(fst.mat) %>%
  set_colnames(., c('pop1', 'pop2','FST'))

fst.melt$pop1 <- factor(fst.melt$pop1, levels = c("Portneuf", "Levis", "Cap-Rouge", "Baie-Saint-Paul", "Pocatiere", "Kamouraska", "Isle-Verte", "Bergeronnes", "Rimouski", "Cap-Chat", "Forestville", "Betsiamites"))
fst.melt$pop2 <- factor(fst.melt$pop2, levels = c("Portneuf", "Levis", "Cap-Rouge", "Baie-Saint-Paul", "Pocatiere", "Kamouraska", "Isle-Verte", "Bergeronnes", "Rimouski", "Cap-Chat", "Forestville", "Betsiamites"))

Fst_heatmap <- ggplot(fst.melt, aes(pop1, pop2, fill = FST)) +
  geom_tile() +
  scale_fill_gradient(low = "#8DD3C7", high = "#BEBADA") +
  theme_light() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 10), axis.text.y = element_text(size = 10)) +
  labs(x = NULL, y = NULL, color = "Fst")

# Create the figure
Pop_struct_plot <- ggarrange( ggarrange(PC1_loc_SNP, PC1_loc, ncol =2, nrow = 1, labels = c("A", "B"), font.label = list(size = 12)),
                              ggarrange(Fst_heatmap,labels = "C", font.label = list(size = 12)),
                              nrow = 2
) 


ggsave("Figure_Structure_10-10-2024.png", Pop_struct_plot, width = 25, height = 30, units = "cm")

