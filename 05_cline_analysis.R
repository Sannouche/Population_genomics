### Quantitative cline analysis using Hzar

# Libraries
library(data.table)
library(tidyverse)
library(hzar)

# Set working directory
setwd("/project/lbernatchez/users/sadel35/Population_structure_final/06_cline_analysis")

# Load and organize data
filtered_snps <- fread("BSP_AFD_neutral_09-19-2024.txt", header = F)
colnames(filtered_snps) <- c("V1", "snp","count_BERG", "count_BET", "count_BSP", "count_CHAT",
                             "count_CR", "count_FOR", "count_IV", "count_KAM", "count_LEV",
                             "count_PNF", "count_POC", "count_RIM", "freq_BERG", "freq_BET",
                             "freq_BSP", "freq_CHAT","freq_CR", "freq_FOR", "freq_IV", "freq_KAM",
                             "freq_LEV", "freq_PNF","freq_POC","freq_RIM")

# Extract frequency and count data
frequencies <- filtered_snps %>% dplyr::select(starts_with("freq_"))
frequencies <- frequencies[,c("freq_PNF", "freq_LEV", "freq_CR", "freq_BSP", "freq_POC", "freq_KAM", "freq_FOR",
                              "freq_IV", "freq_RIM", "freq_BERG", "freq_CHAT", "freq_BET")]
counts <- filtered_snps %>% dplyr::select(starts_with("count_"))
counts <- counts[,c("count_PNF", "count_LEV", "count_CR", "count_BSP", "count_POC", "count_KAM", "count_FOR",
                              "count_IV", "count_RIM", "count_BERG", "count_CHAT", "count_BET")]

# Define your distances vector
distances <- c(-41+41, -6+41, 0.000+41, 99+41, 120+41, 160+41, 271+41, 215+41, 270+41, 215+41, 441+41, 318+41)  # Example distances, replace with actual distances


# Ensure the lengths match
if (ncol(frequencies) != length(distances) || ncol(counts) != length(distances)) {
  stop("Number of frequency or count columns does not match the length of distances vector")
}

# Create a list to store clines for each SNP
clines <- list()

# Loop through each SNP and create a hzar data group object
for (i in 1:nrow(frequencies)) {
  freqs <- as.numeric(frequencies[i, ])
  counts_snp <- as.numeric(counts[i, ])
  snp_name <- filtered_snps$snp[i]
  
  # Create a hzar data group object
  clines[[snp_name]] <- hzar.doMolecularData1DPops(distances, freqs, counts_snp)
}


# Function to process a single SNP and return results
process_snp <- function(snp_name, clines, distances) {
  # Define models
  models_list <- list(
    both = hzar.makeCline1DFreq(clines[[snp_name]], scaling = "fixed", tails = "both"),
    none = hzar.makeCline1DFreq(clines[[snp_name]], scaling = "fixed", tails = "none"),
    left = hzar.makeCline1DFreq(clines[[snp_name]], scaling = "fixed", tails = "left"),
    right = hzar.makeCline1DFreq(clines[[snp_name]], scaling = "fixed", tails = "right")
  )

  # Add width boundaries
  for (model_name in names(models_list)) {
    models_list[[model_name]] <- hzar.model.addBoxReq(models_list[[model_name]], min(distances), max(distances))
  }

  # Fit the models and catch any errors
  fit_model <- function(model) {
    fit_req <- try(hzar.first.fitRequest.old.ML(model, clines[[snp_name]], verbose = FALSE), silent = TRUE)
    if (inherits(fit_req, "try-error")) return(NULL)
    
    fitted <- try(hzar.chain.doSeq(fit_req, count = 5, collapse = TRUE), silent = TRUE)
    if (inherits(fitted, "try-error")) return(NULL)
    
    hzar.dataGroup.add(fitted)
  }

  # Fit all models and include a null model
  fitted_models <- lapply(models_list, fit_model)
  fitted_models$null <- hzar.dataGroup.null(clines[[snp_name]])

  # Check if all models failed
  if (all(sapply(fitted_models, is.null))) {
    print(paste("SNP:", snp_name, "- All models failed"))
    return(data.frame(
      snp_name = snp_name,
      model = NA,
      AIC = NA,
      center = NA,
      width = NA
    ))
  }

  # Group the results
  Model_grouped <- hzar.make.obsDataGroup(dataGroups = fitted_models)
  models <- names(fitted_models)

  # Calculate AIC and find the best model (choose the first in case of tie)
  AIC <- hzar.AICc.hzar.obsDataGroup(Model_grouped)
  best_model_index <- which.min(AIC$AICc)[1]

  # Check if the best model is the null model
  if (models[best_model_index] == "null") {
    print(paste("SNP:", snp_name, "- Best model: null"))
    return(data.frame(
      snp_name = snp_name,
      model = "null",
      AIC = AIC$AICc[best_model_index],
      center = NA,  # null model has no center
      width = NA    # null model has no width
    ))
  }

  # Get the best model parameters, or fill with NA if failed
  best_model <- fitted_models[[best_model_index]]
  
  # Additional safety checks
  if (is.null(best_model) || is.null(best_model$data.param) || length(best_model$data.param) == 0) {
    print(paste("SNP:", snp_name, "- Best model:", models[best_model_index], "- No valid model parameters"))
    return(data.frame(
      snp_name = snp_name,
      model = models[best_model_index],
      AIC = AIC$AICc[best_model_index],
      center = NA,
      width = NA
    ))
  }

  # Print the selected best model
  print(paste("SNP:", snp_name, "- Best model:", models[best_model_index]))

  # Return the best model's information
  data.frame(
    snp_name = snp_name,
    model = models[best_model_index],
    AIC = AIC$AICc[best_model_index],
    center = best_model$data.param$center,
    width = best_model$data.param$width
  )
}


# List of SNP names
snp_names <- names(clines)

# Initialize an empty dataframe to store results
results_df <- data.frame()

# Loop over each SNP and process
for (snp in snp_names) {
  result <- process_snp(snp, clines, distances)
  results_df <- rbind(results_df, result)
}

# Print the final results dataframe
print(results_df)

# Write the result file
write.table(results_df, "result_cline_model.txt", quote = FALSE)



