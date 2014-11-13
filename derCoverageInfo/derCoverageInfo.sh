#!/bin/sh

# Directories
MAINDIR=/nexsan2/disk3/ajaffe/RNASeq/BRAIN
WDIR=${MAINDIR}/libd_n36/derCoverageInfo
DATADIR=${MAINDIR}/n36

# Define variables
SHORT='derCovInf-n36'

# Construct shell files
for chrnum in 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 X Y
do
	chr="chr${chrnum}"
	echo "Creating script for chromosome ${chr}"
	cat > ${WDIR}/.${SHORT}.${chr}.sh <<EOF
#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=50G,h_vmem=100G,h_fsize=30G
#$ -N ${SHORT}.${chr}
echo "**** Job starts ****"
date

# Make logs directory
mkdir -p ${WDIR}/logs

# run loadCoverage()
module load R/3.1.x
R -e "library(derfinder); files <- rawFiles(datadir='${DATADIR}', samplepatt='bam$', bamterm=NULL); names(files) <- gsub('_accepted_hits.bam', '', names(files)); loadCoverage(files=files, chr='${chr}', cutoff=5, output='auto', verbose=TRUE); proc.time(); sessionInfo()"

## Move log files into the logs directory
mv ${SHORT}.${chr}.* ${WDIR}/logs/

echo "**** Job ends ****"
date
EOF
	call="qsub ${WDIR}/.${SHORT}.${chr}.sh"
	echo $call
	$call
done
