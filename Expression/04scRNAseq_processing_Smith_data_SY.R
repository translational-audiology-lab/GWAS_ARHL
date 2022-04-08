#- filename: scRNAseq_processing_Smith_data_SY.R
#- author: Natalia Trpchevska (natalia.trpchevska@ki.se), 
#- modification: by Shuyang Yao (shuyang.yao@ki.se), date: 20211001
#- aim: calculate specificity, generate LDSC and MAGMA in put for this dataset.

library(tidyverse)
library(data.table)
library(stringr)
outpath <- "/Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/202110/"

data <- read.table("/Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/202110/expression.tab",header = T)
head(data)

colnames(data)
head(data)


dat_long <- reshape2::melt(data)
head(dat_long)
colnames(dat_long) <- c("ensemble_ID", "celltype", "exp" )
dat_long <- dat_long %>% 
  separate(celltype, "_", into=c("cell_type_new"), remove=FALSE)
unique(dat_long$cell_type_new)
head(dat_long)
str(dat_long)
dat <- dat_long %>%
  group_by(ensemble_ID, cell_type_new) %>%
  summarise(exp=sum(exp)) 
head(dat)
dim(dat) #51990 x 3

#- keep only mouse to human 1to1 mapped orthologs
m2h <- read.table("/Users/yaoshu/Proj/Genomic_tools/scRNA_disease/Code_Paper/Data/m2h_ENSMUS.txt", header = T, sep = ",") %>% 
  select(ENSMUSGid,entrez) %>% rename(ENTREZ=entrez)
dat <- dat %>% filter(ensemble_ID %in% m2h$ENSMUSGid)
dim(dat) #39876 x 3
head(dat)

#- fill in NAs with 0:
tmp <- dat %>% spread(cell_type_new,exp)
tmp[is.na(tmp)] <- 0
dat <- tmp %>% gather(cellType, exp, -ensemble_ID) 
dim(dat) #39876 x 3 # indication: thre was no missing rows due to NA in the previous step 

#- remove duplicated genes
tmp.dup <- dat %>% add_count(ensemble_ID) %>% filter(n!=3)
unique(tmp.dup$n) # only 3, 3 cell types, no duplicated genes

#- remove genes not expressed in any cell type
tmp.noexp <- dat %>% 
  group_by(ensemble_ID) %>% 
  summarise(sum_exp=sum(exp)) %>%
  filter(sum_exp==0)
dim(tmp.noexp) # 0 rows

# standardize to 1M molecules per cell type
dat <- dat %>%
  group_by(cellType) %>%
  mutate(exp_tpm=exp*1e6/sum(exp)) %>%
  ungroup()
head(dat)

# 3. Calculate specificity  
dat <- dat %>%
  group_by(ensemble_ID) %>%
  mutate(specificity=exp_tpm/sum(exp_tpm)) %>%
  ungroup()
head(dat)

# get human gene name
dat <- dat %>% inner_join(m2h, by=c("ensemble_ID"="ENSMUSGid"))

gene_coordinates <- 
  read_tsv("/Users/yaoshu/Proj/Genomic_tools/scRNA_disease/Code_Paper/Data/NCBI/NCBI37.3.gene.loc.extendedMHCexcluded",
           col_names = FALSE,col_types = 'cciicc') %>%
  mutate(start=as.integer(ifelse(X3-100000<0,0,X3-100000)),
         end=as.integer(X4+100000)) %>%
  select(X2,start,end,1) %>% 
  rename(chr="X2", ENTREZ="X1") %>% 
  mutate(chr=paste0("chr",chr))
head(gene_coordinates)
class(dat$ENTREZ) = "character"

dat <- dat %>% inner_join(gene_coordinates, by="ENTREZ") 

head(dat)
dim(dat) # 39396 x 9

fwrite(dat, paste0(outpath,"gene_specificity.tsv"), 
       sep="\t", col.names = T)



n_genes <- length(unique(dat$ENTREZ))
n_genes_to_keep <- (n_genes * 0.1) %>% round()


magma_top10 <- function(d,Cell_type){
  d_spe <- d %>% group_by_(Cell_type) %>% top_n(.,n_genes_to_keep,specificity) 
  d_spe %>% do(write_group_magma(.,Cell_type))
}
write_group_magma  = function(df,Cell_type) {
  df <- select(df,Cell_type,ENTREZ)
  df_name <- make.names(unique(df[1]))
  colnames(df)[2] <- df_name  
  dir.create(paste0("MAGMA/"), showWarnings = FALSE)
  select(df,2) %>% t() %>% as.data.frame() %>% rownames_to_column("Cat") %>%
    write_tsv("MAGMA/top10.txt",append=T)
  return(df)
}

write_group  = function(df,Cell_type) {
  df <- select(df,Cell_type,chr,start,end,ENTREZ)
  dir.create(paste0("LDSC/Bed"), showWarnings = FALSE,recursive = TRUE)
  write_tsv(df[-1],paste0("LDSC/Bed/",make.names(unique(df[1])),".bed"),col_names = F)
  return(df)
}
ldsc_bedfile <- function(d,Cell_type){
  d_spe <- d %>% group_by_(Cell_type) %>% top_n(.,n_genes_to_keep,specificity) 
  d_spe %>% do(write_group(.,Cell_type))
}
setwd(outpath)
system("rm -r MAGMA")
dat %>% filter(exp_tpm>1) %>% magma_top10("cellType")
system("rm -r LDSC")
dat %>% filter(exp_tpm>1) %>% ldsc_bedfile("cellType")

#--- end ---#