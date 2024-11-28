#!/bin/bash
#SBATCH -J "fastsimcoal"
#SBATCH -o log_%j
#SBATCH -c 1
#SBATCH -p ibis_medium
#SBATCH --mail-type=ALL
#SBATCH --mail-user=YOURMAIL
#SBATCH --time=7-00:00
#SBATCH --mem=10G

# cat 10_fsc/models.list | parallel -j16 srun -c 1 --mem 10G -p ibis_medium -o log_%j --time 7-00:00 ./01_scripts/10_fsc.sh COP KGJ {}

# srun -c 1 --mem 10G -p ibis_medium -o log_%j --time 7-00:00 ./01_scripts/10_fsc.sh COP KGJ {}

module load fastsimcoal2/2.7

POP1=$1
POP2=$2
MODEL=$3

PREFIX="${POP1}_${POP2}_${MODEL}"

mkdir 10_fsc/$PREFIX
cd 10_fsc/$PREFIX

for i in {1..100}
 do
   mkdir run$i
   cp ../${MODEL}.tpl ../${MODEL}.est ../${POP1}_${POP2}_jointMAFpop1_0.obs run$i"/"
   cd run$i
   mv ${POP1}_${POP2}_jointMAFpop1_0.obs ${PREFIX}_jointMAFpop1_0.obs
   mv ${MODEL}.tpl ${PREFIX}.tpl
   mv ${MODEL}.est ${PREFIX}.est
   echo "Run "$i
   fsc27 -t ${PREFIX}.tpl -e ${PREFIX}.est -m -C 1 -n 10000 -L 40 -s 0 -M -c 1
   cd ..
 done