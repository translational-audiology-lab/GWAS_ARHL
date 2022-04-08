#!/bin/bash

#SBATCH --mem=300G
#SBATCH --job-name=path_2
#SBATCH -p brc

cd /scratch/users/k1471250/hear.charge/cleaned/MA/nov18/vegas/res2/

module add apps/R
module add apps/plink

### Pathway analysis by Vegas2
## -geneandp, output from vegas gene prioritization
## -geneandpath, pathways provided by Vegas

/users/k1471250/tools/vegas2/vegas2.sh -P -geneandp hl_ma_nov18_vegas2_genes4pathways_2.txt \
-geneandpath /users/k1471250/tools/vegas2/libs/biosystems20160324.vegas2pathSYM \
-glist /users/k1471250/tools/vegas2/libs/glist-hg19.txt \
-out top10path_2