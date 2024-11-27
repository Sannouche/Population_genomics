# Libraries 
library(tidyverse)
library(data.table)
library(ggpubr)
library(RColorBrewer)
library(car)
library(boot)

# Set working directory
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/02_Diversity/")

# Let's look at heterozygosity by estuary zone 
HE_het <- fread("High_balanced.het")
colnames(HE_het) <- c("id", "observed_hom", "expected_hom", "number_sites", "Fixation_index")
HE_het$pop <- "high"

LE_het <- fread("Low_balanced.het")
colnames(LE_het) <- c("id", "observed_hom", "expected_hom", "number_sites", "Fixation_index")
LE_het$pop <- "low"

ME_het <- fread("BSP.het")
colnames(ME_het) <- c("id", "observed_hom", "expected_hom", "number_sites", "Fixation_index")
ME_het$pop <- "BSP"

all_estuary <- rbind(HE_het, LE_het, ME_het)

# Exclude the BSP_09 outlier
all_estuary$pop <- factor(all_estuary$pop, levels = c("low", "middle", "high"))

hist(LE_het$Fixation_index)
hist(HE_het$Fixation_index)
hist(ME_het$Fixation_index)


# Compare mean without boot straping
ggplot(all_estuary, aes(x= pop, y= Fixation_index)) +
  geom_violin(aes(fill = pop), linewidth = 1, alpha = .5) +
  geom_boxplot(outlier.alpha = 0, coef = 0,
               color = "gray40", width = .2) +
  scale_fill_brewer(palette = "Dark2", guide = "none") +
  coord_flip() +
  theme_bw()

wilcox.test(HE_het$Fixation_index, LE_het$Fixation_index) # p = 0.054
wilcox.test(HE_het$Fixation_index, ME_het$Fixation_index) # p = 0.156
wilcox.test(ME_het$Fixation_index, LE_het$Fixation_index) # p = 0.008

# Do bootstraping for High Estuary
perm_results_HE <- data.frame(Iteration = numeric(0), mean = numeric(0), sd = numeric(0))
# Define the number of iterations
iteration <- 10000

# set a seed
set.seed(44)

# Loop to subsample 148 windows by iteration and calculate the overlap
for (it in 1:iteration) {
  # Subsample 100 individuals in the list
  sampled_Fis <- sample(HE_het$Fixation_index, 50, replace = TRUE)
  
  # Estimate mean and sd
  mean <- mean(sampled_Fis)
  sd <- sd(sampled_Fis)
  
  # Stock results
  perm_results_HE <- rbind(perm_results_HE, data.frame(Iteration = it, mean = mean, sd = sd))
}

# Calculate the percentage of intersection
hist(perm_results_HE$mean)
HE_mean_perm <- mean(perm_results_HE$mean) # -0.049
HE_std_error <- sd(perm_results_HE$mean) / sqrt(length(perm_results_HE))

# Calculate t-confidence interval
t_value <- qt(0.975, df = length(perm_results_HE) - 1)  # 95% confidence level
HE_conf_interval <- HE_mean_perm + c(-1, 1) * t_value * HE_std_error # [-0.0542;-0.0434]

# Now for low estuary
perm_results_LE <- data.frame(Iteration = numeric(0), mean = numeric(0), sd = numeric(0))
# Define the number of iterations
iteration <- 10000

# set a seed
set.seed(44)

# Loop to subsample 148 windows by iteration and calculate the overlap
for (it in 1:iteration) {
  # Subsample 100 individuals in the list
  sampled_Fis <- sample(LE_het$Fixation_index, 50, replace = TRUE)
  
  # Estimate mean and sd
  mean <- mean(sampled_Fis)
  sd <- sd(sampled_Fis)
  
  # Stock results
  perm_results_LE <- rbind(perm_results_LE, data.frame(Iteration = it, mean = mean, sd = sd))
}

# Calculate the percentage of intersection
hist(perm_results_LE$mean)
LE_mean_perm <- mean(perm_results_LE$mean) # -0.052
LE_std_error <- sd(perm_results_LE$mean) / sqrt(length(perm_results_LE))

# Calculate t-confidence interval
t_value <- qt(0.975, df = length(perm_results_LE) - 1)  # 95% confidence level
LE_conf_interval <- LE_mean_perm + c(-1, 1) * t_value * LE_std_error # [-0.0604;-0.0447]

# And for mid estuary
perm_results <- data.frame(Iteration = numeric(0), mean = numeric(0), sd = numeric(0))
# Define the number of iterations
iteration <- 10000

# set a seed
set.seed(44)

# Loop to subsample 148 windows by iteration and calculate the overlap
for (it in 1:iteration) {
  # Subsample 100 individuals in the list
  sampled_Fis <- sample(ME_het$Fixation_index, 50, replace = TRUE)
  
  # Estimate mean and sd
  mean <- mean(sampled_Fis)
  sd <- sd(sampled_Fis)
  
  # Stock results
  perm_results <- rbind(perm_results, data.frame(Iteration = it, mean = mean, sd = sd))
}

# Calculate the percentage of intersection
hist(perm_results$mean)
ME_mean_perm <- mean(perm_results$mean) # -0.046
ME_std_error <- sd(perm_results$mean) / sqrt(length(perm_results))

# Calculate t-confidence interval
t_value <- qt(0.975, df = length(perm_results) - 1)  # 95% confidence level
ME_conf_interval <- ME_mean_perm + c(-1, 1) * t_value * ME_std_error # [-0.0513;-0.0404]

# Group and plot the bootstraps result
Mid_estuary <- cbind("mid",ME_mean_perm, ME_conf_interval[1], ME_conf_interval[2])
Low_estuary <- cbind("low",LE_mean_perm, LE_conf_interval[1], LE_conf_interval[2])
High_estuary <- cbind("high",HE_mean_perm, HE_conf_interval[1], HE_conf_interval[2])

all_estuary_boot <- rbind(Low_estuary, Mid_estuary, High_estuary)
all_estuary_boot <- as.data.frame(all_estuary_boot)
colnames(all_estuary_boot) <- c("Zones", "Mean", "Lower_CI", "Upper_CI")
all_estuary_boot$Zones <- factor(all_estuary_boot$Zones, levels = c("low", "mid", "high"))

ggplot(all_estuary_boot, aes(x = Zones, y = as.numeric(Mean), color = Zones)) +
  geom_boxplot() +
  geom_errorbar(aes(ymin = as.numeric(Lower_CI), ymax = as.numeric(Upper_CI)), width = 0.2, position = position_dodge(0.9)) +
  labs(title = "Boxplot of bootstraped Fis by estuary zones",
       y = "Mean",
       fill = "Group") +
  theme_bw()

t.test(perm_results$mean, perm_results_LE$mean)
t.test(perm_results$mean, perm_results_HE$mean)
t.test(perm_results_HE$mean, perm_results_LE$mean)
# All comparisons are significative with p < 2.2e-16
