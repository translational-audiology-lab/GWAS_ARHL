# 01LDSC_hl2020_h2.sh
# Shuyang.yao@ki.se 20201216
# aim: run LDSC on munged hl2020 GWAS sumstats to get SNP-h2 (observed level)

#= 1. LDSC for h2
ldsc.py \
--h2 /nas/depts/007/sullilab/shared/gwasOmnibus/03sumstats/hl2020.sumstats.gz \
--ref-ld-chr /nas/depts/007/sullilab/shared/bin/ldsc/eur_w_ld_chr/ \
--w-ld-chr /nas/depts/007/sullilab/shared/bin/ldsc/eur_w_ld_chr/ \
--out hl2020_h2

less hl2020_h2.log
#--- Total Observed scale h2: 0.0252 (0.0013)

# copy hl2020_h2.log to local folder: /Users/yaoshu/Proj/_Other/Hearing_loss2020/results
scp shuyao@longleaf.unc.edu:/nas/depts/007/sullilab/shared/gwasOmnibus/02traits/hl2020/hl2020_h2.log /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/01ldsc_hl2020_h2.log

# copy munged sumstats to local folder: /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed
scp shuyao@longleaf.unc.edu:/nas/depts/007/sullilab/shared/gwasOmnibus/03sumstats/hl2020.sumstats.gz /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/
