rcrossref
=========



[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://api.travis-ci.org/ropensci/rcrossref.png)](https://travis-ci.org/ropensci/rcrossref)
[![Build status](https://ci.appveyor.com/api/projects/status/jbo6y7dg4qiq7mol/branch/master)](https://ci.appveyor.com/project/sckott/rcrossref/branch/master)
[![codecov.io](https://codecov.io/github/ropensci/rcrossref/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rcrossref?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/rcrossref)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rcrossref)](https://cran.r-project.org/package=rcrossref)

R interface to various CrossRef APIs
====================================


## CrossRef documentation

* Crossref API: [https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md)
* Crossref [metadata search API](http://search.labs.crossref.org/)
* CrossRef [DOI Content Negotiation](http://citation.crosscite.org/docs.html)
* Text and Data Mining [TDM](http://tdmsupport.crossref.org/)

## Installation

Stable version from CRAN


```r
install.packages("rcrossref")
```

Or development version from GitHub


```r
install.packages("devtools")
devtools::install_github("ropensci/rcrossref")
```

Load `rcrossref`


```r
library('rcrossref')
```


## Citation search

Use CrossRef's [DOI Content Negotiation](http://citation.crosscite.org/docs.html) service, where you can citations back in various formats, including `apa`


```r
cr_cn(dois = "10.1126/science.169.3946.635", format = "text", style = "apa")
#> [1] "Frank, H. S. (1970). The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance. Science, 169(3946), 635–641. doi:10.1126/science.169.3946.635"
```

`bibtex`


```r
cat(cr_cn(dois = "10.1126/science.169.3946.635", format = "bibtex"))
#> @article{Frank_1970,
#> 	doi = {10.1126/science.169.3946.635},
#> 	url = {https://doi.org/10.1126%2Fscience.169.3946.635},
#> 	year = 1970,
#> 	month = {aug},
#> 	publisher = {American Association for the Advancement of Science ({AAAS})},
#> 	volume = {169},
#> 	number = {3946},
#> 	pages = {635--641},
#> 	author = {H. S. Frank},
#> 	title = {The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance},
#> 	journal = {Science}
#> }
```

`bibentry`


```r
cr_cn(dois = "10.6084/m9.figshare.97218", format = "bibentry")
#> Boettiger C (2012). "Regime shifts in ecology and evolution (PhD
#> Dissertation)." doi: 10.6084/m9.figshare.97218 (URL:
#> http://doi.org/10.6084/m9.figshare.97218), <URL:
#> https://doi.org/10.6084/m9.figshare.97218>.
```

## Citation count

Citation count, using OpenURL


```r
cr_citation_count(doi = "10.1371/journal.pone.0042793")
#> [1] 13
```

## Search Crossref metadata API

The following functions all use the [CrossRef API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

### Look up funder information


```r
cr_funders(query = "NSF")
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1             8          NSF           0             20
#>
#> $data
#> # A tibble: 8 × 6
#>             id      location
#>          <chr>         <chr>
#> 1    100000179 United States
#> 2 501100000930     Australia
#> 3    100000001 United States
#> 4    100003187 United States
#> 5    100008367       Denmark
#> 6 501100004190        Norway
#> 7    100006445 United States
#> 8 501100001809         China
#> # ... with 4 more variables: name <chr>, alt.names <chr>, uri <chr>,
#> #   tokens <chr>
#>
#> $facets
#> NULL
```

### Check the DOI minting agency


```r
cr_agency(dois = '10.13039/100000001')
#> $DOI
#> [1] "10.13039/100000001"
#>
#> $agency
#> $agency$id
#> [1] "crossref"
#>
#> $agency$label
#> [1] "CrossRef"
```

### Search works (i.e., articles)


```r
cr_works(filter = c(has_orcid = TRUE, from_pub_date = '2004-04-04'), limit = 1)
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1        688862           NA           0              1
#>
#> $data
#> # A tibble: 1 × 29
#>   alternative.id               container.title    created  deposited
#>            <chr>                         <chr>      <chr>      <chr>
#> 1           1142 Regional Environmental Change 2017-03-29 2017-03-29
#> # ... with 25 more variables: DOI <chr>, funder <list>, indexed <chr>,
#> #   ISBN <chr>, ISSN <chr>, issued <chr>, license_date <chr>,
#> #   license_URL <chr>, license_delay.in.days <chr>,
#> #   license_content.version <chr>, link <list>, member <chr>,
#> #   prefix <chr>, publisher <chr>, reference.count <chr>, score <chr>,
#> #   source <chr>, subject <chr>, title <chr>, type <chr>,
#> #   update.policy <chr>, URL <chr>, assertion <list>, author <list>,
#> #   `clinical-trial-number` <list>
#>
#> $facets
#> NULL
```

### Search journals


```r
cr_journals(issn = c('1803-2427','2326-4225'))
#> $data
#> # A tibble: 2 × 16
#>   alternative.id container.title created deposited funder indexed  ISBN
#>            <chr>           <chr>   <chr>     <chr> <list>   <chr> <chr>
#> 1                                                  <NULL>
#> 2                                                  <NULL>
#> # ... with 9 more variables: ISSN <chr>, issued <chr>, link <list>,
#> #   publisher <chr>, subject <chr>, title <chr>, assertion <list>,
#> #   author <list>, `clinical-trial-number` <list>
#>
#> $facets
#> NULL
```

### Search license information


```r
cr_licenses(query = 'elsevier')
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1            17     elsevier           0             20
#>
#> $data
#> # A tibble: 17 × 2
#>                                                                            URL
#>                                                                          <chr>
#> 1                            http://creativecommons.org/licenses/by-nc-nd/3.0/
#> 2                            http://creativecommons.org/licenses/by-nc-nd/4.0/
#> 3                                  http://creativecommons.org/licenses/by/3.0/
#> 4                                   http://creativecommons.org/licenses/by/4.0
#> 5                                  http://creativecommons.org/licenses/by/4.0/
#> 6                                   http://doi.wiley.com/10.1002/tdm_license_1
#> 7                                 http://doi.wiley.com/10.1002/tdm_license_1.1
#> 8                       http://journals.iucr.org/services/copyrightpolicy.html
#> 9                   http://journals.iucr.org/services/copyrightpolicy.html#TDM
#> 10                           http://onlinelibrary.wiley.com/termsAndConditions
#> 11        http://www.acm.org/publications/policies/copyright_policy#Background
#> 12     http://www.bioone.org/page/resources/researchers/rights_and_permissions
#> 13                        http://www.elsevier.com/open-access/userlicense/1.0/
#> 14                                http://www.elsevier.com/tdm/userlicense/1.0/
#> 15                                      http://www.emeraldinsight.com/page/tdm
#> 16                                                 http://www.springer.com/tdm
#> 17 © 2012, Elsevier Inc., All Rights Reserved. Figure 8, part (B) (images of H
#> # ... with 1 more variables: work.count <int>
```

### Search based on DOI prefixes


```r
cr_prefixes(prefixes = c('10.1016','10.1371','10.1023','10.4176','10.1093'))
#> $meta
#> NULL
#>
#> $data
#>                               member                             name
#> 1   http://id.crossref.org/member/78                      Elsevier BV
#> 2  http://id.crossref.org/member/340 Public Library of Science (PLoS)
#> 3  http://id.crossref.org/member/297                  Springer Nature
#> 4 http://id.crossref.org/member/1989             Co-Action Publishing
#> 5  http://id.crossref.org/member/286    Oxford University Press (OUP)
#>                                  prefix
#> 1 http://id.crossref.org/prefix/10.1016
#> 2 http://id.crossref.org/prefix/10.1371
#> 3 http://id.crossref.org/prefix/10.1023
#> 4 http://id.crossref.org/prefix/10.4176
#> 5 http://id.crossref.org/prefix/10.1093
#>
#> $facets
#> list()
```

### Search CrossRef members


```r
cr_members(query = 'ecology', limit = 5)
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1            18      ecology           0              5
#>
#> $data
#> # A tibble: 5 × 48
#>      id
#>   <int>
#> 1  7052
#> 2  6933
#> 3  7278
#> 4  7745
#> 5  9167
#> # ... with 47 more variables: primary_name <chr>, location <chr>,
#> #   last_status_check_time <date>, total.dois <chr>, current.dois <chr>,
#> #   backfile.dois <chr>, prefixes <chr>,
#> #   coverge.affiliations.current <chr>, coverge.funders.backfile <chr>,
#> #   coverge.licenses.backfile <chr>, coverge.funders.current <chr>,
#> #   coverge.affiliations.backfile <chr>,
#> #   coverge.resource.links.backfile <chr>, coverge.orcids.backfile <chr>,
#> #   coverge.update.policies.current <chr>, coverge.orcids.current <chr>,
#> #   coverge.references.backfile <chr>,
#> #   coverge.award.numbers.backfile <chr>,
#> #   coverge.update.policies.backfile <chr>,
#> #   coverge.licenses.current <chr>, coverge.award.numbers.current <chr>,
#> #   coverge.abstracts.backfile <chr>,
#> #   coverge.resource.links.current <chr>, coverge.abstracts.current <chr>,
#> #   coverge.references.current <chr>,
#> #   flags.deposits.abstracts.current <chr>,
#> #   flags.deposits.orcids.current <chr>, flags.deposits <chr>,
#> #   flags.deposits.affiliations.backfile <chr>,
#> #   flags.deposits.update.policies.backfile <chr>,
#> #   flags.deposits.award.numbers.current <chr>,
#> #   flags.deposits.resource.links.current <chr>,
#> #   flags.deposits.articles <chr>,
#> #   flags.deposits.affiliations.current <chr>,
#> #   flags.deposits.funders.current <chr>,
#> #   flags.deposits.references.backfile <chr>,
#> #   flags.deposits.abstracts.backfile <chr>,
#> #   flags.deposits.licenses.backfile <chr>,
#> #   flags.deposits.award.numbers.backfile <chr>,
#> #   flags.deposits.references.current <chr>,
#> #   flags.deposits.resource.links.backfile <chr>,
#> #   flags.deposits.orcids.backfile <chr>,
#> #   flags.deposits.funders.backfile <chr>,
#> #   flags.deposits.update.policies.current <chr>,
#> #   flags.deposits.licenses.current <chr>, names <chr>, tokens <chr>
#>
#> $facets
#> NULL
```

### Get N random DOIs

`cr_r()` uses the function `cr_works()` internally.


```r
cr_r()
#>  [1] "10.1007/s10841-016-9867-9"
#>  [2] "10.1016/b978-1-4557-3383-5.00008-7"
#>  [3] "10.1515/9783110953527-fm"
#>  [4] "10.1007/bf01571686"
#>  [5] "10.1002/chin.201027234"
#>  [6] "10.1002/9780470872864.ch23"
#>  [7] "10.1090/s0273-0979-1992-00325-7"
#>  [8] "10.1016/j.ejphar.2007.05.027"
#>  [9] "10.1111/j.1538-7836.2005.01695.x"
#> [10] "10.1109/wisnet.2012.6172160"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
#> [1] "10.1007/bf02256554" "10.2307/3467745"
```

## Get full text

Publishers can optionally provide links in the metadata they provide to Crossref for full text of the work, but that data is often missing. Find out more about it at [http://tdmsupport.crossref.org/](http://tdmsupport.crossref.org/).

Get some DOIs for articles that provide full text, and that have `CC-BY 3.0` licenses (i.e., more likely to actually be open)


```r
out <-
  cr_works(filter = list(has_full_text = TRUE,
    license_url = "http://creativecommons.org/licenses/by/3.0/"))
(dois <- out$data$DOI)
#>  [1] "10.1093/ecam/nem168"            "10.1016/j.mri.2010.09.002"
#>  [3] "10.1016/j.stem.2009.11.001"     "10.1016/j.cellsig.2011.08.019"
#>  [5] "10.1016/j.physletb.2011.09.006" "10.1155/2008/424320"
#>  [7] "10.1155/2008/496467"            "10.1155/2008/345478"
#>  [9] "10.1155/2009/730902"            "10.1155/2009/625469"
#> [11] "10.1155/2008/195873"            "10.1016/j.physletb.2011.09.011"
#> [13] "10.1016/j.dnarep.2012.04.002"   "10.1016/j.meegid.2008.11.006"
#> [15] "10.1016/j.physletb.2011.09.010" "10.4061/2010/478746"
#> [17] "10.4061/2010/348919"            "10.1016/j.adhoc.2012.03.013"
#> [19] "10.1155/2011/124595"            "10.1016/j.molcel.2007.09.005"
```

From the output of `cr_works` we can get full text links if we know where to look:


```r
do.call("rbind", out$data$link)
#> # A tibble: 39 × 4
#>                                                                            URL
#>                                                                          <chr>
#> 1                   http://downloads.hindawi.com/journals/ecam/2010/174726.pdf
#> 2  http://api.elsevier.com/content/article/PII:S0730725X10002742?httpAccept=te
#> 3  http://api.elsevier.com/content/article/PII:S0730725X10002742?httpAccept=te
#> 4  http://api.elsevier.com/content/article/PII:S1934590909005748?httpAccept=te
#> 5  http://api.elsevier.com/content/article/PII:S1934590909005748?httpAccept=te
#> 6  http://api.elsevier.com/content/article/PII:S0898656811002658?httpAccept=te
#> 7  http://api.elsevier.com/content/article/PII:S0898656811002658?httpAccept=te
#> 8  http://api.elsevier.com/content/article/PII:S0370269311010689?httpAccept=te
#> 9  http://api.elsevier.com/content/article/PII:S0370269311010689?httpAccept=te
#> 10                 http://downloads.hindawi.com/journals/ijmms/2008/424320.pdf
#> # ... with 29 more rows, and 3 more variables: content.type <chr>,
#> #   content.version <chr>, intended.application <chr>
```

From there, you can grab your full text, but because most links require
authentication, enter another package: `crminer`.

### Get full text

You'll need package `crminer` for the rest

Onc we have DOIs, get URLs to full text content


```r
if (!requireNamespace("crminer")) {
  install.packages("crminer")
}
```


```r
library(crminer)
(links <- crm_links(dois[1]))
#> $pdf
#> <url> http://downloads.hindawi.com/journals/ecam/2010/174726.pdf
```

Then use those URLs to get full text


```r
crm_pdf(links)
#> <document>/Users/sacmac/Library/Caches/crminer/174726.pdf
#>   Pages: 7
#>   No. characters: 36232
#>   Created: 2014-03-26
```

See also [fulltext](https://github.com/ropensci/fulltext) for getting scholarly text
for text mining.


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcrossref/issues).
* License: MIT
* Get citation information for `rcrossref` in R doing `citation(package = 'rcrossref')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles.

---

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
