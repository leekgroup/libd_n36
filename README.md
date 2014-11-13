# LIBD n36 project

This repository is for hosting the code for the LIDB n36 project lead by AE Jaffe.

If you have any questions about the files in this directory contact AE Jaffe <andrew.jaffe@libd.org>.

Scripts use [derfinder](http://www.bioconductor.org/packages/release/bioc/html/derfinder.html) and are organized in the following way:

* [derCoverageInfo](derCoverageInfo/): contains scripts for processing data from BAM files, filtering and creating Rdata files.
* [fullCoverage](fullCoverage/): similar as _derCoverageInfo_ but without filtering data.
* [derAnalysis](derAnalysis/): has scripts for creating the models, running the derfinder analysis one chromosome at a time, merging the results, and creating a html report.
