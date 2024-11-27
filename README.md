# Population_genomics
Scripts for Population genomics analysis

In 00_Filter_dataset, you can find scripts to:
- Calculate depth, missing and heterozygosity (calculate_individual_info.sh)
- Find related individuals (related.R) and filtered them out of the vcf (filter_related.sh)
- Calculate IBM (filtered_missing.sh), find individuals that shared missing data (IBM.r) and filtered them out (remove_IBM.sh)
- prune a vcf (vcf_to_pruned.sh)

In 01_Structure, you can find scripts that help to do:
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

In 03_Cline_analysis, you can find scripts to:
- Calculate allele frequency by site (AF.sh)
- Estimate the minor allele in one sites and standardize for all sites (00_AF.R)
- Identify most differenciated alleles based on allele frequency differenciation (01_AF_by_zones.R)
- Identify in which population outlier alleles are most represented ( 02_AFD_low_alleles.R)
- Filter outlier alleles by 50kb window and neutral alleles (03_AFD_cline_analysis.R)
- Calculate a quantitative model with hzar (https://onlinelibrary.wiley.com/doi/10.1111/1755-0998.12209) by outlier and neutral SNPs (cline_analysis.R)
- Compute results from hzar and identify the best overall model (04_cline_model.R)
