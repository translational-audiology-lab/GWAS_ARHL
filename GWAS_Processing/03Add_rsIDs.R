RS<-list()
path<-"/Users/nattrp/OneDrive - KI.SE/Mac/Desktop/eur_w_ld_chr/"  # path to ldscore.gz files
for (i in 1:22) {
  fname<-paste(path,i, ".l2.ldscore.gz",sep="")
  RS[[i]]<-read.table(gzfile(fname),h=T,stringsAsFactors=F) 
  print(i)
}
RS<-do.call(rbind,RS)

RS$SNPID<-paste(RS$CHR,RS$BP,sep=":") 

save(RS,file="rsIDs_EU.RData") # keep it

### add rsIDs to clean file
setwd("/Users/nattrp/OneDrive - KI.SE/Mac/Desktop/")

load("rsIDs_EU.RData") # load object created above 

# read cleaned files

fls <- read.table("GWAS_meta/CLEAN.GWAS_metal_result_HL_Nov18_NT1.TBL.gz", header = T, sep = "\t")
fls$cptid <- NA

for (f in fls) {
  tmp<-read.table(gzfile(f),h=T,stringsAsFactors=F)
  
  tmp<-merge(RS[,c("SNPID","SNP")],tmp,by.x="SNPID",by.y="cptid") 
  
  # save file for CTG-VL
  tmp$SNPID<-tmp$STRAND<-tmp$MAC<-tmp$IMPUTATION<-NULL
  colnames(tmp)[c(2:4,7,10)]<-c("A1","A2","FREQ","P","BP")
  write.table(tmp,file="hl_ma_nov18_rsID_v2.txt",col.names=T,row.names=F,quote=F)
  print(paste(grep(f,fls),"of",length(fls),sep=" "))
}

