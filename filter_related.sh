#!/bin/bash

# Filter related individuals 
# Run this script from Population_Structure_final directory using :
# srun -c 4 --mem=10G -p small --time=1-00:00:00 -J related -o 99_log/filterrelated_%j.log 00_vcf/relatedness/filter_related.sh $VCF &

# VARIABLES
OUT_DIR="00_vcf"

VCF=$1

CPU=4

# LOAD REQUIRED MODULES
module load bcftools/1.15

## Do the filtering
bcftools view -S ^00_vcf/relatedness/Related_tofilter.txt -Oz -o $OUT_DIR/"$(basename -s .vcf.gz $VCF)"_nonrelated.vcf.gz $VCF