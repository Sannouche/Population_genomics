#!/bin/bash

# Filter IBM outliers 
# Run this script from Population_Structure_final directory using :
# srun -c 4 --mem=10G -p small --time=1-00:00:00 -J IBM -o 99_log/filterIBM_%j.log 00_vcf/02_IBM/remove_IBM.sh $VCF &

# VARIABLES
OUT_DIR="00_vcf"

VCF=$1

CPU=4

# LOAD REQUIRED MODULES
module load bcftools/1.15

## Do the filtering
bcftools view -S ^00_vcf/02_IBM/IBM_outliers.txt -Oz -o $OUT_DIR/"$(basename -s .vcf.gz $VCF)"_noIBM.vcf.gz $VCF