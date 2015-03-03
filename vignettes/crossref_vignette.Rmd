<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Crossref vignette}
-->



## Installation

Install stable version from CRAN


```r
install.packages("rcrossref")
```

Or development version from GitHub


```r
devtools::install_github("ropensci/rcrossref")
```


```r
library("rcrossref")
```

## Citation search

CrossRef's [DOI Content Negotiation](http://www.crosscite.org/cn/) service, where you can citations back in various formats, including `apa`


```r
cr_cn(dois = "10.1371/journal.pone.0112608", format = "text", style = "apa")
```

```
## [1] "Wang, Q., & Taylor, J. E. (2014). Quantifying Human Mobility Perturbation and Resilience in Hurricane Sandy. PLoS ONE, 9(11), e112608. doi:10.1371/journal.pone.0112608"
```

There are a lot more styles. We include a dataset as a character vector within the package, accessible via the `get_styles()` function, e.g., 


```r
get_styles()[1:5]
```

```
## [1] "academy-of-management-review"                   
## [2] "acm-sig-proceedings-long-author-list"           
## [3] "acm-sig-proceedings"                            
## [4] "acm-sigchi-proceedings-extended-abstract-format"
## [5] "acm-sigchi-proceedings"
```

`bibtex`


```r
cat(cr_cn(dois = "10.1126/science.169.3946.635", format = "bibtex"))
```

```
## @article{Frank_1970,
## 	doi = {10.1126/science.169.3946.635},
## 	url = {http://dx.doi.org/10.1126/science.169.3946.635},
## 	year = 1970,
## 	month = {aug},
## 	publisher = {American Association for the Advancement of Science ({AAAS})},
## 	volume = {169},
## 	number = {3946},
## 	pages = {635--641},
## 	author = {H. S. Frank},
## 	title = {The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance},
## 	journal = {Science}
## }
```

`bibentry`


```r
cr_cn(dois = "10.6084/m9.figshare.97218", format = "bibentry")
```

```
## Boettiger; C (2012). "Regime shifts in ecology and evolution (PhD
## Dissertation)." <URL:
## http://dx.doi.org/10.6084/m9.figshare.97218>, <URL:
## http://dx.doi.org/10.6084/m9.figshare.97218>.
```

## Citation count

Citation count, using OpenURL


```r
cr_citation_count(doi="10.1371/journal.pone.0042793")
```

```
## [1] 5
```

## Search Crossref metadata API

