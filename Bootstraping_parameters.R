# Bootstraped paramters.
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/07_Fastsimcoal/")
library(tidyverse)
library(ggpubr)

# Read the output file containing AIC values
output_file <- "Bootstrap_results.txt"  # Replace with the actual output file path
data <- read.table(output_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

colnames(data) <- c("Panc", "Nmar", "Nfresh", "Mig21", "Mig12", "Tstop", "Tbet","Tdiv", "Nanc", "MaxEstLhood", "MaxObsLhood", "RunName", "population_pair")

# Calculate a deltaL for each run
data <- data %>% 
  mutate(deltaL = MaxObsLhood - MaxEstLhood)

ggplot(data, aes(x = population_pair, y = deltaL)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8)

data_reverse <- t(data)

data_reverse <- as.data.frame(data_reverse)
data_reverse <- data_reverse[-c(7,8,9),]

data_reverse$param <- rownames(data_reverse)

# Plot a boxplot with Scenarios on the x-axis and AIC on the y-axis
Mig21 <- ggplot(data, aes(x = population_pair, y = Mig21)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "Mig21") +  # Label the color legend
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 5))

Mig12 <- ggplot(data, aes(x = population_pair, y = Mig12)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "Mig12") +  # Label the color legend
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 5))

Nmar <- ggplot(data, aes(x = population_pair, y = log(Nmar))) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "log(Nmar)") +  # Label the color legend
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 5))

Nfresh <- ggplot(data, aes(x = population_pair, y = log(Nfresh))) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "log(Nfresh)") +  # Label the color legend
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 5))

Nanc <- ggplot(data, aes(x = population_pair, y = log(Nanc))) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "log(Nanc)") +  # Label the color legend
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 5))

Tdiv <- ggplot(data, aes(x = population_pair, y = Tdiv)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "Tdiv") +  # Label the color legend
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 5))

Tstop <- ggplot(data, aes(x = population_pair, y = Tstop)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "Tstop") +  # Label the color legend
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = 5))

Parameters_plot <- ggarrange(Tdiv, Tstop,Mig12, Mig21,
                             Nfresh, Nmar, Nanc,
                             nrow = 2,
                             ncol = 4,
                             labels = c("A", "B", "C", "D", "E", "F"),
                             font.label = list(size = 8)
) 

ggsave("parameters_constantmig_bootstrap_11-10-2024.png", Parameters_plot, width = 25, height = 25, units = "cm")


# I have two modes in Nmar, I'll color dots by mod 1 or 2
# I define my mod as more or less than 500.000 
min(data$deltaL)
data <- data %>% 
  mutate(mod = ifelse(deltaL > 550000, "Standard", "Best"))

color_p <- c("orangered4", "darkblue")

Mig21 <- ggplot(data, aes(x = population_pair, y = Mig21, colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "Mig21") +  # Label the color legend¸
  scale_colour_manual(values = color_p) +
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x =element_blank())

Mig12 <- ggplot(data, aes(x = population_pair, y = Mig12, colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "Mig12") +  # Label the color legend
  scale_colour_manual(values = color_p) +
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x =element_blank())

Nmar <- ggplot(data, aes(x = population_pair, y = log(Nmar), colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "log(Nmar)") +  # Label the color legend
  scale_colour_manual(values = color_p) +
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x =element_blank())

Nfresh <- ggplot(data, aes(x = population_pair, y = log(Nfresh), colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "log(Nfresh)") +  # Label the color legend
  scale_colour_manual(values = color_p) +
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x =element_blank())

Nanc <- ggplot(data, aes(x = population_pair, y = log(Nanc), colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "log(Nanc)") +  # Label the color legend
  scale_colour_manual(values = color_p) +
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x =element_blank())

Tdiv <- ggplot(data, aes(x = population_pair, y = Tdiv, colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "Tdiv") +  # Label the color legend
  scale_colour_manual(values = color_p) +
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x =element_blank())

Tstop <- ggplot(data, aes(x = population_pair, y = Tstop, colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "Tstop") +  # Label the color legend
  scale_colour_manual(values = color_p) +
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x =element_blank())

DeltaLL <- ggplot(data, aes(x = population_pair, y = deltaL, colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = NULL, 
       y = "DeltaL") +  # Label the color legend
  scale_colour_manual(values = color_p) +
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x =element_blank())

Parameters_plot <- ggarrange(DeltaLL,Nanc, Nfresh, Nmar,
                             Mig12, Mig21, Tdiv, Tstop,
                             nrow = 2,
                             ncol = 4,
                             labels = c("A", "B", "C", "D", "E", "F", "G", "H"),
                             font.label = list(size = 8),
                             common.legend = TRUE
) 

ggsave("parameters_constantmig_bootstrap_coloredbymod_20-11-2024.png", Parameters_plot, width = 30, height = 25, units = "cm")

# Caluclate AIC by models, to see if there is a mode that is more plausible than the other
data <- data %>% 
  mutate(AIC = 12 - (2 * (data$MaxEstLhood / log10(exp(1)))))
ggplot(data, aes(x = Mig21, y = AIC, colour = mod)) +
  geom_boxplot(outlier.shape = NA, alpha = 0.5) +  # Boxplot without plotting outliers as points
  geom_jitter(width = 0.2, size = 2, alpha = 0.8) +  # Jitter to add points colored by Population Pair
  labs(x = "log(Nfresh)", 
       y = "AIC") +  # Label the color legend
  theme_bw() +  # Use a minimal theme for a clean look
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

data %>% 
  group_by(mod) %>% 
  summarise(mean = mean(Tstop))

