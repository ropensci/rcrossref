I have read and agree to the the CRAN policies at
http://cran.r-project.org/web/packages/policies.html

R CMD CHECK passed on my local OS X install on R 3.1.2 and R development
version, Ubuntu running on Travis-CI, and Win-Builder.

This submission is in response to the request from Brian Ripley about
fixing problems with examples wrapped in \donttest. I have moved all
examples to be wrapped in \dontrun because all call web APIs.

Thanks! Scott Chamberlain
