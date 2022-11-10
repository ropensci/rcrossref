## Test environments

* local OS X install, R4.2.2 (2022-10-31)
* ubuntu-latest (devel, release, oldrel-1) on GH actions
* win-builder (devel and release)

## R CMD check results

local:

0 errors | 0 warnings | 0 notes

win-builder

1 note highlighting maintainer change

## Reverse dependencies

* I have run R CMD check on the 8 downstream dependencies. There were no problems. See the summary at <https://github.com/ropensci/rcrossref/tree/master/revdep>

-------

This re-submission reduced the size of tarball to less than  5MB.

Overall, this release implements changes relative to the Crossref REST API migration.

It also fixes CRAN Check errors.

Please note the maintainer change from Scott Chamberlain to Najko Jahn.

Thanks!

Najko Jahn
