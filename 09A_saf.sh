#!/bin/bash
#SBATCH -J "08_thetas_bypop"
#SBATCH -o log_%j
#SBATCH -c 4
#SBATCH -p ibis_large
#SBATCH --mail-type=ALL
#SBATCH --mail-user=YOURMAIL
#SBATCH --time=21-00:00
#SBATCH --mem=50G

# cat 02_info/pop.txt | parallel -j20 srun -c 8 --mem 100G -p batch -o log_%j --time 7-00:00 ./01_scripts/09A_saf.sh {}
# srun -c 8 --mem 50G -p batch -o log_%j --time 1-00:00 ./01_scripts/09A_saf.sh LLS

# Mask ancestral genome for region inside 150bp of a deviant SNP
#bedtools maskfasta -fi 02_info/ancestral_genome.fa -bed 02_info/regions_deviants_150bp_chr08_14.bed -fo 02_info/ancestral_genome_deviant_masked_150bp.fa
#samtools faidx 02_info/ancestral_genome_deviant_masked_150bp.fa

#i="RIM"
i="$1"

###this script will work on bamfiles by population and calculate saf  and then thetas
#maybe edit
NB_CPU=4 #change accordingly in SLURM header
#REGION_NUM="$1" 
#REGION=$(head -n $REGION_NUM 02_info/regions.txt | tail -n 1)
REGION="chrXX"

# Important: Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR
module load angsd/0.931
ulimit -S -n 2048

#prepare variables - avoid to modify
source 01_scripts/01_config.sh

#for BAMLIST in $(ls -1 07_fst_by_pop_pair/black/pop/*subsetbam.filelist);
#    do sed 's/\/project/\/mnt\/ibis/g' $BAMLIST > "$BAMLIST".valeria;
#    done

# Do thetas for all population listed
#it will loop on populations
	#to work on a signle population, comment the loop and use
	#i="popname"
	echo $i
	#note that as bamlist I used teh ones with similar sample size drawn at the step 07 when doing the Fst.
	#if samplesize differences is not a pb, one can replace 07_fst_by_pop_pair/$GROUP/"$i"subsetbam.filelist by 02_info/"$i"bam.filelist
	BAM_LIST=02_info/"$i"_sub.bam.filelist
	#BAM_LIST=02_info/"$i"bam.filelist
	
	#this will calculate filter for the initial saf
	N_IND=$(wc -l $BAM_LIST | cut -d " " -f 1)
	MIN_IND_FLOAT=$(echo "($N_IND * $PERCENT_IND)"| bc -l)
	MIN_IND=${MIN_IND_FLOAT%.*} 
	MAX_DEPTH=$(echo "($N_IND * $MAX_DEPTH_FACTOR)" |bc -l)

	#we do not filter on maf nor provide a site list
	#we need to re-do doSaf because we don't want to filter on maf for thetas calculation
	#I don't use the fold option anymore - but be aware that only T watterson and Taj D are interpretable if anc is the ref genome
	echo "working on pop $i, $N_IND individuals"
	echo "will filter for sites with at least one read in $MIN_IND individuals, which is $PERCENT_IND of the total and output saf"
		
angsd -P $NB_CPU \
    -dosaf 5 -GL 2 -doMajorMinor 5 -doCounts 1 \
    -anc 02_info/genome_maskdev.fasta \
    -r $REGION \
    -uniqueOnly 1 -only_proper_pairs 1 \
    -remove_bads 1 -minMapQ 30 -minQ 20 \
    -minInd $MIN_IND -setMinDepthInd $MIN_DEPTH -setMaxDepth $MAX_DEPTH \
	-b "$BAM_LIST" -out 09_ddsfs/"$i"_pctind"$PERCENT_IND"_mindepth"$MIN_DEPTH"_"$REGION"
    
	#
	##the output if a saf (for pop i)