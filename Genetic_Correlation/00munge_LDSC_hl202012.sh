#= 00munge_LDSC_HL202012.sh
#= Shuyang Yao 20201216

#= 00. put HL data on longleaf
scp /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/hl_ma_nov18_rsID_NT.txt.gz

#= 00. munge
cd /nas/depts/007/sullilab/shared/gwasOmnibus/02traits/hl2020/
ln -s /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/original/hl_ma_nov18_rsID_NT.txt.gz .

# check
zcat hl_ma_nov18_rsID_NT.txt.gz | wc -l ## 8244938
zcat hl_ma_nov18_rsID_NT.txt.gz | awk '{print NF}' | sort | uniq -c ## 10

#- munge in LDSC
module load ldsc
munge_sumstats.py \
--out /nas/depts/007/sullilab/shared/gwasOmnibus/03sumstats/hl2020 \
--merge-alleles /nas/depts/007/sullilab/shared/bin/ldsc/w_hm3.snplist \
--sumstats /nas/depts/007/sullilab/shared/gwasOmnibus/02traits/hl2020/hl_ma_nov18_rsID_NT.txt.gz \
--N-col N \
--snp SNP \
--signed-sumstats BETA,0

#--- 1181634 SNPs after munge
