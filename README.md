# Population_genomics
Scripts for Population genomics analysis

In 00_Filter_dataset, you can find scripts to:
- Calculate depth, missing and heterozygosity (calculate_individual_info.sh)
- Find related individuals (related.R) and filtered them out of the vcf (filter_related.sh)
- Calculate IBM (filtered_missing.sh), find individuals that shared missing data (IBM.r) and filtered them out (remove_IBM.sh)
- prune a vcf (vcf_to_pruned.sh)

In 01_Structure, you can find scripts that helped to do:
- the ADMIXTURE analysis (admixture.sh)
- the PCA analysis (pca.R)
- the paitrwise Fst calculation (Pairwise_FST.sh)
- test for the presence of IBD (IBD_allEstuary.R and IBD_byEstuary.R)

Code for the figure in the article (Figure_Structure.R)

In 02_Diversity, you can find scripts to:
- Calculate Heterozygosity (Heterozygosity.sh) and compare populations (Heterozygosity.R)
- Calculate Tajima's D (Tajima_D.sh) and compare populations with manhattan plot (TajimaD.R)
- Calculate Nucleotide diversity Pi with Pixy (https://pixy.readthedocs.io/en/latest/arguments.html) (Diversity_pixy.sh)

Code for the figure in the article (Figure_Diversity.R)
