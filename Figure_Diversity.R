#### Figure of genetic diversity

## Libraries
library(tidyverse)
library(ggtext)
library(normentR)
library(data.table)
library(ggpubr)

# Set working directory
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/02_Diversity/")

# First part : All estuary Nucleotide diversity
Pi <- fread("High_Low_BSP_balanced_pixy_pi.txt")
Pi$mid <- (as.numeric(Pi$window_pos_1) + as.numeric(Pi$window_pos_2))/2

Pi$chromosome <- factor(Pi$chromosome, levels = c("chrI", "chrII", "chrIII", "chrIV", "chrV", "chrVI", "chrVII", "chrVIII",
                                                      "chrIX", "chrX", "chrXI", "chrXII", "chrXIII", "chrXIV", "chrXV",
                                                      "chrXVI", "chrXVII", "chrXVIII", "chrXX", "chrXXI"))

## Create a Piframe that calculate the last position of each chromosome 
Pi_cum <- Pi |>
  group_by(chromosome) |>
  summarise(max_bp = max(mid)) |>
  mutate(bp_add = lag(cumsum(max_bp), default = 0)) |>
  select(chromosome, bp_add)
### Merge with the original Piframe
Pi <- Pi |>
  inner_join(Pi_cum, by = "chromosome") |>
  mutate(bp_cum = mid + bp_add)

Pi <- Pi %>% 
  filter(pop == "High")

# Do the graph 
## Create some parameters for the graph
### Center of the chromosome
axis_set <- Pi |>
  group_by(chromosome) |>
  summarize(center = mean(bp_cum))

## Plot
manhplot_Pi <- ggplot(Pi, aes(
  x = bp_cum, y = avg_pi,
  color = chromosome, size = avg_pi
))  +
  geom_point(alpha = 0.75) +
  scale_x_continuous(
    label = axis_set$chromosome,
    breaks = axis_set$center
  )  +
  scale_color_manual(values = rep(
    c("#276FBF", "#183059"),
    unique(length(axis_set$chromosome))
  )) +
  scale_size_continuous(range = c(0.5, 3)) +
  labs(
    x = NULL,
    y = "Average Pi"
  ) +
  theme_bw() +
  theme(
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown(),
    axis.text.x = element_text(angle = 60, size = 8, vjust = 0.5)
  )
 
# Second part : Tajima's D in high estuary
High_D <- fread("High_balanced.Tajima.D")
colnames(High_D) <- c("chr", "start", "number_snps", "TajimaD")
High_D <- High_D %>% 
  mutate(mid = start + 5000)

High_D$chr <- factor(High_D$chr, levels = c("chrI", "chrII", "chrIII", "chrIV", "chrV", "chrVI", "chrVII", "chrVIII",
                                            "chrIX", "chrX", "chrXI", "chrXII", "chrXIII", "chrXIV", "chrXV",
                                            "chrXVI", "chrXVII", "chrXVIII", "chrXX", "chrXXI"))

## Create a dataframe that calculate the last position of each chromosome 
High_D_cum <- High_D |>
  group_by(chr) |>
  summarise(max_bp = max(mid)) |>
  mutate(bp_add = lag(cumsum(max_bp), default = 0)) |>
  select(chr, bp_add)

### Merge with the original dataframe
High_D <- High_D |>
  inner_join(High_D_cum, by = "chr") |>
  mutate(bp_cum = mid + bp_add)
High_D$pop <- "Saltwater"

axis_set <- High_D |>
  group_by(chr) |>
  summarize(center = mean(bp_cum))

