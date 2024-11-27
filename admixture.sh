#!/bin/bash

# Run Admixture and plot results
# Run this script from SR_popgen_analysis directory using :
# parallel -a 02_infos/iteration_admixture.txt -k -j 10 srun -c 4 --mem 50G -J admix_{} -p medium,large -o 99_log/01_admixture_{}_%j.log 01_scripts/01_admixture.sh $BED {} &

# VARIABLES
BED=$1

iteration=$2

OUT_DIR="03_structure/global"
# MODULE
module load admixture

# 1. Run admixture for k=2 to k=12
# Need to modify the chromosome name before
#awk '{$1 = 0; print}' 00_vcf/03_pruned/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM_pruned.bim > 00_vcf/03_pruned/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM_pruned.bim.tmp
#rm 00_vcf/03_pruned/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM_pruned.bim
#mv 00_vcf/03_pruned/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM_pruned.bim.tmp 00_vcf/03_pruned/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM_pruned.bim

admixture --cv $BED $iteration > $OUT_DIR/"$(basename -s .bed $BED)"_admix_"$iteration"
