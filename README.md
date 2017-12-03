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
* Crossref metadata search API (http://search.labs.crossref.org/)
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
```

## Citation count

Citation count, using OpenURL


```r
cr_citation_count(doi = "10.1371/journal.pone.0042793")
#> [1] 17
```

## Search Crossref metadata API

The following functions all use the [CrossRef API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

### Look up funder information


```r
cr_funders(query = "NSF")
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1             9          NSF           0             20
#> 
#> $data
#> # A tibble: 9 x 6
#>             id      location
#>          <chr>         <chr>
#> 1    100006445 United States
#> 2    100003187 United States
#> 3 501100008982     Sri Lanka
#> 4    100008367       Denmark
#> 5 501100004190        Norway
#> 6    100000179 United States
#> 7 501100000930     Australia
#> 8    100000001 United States
#> 9 501100001809         China
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
#> [1] "Crossref"
```

### Search works (i.e., articles)


```r
cr_works(filter = c(has_orcid = TRUE, from_pub_date = '2004-04-04'), limit = 1)
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1       1078355           NA           0              1
#> 
#> $data
#> # A tibble: 1 x 26
#>                    container.title    created  deposited
#>                              <chr>      <chr>      <chr>
#> 1 Journal of Materials Chemistry B 2015-01-13 2017-11-12
#> # ... with 23 more variables: DOI <chr>, indexed <chr>, ISSN <chr>,
#> #   issue <chr>, issued <chr>, member <chr>, page <chr>, prefix <chr>,
#> #   publisher <chr>, reference.count <chr>, score <chr>, source <chr>,
#> #   subject <chr>, title <chr>, type <chr>, update.policy <chr>,
#> #   URL <chr>, volume <chr>, abstract <chr>, assertion <list>,
#> #   author <list>, funder <list>, link <list>
#> 
#> $facets
#> NULL
```

### Search journals


```r
cr_journals(issn = c('1803-2427','2326-4225'))
#> $data
#> # A tibble: 2 x 3
#>                  ISSN                      publisher
#>                 <chr>                          <chr>
#> 1 1805-4196,1803-2427    De Gruyter Open Sp. z o.o. 
#> 2           2326-4225 American Scientific Publishers
#> # ... with 1 more variables: title <chr>
#> 
#> $facets
#> NULL
```

### Search license information


```r
cr_licenses(query = 'elsevier')
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1            22     elsevier           0             20
#> 
#> $data
#> # A tibble: 22 x 2
#>                                                         URL work.count
#>                                                       <chr>      <int>
#>  1 http://aspb.org/publications/aspb-journals/open-articles          1
#>  2        http://creativecommons.org/licenses/by-nc-nd/3.0/         12
#>  3        http://creativecommons.org/licenses/by-nc-nd/4.0/          7
#>  4           http://creativecommons.org/licenses/by-nc/4.0/          1
#>  5              http://creativecommons.org/licenses/by/3.0/          1
#>  6               http://creativecommons.org/licenses/by/4.0          1
#>  7              http://creativecommons.org/licenses/by/4.0/          1
#>  8               http://doi.wiley.com/10.1002/tdm_license_1        157
#>  9             http://doi.wiley.com/10.1002/tdm_license_1.1       2166
#> 10   http://journals.iucr.org/services/copyrightpolicy.html         10
#> # ... with 12 more rows
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
#> # A tibble: 5 x 48
#>      id                            primary_name
#>   <int>                                   <chr>
#> 1   336   Japanese Society of Microbial Ecology
#> 2  1950               Journal of Vector Ecology
#> 3  2080   The Japan Society of Tropical Ecology
#> 4  2467          Ideas in Ecology and Evolution
#> 5  3732 Japan Association for Landscape Ecology
#> # ... with 46 more variables: location <chr>,
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
#>  [1] "10.2210/pdb4ut7/pdb"               
#>  [2] "10.1108/vjikms-01-2016-0002"       
#>  [3] "10.7251/ghte1410087p"              
#>  [4] "10.1111/j.1467-8292.1953.tb01215.x"
#>  [5] "10.1093/jnci/djh130"               
#>  [6] "10.1061/40743(142)19"              
#>  [7] "10.1016/j.apradiso.2013.11.126"    
#>  [8] "10.1007/s00066-014-0720-3"         
#>  [9] "10.1021/jp9818176"                 
#> [10] "10.1016/j.enbuild.2003.10.013"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
#> [1] "10.1016/s0950-5601(54)80052-9" "10.1016/s0020-7292(12)61466-0"
```

## Get full text

Publishers can optionally provide links in the metadata they provide to Crossref for full text of the work, but that data is often missing. Find out more about it at [http://tdmsupport.crossref.org/](http://tdmsupport.crossref.org/).

Get some DOIs for articles that provide full text, and that have `CC-BY 3.0` licenses (i.e., more likely to actually be open)


```r
out <-
  cr_works(filter = list(has_full_text = TRUE,
    license_url = "http://creativecommons.org/licenses/by/3.0/"))
(dois <- out$data$DOI)
#>  [1] "10.1016/s0370-2693(01)01481-2" "10.1016/s0370-2693(01)01478-2"
#>  [3] "10.1016/s0370-2693(01)01480-0" "10.1016/s0370-2693(01)01482-4"
#>  [5] "10.1016/s0370-2693(01)01488-5" "10.1016/s0370-2693(01)01490-3"
#>  [7] "10.1016/s0370-2693(01)01492-7" "10.1016/s0370-2693(01)01465-4"
#>  [9] "10.1016/s0370-2693(01)01442-3" "10.1016/s0370-2693(01)01418-6"
#> [11] "10.1016/s0370-2693(01)01395-8" "10.1016/s0370-2693(01)01426-5"
#> [13] "10.1016/s0370-2693(01)01415-0" "10.1016/s0370-2693(01)01425-3"
#> [15] "10.1016/s0370-2693(01)01410-1" "10.1016/s0370-2693(01)01419-8"
#> [17] "10.1016/s0370-2693(01)01420-4" "10.1016/s0370-2693(01)01427-7"
#> [19] "10.1016/s0370-2693(01)01282-5" "10.1016/s0370-2693(01)01424-1"
```

From the output of `cr_works` we can get full text links if we know where to look:


```r
do.call("rbind", out$data$link)
#> # A tibble: 40 x 4
#>                                                                            URL
#>                                                                          <chr>
#>  1 http://api.elsevier.com/content/article/PII:S0370269301014812?httpAccept=te
#>  2 http://api.elsevier.com/content/article/PII:S0370269301014812?httpAccept=te
#>  3 http://api.elsevier.com/content/article/PII:S0370269301014782?httpAccept=te
#>  4 http://api.elsevier.com/content/article/PII:S0370269301014782?httpAccept=te
#>  5 http://api.elsevier.com/content/article/PII:S0370269301014800?httpAccept=te
#>  6 http://api.elsevier.com/content/article/PII:S0370269301014800?httpAccept=te
#>  7 http://api.elsevier.com/content/article/PII:S0370269301014824?httpAccept=te
#>  8 http://api.elsevier.com/content/article/PII:S0370269301014824?httpAccept=te
#>  9 http://api.elsevier.com/content/article/PII:S0370269301014885?httpAccept=te
#> 10 http://api.elsevier.com/content/article/PII:S0370269301014885?httpAccept=te
#> # ... with 30 more rows, and 3 more variables: content.type <chr>,
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
#> $xml
#> <url> https://api.elsevier.com/content/article/PII:S0370269301014812?httpAccept=text/xml
#> 
#> $plain
#> <url> https://api.elsevier.com/content/article/PII:S0370269301014812?httpAccept=text/plain
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
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles.

---

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
