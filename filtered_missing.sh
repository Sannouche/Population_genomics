#!/bin/bash

# Filter related by missing individuals 
# Run this script from Population_Structure_final directory using :
# srun -c 4 --mem=10G -p small --time=1-00:00:00 -J IBM -o 99_log/filterIBM_%j.log 00_vcf/02_IBM/filtered_missing.sh $VCF &

# VARIABLES
OUT_DIR="00_vcf/02_IBM"

VCF=$1

CPU=4

# LOAD REQUIRED MODULES
module load plink

## Do the filtering
plink --vcf $VCF --allow-extra-chr --double-id \
--set-missing-var-ids @:# \
--cluster missing --mds-plot 4 \
--out $OUT_DIR/"$(basename -s .vcf.gz $VCF)"_IBM