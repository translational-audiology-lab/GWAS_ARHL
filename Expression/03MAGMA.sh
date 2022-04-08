#== 03MAGMA.sh
#== Shuyang Yao, 20210108

# Steps:
# 1. filter sumstats: info>0.6, MAF>1%, get Neff=Neff_half
# 2. get *pval and *bed files as input for MAGMA
# 3. get annotation for MAGMA
# 4. get gene-level associations
# 5. run MAGMA for each expression dataset:
# (input data already prepared, 
# HCL: /Users/yaoshu/Proj/Genomic_tools/HCL/scripts/MAGMA/01get_top10_input.R
# Others: see repository: https://github.com/jbryois/scRNA_disease)
# GTEx_v8
# Zeisel
# Zeisel_lvl5
# HCL
sftp shuyangy@lisa.surfsara.nl
cd /home/shuyangy/sumstats/hl2020
put /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/hl_ma_nov18_rsID_NT.txt.gz

#--- script starts ---#

# 1. filter sumstats: info>0.6, MAF>1%, get Neff=Neff_half
cd /home/shuyangy/sumstats/hl2020

zcat hl_ma_nov18_rsID_NT.txt.gz | \
awk 'NR==1 || $6>0.01 && $6 <0.99 {print $0}' OFS='\t' > hl2020_filtered.txt
# 7683540 after filtering (8244938 before filtering)

# 2. get *pval and *bed files as input for MAGMA
cd /home/shuyangy/sumstats/hl2020
python /home/shuyangy/PGCMDD3/scRNA_disease/Code_Paper/utils/fast_match.py \
-b /home/shuyangy/MAGMA1.08/g1000_eur/g1000_eur.bim \
-bcols 1,0,3 \
-g hl2020_filtered.txt \
-gcols 2,8,9
# output: file 1 *.pval; file 2 *bed

# 3. get annotation for MAGMA
cd /home/shuyangy/sumstats/hl2020
/home/shuyangy/MAGMA1.08/magma --annotate window=35,10 --snp-loc hl2020_filtered.txt.bed \
--gene-loc /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/Ref_data/NCBI37.3.gene.loc.extendedMHCexcluded \
--out hl2020.annotated_35kbup_10_down

# 4. get gene-level associations
cd /home/shuyangy/sumstats/hl2020
/home/shuyangy/MAGMA1.08/magma --bfile /home/shuyangy/MAGMA1.08/g1000_eur/g1000_eur \
--pval hl2020_filtered.txt.pval ncol=3 \
--gene-annot hl2020.annotated_35kbup_10_down.genes.annot \
--out hl2020.annotated_35kbup_10_down

# 5. run MAGMA for each expression dataset:
hl2020="/home/shuyangy/sumstats/hl2020/hl2020.annotated_35kbup_10_down.genes.raw"
# GTEx_v8
cd /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/GTEx_v8/results
cell_type="../top10.txt"
/home/shuyangy/MAGMA1.08/magma --gene-results  $hl2020 --set-annot  $cell_type --out hl2020
# Zeisel
cd /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/Zeisel/results
cell_type="../top10.txt"
/home/shuyangy/MAGMA1.08/magma --gene-results  $hl2020 --set-annot  $cell_type --out hl2020
# Zeisel_lvl5
cd /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/Zeisel_lvl5/results
cell_type="../top10.txt"
/home/shuyangy/MAGMA1.08/magma --gene-results  $hl2020 --set-annot  $cell_type --out hl2020
# HCL
cd /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/HCL/results
cell_type="../top10.txt"
/home/shuyangy/MAGMA1.08/magma --gene-results  $hl2020 --set-annot  $cell_type --out hl2020

# 6. download results to local
sftp shuyangy@lisa.surfsara.nl
cd /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/GTEx_v8/results
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03MAGMA/GTEx_v8
get hl2020.gsa.out
cd /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/Zeisel/results
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03MAGMA/Zeisel
get hl2020.gsa.out
cd /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/Zeisel_lvl5/results
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03MAGMA/Zeisel_lvl5
get hl2020.gsa.out
cd /home/shuyangy/PGCMDD3/analysis_sy/MAGMA/HCL/results
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03MAGMA/HCL
get hl2020.gsa.out

