## Merge the coverage data
## Note that you would now use the fullCoverage(cutoff = 5) function which did not exist when this script was made.

library('IRanges')

## setup
chrs <- c(1:22, "X", "Y")
filteredCov <- vector("list", 24)
names(filteredCov) <- chrs

## Actual processing
for(chr in chrs) {
	load(paste0("chr", chr, "CovInfo.Rdata"))
	eval(parse(text=paste0("data <- ", "chr", chr, "CovInfo")))
	filteredCov[[chr]] <- data
}

save(filteredCov, file="filteredCov.Rdata")
