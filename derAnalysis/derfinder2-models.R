## Calculate the library adjustments and build the models

## Available at http://www.bioconductor.org/packages/release/bioc/html/derfinder.html
library("derfinder")

## Load the coverage information
load("../../derCoverageInfo/filteredCov.Rdata")

## Identify the sampledirs
dirs <- colnames(filteredCov[[1]]$coverage)

##### Note that this whole section is for defining the models using makeModels()
##### You can alternatively define them manually and/or use packages such as splines if needed.

## Define the groups
info <- read.table( "/home/epi/ajaffe/Lieber/Projects/RNAseq/n36/samples_for_rnaseq.txt", header=TRUE)
info <- info[complete.cases(info),]
## Match dirs with actual rows in the info table
info$dir <- paste0("R", info$RNANum)
match <- sapply(dirs, function(x) { which(info$dir == x)})
info <- info[match, ]
## Set the control group as the reference
group <- relevel(info$ageGroup, "(0,1]")

## Determine sample size adjustments
if(file.exists("sampleDepths.Rdata")) {
	load("sampleDepths.Rdata")
} else {
	if(file.exists("collapsedFull.Rdata")) {
		load("collapsedFull.Rdata")
	} else {
		## Load the un-filtered coverage information for getting the sample size adjustments
		load("../../derCoverageInfo/fullCov.Rdata")

		## Collapse
		collapsedFull <- collapseFullCoverage(fullCov, save=TRUE)
	}

	## Get the adjustments
	sampleDepths <- sampleDepth(collapsedFull=collapsedFull, probs = 1, nonzero = TRUE, scalefac = 32, center=FALSE, verbose=TRUE)
	save(sampleDepths, file="sampleDepths.Rdata")
}

## Build the models
models <- makeModels(sampleDepths=sampleDepths, testvars=group, adjustvars=NULL, testIntercept=FALSE)
save(models, file="models.Rdata")

## Save information used for analyzeChr(groupInfo)
groupInfo <- group
save(groupInfo, file="groupInfo.Rdata")

## Done :-)
proc.time()
sessionInfo()
