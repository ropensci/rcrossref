rcrossref
=========



[![Build Status](https://api.travis-ci.org/ropensci/rcrossref.png)](https://travis-ci.org/ropensci/rcrossref)
[![Build status](https://ci.appveyor.com/api/projects/status/jbo6y7dg4qiq7mol/branch/master)](https://ci.appveyor.com/project/sckott/rcrossref/branch/master)
[![codecov.io](https://codecov.io/github/ropensci/rcrossref/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rcrossref?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/rcrossref)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rcrossref)](http://cran.rstudio.com/web/packages/rcrossref)

R interface to various CrossRef APIs
====================================


## CrossRef documentation

* Crossref API: [https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md)
* Crossref [metadata search API](http://search.labs.crossref.org/)
* CrossRef [DOI Content Negotiation](http://www.crosscite.org/cn/)
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

Use CrossRef's [DOI Content Negotiation](http://www.crosscite.org/cn/) service, where you can citations back in various formats, including `apa`


```r
cr_cn(dois = "10.1126/science.169.3946.635", format = "text", style = "apa")
#> [1] "Frank, H. S. (1970). The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance. Science, 169(3946), 635–641. doi:10.1126/science.169.3946.635"
```

`bibtex`


```r
cat(cr_cn(dois = "10.1126/science.169.3946.635", format = "bibtex"))
#> @article{Frank_1970,
#> 	doi = {10.1126/science.169.3946.635},
#> 	url = {http://dx.doi.org/10.1126/science.169.3946.635},
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
#> Boettiger; C (2012). "Regime shifts in ecology and evolution (PhD
#> Dissertation)." <URL: http://doi.org/10.6084/m9.figshare.97218>,
#> <URL: http://dx.doi.org/10.6084/m9.figshare.97218>.
```

## Citation count

Citation count, using OpenURL


```r
cr_citation_count(doi = "10.1371/journal.pone.0042793")
#> [1] 7
```

## Search Crossref metadata API

The following functions all use the [CrossRef API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

### Look up funder information


```r
cr_fundref(query = "NSF")
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1             8          NSF           0             20
#> 
#> $data
#> Source: local data frame [8 x 6]
#> 
#>             id      location
#>          (chr)         (chr)
#> 1 501100000930     Australia
#> 2    100000001 United States
#> 3    100003187 United States
#> 4    100008367       Denmark
#> 5 501100004190        Norway
#> 6    100000179 United States
#> 7    100006445 United States
#> 8 501100001809         China
#> Variables not shown: name (chr), alt.names (chr), uri (chr), tokens (chr)
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
#> 1        254101           NA           0              1
#> 
#> $data
#> Source: local data frame [1 x 23]
#> 
#>   alternative.id container.title    created  deposited
#>            (chr)           (chr)      (chr)      (chr)
#> 1                                2015-11-11 2015-11-11
#> Variables not shown: DOI (chr), funder (chr), indexed (chr), ISBN (chr),
#>   ISSN (chr), issued (chr), link (chr), member (chr), prefix (chr),
#>   publisher (chr), reference.count (chr), score (chr), source (chr),
#>   subject (chr), title (chr), type (chr), URL (chr), assertion (chr),
#>   author (chr)
#> 
#> $facets
#> NULL
```

### Search journals


```r
cr_journals(issn = c('1803-2427','2326-4225'))
#> Source: local data frame [2 x 15]
#> 
#>   alternative.id container.title created deposited funder indexed  ISBN
#>            (chr)           (chr)   (chr)     (chr)  (chr)   (chr) (chr)
#> 1                                                  <NULL>              
#> 2                                                  <NULL>              
#> Variables not shown: ISSN (chr), issued (chr), link (chr), publisher
#>   (chr), subject (chr), title (chr), assertion (chr), author (chr)
```

### Search license information


```r
cr_licenses(query = 'elsevier')
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1            11     elsevier           0             20
#> 
#> $data
#> Source: local data frame [11 x 2]
#> 
#>                                                                            URL
#>                                                                          (chr)
#> 1                            http://creativecommons.org/licenses/by-nc-nd/3.0/
#> 2                            http://creativecommons.org/licenses/by-nc-nd/4.0/
#> 3                                  http://creativecommons.org/licenses/by/3.0/
#> 4                                   http://doi.wiley.com/10.1002/tdm_license_1
#> 5                            http://onlinelibrary.wiley.com/termsAndConditions
#> 6         http://www.acm.org/publications/policies/copyright_policy#Background
#> 7                         http://www.elsevier.com/open-access/userlicense/1.0/
#> 8                                 http://www.elsevier.com/tdm/userlicense/1.0/
#> 9                                                  http://www.springer.com/tdm
#> 10 © 2007 Elsevier Masson SAS. All rights reserved. The patient figure in Figu
#> 11 © 2012, Elsevier Inc., All Rights Reserved. Figure 8, part (B) (images of H
#> Variables not shown: work.count (int)
```

### Search based on DOI prefixes


```r
cr_prefixes(prefixes = c('10.1016','10.1371','10.1023','10.4176','10.1093'))
#> $meta
#> NULL
#> 
#> $data
#> Source: local data frame [5 x 3]
#> 
#>                               member                              name
#>                                (chr)                             (chr)
#> 1   http://id.crossref.org/member/78                       Elsevier BV
#> 2  http://id.crossref.org/member/340  Public Library of Science (PLoS)
#> 3  http://id.crossref.org/member/297 Springer Science + Business Media
#> 4 http://id.crossref.org/member/1989              Co-Action Publishing
#> 5  http://id.crossref.org/member/286     Oxford University Press (OUP)
#> Variables not shown: prefix (chr)
#> 
#> $facets
#> list()
```

### Search CrossRef members


```r
cr_members(query = 'ecology', limit = 5)
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1            17      ecology           0              5
#> 
#> $data
#> Source: local data frame [5 x 40]
#> 
#>      id                                             primary_name
#>   (int)                                                    (chr)
#> 1  7052                         Chinese Journal of Plant Ecology
#> 2  6933                          Knowledge Ecology International
#> 3  7278 Korean Society of Ecology and Infrastructure Engineering
#> 4  7745                             Institute of Applied Ecology
#> 5   336                    Japanese Society of Microbial Ecology
#> Variables not shown: location (chr), last_status_check_time (date),
#>   backfile.dois (chr), current.dois (chr), total.dois (chr), prefixes
#>   (chr), coverge.funders.backfile (chr), coverge.licenses.backfile (chr),
#>   coverge.funders.current (chr), coverge.resource.links.backfile (chr),
#>   coverge.orcids.backfile (chr), coverge.update.policies.current (chr),
#>   coverge.orcids.current (chr), coverge.references.backfile (chr),
#>   coverge.award.numbers.backfile (chr), coverge.update.policies.backfile
#>   (chr), coverge.licenses.current (chr), coverge.award.numbers.current
#>   (chr), coverge.resource.links.current (chr), coverge.references.current
#>   (chr), flags.deposits.orcids.current (chr), flags.deposits (chr),
#>   flags.deposits.update.policies.backfile (chr),
#>   flags.deposits.award.numbers.current (chr),
#>   flags.deposits.resource.links.current (chr), flags.deposits.articles
#>   (chr), flags.deposits.funders.current (chr),
#>   flags.deposits.references.backfile (chr),
#>   flags.deposits.licenses.backfile (chr),
#>   flags.deposits.award.numbers.backfile (chr),
#>   flags.deposits.references.current (chr),
#>   flags.deposits.resource.links.backfile (chr),
#>   flags.deposits.orcids.backfile (chr), flags.deposits.funders.backfile
#>   (chr), flags.deposits.update.policies.current (chr),
#>   flags.deposits.licenses.current (chr), names (chr), tokens (chr)
#> 
#> $facets
#> NULL
```

### Get N random DOIs

`cr_r()` uses the function `cr_works()` internally.


```r
cr_r()
#>  [1] "10.5594/j16363"                   "10.1093/icsidreview/23.1.164"    
#>  [3] "10.1007/bf03302528"               "10.1163/1877-8054_cmri_com_24648"
#>  [5] "10.1080/08911916.1996.11643918"   "10.1007/978-94-011-1472-1_34"    
#>  [7] "10.4267/10608/4227"               "10.1103/physrevd.36.527"         
#>  [9] "10.1002/pam.20136"                "10.1016/j.ijleo.2015.09.110"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
#> [1] "10.1201/b19172-3"        "10.4236/msce.2013.15009"
```

## pmid2doi & doi2pmid

DOIs to PMIDs

__UPDATE: as of 2014-12-23 the web API behind these functions is down - we'll update the package once the API is up again__

## Get full text links to works

Publishers can optionally provide links in the metadata they provide to Crossref for full text of the work, but that data is often missing. Find out more about it at [http://tdmsupport.crossref.org/](http://tdmsupport.crossref.org/).

Get some DOIs for articles that provide full text, and that have `CC-BY 3.0` licenses (i.e., more likely to actually be open)


```r
out <-
  cr_works(filter = list(has_full_text = TRUE,
    license_url = "http://creativecommons.org/licenses/by/3.0/"))
(dois <- out$data$DOI)
#>  [1] "10.1155/2015/108274"        "10.1016/j.susc.2014.02.008"
#>  [3] "10.1155/2014/152487"        "10.1016/j.susc.2014.03.018"
#>  [5] "10.1155/2014/101496"        "10.1155/2014/156438"       
#>  [7] "10.1155/1989/60313"         "10.1155/2008/683505"       
#>  [9] "10.1155/2009/867380"        "10.1155/2009/316249"       
#> [11] "10.4061/2010/147142"        "10.1155/2010/285376"       
#> [13] "10.5402/2011/736062"        "10.1155/2011/434375"       
#> [15] "10.1155/2011/891593"        "10.1155/2010/282464"       
#> [17] "10.1155/2011/875028"        "10.1155/2011/463704"       
#> [19] "10.1155/2011/129341"        "10.1155/2011/814794"
```

Then get URLs to full text content


```r
(links <- cr_ft_links(dois[1]))
#> <url> http://downloads.hindawi.com/journals/cmmm/2015/108274.xml
```

Then use those URLs to get full text


```r
cr_ft_text(links, "xml")
#> <?xml version="1.0"?>
#> <article xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://jats.nlm.nih.gov/publishing/1.1d1/xsd/JATS-journalpublishing1-mathml3.xsd" dtd-version="1.1d1">
#>   <front>
#>     <journal-meta>
#>       <journal-id journal-id-type="publisher-id">SV</journal-id>
#>       <journal-title-group>
#>         <journal-title>Shock and Vibration</journal-title>
#>       </journal-title-group>
#>       <issn pub-type="epub">1875-9203</issn>
#>       <issn pub-type="ppub">1070-9622</issn>
#>       <publisher>
#>         <publisher-name>Hindawi Publishing Corporation</publisher-name>
#>       </publisher>
#>     </journal-meta>
#> .................... cutoff
```


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcrossref/issues).
* License: MIT
* Get citation information for `rcrossref` in R doing `citation(package = 'rcrossref')`
* Please note that this project is released with a [Contributor Code of Conduct](CONDUCT.md). By participating in this project you agree to abide by its terms.

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles.

---

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
