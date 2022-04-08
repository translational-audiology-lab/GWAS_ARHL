######### Forest plots for hearing loss
library(forestplot)
library(metafor)
setwd("C:/Users/mbf19/Desktop/covid/tmp_hl/tmp_forests/")

fls<-list.files(path="Data_23Mar/")

## names of cohorts
cohorts<-vector()
for (f in fls) 
  cohorts<-append(cohorts,substr(f,1,nchar(f)))                
cohorts<-sub(".forestplot_23Mar.txt","",cohorts)                

## prepare data for each SNP + upper/lower
LS<-list()
for (f in fls) {
  fname<-paste("Data_23Mar/",f,sep="")
  tmp<-read.table(fname,h=T)
  tmp$cohort<-cohorts[which(fls%in%f)]
  LS[[which(fls%in%f)]]<-tmp
}

SNPS<-do.call(rbind,LS)

#SNPS$BETA<-SNPS$B*-1 # this is because MA is done for other allele?

MA<-read.csv("HL_MA_COJO_19mar21_maf1e-3_p5e-8.csv")
MA$upper<-MA$b+MA$se
MA$lower<-MA$b-MA$se
MA$cptid<-paste(MA$Chr,MA$bp,sep=":")

snps<-unique(SNPS$cptid)

###### temporarily
snps<-snps[-which(snps=="3:121712051")]
######


for(s in snps) {
    tmp<-SNPS[SNPS$cptid%in%s,c("cohort","BETA","N","SE")]
    ma<-MA[grep(s,MA$cptid),]
    ## check direction of effect!
    beta<-rma.uni(tmp$BETA,sei=tmp$SE)$beta
    if((beta<0 & ma$b>0) | (beta>0 & ma$b<0)) {
      tmp$BETA<--1*tmp$BETA
      tmp$upper<-tmp$BETA+tmp$SE
      tmp$lower<-tmp$BETA-tmp$SE
      }
      else {
        tmp$upper<-tmp$BETA+tmp$SE
        tmp$lower<-tmp$BETA-tmp$SE
      }
    
    snpforest <-data.frame(mean  = c(NA, tmp$BETA,NA,ma$b),
                           lower = c(NA, tmp$lower,NA,ma$lower),
                           upper = c(NA, tmp$upper,NA,ma$upper))
    tabletext <- cbind(
      c("Study", tmp$cohort,NA,"Meta-analysis"),
      c("Sample size", tmp$N,NA,sum(tmp$N)))
      #c("Sample size", tmp$N,NA,ma$n))
    
    png(paste("plots_upd/",ma$SNP,"_forest.png",sep=""),w=800,h=900)
    
    fp<-forestplot(tabletext,snpforest,
               col = fpColors(box = "royalblue",
                              line = "darkblue",
                              summary = "#af002a"),
               is.summary = c(TRUE,rep(FALSE,nrow(tmp)),TRUE),
               xlab="Effect size",
               txt_gp=fpTxtGp(xlab  = gpar(cex = 1.5),
                              ticks = gpar(cex = 1)),
               title=paste(ma$SNP," (",ma$cptid,")",sep=""))
    print(fp)
    dev.off()
    
    }


######## Leftover SNP
library(forestplot)
library(metafor)
setwd("C:/Users/mbf19/Desktop/covid/tmp_hl/tmp_forests/")

fls<-list.files(path="leftover/")

## names of cohorts
cohorts<-vector()
for (f in fls) 
  cohorts<-append(cohorts,substr(f,1,nchar(f)))                
cohorts<-sub("_snp.txt","",cohorts)                

## prepare data for each SNP + upper/lower
LS<-list()
for (f in fls) {
  fname<-paste("leftover/",f,sep="")
  tmp<-read.table(fname,h=T)
  tmp$cohort<-cohorts[which(fls%in%f)]
  LS[[which(fls%in%f)]]<-tmp
}

SNPS<-do.call(rbind,LS)

MA<-read.csv("HL_MA_COJO_19mar21_maf1e-3_p5e-8.csv")
MA$upper<-MA$b+MA$se
MA$lower<-MA$b-MA$se
MA$cptid<-paste(MA$Chr,MA$bp,sep=":")

  tmp<-SNPS[,c("cohort","BETA","N","SE")]
  ma<-MA[grep(SNPS$cptid[1],MA$cptid),]
  ## check direction of effect!
  beta<-rma.uni(tmp$BETA,sei=tmp$SE)$beta
  if((beta<0 & ma$b>0) | (beta>0 & ma$b<0)) {
    tmp$BETA<--1*tmp$BETA
    tmp$upper<-tmp$BETA+tmp$SE
    tmp$lower<-tmp$BETA-tmp$SE
  }
  
  snpforest <-data.frame(mean  = c(NA, tmp$BETA,NA,ma$b),
                         lower = c(NA, tmp$lower,NA,ma$lower),
                         upper = c(NA, tmp$upper,NA,ma$upper))
  tabletext <- cbind(
    c("Study", tmp$cohort,NA,"Meta-analysis"),
    c("Sample size", tmp$N,NA,sum(tmp$N)))
  
  png(paste("plots_upd/",ma$SNP,"_forest.png",sep=""),w=800,h=900)
  
  fp<-forestplot(tabletext,snpforest,
             col = fpColors(box = "royalblue",
                            line = "darkblue",
                            summary = "#af002a"),
             is.summary = c(TRUE,rep(FALSE,nrow(tmp)),TRUE),
             xlab="Effect size",
             txt_gp=fpTxtGp(xlab  = gpar(cex = 1.5),
                            ticks = gpar(cex = 1)),
             title=paste(ma$SNP," (",ma$cptid,")",sep=""))
  
  print(fp)
  dev.off()
  
