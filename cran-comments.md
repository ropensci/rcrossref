## Test environments

* local OS X install, R 3.6.0 patched
* ubuntu 14.04.5 LTS (on Travis-CI), R 3.6.0
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 0 notes

## Reverse dependencies

* I have run R CMD check on the 5 downstream dependencies. There were no problems. See the summary at <https://github.com/ropensci/rcrossref/tree/master/revdep>

-------

This submission includes new functionality for some functions, a slight fix for a function, and fixes non-ascii text in a test fixture that was causing cran check failures on debian clang devel.

Thanks!
Scott Chamberlain
