library(tidyverse)

# Read command-line arguments for input files and the output file path
args <- commandArgs(trailingOnly = TRUE)

# Check if the correct number of arguments is provided
if (length(args) != 2) {
  stop("Usage: Rscript script.R Populations.txt output.txt")
}

# Assign arguments to file paths
populations_file <- args[1]
output_file <- args[2]

# Read populations from the input file
populations <- readLines(populations_file)

# Generate all unique pairs of populations
population_pairs <- combn(populations, 2, simplify = FALSE)

# Set the base path where the analysis directories are located
base_path <- "/project/lbernatchez/users/sadel35/angsd_pipeline/10_fsc/"

# Open a connection to write the paths of the best runs to the output file
file_conn <- file(output_file, open = "w")

# Loop through each population pair
for (pair in population_pairs) {
  Pop1 <- pair[1]
  Pop2 <- pair[2]
  
  # Construct the base directory path for the population pair
  dir_path <- paste0(base_path, Pop1, "_", Pop2, "_bs")
    
  # Check if the directory structure exists for the population pair
  if (dir.exists(dir_path)) {
    # Initialize variables to track the best run
    bestrun_name <- ""
    bestrun_Lhood <- -1e12  # A very low initial likelihood value
    
    # Loop through bs numbers
    for (bs in 1:50) {
      bs_path <- paste0(dir_path, "/bs", bs)
       
      # Loop through 100 runs to identify the best one
      for (i in 1:100) {
        # Construct the run path for each run
        run_path <- paste0(bs_path, "/run", i, "/", Pop1, "_", Pop2, "_bs")
        
        # Construct the full file path for each run
        run_file <- paste0(run_path, "/", Pop1, "_", Pop2, "_bs.bestlhoods")
        
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
      
      # If a best run was found for the current bs, write it to the output file
      if (bestrun_name != "") {
        best_run_path <- paste0(bs_path, "/", bestrun_name, "/", Pop1, "_", Pop2, "_bs/", Pop1, "_", Pop2, "_bs.bestlhoods")
        writeLines(best_run_path, file_conn)
      }
    }
  }
}

# Close the file connection
close(file_conn)
