#!/bin/bash

#SBATCH --mem=100G
#SBATCH --array=1-23%5
#SBATCH --job-name=top10

cd /scratch/users/k1471250/hear.charge/cleaned/MA/nov18/vegas/

chrom=${SLURM_ARRAY_TASK_ID}

module add apps/R
module add apps/plink

## this is based on the analysis of top10 SNPs and 10kb window
## this can be modified by -top/-upper/-lower
## -snpandp, GWAS results, include two colums: SNPs and p-values; no header required
## -custom, plink binary format genotype files to compute pairwise LD between variants
## -glist, list of genes with coordinates, provided by vegas
## -G, gene prioritization; for pathway analysis use -P

/users/k1471250/tools/vegas2/vegas2.sh -G -snpandp hl_ma_nov18_vegas.txt \
-custom /scratch/users/k1471250/UKBB/grm/bed/ukb.ea \
-glist /users/k1471250/tools/vegas2/libs/glist-hg19.txt \
-chr ${chrom} \
-top 10 \
-upper 10 \
-lower 10 \
-out hl_ma_nov18_vegas_top10_10kb_chr${chrom}

