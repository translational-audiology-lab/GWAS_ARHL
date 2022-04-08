#== 03pLDSC_longleaf.sh
#== Shuyang Yao, 20211003

#--- script starts ---#

# get data in place
sftp shuyao@longleaf.unc.edu
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/03LDSC/smith/Bed
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/202110/LDSC/Bed
put *

# set up environment
module load ldsc/1.0.0
module load bedtools/2.25.0
module load r/3.4.1
# specify my LDSC pipeline path
LDSC_Folder=/nas/depts/007/sullilab/shared/sy/hearing_loss2020/03LDSC/smith/

#===================
# munge
#cd $LDSC_Folder
#munge_sumstats.py \
#--out /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed/hl2020 \
#--merge-alleles /nas/depts/007/sullilab/shared/partitioned_LDSC/w_hm3.snplist \
#--sumstats /nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/original/hl_ma_nov18_rsID_NT.txt.gz

GWAS_Sumatats=/nas/depts/007/sullilab/shared/sy/hearing_loss2020/00data/processed/

#===================
# enrichment, prepare files and scripts
cd $LDSC_Folder
ln -s Bed/*bed .
cp /nas/depts/007/sullilab/shared/partitioned_LDSC/get_annotation_ldscores_tissue_v2_longleaf.sh ${LDSC_Folder}/
cp /nas/depts/007/sullilab/shared/partitioned_LDSC/get_partitioned_h2_tissue_v2_longleaf.sh ${LDSC_Folder}/

#= 1. prepare ldsc for annotations:
cd $LDSC_Folder
sbatch -t 1:00:00 -n 4 -N 1 -o log_get_annot_ld_scores_tissue --wrap="sh get_annotation_ldscores_tissue_v2_longleaf.sh"

#= 2. partitioned h2 for hl2020:
cd $LDSC_Folder
hl=$GWAS_Sumatats/hl2020.sumstats.gz
# tissue code:
sbatch -t 1:00:00 -n 4 -N 1 -o log_get_partitioned_tissue_h2_hl --wrap="sh get_partitioned_h2_tissue_v2_longleaf.sh $hl"


#= 3. download results 
sftp shuyao@longleaf.unc.edu
cd /nas/depts/007/sullilab/shared/sy/hearing_loss2020/03LDSC/smith
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/smith
get hl*results

#== end ==#