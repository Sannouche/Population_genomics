# Load necessary library
library(tidyverse)

# Read command-line arguments for input files
args <- commandArgs(trailingOnly = TRUE)

# Check if the correct number of arguments is provided
if (length(args) != 3) {
  stop("Usage: Rscript script.R Populations.txt Scenarios.txt Parameters.txt")
}

# Assign arguments to file paths
populations_file <- args[1]
scenarios_file <- args[2]
parameters_file <- args[3]

# Read populations, scenarios, and parameters from the input files
populations <- readLines(populations_file)
scenarios <- readLines(scenarios_file)

# Read the parameters file, expecting columns: 'Scenario' and 'nparam'
parameters <- read.table(parameters_file, header = TRUE, stringsAsFactors = FALSE)

# Generate all unique pairs of populations
population_pairs <- combn(populations, 2, simplify = FALSE)

# Set the base path where the analysis directories are located
base_path <- "/project/lbernatchez/users/sadel35/angsd_pipeline/10_fsc/"

# Initialize an empty data frame to store results
results <- data.frame()

# Loop through each population pair and scenario
for (pair in population_pairs) {
  Pop1 <- pair[1]
  Pop2 <- pair[2]
  
  for (scenario in scenarios) {
    # Find the corresponding number of parameters for the scenario
    nparam <- parameters$nparam[parameters$Scenario == scenario]
    
    # Check if nparam exists; otherwise, skip this scenario
    if (length(nparam) == 0) {
      cat("No parameter count found for scenario:", scenario, "\n")
      next
    }
    
    # Construct the directory path to the BestRun folder
    best_run_path <- paste0(base_path, Pop1, "_", Pop2, "_", scenario, "/BestRun/", Pop1, "_", Pop2, "_", scenario, "/", Pop1, "_", Pop2, "_", scenario, ".bestlhoods")
    
    # Check if the best likelihood file exists
    if (file.exists(best_run_path)) {
      # Read the MaxEstLhood value from the .bestlhoods file
      tryCatch({
        run <- read.table(best_run_path, header = TRUE)
        
        # Add the likelihood and model details to the results data frame
        results <- rbind(results, data.frame(
          Pop1 = Pop1,
          Pop2 = Pop2,
          Scenario = scenario,
          MaxEstLhood = run$MaxEstLhood,
          nparam = nparam # Use the retrieved number of parameters
        ))
        
      }, error = function(e) {
        cat("Error reading file:", best_run_path, "\n")
      })
    }
  }
}

# Calculate AIC and deltaL for each row in results
if (nrow(results) > 0) {
  results$maxobsL <- -76916607.752 # Adjust maxobsL as needed for your analysis
  results$AIC <- 2 * results$nparam - 2 * (results$MaxEstLhood / log10(exp(1)))
  results$deltaL <- results$maxobsL - results$MaxEstLhood
  
  # Print or save the results data frame
  print(results)
  # Optionally save results to a CSV file
  write.csv(results, "AIC_results.csv", row.names = FALSE)
} else {
  cat("No valid .bestlhoods files found in BestRun folders.\n")
}
