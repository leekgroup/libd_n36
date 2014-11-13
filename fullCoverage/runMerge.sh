#!/bin/bash	
#$ -cwd
#$ -m e
#$ -l mem_free=30G,h_vmem=100G
#$ -N n36-mergeFull
echo "**** Job starts ****"
date

# merge
module load R/3.1.x
Rscript mergeFull.R

echo "**** Job ends ****"
date
