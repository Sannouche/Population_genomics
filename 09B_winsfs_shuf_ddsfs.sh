#!/bin/bash
#SBATCH -J "09B_winsfs_shuf_ddsfs"
#SBATCH -o log_%j
#SBATCH -c 10
#SBATCH -p ibis_medium
#SBATCH --mail-type=ALL
#SBATCH --mail-user=YOURMAIL
#SBATCH --time=7-00:00
#SBATCH --mem=50G

# parallel -a 02_info/regions_number.txt -k -j 10 srun -c 4 --mem 50G -p medium -o 99_log/09B_winsfs_%j.log --time 7-00:00 ./01_scripts/09B_winsfs_shuffle_ddsfs.sh {} &


GROUP=subset #the subgroup on whcih we are making the fst comparison -> it should be a file like GROUP.txt in the folder 02_info
POP_FILE1=02_info/"$GROUP".txt #choose on which list of pop run the analyses
num_pops=$(wc -l "$POP_FILE1" | cut -d " " -f 1)
NB_CPU=10 #change accordingly in SLURM header
#REGION_NUM="$1" 
#REGION=$(head -n $REGION_NUM 02_info/regions.txt | tail -n 1)
REGION=$1

# Important: Move to directory where job was submitted
cd $SLURM_SUBMIT_DIR

#prepare variables - avoid to modify
module load angsd/0.931
source 01_scripts/01_config.sh

for i in $(seq $num_pops)
do
	pop1=$(cat "$POP_FILE1" | head -"$i" | tail -1)
	for j in $(seq $[ $i + 1 ] $num_pops)
	do
		pop2=$(cat "$POP_FILE1" | head -"$j" | tail -1)
		echo "FST between $pop1 and $pop2"
		echo "$pop1"
		echo "$pop2"
		
        echo "Shuffle SAF"
        
         /project/lbernatchez/users/sadel35/angsd_pipeline/software/bin/winsfs shuffle -v --output 09_ddsfs/"$pop1"_"$pop2"_"$REGION".saf.shuf \
             09_ddsfs/$pop1/"$pop1"_pctind"$PERCENT_IND"_mindepth"$MIN_DEPTH"_"$REGION".saf.idx \
             09_ddsfs/$pop2/"$pop2"_pctind"$PERCENT_IND"_mindepth"$MIN_DEPTH"_"$REGION".saf.idx
        
		echo "calculate the 2dsfs"
        
        /project/lbernatchez/users/sadel35/angsd_pipeline/software/bin/winsfs -t $NB_CPU -v 09_ddsfs/"$pop1"_"$pop2"_"$REGION".saf.shuf > 09_ddsfs/"$pop1"_"$pop2"_"$REGION".winsfs.dsfs
        
        ## Remove header
        tail -n 1 09_ddsfs/"$pop1"_"$pop2"_"$REGION".winsfs.dsfs > 09_ddsfs/"$pop1"_"$pop2"_"$REGION".winsfs.ddsfs
        
        rm 09_ddsfs/"$pop1"_"$pop2"_"$REGION".saf.shuf
        rm 09_ddsfs/"$pop1"_"$pop2"_"$REGION".winsfs.dsfs    
	done
done
