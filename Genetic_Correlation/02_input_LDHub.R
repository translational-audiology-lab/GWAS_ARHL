#= 02_input_LDHub.R
#= Shuyang Yao 20201217

#= generate input file for LDHub.
#= output file of this script: /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/hl2020_LDhub.zip

#= requirement from LDHub:
# http://ldsc.broadinstitute.org/upload_file/#
#LD Hub can handle both space and tab delimited files. By default, please prepare your file using tab as delimiter.
#LD Hub can handle but Z scores and betas. By default, please use Z scores in your file.
# header:
#snpid	A1	A2	Zscore	N	P-value
#rs1	A	C	-4.56	19540	0.0001

# 1. To save the uploading time, LD Hub only accepts zipped files as input (e.g. mydata.zip).
# 
# 2. Please check that there is ONLY ONE plain TXT file (e.g. mydata.txt) in your zipped file.
# 
# 3. Please make sure you do NOT zip any folder together with the plain txt file (e.g. /myfolder/mydata.txt), otherwise you will get an error: [Errno 2] No such file or directory
# 
# 4. Please do NOT zip multiple files (e.g. zip mydata.zip file1.txt file2.txt ..) or zip a file with in a folder (e.g. zip mydata.zip /path/to/my/file/mydata.txt).
# 
# 5. Please keep the file name of your plain txt file short (less than 50 characters), otherwise you may get an error: [Errno 2] No such file or directory
# 
# 6. Please zip your plain txt file using following command (ONE file at a time):
#   
#   For Windows system: 1) Locate the file that you want to compress. 2) Right-click the file, point to Send to, and then click Compressed (zipped) folder.
# 
# For Linux and Mac OS system: zip mydata.zip mydata.txt
# 
# Reminder: for Mac OS system, please do NOT zip you file by right click mouse and click "Compress" to zip your file, this will automatically create a folder called "__MACOS". You will get an error: [Errno 2] No such file or directory.
# 

#= steps:
# 1. read in munged file, 
# 2. merge with original file for p 
# 3. fix column names


library(data.table)
library(tidyverse)

a <- "/Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/hl2020.sumstats.gz"
dat1 <- fread(a, stringsAsFactors = F, data.table = F)

b <- "/Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/hl_ma_nov18_rsID_NT.txt.gz"
dat2 <- fread(b, stringsAsFactors = F, data.table = F) %>% select(SNP, P)

dat3 <- dat1 %>% left_join(dat2, by=c("SNP"="SNP"))

colnames(dat3) <- c("snpid", "A1", "A2", "Zscore", "N", "P-value")

c <- "/Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/hl2020_LDhub.txt"
fwrite(dat3, c, sep="\t", col.names = T)

# system("zip /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/hl2020_LDhub_input.zip /Users/yaoshu/Proj/_Other/Hearing_loss2020/Data/processed/hl2020_LDhub_input.txt")


