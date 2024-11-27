#!/bin/bash

# Calculate differenciation indices (dxy and fst) and Pi along the genome
# Run this script from Population_Structure_final directory using :
# srun -c 8 --mem 100G -p medium --time 7-00 -o 99_log/pixy_%j.log -J pixy 01_scripts/03_Diversity_pixy.sh $VCF $POP &

# VARIABLES
OUT_DIR="./04_diversity"

VCF=$1 # Used a vcf with invariants sites 


POP=$2 #file with populations info (ID-POP) 

CPU=8

# No module required but need to load conda environment : python_genomics

## Run pixy directly in command line
srun -c 8 --mem 100G -p medium --time 7-00 -o 99_log/pixy_%j.log -J pixy pixy --stats dxy pi fst --vcf $VCF --populations $POP --window_size 10000 --n_cores $CPU --output_folder $OUT_DIR --output_prefix "$(basename -s .vcf.gz $VCF)"_pixy &