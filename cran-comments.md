## Test environments

* local OS X install, R 3.5.1 patched
* ubuntu 14.04.5 LTS (on Travis-CI), R 3.5.1
* win-builder (devel and release)

## R CMD check results

0 errors | 0 warnings | 1 note

   License components with restrictions and base license permitting such:
     MIT + file LICENSE
   File 'LICENSE':
     YEAR: 2018
     COPYRIGHT HOLDER: Scott Chamberlain

## Reverse dependencies

* I have run R CMD check on the 4 downstream dependencies. There was a problem in one package (roadoi), but I've sent a pull request that has been merged to that package and they will submit a patch to CRAN soon. See the summary at <https://github.com/ropensci/rcrossref/tree/master/revdep>

-------

This submission includes many bug fixes and some minor improvements. 

Thanks!
Scott Chamberlain
