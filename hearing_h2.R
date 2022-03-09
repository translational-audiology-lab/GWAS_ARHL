## do this just once
RS<-list()
path<-"/Users/nattrp/OneDrive - KI.SE/Mac/Desktop/GWAS_meta/eur_w_ld_chr/"  # path to ldscore.gz files
for (i in 1:22) {
fname<-paste(path,i, ".l2.ldscore.gz",sep="")
RS[[i]]<-read.table(gzfile(fname),h=T,stringsAsFactors=F) 
print(i)
}
RS<-do.call(rbind,RS)
 
RS$SNPID<-paste(RS$CHR,RS$BP,sep=":") 

save(RS,file="rsIDs_EU.RData") # keep it

### add rsIDs to clean file
setwd("/Users/nattrp/OneDrive - KI.SE/Mac/Desktop/CLEANED_files/")

load("rsIDs_EU.RData") # load object created above 

# read cleaned files

fls<-list.files(pattern="CLEANED")

fls<-fls[-grep("AFR",fls)]
fls<-fls[-grep("BLACK",fls)]

for (f in fls) {
tmp<-read.table(gzfile(f),h=T,stringsAsFactors=F)
tmp<-read.table("GWAS_metal_result_HL_Apr14_gc_noUKBB1.TBL.gz", h=T, stringsAsFactors = F)
tmp<-merge(RS[,c("SNPID","SNP")],tmp,by.x="SNPID",by.y="MarkerName") 

# save file for CTG-VL
tmp$SNPID<-tmp$STRAND<-tmp$MAC<-tmp$IMPUTATION<-NULL
colnames(tmp)[c(2:4,7,10)]<-c("A1","A2","FREQ","P","BP")
write.table(tmp,file=paste(f,"CTGVL.txt",sep="_"),col.names=T,row.names=F,quote=F)
write.table(tmp, "GWAS_HL_MA_noUKBB.txt", sep = "\t", col.names = T, row.names = F, quote = F)
print(paste(grep(f,fls),"of",length(fls),sep=" "))
}


#### for Africans, let's use my files
RS<-read.table(gzfile("/scratch/users/k1471250/UKBB/ldsc/afr/afr500_LDscore.gz"),h=T,stringsAsFactor=F) 
RS$SNPID<-paste(RS$CHR,RS$BP,sep=":") 

save(RS,file="rsIDs_AFR.RData") # keep it

### add rsIDs to clean file
setwd("/scratch/users/k1471250/hear.charge/cleaned/")

load("rsIDs_AFR.RData") # load object created above 

# read cleaned files

fls<-list.files(pattern="CLEANED")

fls<-fls[c(grep("AFR",fls),grep("BLACK",fls))]

for (f in fls) {
tmp<-read.table(gzfile(f),h=T,stringsAsFactors=F)

tmp<-merge(RS[,c("SNPID","SNP")],tmp,by.x="SNPID",by.y="cptid") 

# save file for CTG-VL
tmp$SNPID<-tmp$STRAND<-tmp$MAC<-tmp$IMPUTATION<-NULL
colnames(tmp)[c(2:4,7,10)]<-c("A1","A2","FREQ","P","BP")
write.table(tmp,file=paste(f,"CTGVL.txt",sep="_"),col.names=T,row.names=F,quote=F)
print(paste(grep(f,fls),"of",length(fls),sep=" "))
}

