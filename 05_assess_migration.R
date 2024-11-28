library(tidyverse)

# Read command-line arguments for input files and the output file path
args <- commandArgs(trailingOnly = TRUE)

# Check if the correct number of arguments is provided
if (length(args) != 3) {
  stop("Usage: Rscript script.R Populations.txt Scenarios.txt output.txt")
}

# Assign arguments to file paths
populations_file <- args[1]
scenarios_file <- args[2]
output_file <- args[3]

# Read populations, scenarios, and parameters from the input files
populations <- readLines(populations_file)
scenarios <- scenarios_file

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
  Nanc = numeric(),
  Nmar = numeric(),
  Nfresh = numeric(),
  Mig12 = numeric(),
  Mig21 = numeric(),
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
      # Loop through 100 runs and store likelihood information
      for (i in 1:100) {
        # Construct the run path for each run (e.g., run1, run2,...)
        run_path <- paste0(dir_path, "/run", i, "/", Pop1, "_", Pop2, "_", scenario)
        # Construct the full file path for each run
        run_file <- paste0(run_path, "/", Pop1, "_", Pop2, "_", scenario, ".brent_lhoods")
        
        # Check if the file exists; process if it does
        if (file.exists(run_file)) {
          run <- read.table(run_file,
                  header = FALSE,
                  sep = "\t",  # or " " if space-separated
                  fill = TRUE,  # Fill missing values with NA
                  skip = 1)

  
          # Add the current run's information to the data frame
          all_runs <- rbind(all_runs, data.frame(
            Population1 = Pop1,
            Population2 = Pop2,
            Scenario = scenario,
            Run = paste0("run", i),
              Nanc = run[1,2],
              Nmar = run[1,3],
              Nfresh = run[1,4],
              Mig12 = run[1,5],
              Mig21 = run[1,6]
          ))
        }
      }
    }
  }
}

# Write the data frame with all runs to the output file in tabular format
write.table(all_runs, file = output_file, row.names = FALSE, quote = FALSE, sep = "\t")
