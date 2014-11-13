## Fix some names before running the report

library("GenomicRanges")
load("fullRegions.Rdata")
load("groupInfo.Rdata")

colnames(values(fullRegions))

i <- grep("mean\\.", colnames(values(fullRegions)))
colnames(values(fullRegions))[i] <- paste("mean", levels(groupInfo), sep="")

i <- grep("log2FoldChange", colnames(values(fullRegions)))
colnames(values(fullRegions))[i] <- paste("log2FoldChange", levels(groupInfo)[2:length(unique(groupInfo))], "vs", levels(groupInfo)[1], sep="")

colnames(values(fullRegions))

save(fullRegions, file="fullRegions.Rdata")

## Note: this might no longer be needed with the BioC version of derfinder, but we'll leave it here just in case.
