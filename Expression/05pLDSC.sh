#== 03pLDSC.sh
#== Shuyang Yao, 20201221

### NOTE ### Probably need to activate every time log on to lisa: 
cd /home/shuyangy/ldsc
conda env update --file environment.yml
conda activate ldsc


#--- script starts ---#

# update LDSC environment every time
cd /home/shuyangy/ldsc
conda env update --file environment.yml
conda activate ldsc

#===================
# HCL transfer
ssh -X shuyao@rc-dm2.its.unc.edu
# ssh -A shuyangy@lisa.surfsara.nl
# exit
sftp shuyangy@lisa.surfsara.nl
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL
lcd /nas/depts/007/sullilab/shared/sy/sy_pldsc/HCL/Bed
# put -r 1/bed* 1/
# copy bed files for all 53 filders

#= get ready scripts
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC
cp get_*_tissue_v2_lisa.sh GTEx_v8/
cp get_*_tissue_v2_lisa.sh Zeisel/
cp get_*_tissue_v2_lisa.sh Zeisel_lvl5/
for ((i=1; i<=53; i++))
do 
cp get_*_tissue_v2_lisa.sh HCL/${i}/
done

#= 1. prepare ldsc for annotations:
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/GTEx_v8
sbatch -t 13:00:00 -n 4 -N 1 -o log_get_annot_ld_scores_tissue --wrap="sh get_annotation_ldscores_tissue_v2_lisa.sh"

cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/Zeisel
sbatch -t 20:00:00 -n 4 -N 1 -o log_get_annot_ld_scores_tissue --wrap="sh get_annotation_ldscores_tissue_v2_lisa.sh"

cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/Zeisel_lvl5
sbatch -t 48:00:00 -n 4 -N 1 -o log_get_annot_ld_scores_tissue --wrap="sh get_annotation_ldscores_tissue_v2_lisa.sh"

cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL
for ((i=1; i<=53; i++))
do 
cd ${i}
sbatch -t 9:00:00 -n 4 -N 1 -o log_get_annot_ld_scores_tissue --wrap="sh get_annotation_ldscores_tissue_v2_lisa.sh"
cd ..
done

#= 2. partitioned h2 for hl2020:
hl2020=/home/shuyangy/sumstats/hl2020.sumstats.gz
# GTEx_v8
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/GTEx_v8
sbatch -t 1:00:00 -n 4 -N 1 -o log_get_partitioned_tissue_h2_hl2020 --mail-type=end --mail-user=shuyang.yao@ki.se --wrap="sh get_partitioned_h2_tissue_v2_lisa.sh $hl2020"
# Zeisel
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/Zeisel
sbatch -t 1:00:00 -n 4 -N 1 -o log_get_partitioned_tissue_h2_hl2020 --mail-type=end --mail-user=shuyang.yao@ki.se --wrap="sh get_partitioned_h2_tissue_v2_lisa.sh $hl2020"
# Zeisel_lvl5
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/Zeisel_lvl5
sbatch -t 1:00:00 -n 4 -N 1 -o log_get_partitioned_tissue_h2_hl2020 --mail-type=end --mail-user=shuyang.yao@ki.se --wrap="sh get_partitioned_h2_tissue_v2_lisa.sh $hl2020"
# HCL
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL
for ((i=1;i<=53;i++))
do 
cd ${i}
sbatch -t 1:00:00 -n 4 -N 1 -o log_get_partitioned_tissue_h2_hl2020 --wrap="sh get_partitioned_h2_tissue_v2_lisa.sh $hl2020"
cd ..
done


#= 3. download results 
sftp shuyangy@lisa.surfsara.nl
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/GTEx_v8
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/GTEx_v8
get hl2020*results

cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/Zeisel
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/Zeisel
get hl2020*results

cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/Zeisel_lvl5
lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/Zeisel_lvl5
get hl2020*results

lcd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/HCL
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/1
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/2
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/3
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/4
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/5
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/6
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/7
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/8
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/9
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/10
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/11
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/12
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/13
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/14
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/15
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/16
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/17
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/18
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/19
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/20
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/21
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/22
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/23
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/24
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/25
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/26
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/27
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/28
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/29
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/30
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/31
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/32
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/33
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/34
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/35
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/36
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/37
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/38
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/39
get hl2020*results

cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/40
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/41
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/42
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/43
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/44
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/45
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/46
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/47
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/48
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/49
get hl2020*results

cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/50
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/51
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/52
get hl2020*results
cd /home/shuyangy/PGCMDD3/analysis_sy/pLDSC/HCL/53
get hl2020*results


#= 3. tidy up
# cd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/GTEx_v8
# head -1 hl2020_Adipose.Tissue.bed_gazal_dir.results | tr -s ' ' | tr ' ' '\t' > 03hl2020_GTEXv8_500bpext.all.tsv
# head -1 hl2020_Adipose.Tissue.bed_gazal_dir.results | tr -s ' ' | tr ' ' '\t' > 03hl2020_GTEXv8.all.tsv
# for i in *results; do tail -2 ${i} | head -1 | tr -s ' ' | tr ' ' '\t' >> 03hl2020_GTEXv8.all.tsv; done
# for i in *results; do tail -1 ${i} | tr -s ' ' | tr ' ' '\t' >> 03hl2020_GTEXv8_500bpext.all.tsv; done
# 
# cd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/Zeisel
# head -1 hl2020_Astrocytes.bed_gazal_dir.results | tr -s ' ' | tr ' ' '\t' > 03hl2020_Zeisel_500bpext.all.tsv
# head -1 hl2020_Astrocytes.bed_gazal_dir.results | tr -s ' ' | tr ' ' '\t' > 03hl2020_Zeisel.all.tsv
# for i in *results; do tail -2 ${i} | head -1 | tr -s ' ' | tr ' ' '\t' >> 03hl2020_Zeisel.all.tsv; done
# for i in *results; do tail -1 ${i} | tr -s ' ' | tr ' ' '\t' >> 03hl2020_Zeisel_500bpext.all.tsv; done
# 
# cd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/Zeisel_lvl5
# head -1 hl2020_ABC.bed_gazal_dir.results | tr -s ' ' | tr ' ' '\t' > 03hl2020_Zeisel_lvl5_500bpext.all.tsv
# head -1 hl2020_ABC.bed_gazal_dir.results | tr -s ' ' | tr ' ' '\t' > 03hl2020_Zeisel_lvl5.all.tsv
# for i in *results; do tail -2 ${i} | head -1 | tr -s ' ' | tr ' ' '\t' >> 03hl2020_Zeisel_lvl5.all.tsv; done
# for i in *results; do tail -1 ${i} | tr -s ' ' | tr ' ' '\t' >> 03hl2020_Zeisel_lvl5_500bpext.all.tsv; done
# 
# cd /Users/yaoshu/Proj/_Other/Hearing_loss2020/results/03pLDSC/HCL
# head -1 hl2020_AdultAdipose_Adipocyte_FGR_high.bed_gazal_dir.results | tr -s ' ' | tr ' ' '\t' > 03hl2020_HCL_500bpext.all.tsv
# head -1 hl2020_AdultAdipose_Adipocyte_FGR_high.bed_gazal_dir.results | tr -s ' ' | tr ' ' '\t' > 03hl2020_HCL.all.tsv
# for i in *results; do tail -2 ${i} | head -1 | tr -s ' ' | tr ' ' '\t' >> 03hl2020_HCL.all.tsv; done
# for i in *results; do tail -1 ${i} | tr -s ' ' | tr ' ' '\t' >> 03hl2020_HCL_500bpext.all.tsv; done

#== end ==#