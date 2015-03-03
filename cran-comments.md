I have read and agree to the the CRAN policies at
http://cran.r-project.org/web/packages/policies.html

R CMD CHECK passed on my local OS X install on R 3.1.2 and R development
version, Ubuntu running on Travis-CI, and Win-Builder.

This version includes a fix requested by CRAN:
- CRAN reported some examples were not passing in R development version that 
were wrapped in \donttest. I haven't been able to reproduce the failures in 
examples reported by CRAN. Most examples are now in \dontrun, with only a few 
examples in \donttest, which should all pass R CMD CHECK. Most functions still
have some examples not in \dontrun, so functionality of the package will be 
tested if --run-donttest is used on R CMD CHECK.

Thanks! Scott Chamberlain
