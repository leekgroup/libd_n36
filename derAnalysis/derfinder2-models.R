## Calculate the library adjustments and build the models

library("getopt")

## Available at https://github.com/lcolladotor/derfinder
library("derfinder")

## Specify parameters
spec <- matrix(c(
	'reference', 'r', 1, "character", "group 1 to use in the comparison",
	'comparison', 'c', 1, "character", "group 2 to use in the comparison",
	'help' , 'h', 0, "logical", "Display help"
), byrow=TRUE, ncol=5)
opt <- getopt(spec)

## Testing the script
test <- FALSE
if(test) {
	## Speficy it using an interactive R session and testing
	test <- TRUE
}

## Test values
if(test){
	opt <- NULL
	opt$group1 <- "(-1,0]"
	opt$group2 <- "(0,1]"
}

## if help was asked for print a friendly message
## and exit with a non-zero error code
if (!is.null(opt$help)) {
	cat(getopt(spec, usage=TRUE))
	q(status=1)
}


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
## Set the first group as the reference
twogroups <- c(opt$reference, opt$comparison)
cases <- c("(-1,0]", "(0,1]", "(1,10]", "(10,20]", "(20,50]", "(50,100]")
names(cases) <- c("fetal", "infant", "child", "teen", "adult", "elderly")
levels <- cases[match(twogroups, names(cases))]

group <- factor(info$ageGroup, levels=levels)

## Define colsubset
colsubset <- which(!is.na(group))
save(colsubset, file="colsubset.Rdata")

## Update the group labels
group <- group[!is.na(group)]

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
		collapsedFull <- collapseFullCoverage(fullCov, colsubset=colsubset, save=TRUE)
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
