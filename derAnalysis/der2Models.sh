#!/bin/sh

## Usage
# sh der2Models.sh fetalVsInfant-v0.0.46 fetal infant

# Directories
MAINDIR=/dcs01/lieber/ajaffe/Brain/derRuns/libd_n36
WDIR=${MAINDIR}/derAnalysis

# Define variables
SHORT='der2Mod-n36'
PREFIX=$1
GROUP1=$2
GROUP2=$3

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
cd ${WDIR}/${outdir}/
Rscript-3.1 ${WDIR}/derfinder2-models.R -r "$GROUP1" -c "$GROUP2"

# Move log files into the logs directory
mv ${WDIR}/${sname}.* ${WDIR}/${outdir}/logs/

echo "**** Job ends ****"
date
EOF
call="qsub -cwd -l mem_free=50G,h_vmem=100G,h_fsize=10G -N ${sname} -m e .${sname}.sh"
echo $call
$call