#!/bin/bash

#SBATCH -p general
#SBATCH -N 1
#SBATCH -n 1
#SBATCH --mem=32g
#SBATCH -t 02-00:00:00



#=== 04ldsc_rg.sh, by SY 06/2019
## 1. write a loop to do rg of each trait against all.
## steps:
# load ldsc, read source
# set variables: the number of traits; list of traits
# start a loop,
 # pick one trait at a time
 # do ldsc.py --rg
# end loop

# load ldsc, read source
module load ldsc
source /nas/depts/007/sullilab/shared/gwasOmnibus/00common/var.def.sh

# set variables: the number of traits; list of traits
cd ${TO}
NRTRAITS=$(ls *gz | wc -l)
TRAITS=$(ls *gz | tr '\n' ',' | sed 's/,$//')
## check if they are correct
echo $NRTRAITS
echo $TRAITS

# start a loop, each time, pick one trait, do --rg against all (including itself)
cd ${TO}
ldsc.py \
--ref-ld-chr /nas/depts/007/sullilab/shared/bin/ldsc/eur_w_ld_chr/ \
--w-ld-chr   /nas/depts/007/sullilab/shared/bin/ldsc/eur_w_ld_chr/ \
--out /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed/rg.hl2020.gwasOmnibus \
--rg /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed/hl2020.sumstats.gz,${TRAITS}
done

# check result files.

# download
scp shuyao@longleaf.unc.edu:"/nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed/rg.hl2020.gwasOmnibus.log" /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/02rg_gwasOmnibus
cd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/02rg_gwasOmnibus
# fix format
grep -h 'p1 ' rg.hl2020.gwasOmnibus.log > rg.hl2020.gwasOmnibus.txt
cat rg.hl2020.gwasOmnibus.log | grep "/nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed/hl2020.sumstats.gz" | tail -41 >> rg.hl2020.gwasOmnibus.txt
# change name
mv rg.hl2020.gwasOmnibus.txt 02rg.hl2020.gwasOmnibus.txt