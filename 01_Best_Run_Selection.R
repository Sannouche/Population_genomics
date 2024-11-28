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

# Read populations and scenarios from the input files
populations <- readLines(populations_file)
scenarios <- readLines(scenarios_file)

# Generate all unique pairs of populations
population_pairs <- combn(populations, 2, simplify = FALSE)

# Set the base path where the analysis directories are located
base_path <- "/project/lbernatchez/users/sadel35/angsd_pipeline/10_fsc/"

# Open a connection to write the paths of the best runs to the output file
file_conn <- file(output_file, open = "w")

# Loop through each population pair and scenario
for (pair in population_pairs) {
  Pop1 <- pair[1]
  Pop2 <- pair[2]
  
  for (scenario in scenarios) {
    # Construct the directory path including _2pop_
    dir_path <- paste0(base_path, Pop1, "_", Pop2, "_", scenario)
    
    # Check if the directory structure exists for the population pair and scenario
    if (dir.exists(dir_path)) {
      # Initialize variables to track the best run
      bestrun_name <- ""
      bestrun_Lhood <- -1e12  # A very low initial likelihood value
      
      # Loop through 100 runs to identify the best one
      for (i in 1:100) {
        # Construct the run path for each run (e.g., run1, run2,...)
        run_path <- paste0(dir_path, "/run", i, "/", Pop1, "_", Pop2, "_", scenario)
        # Construct the full file path for each run
        run_file <- paste0(run_path, "/", Pop1, "_", Pop2, "_", scenario, ".bestlhoods")
        
        # Check if the file exists; process if it does
        if (file.exists(run_file)) {
          run <- read.table(run_file, header = TRUE)
          
          # Update the best run if the current likelihood is higher
          if (run$MaxEstLhood > bestrun_Lhood) {
            bestrun_name <- paste0("run", i)  # Correctly assign the run number
            bestrun_Lhood <- run$MaxEstLhood  # Update the best likelihood value
          }
        }
      }
      
      # If a best run was found, construct the path and write it to the output file
      if (bestrun_name != "") {
        best_run_path <- paste0(dir_path, "/", bestrun_name, "/", Pop1, "_", Pop2, "_", scenario, "/", Pop1, "_", Pop2, "_", scenario, ".bestlhoods")
        writeLines(best_run_path, file_conn)
      }
    }
  }
}

# Close the file connection
close(file_conn)
