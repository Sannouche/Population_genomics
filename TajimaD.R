# Libraries 
library(tidyverse)
library(ggtext)
library(normentR)
library(data.table)
library(ggpubr)

# Set working directory
setwd("C:/Users/utilisateur/Documents/Figure_doc/Chapitre_1_final/02_Diversity/")

## Let's load the data for each pop 
### High and middle estuary
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
High_D$pop <- "High"


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
Low_D$pop <- "Low"

# Do a manhattan plot
## Create some parameters for the graph
### Center of the chromosome
axis_set <- BSP_D |>
  group_by(chr) |>
  summarize(center = mean(bp_cum))

manhplot_BSP <- ggplot(BSP_D, aes(
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


manhplot_High <- ggplot(High_D, aes(
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


manhplot_Low <- ggplot(Low_D, aes(
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

TajimaD_all_estuary_plot <- ggarrange(manhplot_High,
                                   manhplot_BSP,
                                   manhplot_Low,
                                   nrow = 3, 
                                   labels = c("High","BSP","Low"),
                                   hjust = -0.1,
                                   font.label = list(size = 8))

ggsave("Tajima_3groups_balanced_09-25-2024.png", TajimaD_all_estuary_plot, width = 25, height = 25, units = "cm")


### Let's do a boxplot
all_estuary <- rbind(Low_D, BSP_D, High_D)
all_estuary$pop <- factor(all_estuary$pop, levels = c("Low", "BSP", "High"))

Boxplot_TajimaD_byEstuary <- ggplot(all_estuary, aes(x= pop, y= TajimaD)) +
  geom_violin(aes(fill = pop), linewidth = 1, alpha = .5) +
  geom_boxplot(outlier.alpha = 0, coef = 0,
               color = "gray40", width = .2) +
  scale_fill_brewer(palette = "Dark2", guide = "none") +
  coord_flip() +
  theme_bw()

ggsave("Boxplot_TajimaD_balanced_byEstuary_09-25-2024.png", Boxplot_TajimaD_byEstuary, width = 20, height = 20, units = "cm")


### Is TajimaD normally distributed
hist(BSP_D$TajimaD) # yes
mean(BSP_D$TajimaD,na.rm = TRUE )
hist(Low_D$TajimaD) # yes
mean(Low_D$TajimaD,na.rm = TRUE )
hist(High_D$TajimaD) # yes
mean(High_D$TajimaD,na.rm = TRUE )

### We can compare means with t test
t.test(High_D$TajimaD, Low_D$TajimaD) #p = 2.2e-16
t.test(High_D$TajimaD, BSP_D$TajimaD) #p = 2.2e-16
t.test(BSP_D$TajimaD, Low_D$TajimaD) #p = 0.008

# All comparison are significative