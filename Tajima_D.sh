#!/bin/bash

# Calculated Nucleotide diversity and Tajima's D by group
# Run this script from SR_popgen_analysis directory using :
# srun -c 1 --mem=10G -p small --time=1-00:00:00 -J 03_Pi -o 99_log/03_Pi_%j.log 01_scripts/Tajima_D.sh & 

#VARIABLES
VCF="/project/lbernatchez/users/sadel35/SNP_calling_pipeline_202205/06_merged/merged_withoutUn_invariants_V2_2all_FM01_DP4_nonrelated.vcf.gz"

#MODULE
module load vcftools

# Perform linkage pruning
#vcftools --gzvcf $VCF --keep 02_infos/Middle_and_Marine_Estuary.txt --TajimaD 10000 --out 04_diversity/Middle_and_Marine_Estuary
#vcftools --gzvcf $VCF --keep 02_infos/Fluvial_Estuary.txt --TajimaD 10000 --out 04_diversity/Fluvial_Estuary
#vcftools --gzvcf $VCF --keep 02_infos/BSP_4fst_pop.txt --TajimaD 10000 --out 04_diversity/BSP

vcftools --gzvcf $VCF --keep 02_infos/Marine_Estuary_balanced.txt --TajimaD 10000 --out 04_diversity/High_balanced
vcftools --gzvcf $VCF --keep 02_infos/Fluvial_Estuary_balanced.txt --TajimaD 10000 --out 04_diversity/Low_balanced
