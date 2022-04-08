######## Manhattan plot for MAGMA/VEGAS
setwd("/scratch/users/k1471250/hear.charge/miami/")
source("mhtnew.R")

magma<-read.table("magma.genes.out",h=T,stringsAsFactors=F)
vegas<-read.csv("hl_ma_nov18_vegas2_genes_2.csv",stringsAsFactors=F)

genes<-magma$SYMBOL[which(magma$P<2.66e-06)] # 87

vegas<-vegas[vegas$Gene%in%genes & vegas$Bonferroni<0.05,] # 41

topHits<-magma[magma$SYMBOL%in%vegas$Gene,]

pdf("magma_vegas.pdf",w=10)
mht2(magma,p="P",chr="CHR",bp="START",snp="SYMBOL",
          suggestiveline = F, genomewideline = -log10(2.66e-06),
          TOP=magma$SYMBOL[magma$P<2.66e-06],
          over=vegas$Gene)
dev.off()
          
          
          
          