#!/bin/bash

#SBATCH -A sens2017552
#SBATCH -p node
#SBATCH -n 6
#SBATCH -t 04:00:00
#SBATCH -J extract_top_hits


module load R_packages/3.6.1
Rscript extract_tophits.R
