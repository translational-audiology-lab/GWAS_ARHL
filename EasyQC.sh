#!/bin/bash


#SBATCH -A sens2017552
#SBATCH -p core
#SBATCH -n 4
#SBATCH -t 04:00:00
#SBATCH -J EasyQC_Tin_UKBB



module load R_packages/3.6.1

Rscript easyQC.r
