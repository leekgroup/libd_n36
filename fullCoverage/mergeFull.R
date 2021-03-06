## Merge the coverage data
## Note that you would now use the fullCoverage() function which did not exist when this script was made.

library('IRanges')

## setup
chrs <- c(1:22, "X", "Y")
fullCov <- vector("list", 24)
names(fullCov) <- chrs

## Actual processing
for(chr in chrs) {
	load(paste0("chr", chr, "CovInfo.Rdata"))
	eval(parse(text=paste0("data <- ", "chr", chr, "CovInfo")))
	fullCov[[chr]] <- data$coverage
}

save(fullCov, file="../derCoverageInfo/fullCov.Rdata")
