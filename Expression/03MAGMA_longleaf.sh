#== 03MAGMA.sh
#== Shuyang Yao, 20210108

# Steps:
# 1. filter sumstats: info>0.6, MAF>1%, get Neff=Neff_half
# 2. get *pval and *bed files as input for MAGMA
# 3. get annotation for MAGMA
# 4. get gene-level associations
# 5. run MAGMA for each expression dataset:
# Smith (got expression data from Natalia; generated input 20211002)

sftp shuyao@longleaf.unc.edu
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/original
put /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/hl_ma_nov18_rsID_NT.txt.gz

# update 211003: Smith snRNA-seq data
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/03MAGMA/
put /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/202110/MAGMA/top10.txt

#--- script starts ---#

# 1. filter sumstats: info>0.6, MAF>1%, get Neff=Neff_half
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/original

zcat hl_ma_nov18_rsID_NT.txt.gz | \
awk 'NR==1 || $6>0.01 && $6 <0.99 {print $0}' OFS='\t' > ../processed/hl2020_filtered.txt
# 7683540 after filtering (8244938 before filtering)

# 2. get *pval and *bed files as input for MAGMA
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed
python /nas/depts/007/sullilab/shared/sy/scRNA_disease/Code_Paper/utils/fast_match.py \
-b /nas/depts/007/sullilab/shared/sy/MAGMA/Ref_data/g1000_eur.bim \
-bcols 1,0,3 \
-g hl2020_filtered.txt \
-gcols 2,8,9
# output: file 1 *.pval; file 2 *bed

# 3. get annotation for MAGMA
module load magma/1.08
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed
magma --annotate window=35,10 --snp-loc hl2020_filtered.txt.bed \
--gene-loc /nas/depts/007/sullilab/shared/sy/MAGMA/Ref_data/NCBI37.3.gene.loc.extendedMHCexcluded \
--out /nas/depts/007/sullilab/shared/sy/hearing_loss2020/03MAGMA/hl2020.annotated_35kbup_10_down

# 4. get gene-level associations
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/03MAGMA
magma --bfile /nas/depts/007/sullilab/shared/sy/MAGMA/Ref_data/g1000_eur \
--pval /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed/hl2020_filtered.txt.pval ncol=3 \
--gene-annot hl2020.annotated_35kbup_10_down.genes.annot \
--out hl2020.annotated_35kbup_10_down

# 5. run MAGMA for each expression dataset:
hl2020="/nas/depts/007/sullilab/shared/sy/hearing_loss2020/03MAGMA/hl2020.annotated_35kbup_10_down.genes.raw"
# Smith
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/03MAGMA/smith
cell_type="top10.txt"
magma --gene-results  $hl2020 --set-annot  $cell_type --out hl2020


# 6. download results to local
sftp shuyao@longleaf.unc.edu
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/03MAGMA/smith
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03MAGMA/smith
get hl2020.gsa.out
