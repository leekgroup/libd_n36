#!/bin/sh

## Usage
# sh der2Report.sh run1-v0.0.46

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
echo "**** Job starts ****"
date

mkdir -p ${WDIR}/${outdir}/logs

# merge results
Rscript-3.1 -e "library(derfinderReport); load('${MAINDIR}/derCoverageInfo/fullCov.Rdata'); generateReport(prefix='${PREFIX}', browse=FALSE, nBestClusters=20, fullCov=fullCov, device='CairoPNG')"

# Move log files into the logs directory
mv ${WDIR}/${sname}.* ${WDIR}/${outdir}/logs/

echo "**** Job ends ****"
date
EOF
call="qsub -cwd -l mem_free=50G,h_vmem=100G,h_fsize=10G -N ${sname} -m e .${sname}.sh"
echo $call
$call