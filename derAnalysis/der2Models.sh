#!/bin/sh

## Usage
# sh der2Models.sh run2-v0.0.42

# Directories
MAINDIR=/dcs01/lieber/ajaffe/Brain/derRuns/libd_n36
WDIR=${MAINDIR}/derAnalysis

# Define variables
SHORT='der2Mod-n36'
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
cd ${WDIR}/${outdir}/
module load R/3.1.x
Rscript ${WDIR}/derfinder2-models.R

# Move log files into the logs directory
mv ${WDIR}/${sname}.* ${WDIR}/${outdir}/logs/

echo "**** Job ends ****"
date
EOF
call="qsub .${sname}.sh"
echo $call
$call
