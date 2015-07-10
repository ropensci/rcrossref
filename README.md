rcrossref
=========



[![Build Status](https://api.travis-ci.org/ropensci/rcrossref.png)](https://travis-ci.org/ropensci/rcrossref)
[![Build status](https://ci.appveyor.com/api/projects/status/jbo6y7dg4qiq7mol/branch/master)](https://ci.appveyor.com/project/sckott/rcrossref/branch/master)
[![Coverage Status](https://coveralls.io/repos/ropensci/rcrossref/badge.svg)](https://coveralls.io/r/ropensci/rcrossref)
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
#> [1] 6
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
#> 1 501100004190        Norway
#> 2    100000179 United States
#> 3    100006445 United States
#> 4    100003187 United States
#> 5 501100001809         China
#> 6 501100000930     Australia
#> 7    100008367       Denmark
#> 8    100000001 United States
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
#> 1        229074           NA           0              1
#> 
#> $data
#> Source: local data frame [1 x 25]
#> 
#>    issued score                                prefix
#> 1 2015-02     1 http://id.crossref.org/prefix/10.1016
#> Variables not shown: container.title (chr), reference.count (chr),
#>   deposited (chr), title (chr), type (chr), DOI (chr), URL (chr), source
#>   (chr), publisher (chr), indexed (chr), member (chr), page (chr), ISBN
#>   (chr), subject (chr), author (chr), issue (chr), ISSN (chr), volume
#>   (chr), license_date (chr), license_content.version (chr),
#>   license_delay.in.days (chr), license_URL (chr)
#> 
#> $facets
#> NULL
```

### Search journals


```r
cr_journals(issn = c('1803-2427','2326-4225'))
#> Source: local data frame [2 x 12]
#> 
#>   issued container.title deposited
#> 1                                 
#> 2                                 
#> Variables not shown: title (chr), publisher (chr), indexed (chr), ISBN
#>   (chr), subject (chr), author (chr), issue (chr), ISSN (chr), volume
#>   (chr)
```

### Search license information


```r
cr_licenses(query = 'elsevier')
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1             7     elsevier           0             20
#> 
#> $data
#> Source: local data frame [7 x 2]
#> 
#>                                                                           URL
#> 1                           http://creativecommons.org/licenses/by-nc-nd/3.0/
#> 2                           http://creativecommons.org/licenses/by-nc-nd/4.0/
#> 3                                 http://creativecommons.org/licenses/by/3.0/
#> 4                        http://www.elsevier.com/open-access/userlicense/1.0/
#> 5                                http://www.elsevier.com/tdm/userlicense/1.0/
#> 6 © 2007 Elsevier Masson SAS. All rights reserved. The patient figure in Figu
#> 7 © 2012, Elsevier Inc., All Rights Reserved. Figure 8, part (B) (images of H
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
#>     id                                 primary_name
#> 1 3947          Korean Association of Human Ecology
#> 2 2151        Ecology and Civil Engineering Society
#> 3 2080        The Japan Society of Tropical Ecology
#> 4 2232 Japanese Society of Health and Human Ecology
#> 5  336        Japanese Society of Microbial Ecology
#> Variables not shown: location (chr), last_status_check_time (date),
#>   backfile.dois (chr), current.dois (chr), total.dois (chr), prefixes
#>   (chr), coverge.resource.links.backfile (chr), coverge.funders.current
#>   (chr), coverge.funders.backfile (chr), coverge.references.current (chr),
#>   coverge.references.backfile (chr), coverge.update.policies.backfile
#>   (chr), coverge.resource.links.current (chr),
#>   coverge.update.policies.current (chr), coverge.award.numbers.current
#>   (chr), coverge.orcids.current (chr), coverge.orcids.backfile (chr),
#>   coverge.award.numbers.backfile (chr), coverge.licenses.current (chr),
#>   coverge.licenses.backfile (chr), flags.deposits.award.numbers.backfile
#>   (chr), flags.deposits (chr), flags.deposits.licenses.backfile (chr),
#>   flags.deposits.resource.links.backfile (chr),
#>   flags.deposits.licenses.current (chr), flags.deposits.orcids.current
#>   (chr), flags.deposits.funders.backfile (chr),
#>   flags.deposits.references.current (chr), flags.deposits.orcids.backfile
#>   (chr), flags.deposits.references.backfile (chr),
#>   flags.deposits.resource.links.current (chr),
#>   flags.deposits.award.numbers.current (chr),
#>   flags.deposits.update.policies.backfile (chr),
#>   flags.deposits.funders.current (chr),
#>   flags.deposits.update.policies.current (chr), flags.deposits.articles
#>   (chr), names (chr), tokens (chr)
#> 
#> $facets
#> NULL
```

### Get N random DOIs

`cr_r()` uses the function `cr_works()` internally.


```r
cr_r()
#>  [1] "10.1016/s1090-3798(08)70717-7"    
#>  [2] "10.5006/0010-9312-5.12.416"       
#>  [3] "10.1016/s0092-8240(74)80059-5"    
#>  [4] "10.1002/jps.10429"                
#>  [5] "10.1371/journal.pone.0036908.g005"
#>  [6] "10.1086/270400"                   
#>  [7] "10.4327/jsnfs.57.179"             
#>  [8] "10.1126/science.164.3885.1224-a"  
#>  [9] "10.2307/208505"                   
#> [10] "10.1079/9781845930691.0163"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
#> [1] "10.12775/ae.2010.012" "10.1375/anft.29.1.51"
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
#>  [1] "10.1063/1.4905851"         "10.1063/1.4905271"        
#>  [3] "10.1063/1.4905272"         "10.1155/2014/214587"      
#>  [5] "10.1155/2014/245347"       "10.1155/2014/340936"      
#>  [7] "10.1155/2014/902492"       "10.1155/2014/524940"      
#>  [9] "10.1155/2014/137231"       "10.1155/2014/598762"      
#> [11] "10.1155/2014/256879"       "10.1155/2014/182303"      
#> [13] "10.1155/2014/954604"       "10.1155/2014/846581"      
#> [15] "10.1155/2014/164714"       "10.1155/2014/687608"      
#> [17] "10.1155/s1110724303209050" "10.1155/s0161171203203203"
#> [19] "10.1155/s0161171203211480" "10.1002/cfg.287"
```

Then get URLs to full text content


```r
(links <- cr_ft_links(dois[1]))
#> NULL
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

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles.

---

[![rofooter](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
