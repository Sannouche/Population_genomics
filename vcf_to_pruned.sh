#!/bin/bash

# Prunned SNPs with LD value
# Run this script from Population_Structure_final directory using :
# srun -c 4 --mem=10G -p small --time=1-00:00:00 -J prune -o 99_log/prunning_%j.log 00_vcf/03_pruned/vcf_to_pruned.sh $VCF &

#VARIABLES
OUT_DIR="00_vcf/03_pruned"

VCF=$1

CPU=4

#MODULE
module load plink

# Perform linkage pruning
plink --vcf $VCF \
--double-id --allow-extra-chr --set-missing-var-ids @:# \
--extract 00_vcf/03_pruned/stickleback_453_withoutUn_2all_maf0.05_FM01_DP4_nonrelated_noIBM_pruned.prune.in \
--make-bed --pca \
--out $OUT_DIR/"$(basename -s .vcf.gz $VCF)"_pruned
