#!/bin/bash

# Calculate individuals properties : depth, missingness and heterozygosity
# Run this script from Population_Structure_final directory using :
# srun -c 4 --mem=10G -p small --time=1-00:00:00 -J IBM -o 99_log/info_%j.log 00_vcf/02_IBM/calculate_individual_info.sh $VCF &

# VARIABLES
OUT_DIR="02_infos"

VCF=$1

CPU=4

# LOAD REQUIRED MODULES
module load vcftools

## Do the calculation
vcftools --gzvcf $VCF --depth --out $OUT_DIR/"$(basename -s .vcf.gz $VCF)"_info

vcftools --gzvcf $VCF --missing-indv --out $OUT_DIR/"$(basename -s .vcf.gz $VCF)"_info

vcftools --gzvcf $VCF --het --out $OUT_DIR/"$(basename -s .vcf.gz $VCF)"_info