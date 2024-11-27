#!/bin/bash

# Calculated Allelic frequency by site
# Run this script from SR_popgen_analysis directory using :
# ls -1 02_infos/sites/* |parallel -k -j 10 srun -c 1 --mem=10G -p small --time=1-00:00:00 -J 05_AF_{/.} -o 99_log/05_AF_{/.}_%j.log 01_scripts/04_AF.sh {} & 

#VARIABLES
VCF="/project/lbernatchez/users/sadel35/Population_structure_final/00_vcf/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM.vcf.gz"
POP_FILE=$1
POP=$(basename -s ".txt" $POP_FILE)  

#MODULE
module load vcftools

# Perform linkage pruning
vcftools --gzvcf $VCF --freq --keep $POP_FILE --out 05_Allelic_Frequency/$POP