There are two functions that use an older Crossre API: `cr_search()` and `cr_search_free()`. You can of course use them, but the newer Crossref API available through various functions (`cr_agency()`, `cr_fundref()`, `cr_journals()`, `cr_licenses()`, `cr_members()`, `cr_prefixes()`, and `cr_works()`) is more powerful and will recieve more support going forward. The following functions (of the newer set just mentioend) all use the [CrossRef API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

### Look up funder information


```r
cr_fundref(query="NSF")
```

```
## $meta
##   total_results search_terms start_index items_per_page
## 1             8          NSF           0             20
## 
## $data
## Source: local data frame [8 x 6]
## 
##             id      location
## 1 501100004190        Norway
## 2    100000179 United States
## 3 501100000930     Australia
## 4    100008367       Denmark
## 5    100003187 United States
## 6    100000001 United States
## 7    100006445 United States
## 8 501100001809         China
## Variables not shown: name (chr), alt.names (chr), uri (chr), tokens (chr)
```

### Check the DOI minting agency


```r
cr_agency(dois = '10.13039/100000001')
```

```
## $DOI
## [1] "10.13039/100000001"
## 
## $agency
## $agency$id
## [1] "crossref"
## 
## $agency$label
## [1] "CrossRef"
```

### Search works (i.e., articles, books, etc.)


```r
cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'), limit=1)
```

```
## $meta
##   total_results search_terms start_index items_per_page
## 1        128970           NA           0              1
## 
## $data
## Source: local data frame [1 x 24]
## 
##    issued score                                prefix
## 1 2014-12     1 http://id.crossref.org/prefix/10.1016
## Variables not shown: container.title (chr), reference.count (chr),
##   deposited (chr), title (chr), type (chr), DOI (chr), URL (chr), source
##   (chr), publisher (chr), indexed (chr), member (chr), ISBN (chr), subject
##   (chr), author (chr), issue (chr), ISSN (chr), volume (chr), license_date
##   (chr), license_content.version (chr), license_delay.in.days (chr),
##   license_URL (chr)
## 
## $facets
## NULL
```

### Search journals 


```r
cr_journals(issn=c('1803-2427','2326-4225'))
```

```
## Source: local data frame [2 x 12]
## 
##   issued container.title deposited
## 1                                 
## 2                                 
## Variables not shown: title (chr), publisher (chr), indexed (chr), ISBN
##   (chr), subject (chr), author (chr), issue (chr), ISSN (chr), volume
##   (chr)
```

### Search license information


```r
cr_licenses(query = 'elsevier')
```

```
## $meta
##   total_results search_terms start_index items_per_page
## 1             2     elsevier           0             20
## 
## $data
## Source: local data frame [2 x 2]
## 
##                                            URL work.count
## 1  http://creativecommons.org/licenses/by/3.0/          1
## 2 http://www.elsevier.com/tdm/userlicense/1.0/        145
```

### Search based on DOI prefixes


```r
cr_prefixes(prefixes=c('10.1016','10.1371','10.1023','10.4176','10.1093'))
```

```
## $meta
## NULL
## 
## $data
## Source: local data frame [5 x 3]
## 
##                               member                              name
## 1   http://id.crossref.org/member/78                       Elsevier BV
## 2  http://id.crossref.org/member/340  Public Library of Science (PLoS)
## 3  http://id.crossref.org/member/297 Springer Science + Business Media
## 4 http://id.crossref.org/member/1989              Co-Action Publishing
## 5  http://id.crossref.org/member/286     Oxford University Press (OUP)
## Variables not shown: prefix (chr)
## 
## $facets
## list()
```

### Search CrossRef members


```r
cr_members(query='ecology', limit = 5)
```

```
## $meta
##   total_results search_terms start_index items_per_page
## 1            15      ecology           0              5
## 
## $data
## Source: local data frame [5 x 40]
## 
##     id                                 primary_name
## 1 3947          Korean Association of Human Ecology
## 2 2151        Ecology and Civil Engineering Society
## 3 2080        The Japan Society of Tropical Ecology
## 4 2232 Japanese Society of Health and Human Ecology
## 5  336        Japanese Society of Microbial Ecology
## Variables not shown: location (chr), last_status_check_time (date),
##   backfile.dois (chr), current.dois (chr), total.dois (chr), prefixes
##   (chr), coverge.resource.links.backfile (chr), coverge.funders.current
##   (chr), coverge.funders.backfile (chr), coverge.references.current (chr),
##   coverge.references.backfile (chr), coverge.update.policies.backfile
##   (chr), coverge.resource.links.current (chr),
##   coverge.update.policies.current (chr), coverge.award.numbers.current
##   (chr), coverge.orcids.current (chr), coverge.orcids.backfile (chr),
##   coverge.award.numbers.backfile (chr), coverge.licenses.current (chr),
##   coverge.licenses.backfile (chr), flags.deposits.award.numbers.backfile
##   (chr), flags.deposits (chr), flags.deposits.licenses.backfile (chr),
##   flags.deposits.resource.links.backfile (chr),
##   flags.deposits.licenses.current (chr), flags.deposits.orcids.current
##   (chr), flags.deposits.funders.backfile (chr),
##   flags.deposits.references.current (chr), flags.deposits.orcids.backfile
##   (chr), flags.deposits.references.backfile (chr),
##   flags.deposits.resource.links.current (chr),
##   flags.deposits.award.numbers.current (chr),
##   flags.deposits.update.policies.backfile (chr),
##   flags.deposits.funders.current (chr),
##   flags.deposits.update.policies.current (chr), flags.deposits.articles
##   (chr), names (chr), tokens (chr)
## 
## $facets
## NULL
```

### Get N random DOIs

`cr_r()` uses the function `cr_works()` internally. 


```r
cr_r()
```

```
##  [1] "10.1016/j.bbrc.2006.06.185"    "10.1017/s0007087406008739"    
##  [3] "10.1016/s0140-6736(53)91360-9" "10.1007/978-3-642-36897-4_4"  
##  [5] "10.1056/nejmoa0908806"         "10.3139/9783446432758"        
##  [7] "10.1016/0010-7824(94)90111-2"  "10.1109/aps.1991.175215"      
##  [9] "10.1145/170791.170817"         "10.1163/9780080548692"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
```

```
## [1] "10.3989/ic.1995.v47.i437.1072"    "10.1016/j.preteyeres.2015.01.004"
```

### The older functions and API

Search by author


```r
cr_search(query = c("renear", "palmer"), rows = 3, sort = "year")[1:2,-6]
```

```
##                                              doi     score normalizedScore
## 1 http://dx.doi.org/10.1136/flgastro-2014-100540 0.4935921              15
## 2 http://dx.doi.org/10.1097/aln.0000000000000554 0.4935921              15
##                                                title
## 1 New and emerging endoscopic haemostasis techniques
## 2                  Tilting at Aortocaval Compression
##                                                                                                          fullCitation
## 1 R. Palmer, B. Braden, 2015, 'New and emerging endoscopic haemostasis techniques', <i>Frontline Gastroenterology</i>
## 2     Craig M. Palmer, 2015, 'Tilting at Aortocaval Compression', <i>Anesthesiology</i>, vol. 122, no. 2, pp. 231-232
##   year
## 1 2015
## 2 2015
```

Search by DOI


```r
cr_search(doi = "10.1890/10-0340.1")[,-6]
```

```
##                                   doi    score normalizedScore
## 1 http://dx.doi.org/10.1890/10-0340.1 18.59906             100
##                                                            title
## 1 The arcsine is asinine: the analysis of proportions in ecology
##                                                                                                                                           fullCitation
## 1 David I. Warton, Francis K. C. Hui, 2011, 'The arcsine is asinine: the analysis of proportions in ecology', <i>Ecology</i>, vol. 92, no. 1, pp. 3-10
##   year
## 1 2011
```

Free search


```r
queries <- c("Piwowar sharing data PLOS one", "Priem Scientometrics 2.0 social web",
  "William Gunn A Crosstalk Between Myeloma Cells",
 "karthik ram Metapopulation dynamics override local limits")
cr_search_free(queries)[,-4]
```

```
##                                                        text match
## 1                             Piwowar sharing data PLOS one  TRUE
## 2                       Priem Scientometrics 2.0 social web  TRUE
## 3            William Gunn A Crosstalk Between Myeloma Cells  TRUE
## 4 karthik ram Metapopulation dynamics override local limits  TRUE
##                                              doi    score
## 1 http://dx.doi.org/10.1371/journal.pone.0000308 3.353533
## 2        http://dx.doi.org/10.5210/fm.v15i7.2874 3.747504
## 3  http://dx.doi.org/10.1634/stemcells.2005-0220 2.833707
## 4            http://dx.doi.org/10.1890/08-0228.1 3.966986
```
