rcrossref: R interface to CrossRef APIs
=======================================



[![cran checks](https://cranchecks.info/badges/worst/rcrossref)](https://cranchecks.info/pkgs/rcrossref)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![R-check](https://github.com/ropensci/rcrossref/actions/workflows/R-check.yml/badge.svg)](https://github.com/ropensci/rcrossref/actions/workflows/R-check.yml)
[![codecov](https://codecov.io/gh/ropensci/rcrossref/branch/master/graph/badge.svg)](https://app.codecov.io/gh/ropensci/rcrossref)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rcrossref)](https://github.com/r-hub/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rcrossref)](https://cran.r-project.org/package=rcrossref)

## CrossRef documentation

* Crossref API: https://github.com/CrossRef/rest-api-doc#readme
* Crossref's API issue tracker: https://gitlab.com/crossref/issues
* Crossref metadata search API: https://www.crossref.org/labs/crossref-metadata-search/
* Crossref DOI Content Negotiation: https://citation.crosscite.org/docs.html
* Crossref Text and Data Mining (TDM) Services: https://www.crossref.org/education/retrieve-metadata/rest-api/text-and-data-mining/

## Installation

Stable version from CRAN


```r
install.packages("rcrossref")
```

Or development version from GitHub


```r
remotes::install_github("ropensci/rcrossref")
```

Load `rcrossref`


```r
library('rcrossref')
```

## Register for the Polite Pool

If you are intending to access Crossref regularly you will want to send your email address with your queries. This has the advantage that queries are placed in the polite pool of servers. Including your email address is good practice as described in the Crossref documentation under Good manners (https://github.com/CrossRef/rest-api-doc#good-manners--more-reliable-service). The second advantage is that Crossref can contact you if there is a problem with a query.

Details on how to register your email in a call can be found at `?rcrossref-package`. To pass your email address to Crossref, simply store it as an environment variable in .Renviron like this:

Open file: `file.edit("~/.Renviron")`

Add email address to be shared with Crossref `crossref_email= "name@example.com"`

Save the file and restart your R session

To stop sharing your email when using rcrossref simply delete it from your .Renviron file. 

## Documentation

See https://docs.ropensci.org/rcrossref/ to get started

## Meta

* Please report any issues or bugs: https://github.com/ropensci/rcrossref/issues
* License: MIT
* Get citation information for `rcrossref` in R doing `citation(package = 'rcrossref')`
* Please note that this package is released with a Contributor Code of Conduct (https://ropensci.org/code-of-conduct/). By contributing to this project, you agree to abide by its terms.

---

This package is part of a richer suite called fulltext (https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles.

---
