#!/bin/sh

## Usage
# sh der2Analysis.sh run2-v0.0.42

# Directories
MAINDIR=/dcl01/lieber/ajaffe/derRuns/libd_n36
WDIR=${MAINDIR}/derAnalysis
DATADIR=${MAINDIR}/derCoverageInfo

# Define variables
SHORT='der2A-n36'
PREFIX=$1
CORES=8

# Construct shell files
for chrnum in 22 21 Y 20 19 18 17 16 15 14 13 12 11 10 9 8 X 7 6 5 4 3 2 1
#for chrnum in Y
do
	echo "Creating script for chromosome ${chrnum}"
	chr="chr${chrnum}"
	outdir="${PREFIX}/${chr}"
	sname="${SHORT}.${PREFIX}.${chr}"
	cat > ${WDIR}/.${sname}.sh <<EOF
#!/bin/bash	
#$ -cwd
#$ -m e
#$ -l mem_free=125G,h_vmem=25G,h_fsize=10G
#$ -N ${sname}
#$ -pe local ${CORES}

echo "**** Job starts ****"
date

# Create output directory 
mkdir -p ${WDIR}/${outdir}
# Make logs directory
mkdir -p ${WDIR}/${outdir}/logs

# run derfinder2-analysis.R
cd ${WDIR}/${PREFIX}/
module load R/3.1.x
Rscript ${WDIR}/derfinder2-analysis.R -d "${DATADIR}/${chr}CovInfo.Rdata" -c "${chrnum}" -m ${CORES} -v TRUE

# Move log files into the logs directory
mv ${WDIR}/${sname}.* ${WDIR}/${outdir}/logs/

echo "**** Job ends ****"
date
EOF
	call="qsub .${sname}.sh"
	$call
done
