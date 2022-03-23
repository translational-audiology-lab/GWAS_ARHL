# Read in meta-analysis output
a<-read.table("GWAS_metal_result_tin_noGC_NT1.TBL.gz",header=T,sep="\t")
#creating chr/position columns
library(tidyr)
a<-separate(a, col = MarkerName, into = c("Chromosome", "Position"), sep = ":")

# Create number of studies
a$studies<-a$HetDf+1

# Determine maximum number of studies
max.studies<-max(a$studies)

# Determine half of the maximum number of studies
filter1<-max.studies/2

# Determine the maxinum of sample size
max.sample<-max(a$N)

# Determine half of the maximum sample size
filter2<-max.sample/2

# Subset meta-analysis results
a1<-a[a$studies>=filter1 & a$N>=filter2,]

# Remove studies column
a2<-a1[c(-19)]

# change chrX to chr23
a2$Chromosome <- gsub("X", "23", a2$Chromosome)
a2$Chromosome <- as.numeric(a2$Chromosome)
a2$Position <- as.numeric(a2$Position)
# load library
library(qqman)

# Manhattan plot
bitmap("Manhattan_tin_MA.jpeg",w=16,h=10)
manhattan(a2, chr = "Chromosome", bp = "Position", p = "P.value", col = c("gray10","gray60"),chrlabs=c(1:22,"X"),suggestiveline=-log10(5e-06),
genomewideline=-log10(5e-08),highlight=NULL,logp=TRUE)
dev.off()

# QQ plot
bitmap("QQ_tin_MA.jpeg",w=16,h=10)
qq(a2$P.value)
dev.off()

# Write clean meta-analysis output
write.table(a2,file="CLEAN.GWAS_metal_result_tin_MA.txt",quote=F,row.names=F,sep='\t')

