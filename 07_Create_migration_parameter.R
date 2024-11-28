library(tidyverse)

# Read the list of best run file paths from the previous output file
best_run_file <- "BestRuns_bootstrap.txt"  # Specify the correct path to your list of best run files
best_run_paths <- readLines(best_run_file)

# Initialize an empty dataframe to store the summary
summary_df <- data.frame()

# Loop through each best run file
for (path in best_run_paths) {
  # Extract the population names and run name from the file path
  # Example path structure: "/.../Pop1_Pop2_bs/bsX/runX/Pop1_Pop2_bs.bestlhoods"
  split_path <- str_split(path, "/")[[1]]
  
  # Extract Pop1_Pop2_bs from the last part of the directory before the file name
  population_info <- split_path[length(split_path) - 1]
  
  # Extract the run name (runX) from the second to last part of the directory
  run_name <- split_path[length(split_path) - 2]
  
  # Read the content of the .bestlhoods file into a dataframe
  run_data <- read.table(path, header = TRUE)  # Assuming the file has a header
  
  # Add columns for the run name and population info to the dataframe
  run_data$RunName <- run_name
  run_data$Populations <- population_info
  
  # Append to the summary dataframe
  summary_df <- bind_rows(summary_df, run_data)
}

# Write the summary to a new file
summary_file <- "summary_file.txt"  # Specify the desired output file name
write.table(summary_df, file = summary_file, sep = "\t", row.names = FALSE, col.names = TRUE, quote = FALSE)
