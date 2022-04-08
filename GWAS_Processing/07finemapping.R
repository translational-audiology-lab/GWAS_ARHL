######## Finemapping for HL
######## Pipeline described here 
######## https://github.com/mulinlab/CAUSALdb-finemapping-pip
######## Use region 

library(readxl)

setwd("/scratch/users/k1471250/hear.charge/finemap/")
load("hl_ma_nov18.RData")
tmp<-do.call(rbind,lapply(x$MarkerName,function(a)
                                               {tmp<-strsplit(a,split=":")
                                               chr<-unlist(tmp)[1]
                                               bp<-unlist(tmp)[2]
                                               out<-c(chr,bp)}))
w<-which(tmp[,1]=="X")
tmp[w,1]<-"23"
x$chr<-as.numeric(tmp[,1]) # some crazy codes will be NA'd
x$bp<-as.numeric(tmp[,2])

loci<-as.data.frame(read_excel("Table 1. Genomic Loci.xlsx",sheet=1))
loci$MarkerName<-paste(loci$chr,loci$pos,sep=":")

input<-function(locus,dista=500000) {
         chr<-loci$chr[loci$MarkerName%in%locus]
         snp<-loci$SNP[loci$MarkerName%in%locus]
         
         tmp<-x[x$chr%in%chr,c("MarkerName","Allele1","Allele2","Freq1","Effect","StdErr","P.value","N","chr","bp")]
         tmp<-tmp[order(tmp$bp),]
         w<-which(tmp$MarkerName%in%locus)
         c0<-tmp$bp[w]-dista
         c1<-tmp$bp[w]+dista
         tmp<-tmp[tmp$bp%in%c(c0:c1),]
         
         N<-paste(max(tmp$N),median(tmp$N),sep="_")
         
         tmp<-tmp[,c("chr","bp","MarkerName","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
         colnames(tmp)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
         tmp$Zscore<-tmp$BETA/tmp$SE
         tmp$EA<-toupper(tmp$EA)
         tmp$NEA<-toupper(tmp$NEA)
         tmp$MAF<-NA
         
         fname<-paste(paste("input/",snp,sep=""),"_w.",2*dista,"_snp.",nrow(tmp),"_",N,".txt",sep="")
         write.table(tmp,file=fname,col.names=T,row.names=F,quote=F,sep="\t")
         print(snp)
         }

for(i in 1:nrow(loci)) input(loci$MarkerName[i],dista=50000)
for(i in 1:nrow(loci)) input(loci$MarkerName[i],dista=500000)

# save files for finemapping
# 1M
setwd("input/")
tmp<-list.files(pattern="06_snp")
a<-unlist(lapply(tmp,function(x)unlist(strsplit(x,split="_"))[5]))
a<-sub(".txt","",a)

tmp<-data.frame("python ../../CAUSALdb/fine_map_pipe.py -s",
                a,
                paste("input/",tmp,sep=""),
                "output1M")
setwd("../")
write.table(tmp,file="run_finemapping_1M.sh",col.names=F,row.names=F,quote=F,sep=" ")

# 100K
setwd("input/")
tmp<-list.files(pattern="05_snp")
a<-unlist(lapply(tmp,function(x)unlist(strsplit(x,split="_"))[5]))
a<-sub(".txt","",a)

tmp<-data.frame("python ../../CAUSALdb/fine_map_pipe.py -s",
                a,
                paste("input/",tmp,sep=""),
                "output100K")
setwd("../")
write.table(tmp,file="run_finemapping_100K.sh",col.names=F,row.names=F,quote=F,sep=" ")

######### Run the whole gene

#rs9493627	6	133789728	Kalra (2020), Wells (2019)	[EYA4] G>S
#rs143282422	10	73377112	Wells (2019)	[CDH23] A>T
#rs35887622	13	20763620	no	[GJB2] M>T
#rs143796236	17	79495969	Ivarsdottir (2021)	[FSCN2] H>Y
#rs12980998	19	4217510	no	[ANKRD24] T>S
#rs61734651	20	61451332	no	[COL9A3] R>W
#rs5756795	22	38122122	Wells (2019)	[TRIOBP] F>I
#rs36062310	22	50988105	Kalra (2020), Wells (2019)	[KLHDC7B] V>M

setwd("/scratch/users/k1471250/hear.charge/finemap/")
load("/scratch/groups/dtr/Groups_WorkSpace/FrancesWilliams/EARGEN/MA/nov18/cojo/hl_ma_nov18_cojo_tmp.Robj")

##### EYA4
# chr6:133,562,495-133,853,266(GRCh37/hg19 by Entrez Gene)
gene<-hl.meta.gwas2[which(hl.meta.gwas2$CHR==6 & hl.meta.gwas2$BP>=133562495-1000 & hl.meta.gwas2$BP<=133853266+1000),]
gene<-gene[,c("CHR","BP","SNP","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
colnames(gene)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
gene$Zscore<-gene$BETA/gene$SE
gene$EA<-toupper(gene$EA)
gene$NEA<-toupper(gene$NEA)
gene$MAF<-NA

write.table(gene,file="genes/EYA4_chr6_896.txt",col.names=T,row.names=F,quote=F,sep="\t")

##### CDH23
# chr10:73,156,677-73,575,704
gene<-hl.meta.gwas2[which(hl.meta.gwas2$CHR==10 & hl.meta.gwas2$BP>=73156677-1000 & hl.meta.gwas2$BP<=73575704+1000),]
gene<-gene[,c("CHR","BP","SNP","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
colnames(gene)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
gene$Zscore<-gene$BETA/gene$SE
gene$EA<-toupper(gene$EA)
gene$NEA<-toupper(gene$NEA)
gene$MAF<-NA

write.table(gene,file="genes/CDH23_chr10_1420.txt",col.names=T,row.names=F,quote=F,sep="\t")

##### GJB2
# chr13:20,761,609-20,767,077
gene<-hl.meta.gwas2[which(hl.meta.gwas2$CHR==13 & hl.meta.gwas2$BP>=20761609-1000 & hl.meta.gwas2$BP<=20767077+1000),]
gene<-gene[,c("CHR","BP","SNP","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
colnames(gene)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
gene$Zscore<-gene$BETA/gene$SE
gene$EA<-toupper(gene$EA)
gene$NEA<-toupper(gene$NEA)
gene$MAF<-NA

write.table(gene,file="genes/GJB2_chr10_21.txt",col.names=T,row.names=F,quote=F,sep="\t")

###### FSCN2
# chr17:79,495,403-79,504,156
gene<-hl.meta.gwas2[which(hl.meta.gwas2$CHR==17 & hl.meta.gwas2$BP>=79495403-1000 & hl.meta.gwas2$BP<=79504156+1000),]
gene<-gene[,c("CHR","BP","SNP","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
colnames(gene)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
gene$Zscore<-gene$BETA/gene$SE
gene$EA<-toupper(gene$EA)
gene$NEA<-toupper(gene$NEA)
gene$MAF<-NA

write.table(gene,file="genes/FSCN2_chr17_21.txt",col.names=T,row.names=F,quote=F,sep="\t")

###### ANKRD24
# chr19:4,183,351-4,224,811
gene<-hl.meta.gwas2[which(hl.meta.gwas2$CHR==19 & hl.meta.gwas2$BP>=4183351-1000 & hl.meta.gwas2$BP<=4224811+1000),]
gene<-gene[,c("CHR","BP","SNP","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
colnames(gene)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
gene$Zscore<-gene$BETA/gene$SE
gene$EA<-toupper(gene$EA)
gene$NEA<-toupper(gene$NEA)
gene$MAF<-NA

write.table(gene,file="genes/ANKRD24_chr19_179.txt",col.names=T,row.names=F,quote=F,sep="\t")

###### COL9A3
# chr20:61,448,402-61,472,511
gene<-hl.meta.gwas2[which(hl.meta.gwas2$CHR==20 & hl.meta.gwas2$BP>=61448402-1000 & hl.meta.gwas2$BP<=61472511+1000),]
gene<-gene[,c("CHR","BP","SNP","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
colnames(gene)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
gene$Zscore<-gene$BETA/gene$SE
gene$EA<-toupper(gene$EA)
gene$NEA<-toupper(gene$NEA)
gene$MAF<-NA

write.table(gene,file="genes/COL9A3_chr20_143.txt",col.names=T,row.names=F,quote=F,sep="\t")

###### TRIOBP
# chr22:38,093,055-38,172,563
gene<-hl.meta.gwas2[which(hl.meta.gwas2$CHR==22 & hl.meta.gwas2$BP>=38093055-1000 & hl.meta.gwas2$BP<=38172563+1000),]
gene<-gene[,c("CHR","BP","SNP","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
colnames(gene)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
gene$Zscore<-gene$BETA/gene$SE
gene$EA<-toupper(gene$EA)
gene$NEA<-toupper(gene$NEA)
gene$MAF<-NA

write.table(gene,file="genes/TRIOBP_chr22_212.txt",col.names=T,row.names=F,quote=F,sep="\t")

###### KLHDC7B
# chr22:50,984,328-50,989,452
gene<-hl.meta.gwas2[which(hl.meta.gwas2$CHR==22 & hl.meta.gwas2$BP>=50984328-1000 & hl.meta.gwas2$BP<=50989452+1000),]
gene<-gene[,c("CHR","BP","SNP","Freq1","Allele1","Allele2","Effect","StdErr","P.value")]
colnames(gene)<-c("CHR","BP","rsID","MAF","EA","NEA","BETA","SE","P")
gene$Zscore<-gene$BETA/gene$SE
gene$EA<-toupper(gene$EA)
gene$NEA<-toupper(gene$NEA)
gene$MAF<-NA

write.table(gene,file="genes/KLHDC7B_chr22_37.txt",col.names=T,row.names=F,quote=F,sep="\t")

