#!/bin/bash

# Calculated Heterozygosity by group
# Run this script from SR_popgen_analysis directory using :
# srun -c 1 --mem=10G -p small --time=1-00:00:00 -J 03_Pi -o 99_log/_%j.log 01_scripts/01_Heterozygosity.sh & 

#VARIABLES
VCF="/project/lbernatchez/users/sadel35/SNP_calling_pipeline_202205/06_merged/merged_withoutUn_invariants_V2_2all_FM01_DP4_nonrelated.vcf.gz"

#MODULE
module load vcftools

# Perform linkage pruning
vcftools --gzvcf $VCF --keep 02_infos/Marine_Estuary_balanced.txt --het --out 04_diversity/High_balanced
vcftools --gzvcf $VCF --keep 02_infos/Fluvial_Estuary_balanced.txt --het --out 04_diversity/Low_balanced
vcftools --gzvcf $VCF --keep 02_infos/BSP_4fst_pop.txt --het --out 04_diversity/BSP
