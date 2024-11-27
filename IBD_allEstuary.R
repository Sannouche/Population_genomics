### Figure IBD

setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/03_IBD/")

# load tidyverse package
library(SoDA)
library(reshape2)
library(tidyverse)
library(magrittr)
library(RColorBrewer)
library(corrplot)
library(data.table)
library(lme4)
library(AICcmodavg)
library(ggpubr)

# Load data
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

## Represent IBD
###import information about populations
info_pop <- fread("Sites_echantillonnage.csv", header=T)
head(info_pop)

###calculate geogrpahic (euclidian) distances between all pairs of populations
distance <- dist(SoDA::geoXY(info_pop$latitude, info_pop$longitude)) %>%
  as.matrix(.)
dimnames(distance) <- list(info_pop$pop,info_pop$pop)

###prepare datasets
##linearize the distance matrix
dist.melt <- reshape2::melt(distance) %>%
  set_colnames(., c('pop1', 'pop2','distance'))

##linearize the fst matrix
fst.melt <- reshape2::melt(fst.mat) %>%
  set_colnames(., c('pop1', 'pop2','FST'))

##join the distance and fst
IBD.df <- left_join(dist.melt, fst.melt, by=c('pop1','pop2')) %>%
  filter(., distance > 0)

##plot IBD
options(scipen=4)
IBD <- ggplot(mod_test, aes(x=log(distance), y= FST)) +
  geom_point() +
  geom_smooth(aes(group = 1), method='lm', formula= y~x, color = "black") +
  theme_bw() +
  theme(plot.margin = margin(r = 2, l = 2, unit = "cm")) +
  labs(y = "Fst", x = "log(Distance)")  +
  theme(legend.key.size = unit(0.5, "cm")) 
IBD 
IBD_SV

##Create IBE withtout color
salinity <- matrix(nrow = 12, ncol = 12)
colnames(salinity) <- info_pop$pop
rownames(salinity) <- info_pop$pop

sal <- info_pop$salinity
names(sal) <- info_pop$pop

for (i in c(1:12)) {
  for (j in c(1:12)) {
    if (i == j) {
      salinity[i,j] = 0
      
    }
    else {
      salinity[i,j] = abs(sal[i] - sal[j])
    }
    
  }
  
}

salinity.melt <- reshape2::melt(salinity) %>%
  set_colnames(., c('pop1', 'pop2','salinity'))

##Combine datasets
mod_test <- left_join(dist.melt, fst.melt, by=c('pop1','pop2'))
mod_test <- left_join(mod_test, salinity.melt, by=c("pop1", "pop2")) %>% 
  filter(., distance > 0)

##IBE plot
IBE_plot <- ggplot(mod_test, aes(x=salinity, y= FST)) +
  geom_point() +
  geom_smooth(aes(group = 1), method='lm', formula= y~x, color = "black") +
  theme_bw() +
  theme(plot.margin = margin(r = 2, l = 2, unit = "cm")) +
  labs(y = "Fst", x = "salinity")  +
  theme(legend.key.size = unit(0.5, "cm")) 
IBE_plot 
IBE_plot_SV

# Do model testing
m_null <- lmer(FST ~ 1 + (1 | pop1) +  (1 | pop2), data = mod_test, REML = FALSE)
m_dist <- lmer(FST ~ log(distance) + (1 | pop1) +  (1 | pop2), data = mod_test, REML = FALSE)
m_sal <- lmer(FST ~ salinity + (1 | pop1) +  (1 | pop2), data = mod_test, REML = FALSE)
m_sal_dist <- lmer(FST ~ salinity + log(distance) + (1 | pop1) +  (1 | pop2), data = mod_test, REML = FALSE)

model_table <- aictab(c(m_null, m_dist, m_sal, m_sal_dist), modnames = c("null", "distance", "salinity", "distance + salinity"))

# Create the figure
IBD_plot <- ggarrange( IBD, IBD_SV,
                       IBE_plot,IBE_plot_SV,
                       nrow = 2,
                       ncol = 2,
                       labels = c("A","","B",""),
                       font.label = list(size = 12)
) 
IBD_plot
ggsave("Figure_IBD_we_11-13-2024.png", IBD_plot, width = 25, height = 25, units = "cm")
