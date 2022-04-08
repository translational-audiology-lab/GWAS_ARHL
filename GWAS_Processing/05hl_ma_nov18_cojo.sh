#!/bin/bash

#SBATCH --ntasks=10
#SBATCH --mem=100G
#SBATCH --array=1-22
#SBATCH --job-name=HL.cojo
#SBATCH --time=7-0

chrom=${SLURM_ARRAY_TASK_ID}

cd /scratch/users/k1471250/hear.charge/cleaned/MA/nov18/cojo/

DIRgcta=/users/k1471250/tools/gcta/gcta_1.93.2beta/
DIRbed=/scratch/users/k1471250/UKBB/studies/bp.by.sex/chron/gwas2/age/cojo/50k.cojo/

### cojo requies a reference dataset
### here, I used 50,000 random Europeans from UK Biobank
### maf, minor allele frequency
### cojo-p, p-value threshold for significance
### cojo-file, file with GWAS results 
### must include headers: SNP, A1, A2, freq, b, se, p, N

$DIRgcta/gcta64 \
   --bfile $DIRbed/50k_chr${chrom} \
   --maf 0.0001 --cojo-slct --cojo-p 5e-8 \
   --cojo-file hl_ma_nov18_cojo.txt \
   --out out/tmp_chr${chrom} \
   --threads 10
