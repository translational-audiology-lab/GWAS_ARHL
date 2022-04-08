#### top 10% expressed Genes in Basal cells overlap with VEGAS geens for pathway analysis ####3

library(dplyr)

####Extract Gene_ids from basal cell to get the gene names (ENTREZ) #####

Basal_genes <- read.table("Basal_cells.bed",  header = F, sep = "\t")
head(Basal_genes)
colnames(Basal_genes) <- c("CHR", "Start", "End", "GENE")
Gene_list_basal_cells <- subset(Basal_genes, select = c(4))
head(Gene_list_basal_cells)

write.table(Gene_list_basal_cells, "Gene_list_basal_cells.txt", col.names = F, row.names = F, quote = F, sep = "\t" )

##### Get the gene names from Uniprot ######
gene_names <- read.table("uniprot-yourlist_M2022021192C7BAECDB1C5C413EE0E0348724B68240561AX-filtered-rev--.tab", header = T, quote = "", sep = "\t")
head(gene_names)
##### Subset only the gene names ###
gene_names_list <- subset(gene_names, select = c(6))
head(gene_names_list)

write.table(gene_names_list, "Gene_name_list_Basal.txt", col.names = T, row.names = F, quote = F, sep = "\t" )

#### Read in VEGAS data and chech the gene overlap ####

vegas <- read.csv("hl_ma_nov18_vegas2_genes_2.csv", header = T, sep = ",")
head(vegas)

#Significant_pvalue <- subset(overlap_genes, Pvalue <= 9e-05) # Bonferroni corrected pvalue 0.05/510

#write.table(overlap_genes, "Significant_pvalue_genes.txt", col.names = T, row.names = F, quote = F, sep = "\t" )
write.table(overlap_genes, "Overlap_genes_basal_cells.txt", col.names = T, row.names = F, quote = F, sep = "\t" )


magma <- read.csv("magma.genes.out", header = T, sep = "\t")
head(magma)
vegas %>% 
  group_by(Gene) %>% 
  filter(n()>1)  %>% summarize(n=n())

overlap_genes <- vegas[vegas$Gene%in%gene_names_list$Gene.names,]
head(overlap_genes)


##### top 10% genes expressed in Spindle/root cells #####

Spindle <- read.table("Spindle_Root_Cells.bed",  header = T, sep = "\t")
head(Spindle)
colnames(Spindle) <- c("CHR", "Start", "End", "GENE")
GeneID_Spindle_cells <- subset(Spindle, select = c(4))
head(GeneID_Spindle_cells)

write.table(GeneID_Spindle_cells, "GeneID_Spindle_cells.txt", col.names = F, row.names = F, quote = F, sep = "\t" )


gene_names <- read.table("uniprot-yourlist_M2022021592C7BAECDB1C5C413EE0E0348724B6824165CE1-filtered-rev--.tab", header = T, quote = "", sep = "\t")
head(gene_names)

write.table(gene_names, "Gene_name_list_Spindle.txt", col.names = T, row.names = F, quote = F, sep = "\t" )

gene_names_list <- subset(gene_names, select = c(6))
head(gene_names_list)
#### Read in VEGAS data and chech the gene overlap ####

overlap_genes <- vegas[vegas$Gene%in%gene_names_list$Gene.names,]
head(overlap_genes)

vegas <- read.csv("hl_ma_nov18_vegas2_genes_2.csv", header = T, sep = ",")
head(vegas)

overlap_genes <- vegas[vegas$Gene%in%gene_names$Gene.names,]
head(overlap_genes)
Significant_pvalue <- subset(overlap_genes, Pvalue <= 9e-05) # Bonferroni corrected pvalue 0.05/510

write.table(overlap_genes, "Significant_pvalue_genes.txt", col.names = T, row.names = F, quote = F, sep = "\t" )
write.table(overlap_genes, "Overlap_genes_Spindle_cells.txt", col.names = T, row.names = F, quote = F, sep = "\t" )
#### Hoa Paper genes ####
Spindle <- read.table("Overlap_genes_Spindle_cells.txt", header = T, sep = "\t")
head(Spindle)
Hoa <- read.table("TOP30Genes_Spindle_Root.txt", header = T, sep = "\t")
head(Hoa)
colnames(Hoa)
table(Hoa$All.Spindle.Root)
str(Hoa)

overlap_genes_all <- Hoa[Hoa$All.Spindle.Root%in%gene_names$Gene.names,]
head(overlap_genes_all)

write.table(overlap_genes_all, "Overlap_Hoa_All_Spindle.txt", col.names = T, row.names = F, quote = F, sep = "\t" )


overlap_genes_Spindle_root_1 <- Spindle[Spindle$Gene%in%Hoa$Spindle.Root.1,]
write.table(overlap_genes_Spindle_root_1, "Overlap_Hoa_Spindle_1.txt", col.names = T, row.names = F, quote = F, sep = "\t" )


overlap_genes_Spindle_root_2 <- Spindle[Spindle$Gene%in%Hoa$Spindle.Root.2,]
write.table(overlap_genes_Spindle_root_2, "Overlap_Hoa_All_Spindle_2.txt", col.names = T, row.names = F, quote = F, sep = "\t" )

head(overlap_genes_Spindle_root_2)

