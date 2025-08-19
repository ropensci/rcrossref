## Test environments

* local Mac OS 15.6, R version 4.5.1 (2025-06-13)
* ubuntu-latest (devel, release, oldrel-1) on GH actions
* win-builder (oldrelease, release, and devel)

## R CMD check results

local:

0 errors | 0 warnings | 0 notes

win-builder 4.4.3 (oldrelease):

1 note about Author field differs from that derived from Authors@R 

## Reverse dependencies

* I have run R CMD check on the 86 downstream dependencies. There were no problems. 

-------

This submission fixes a warning message when using bibtex::do_read_bib() internally, as alerted by Kurt Hornik.

Thanks!

Najko Jahn
