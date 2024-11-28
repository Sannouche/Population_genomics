#!/bin/bash

# Input file containing the paths to the best runs
input_file=$1

# Read each line from the input file
while IFS= read -r line; do
  # Extract the path to the .bestlhoods file and get its parent directory
  bestlhoods_path=$(dirname "$line")  # This gets the path to the directory containing the .bestlhoods file
  run_dir=$(dirname "$bestlhoods_path")  # This gets the parent directory (the run N directory)

  # Get the scenario directory path (up to the run N directory)
  scenario_dir=$(dirname "$run_dir")  # This gets the directory up to the scenario

  # Construct the new directory path for BestRun
  new_dir="${scenario_dir}/BestRun"  # Create the BestRun directory under the scenario directory
  
    # Echo the values for debugging
  echo "Processing line: $line"
  echo "Best likelihoods path: $bestlhoods_path"
  echo "Run directory: $run_dir"
  echo "Scenario directory: $scenario_dir"
  echo "New BestRun directory: $new_dir"

  # Create the new directory if it doesn't exist
  mkdir -p "$new_dir"

  # Copy the entire contents of the original run directory to the new BestRun directory
  cp -r "$run_dir/"* "$new_dir/"  # Copy contents of run N to BestRun directory

done < "$input_file"