manhplot_Tajima <- ggplot(High_D, aes(
  x = bp_cum, y = TajimaD,
  color = chr, size = TajimaD
))  +
  geom_point(alpha = 0.75) +
  scale_x_continuous(
    label = axis_set$chr,
    breaks = axis_set$center
  )  +
  scale_color_manual(values = rep(
    c("#276FBF", "#183059"),
    unique(length(axis_set$chr))
  )) +
  scale_size_continuous(range = c(0.5, 3)) +
  labs(
    x = NULL,
    y = "Tajima's D"
  ) +
  theme_bw() +
  ylim(-3, 4) +
  theme(
    legend.position = "none",
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    axis.title.y = element_markdown(),
    axis.text.x = element_text(angle = 60, size = 8, vjust = 0.5)
  )

# Third part : Box plot to compare Tajima's D average
### Baie-Saint-Paul
BSP_D <- fread("BSP.Tajima.D")
colnames(BSP_D) <- c("chr", "start", "number_snps", "TajimaD")
BSP_D <- BSP_D %>% 
  mutate(mid = start + 5000)

BSP_D$chr <- factor(BSP_D$chr, levels = c("chrI", "chrII", "chrIII", "chrIV", "chrV", "chrVI", "chrVII", "chrVIII",
                                          "chrIX", "chrX", "chrXI", "chrXII", "chrXIII", "chrXIV", "chrXV",
                                          "chrXVI", "chrXVII", "chrXVIII", "chrXX", "chrXXI"))

## Create a dataframe that calculate the last position of each chromosome 
BSP_D_cum <- BSP_D |>
  group_by(chr) |>
  summarise(max_bp = max(mid)) |>
  mutate(bp_add = lag(cumsum(max_bp), default = 0)) |>
  select(chr, bp_add)
### Merge with the original dataframe
BSP_D <- BSP_D |>
  inner_join(BSP_D_cum, by = "chr") |>
  mutate(bp_cum = mid + bp_add)
BSP_D$pop <- "BSP"

### Baie-Saint-Paul
Low_D <- fread("Low_balanced.Tajima.D")
colnames(Low_D) <- c("chr", "start", "number_snps", "TajimaD")
Low_D <- Low_D %>% 
  mutate(mid = start + 5000)

Low_D$chr <- factor(Low_D$chr, levels = c("chrI", "chrII", "chrIII", "chrIV", "chrV", "chrVI", "chrVII", "chrVIII",
                                          "chrIX", "chrX", "chrXI", "chrXII", "chrXIII", "chrXIV", "chrXV",
                                          "chrXVI", "chrXVII", "chrXVIII", "chrXX", "chrXXI"))

## Create a dataframe that calculate the last position of each chromosome 
Low_D_cum <- Low_D |>
  group_by(chr) |>
  summarise(max_bp = max(mid)) |>
  mutate(bp_add = lag(cumsum(max_bp), default = 0)) |>
  select(chr, bp_add)
### Merge with the original dataframe
Low_D <- Low_D |>
  inner_join(Low_D_cum, by = "chr") |>
  mutate(bp_cum = mid + bp_add)
Low_D$pop <- "Fluvial"

all_estuary <- rbind(Low_D, BSP_D, High_D)
all_estuary$pop <- factor(all_estuary$pop, levels = c("Fluvial", "BSP", "Saltwater"))

Boxplot_TajimaD_byEstuary <- ggplot(all_estuary, aes(x= pop, y= TajimaD)) +
  geom_violin(aes(fill = pop), linewidth = 1, alpha = .5) +
  geom_boxplot(outlier.alpha = 0, coef = 0,
               color = "gray40", width = .2) +
  scale_fill_brewer(palette = "Dark2", guide = "none") +
  coord_flip() +
  theme_bw()

# Fourth Part : Final graph
Diversity_plot <- ggarrange(ggarrange(Boxplot_TajimaD_byEstuary, nrow = 1,labels = "A"),
  ggarrange(manhplot_Tajima, manhplot_Pi, nrow = 2, labels = c("B", "C")),
                            ncol = 2,
                            widths = c(1, 1.5),
                            font.label = list(size = 8))

ggsave("Figure_Diversity_11-14-2024.png", Diversity_plot, width = 30, height = 25, units = "cm")
