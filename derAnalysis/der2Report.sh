#!/bin/sh

## Usage
# sh der2Report.sh run2-v0.0.42

## regionReport available at http://www.bioconductor.org/packages/release/bioc/html/regionReport.html

# Directories
MAINDIR=/dcs01/lieber/ajaffe/Brain/derRuns/libd_n36
WDIR=${MAINDIR}/derAnalysis

# Define variables
SHORT='der2R-n36'
PREFIX=$1

# Construct shell files
outdir="${PREFIX}"
sname="${SHORT}.${PREFIX}"
echo "Creating script ${sname}"
cat > ${WDIR}/.${sname}.sh <<EOF
#!/bin/bash
#$ -cwd
#$ -m e
#$ -l mem_free=50G,h_vmem=100G,h_fsize=10G 
#$ -N ${sname}
echo "**** Job starts ****"
date

mkdir -p ${WDIR}/${outdir}/logs

# merge results
module load R/3.1.x
Rscript -e "library(regionReport); load('${MAINDIR}/derCoverageInfo/fullCov.Rdata'); derfinderReport(prefix='${PREFIX}', browse=FALSE, nBestClusters=20, fullCov=fullCov, device='CairoPNG')"

# Move log files into the logs directory
mv ${WDIR}/${sname}.* ${WDIR}/${outdir}/logs/

echo "**** Job ends ****"
date
EOF
call="qsub .${sname}.sh"
echo $call
$call