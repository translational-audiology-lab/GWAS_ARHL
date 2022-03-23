#!/bin/bash

#SBATCH -A sens2017552
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 08:00:00
#SABTCH -J Clean_meta_noGC



module load R_packages/3.6.1

Rscript clean_meta_HL_noukbb.R
