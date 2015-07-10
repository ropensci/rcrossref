R CMD CHECK passed on my local OS X install on R 3.2.1 and R development
version, and Ubuntu running on Travis-CI. 

Win-Builder passed for R-devel, but on R 3.2.1, I get

   Package required and available but unsuitable version: 'httr'

But httr v1, required by this package, is on CRAN, so I assume the build of R
on Win-Builder machine is older somehow?

This submission imports functions from default R packages other than 
base used in this package. In addition, there are other fixes, including
for changes in httr v1. 

Thanks! Scott Chamberlain
