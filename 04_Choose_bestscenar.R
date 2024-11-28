library(tidyverse)

# Read command-line arguments for input files and the output file path
args <- commandArgs(trailingOnly = TRUE)

# Check if the correct number of arguments is provided
if (length(args) != 4) {
  stop("Usage: Rscript script.R Populations.txt Scenarios.txt Parameters.txt output.txt")
}

# Assign arguments to file paths
populations_file <- args[1]
scenarios_file <- args[2]
parameters_file <- args[3]
output_file <- args[4]

# Read populations, scenarios, and parameters from the input files
populations <- readLines(populations_file)
scenarios <- readLines(scenarios_file)
parameters <- read.table(parameters_file, header = TRUE, stringsAsFactors = FALSE)  # Expecting 'Scenario' and 'nparam'

# Generate all unique pairs of populations
population_pairs <- combn(populations, 2, simplify = FALSE)

# Set the base path where the analysis directories are located
base_path <- "/project/lbernatchez/users/sadel35/angsd_pipeline/10_fsc/"

# Initialize a data frame to store all runs and their likelihoods
all_runs <- data.frame(
  Population1 = character(),
  Population2 = character(),
  Scenario = character(),
  Run = character(),
  MaxEstLhood = numeric(),
  nparam = numeric(),
  AIC = numeric(),
  deltaLL = numeric(),
  stringsAsFactors = FALSE
)

# Loop through each population pair and scenario
for (pair in population_pairs) {
  Pop1 <- pair[1]
  Pop2 <- pair[2]
  
  for (scenario in scenarios) {
    # Construct the directory path including _2pop_
    dir_path <- paste0(base_path, Pop1, "_", Pop2, "_", scenario)
    
    # Check if the directory structure exists for the population pair and scenario
    if (dir.exists(dir_path)) {
      # Get the number of parameters for the scenario
      nparam <- parameters$nparam[parameters$Scenario == scenario]
      
      if (length(nparam) == 0) {
        cat("No parameter count found for scenario:", scenario, "\n")
        next
      }
      
      # Loop through 100 runs and store likelihood information
      for (i in 1:100) {
        # Construct the run path for each run (e.g., run1, run2,...)
        run_path <- paste0(dir_path, "/run", i, "/", Pop1, "_", Pop2, "_", scenario)
        # Construct the full file path for each run
        run_file <- paste0(run_path, "/", Pop1, "_", Pop2, "_", scenario, ".bestlhoods")
        
        # Check if the file exists; process if it does
        if (file.exists(run_file)) {
          run <- read.table(run_file, header = TRUE)
          
          # Calculate AIC for the current run
          AIC <- 2 * nparam - 2 * (run$MaxEstLhood / log10(exp(1)))
          
          # Define maxobsL for deltaLL calculation (this is a constant in your analysis)
          maxobsL <- -76916607.752  # Adjust this value as needed for your analysis
          deltaLL <- maxobsL - run$MaxEstLhood
          
          # Add the current run's information to the data frame
          all_runs <- rbind(all_runs, data.frame(
            Population1 = Pop1,
            Population2 = Pop2,
            Scenario = scenario,
            Run = paste0("run", i),
            MaxEstLhood = run$MaxEstLhood,
            nparam = nparam,
            AIC = AIC,
            deltaLL = deltaLL
          ))
        }
      }
    }
  }
}

# Write the data frame with all runs to the output file in tabular format
write.table(all_runs, file = output_file, row.names = FALSE, quote = FALSE, sep = "\t")
