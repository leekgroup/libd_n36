library('GenomicRanges')
library('BiocParallel')
library('devtools')

chrs <- paste0('chr', c(1:22, 'X', 'Y'))
names(chrs) <- chrs

## Load preprocess coverage and extract mean
meanFromPreproc <- function(chr) {
    load(file.path('run1-v0.0.046', chr, 'coveragePrep.Rdata'))
    meanCov <- prep$meanCoverage
    return(meanCov)
}

## Do it
meanCov <- bplapply(meanFromPreproc, chrs, SIMPLIFY = FALSE, BPPARAM = MulticoreParam(workers = 10, outfile = Sys.getenv('SGE_STDERR_PATH')))

## Save results
save(meanCov, file = 'meanCov.Rdata')

## Reproducibility info
proc.time()
message(Sys.time())
options(width = 120)
devtools::session_info()
