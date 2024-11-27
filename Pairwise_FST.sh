#!/bin/bash

# Perform Fst calculation pairwise
# Run this script from Population_structure_final directory using :
# srun -c 4 --mem 20G -p medium --time 3-00 -o 03_structure/global/fst_pairwise/pairwise_fst_values.txt 01_scripts/02_Pairwise_FST.sh VCF_PATH &


#VARIABLES
VCF=$1
INPUT_DIR="02_infos/sites"
OUTPUT_DIR="03_structure/global/fst_pairwise"

#MODULE
module load vcftools

#FST Pairwise for BERG
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/BET.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-BET_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/BSP.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-BSP_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/CHAT.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-CHAT_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/CR.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-CR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/FOR.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-FOR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/IV.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-IV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/KAM.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-KAM_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/LEV.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-LEV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BERG.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/BERG-RIM_fst

#FST Pairwise for BET
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/BSP.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-BSP_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/CHAT.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-CHAT_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/CR.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-CR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/FOR.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-FOR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/IV.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-IV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/KAM.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-KAM_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/LEV.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-LEV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BET.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/BET-RIM_fst

#FST Pairwise for BSP
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/CHAT.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-CHAT_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/CR.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-CR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/FOR.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-FOR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/IV.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-IV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/KAM.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-KAM_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/LEV.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-LEV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/BSP.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/BSP-RIM_fst

#FST Pairwise for CHAT
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CHAT.txt --weir-fst-pop $INPUT_DIR/CR.txt --fst-window-size 10000 --out $OUTPUT_DIR/CHAT-CR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CHAT.txt --weir-fst-pop $INPUT_DIR/FOR.txt --fst-window-size 10000 --out $OUTPUT_DIR/CHAT-FOR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CHAT.txt --weir-fst-pop $INPUT_DIR/IV.txt --fst-window-size 10000 --out $OUTPUT_DIR/CHAT-IV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CHAT.txt --weir-fst-pop $INPUT_DIR/KAM.txt --fst-window-size 10000 --out $OUTPUT_DIR/CHAT-KAM_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CHAT.txt --weir-fst-pop $INPUT_DIR/LEV.txt --fst-window-size 10000 --out $OUTPUT_DIR/CHAT-LEV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CHAT.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/CHAT-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CHAT.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/CHAT-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CHAT.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/CHAT-RIM_fst

#FST Pairwise for CR
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CR.txt --weir-fst-pop $INPUT_DIR/FOR.txt --fst-window-size 10000 --out $OUTPUT_DIR/CR-FOR_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CR.txt --weir-fst-pop $INPUT_DIR/IV.txt --fst-window-size 10000 --out $OUTPUT_DIR/CR-IV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CR.txt --weir-fst-pop $INPUT_DIR/KAM.txt --fst-window-size 10000 --out $OUTPUT_DIR/CR-KAM_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CR.txt --weir-fst-pop $INPUT_DIR/LEV.txt --fst-window-size 10000 --out $OUTPUT_DIR/CR-LEV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CR.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/CR-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CR.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/CR-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/CR.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/CR-RIM_fst

#FST Pairwise for FOR
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/FOR.txt --weir-fst-pop $INPUT_DIR/IV.txt --fst-window-size 10000 --out $OUTPUT_DIR/FOR-IV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/FOR.txt --weir-fst-pop $INPUT_DIR/KAM.txt --fst-window-size 10000 --out $OUTPUT_DIR/FOR-KAM_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/FOR.txt --weir-fst-pop $INPUT_DIR/LEV.txt --fst-window-size 10000 --out $OUTPUT_DIR/FOR-LEV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/FOR.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/FOR-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/FOR.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/FOR-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/FOR.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/FOR-RIM_fst

#FST Pairwise for IV
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/IV.txt --weir-fst-pop $INPUT_DIR/KAM.txt --fst-window-size 10000 --out $OUTPUT_DIR/IV-KAM_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/IV.txt --weir-fst-pop $INPUT_DIR/LEV.txt --fst-window-size 10000 --out $OUTPUT_DIR/IV-LEV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/IV.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/IV-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/IV.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/IV-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/IV.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/IV-RIM_fst

#FST Pairwise for KAM
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/KAM.txt --weir-fst-pop $INPUT_DIR/LEV.txt --fst-window-size 10000 --out $OUTPUT_DIR/KAM-LEV_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/KAM.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/KAM-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/KAM.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/KAM-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/KAM.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/KAM-RIM_fst

#FST Pairwise for LEV
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/LEV.txt --weir-fst-pop $INPUT_DIR/PNF.txt --fst-window-size 10000 --out $OUTPUT_DIR/LEV-PNF_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/LEV.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/LEV-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/LEV.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/LEV-RIM_fst

#FST Pairwise for PNF
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/PNF.txt --weir-fst-pop $INPUT_DIR/POC.txt --fst-window-size 10000 --out $OUTPUT_DIR/PNF-POC_fst
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/PNF.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/PNF-RIM_fst

#FST Pairwise for POC
vcftools --gzvcf $VCF --weir-fst-pop $INPUT_DIR/POC.txt --weir-fst-pop $INPUT_DIR/RIM.txt --fst-window-size 10000 --out $OUTPUT_DIR/POC-RIM_fst
