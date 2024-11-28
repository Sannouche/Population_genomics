# Likelihoods from different models computed in fastsimcoal
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/07_Fastsimcoal/")
library(tidyverse)

# Read the output file containing AIC values
output_file <- "AIC_by_run.txt"  # Replace with the actual output file path
data <- read.table(output_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

# Create a new column that combines Population1 and Population2 to represent the pair
data <- data %>%
  mutate(Population_Pair = paste(Population1, Population2, sep = "_")) 

# Plot a boxplot with Scenarios on the x-axis and AIC on the y-axis
ggplot(data, aes(x = Scenario, y = AIC, color = Population_Pair)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(title = "AIC Distribution by Scenario", 
       x = "Scenario", 
       y = "AIC", 
       color = "Population Pair") +  # Label the color legend
  theme_minimal() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Plot migration against AIC for constant
parameters <- read.table("constantmig_parameters.txt", header = TRUE, stringsAsFactors = FALSE)

AIC_mig <- data %>% 
  left_join(parameters, by = c("Population1", "Population2", "Scenario", "Run")) %>% 
  filter(Scenario == "2pop_constantmig")

CR_BET <- AIC_mig %>% 
  filter(Population_Pair == "LEV_BET")

ggplot(CR_BET, aes(x = log(AIC), y = log(Mig12))) +
  geom_point()
  labs(title = "AIC Distribution by Scenario", 
       x = "Scenario", 
       y = "AIC", 
       color = "Population Pair") +  # Label the color legend
  theme_minimal() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

CR_BET_sce <- data %>% 
    filter(Population_Pair == "CR_RIM")

test <- ggplot(CR_BET_sce, aes(x = Scenario, y =AIC)) +
    geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
    geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
    labs(x = "Scenario", 
         y = "AIC", 
         color = "Population Pair") +  # Label the color legend
    theme_bw() +  # Use a minimal theme for a clean look
    theme(axis.text.x = element_text(angle = 45, hjust = 1))

test

ggsave("AIC_distribution_byScenario_11-11-2024.png", test, width = 20, height = 20, units = "cm")

ggplot(CR_BET, aes(x = Scenario, y = AIC, colour = Mig12)) +
  geom_jitter(width = 0.2, size = 2, alpha = 0.8)

cor.test(CR_BET$AIC, CR_BET$Mig12)
