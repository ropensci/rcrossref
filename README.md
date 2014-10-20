rcrossref
=========



[![Build Status](https://api.travis-ci.org/ropensci/rcrossref.png)](https://travis-ci.org/ropensci/rcrossref)
[![Build status](https://ci.appveyor.com/api/projects/status/jbo6y7dg4qiq7mol/branch/master)](https://ci.appveyor.com/project/sckott/rcrossref/branch/master)

R interface to various CrossRef APIs

CrossRef documentation
---------------

<!--
* [Register](http://www.crossref.org/requestaccount/) an email address with the CrossRef API as you'll need an API key for some functions.
-->

* Crossref API: [https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md)
* CrossRef [OpenURL](http://www.crossref.org/openurl/)
* CrossRef [DOI Content Negotiation](http://www.crosscite.org/cn/)

<!--
* Fundref: [source 1](https://github.com/CrossRef/rest-api-doc/blob/master/funder_kpi_api.md), [source 2](http://crosstech.crossref.org/2014/04/%E2%99%AB-researchers-just-wanna-have-funds-%E2%99%AB.html), [source 3](http://help.crossref.org/#fundref-api)
* [Content negotiation](http://www.crosscite.org/cn/)
* [Metadata search]()
* [Text and data mining (TDM)](http://tdmsupport.crossref.org/)
-->

## Installation


```r
install.packages("devtools")
devtools::install_github("ropensci/rcrossref")
```

Load `rcrossref`


```r
library('rcrossref')
```


## Citation search

Look up a citation using [OpenURL](http://www.crossref.org/openurl/)


```r
cr_citation(doi="10.1371/journal.pone.0042793")
#> Calvo R, Zheng Y, Kumar S, Olgiati A, Berkman L and Mock N (2012).
#> "Well-Being and Social Capital on Planet Earth: Cross-National
#> Evidence from 142 Countries." _PLoS ONE_, *7*. <URL:
#> http://dx.doi.org/10.1371/journal.pone.0042793>.
```

Or use CrossRef's [DOI Content Negotiation](http://www.crosscite.org/cn/) service, where you can citations back in various formats, including `apa`


```r
cr_cn(dois = "10.1126/science.169.3946.635", format = "text", style = "apa")
#> [1] "Frank, H. S. (1970). The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance. Science, 169(3946), 635â\u0080\u0093641. doi:10.1126/science.169.3946.635\n"
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
#> Dissertation)." <URL:
#> http://dx.doi.org/10.6084/m9.figshare.97218>, <URL:
#> http://dx.doi.org/10.6084/m9.figshare.97218>.
```


## Citation count

Citation count, using [OpenURL](http://www.crossref.org/openurl/)


```r
cr_citation_count(doi="10.1371/journal.pone.0042793")
#> [1] 3
```



## Search Crossref metadata API

The following functions all use the [CrossRef API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

### Look up funder information


```r
cr_fundref(query="NSF")
#> $items
#>             id      location
#> 1 501100004190        Norway
#> 2 501100001809         China
#> 3 501100000930     Australia
#> 4    100003187 United States
#> 5    100000001 United States
#> 6    100006445 United States
#> 7    100000179 United States
#>                                                                 name
#> 1                                            Norsk Sykepleierforbund
#> 2                       National Natural Science Foundation of China
#> 3                                         National Stroke Foundation
#> 4                                          National Sleep Foundation
#> 5                                        National Science Foundation
#> 6 Center for Hierarchical Manufacturing, National Science Foundation
#> 7                                         NSF Office of the Director
#>                                                                         alt-names
#> 1                                              NSF, Norwegian Nurses Organisation
#> 2                                                                            NSFC
#> 3                                                                             NSF
#> 4                                                                             NSF
#> 5                                                                             NSF
#> 6 University of Massachusetts NSF Center for Hierarchical Manufacturing, CHM, NSF
#> 7                                                                              OD
#>                                       uri
#> 1 http://dx.doi.org/10.13039/501100004190
#> 2 http://dx.doi.org/10.13039/501100001809
#> 3 http://dx.doi.org/10.13039/501100000930
#> 4    http://dx.doi.org/10.13039/100003187
#> 5    http://dx.doi.org/10.13039/100000001
#> 6    http://dx.doi.org/10.13039/100006445
#> 7    http://dx.doi.org/10.13039/100000179
#>                                                                                                                                                            tokens
#> 1                                                                                                  norsk, sykepleierforbund, nsf, norwegian, nurses, organisation
#> 2                                                                                                         national, natural, science, foundation, of, china, nsfc
#> 3                                                                                                                               national, stroke, foundation, nsf
#> 4                                                                                                                                national, sleep, foundation, nsf
#> 5                                                                                                                              national, science, foundation, nsf
#> 6 center, for, hierarchical, manufacturing, national, science, foundation, university, of, massachusetts, nsf, center, for, hierarchical, manufacturing, chm, nsf
#> 7                                                                                                                              nsf, office, of, the, director, od
#> 
#> $`total-results`
#> [1] 7
#> 
#> $query
#> $query$`search-terms`
#> [1] "NSF"
#> 
#> $query$`start-index`
#> [1] 0
#> 
#> 
#> $`items-per-page`
#> [1] 20
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
cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'), limit=1)
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1         96757           NA           0              1
#> 
#> $data
#> Source: local data frame [1 x 21]
#> 
#>      issued score                                prefix container.title
#> 1 2013-6-14     1 http://id.crossref.org/prefix/10.5194  Biogeosciences
#> Variables not shown: reference.count (chr), deposited (chr), title (chr),
#>   type (chr), DOI (chr), URL (chr), source (chr), publisher (chr), indexed
#>   (chr), member (chr), page (chr), ISBN (chr), subject (chr), author
#>   (chr), issue (chr), ISSN (chr), volume (chr)
#> 
#> $facets
#> [1] NA
```

### Search journals 


```r
cr_journals(issn=c('1803-2427','2326-4225'))
#> Source: local data frame [2 x 13]
#> 
#>   issued container.title deposited
#> 1                                 
#> 2                                 
#> Variables not shown: title (chr), publisher (chr), indexed (chr), ISBN
#>   (chr), subject (chr), author (chr), issue (chr), ISSN (chr), volume
#>   (chr), issn (chr)
```

### Search license information


```r
cr_licenses(query = 'elsevier')
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1             2     elsevier           0             20
#> 
#> $data
#> Source: local data frame [2 x 2]
#> 
#>                                            URL work.count
#> 1  http://creativecommons.org/licenses/by/3.0/          1
#> 2 http://www.elsevier.com/tdm/userlicense/1.0/         92
```

### Search based on DOI prefixes


```r
cr_prefixes(prefixes=c('10.1016','10.1371','10.1023','10.4176','10.1093'))
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
cr_members(query='ecology', limit = 5)
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1            13      ecology           0              5
#> 
#> $data
#> Source: local data frame [5 x 43]
#> 
#>     id                                               primary_name
#> 1  336                      Japanese Society of Microbial Ecology
#> 2 1950                                  Journal of Vector Ecology
#> 3 2080                      The Japan Society of Tropical Ecology
#> 4 2151                      Ecology and Civil Engineering Society
#> 5 2169 Italian Society of Sivilculture and Forest Ecology (SISEF)
#> Variables not shown: location (chr), last_status_check_time (date),
#>   backfile.dois (chr), current.dois (chr), X.10.1264. (chr),
#>   coverge.resource.links.backfile (chr), coverge.funders.current (chr),
#>   coverge.funders.backfile (chr), coverge.references.current (chr),
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
#>   (chr), names (chr), tokens (chr), X.10.3376. (chr), X.10.3759. (chr),
#>   X.10.3825. (chr), X.10.3832. (chr)
#> 
#> $facets
#> NULL
```

### Get N random DOIs

`cr_r()` uses the function `cr_works()` internally. 


```r
cr_r()
#>  [1] "10.1007/978-1-4615-7237-4_4"      "10.1111/irj.2011.42.issue-3"     
#>  [3] "10.1080/07303084.1983.10631204"   "10.1109/tei.1986.349102"         
#>  [5] "10.1016/s1003-6326(14)63252-0"    "10.1088/0029-5515/25/1/006"      
#>  [7] "10.3764/ajaonline1104.alramstern" "10.1111/j.1744-1722.2006.00030.x"
#>  [9] "10.2524/jtappij.11.249"           "10.3945/ajcn.112.037143"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
#> [1] "10.1016/j.fct.2004.11.021"    "10.1016/0272-8842(93)90061-u"
```


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcrossref/issues).
* License: MIT
* This package is part of the [rOpenSci](http://ropensci.org/packages) project.
* Get citation information for `rcrossref` in R doing `citation(package = 'rcrossref')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
