#!/bin/bash	
#$ -cwd
#$ -m e
#$ -l jabba,mem_free=30G,h_vmem=100G
#$ -N n36-mergeFull
echo "**** Job starts ****"
date

# merge
Rscript mergeFull.R

echo "**** Job ends ****"
date