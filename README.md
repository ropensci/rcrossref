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
* Crossref [metadata search API](http://search.labs.crossref.org/)
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
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1             7          NSF           0             20
#> 
#> $data
#> Source: local data frame [7 x 6]
#> 
#>             id      location
#> 1 501100004190        Norway
#> 2    100000179 United States
#> 3 501100000930     Australia
#> 4    100003187 United States
#> 5    100000001 United States
#> 6    100006445 United States
#> 7 501100001809         China
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
cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'), limit=1)
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1        106345           NA           0              1
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
#> 2 http://www.elsevier.com/tdm/userlicense/1.0/        130
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
#>     id                                 primary_name
#> 1 3947          Korean Association of Human Ecology
#> 2 2080        The Japan Society of Tropical Ecology
#> 3 2151        Ecology and Civil Engineering Society
#> 4 2232 Japanese Society of Health and Human Ecology
#> 5  336        Japanese Society of Microbial Ecology
#> Variables not shown: location (chr), last_status_check_time (date),
#>   backfile.dois (chr), current.dois (chr), X.10.5934. (chr),
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
#>   (chr), names (chr), tokens (chr), X.10.3759. (chr), X.10.3825. (chr),
#>   X.10.3861. (chr), X.10.1264. (chr)
#> 
#> $facets
#> NULL
```

### Get N random DOIs

`cr_r()` uses the function `cr_works()` internally. 


```r
cr_r()
#>  [1] "10.1038/098217b0"                 "10.1115/icef2011-60114"          
#>  [3] "10.12968/chca.2010.7.8.49102"     "10.1111/j.1440-1746.2010.06409.x"
#>  [5] "10.1017/cbo9781139168564.012"     "10.1037//0021-843x.106.2.230"    
#>  [7] "10.7152/bippa.v29i0.9482"         "10.1021/es3036779"               
#>  [9] "10.1016/0197-2456(88)90026-8"     "10.1002/cne.910090123"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
#> [1] "10.1176/appi.ajp.159.8.1446" "10.2307/1435747"
```

## pmid2doi & doi2pmid

DOIs to PMIDs


```r
doi2pmid("10.1016/0006-2944(75)90147-7")
#>   pmid                          doi
#> 1    1 10.1016/0006-2944(75)90147-7
```


```r
doi2pmid("10.1016/0006-2944(75)90147-7", TRUE)
#> [1] 1
```


```r
doi2pmid(c("10.1016/0006-2944(75)90147-7","10.1186/gb-2008-9-5-r89"))
#>       pmid                          doi
#> 1        1 10.1016/0006-2944(75)90147-7
#> 2 18507872      10.1186/gb-2008-9-5-r89
```

PMIDs to DOIs


```r
pmid2doi(18507872)
#>       pmid                     doi
#> 1 18507872 10.1186/gb-2008-9-5-r89
```


```r
pmid2doi(18507872, TRUE)
#> [1] "10.1186/gb-2008-9-5-r89"
```


```r
pmid2doi(c(1,2,3))
#>   pmid                          doi
#> 1    1 10.1016/0006-2944(75)90147-7
#> 2    2 10.1016/0006-291X(75)90482-9
#> 3    3 10.1016/0006-291X(75)90498-2
```

<!--
## Get full text links to works

This is a mostly experimental function so far in that it may not work that often. Publishers can optionally provide links in the metadata they provide to Crossref for full text of the work, but that data is often missing. Find out more about it at [http://tdmsupport.crossref.org/](http://tdmsupport.crossref.org/). Some examples that do work:

Get link to the pdf


```r
cr_full_links(doi = "10.5555/515151", type = "pdf")
#> Error in eval(expr, envir, enclos): could not find function "cr_full_links"
```

Get a bunch of DOIs first, then get many URLs back


```r
out <- cr_works(filter=c(has_full_text = TRUE))
dois <- out$data$DOI
sapply(dois[1:5], cr_full_links, type="xml")
#> Error in match.fun(FUN): object 'cr_full_links' not found
```
-->


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcrossref/issues).
* License: MIT
* Get citation information for `rcrossref` in R doing `citation(package = 'rcrossref')`

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles. 

---

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
