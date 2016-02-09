<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{Crossref vignette}
%\VignetteEncoding{UTF-8}
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
#> [1] "Wang, Q., & Taylor, J. E. (2014). Quantifying Human Mobility Perturbation and Resilience in Hurricane Sandy. PLoS ONE, 9(11), e112608. doi:10.1371/journal.pone.0112608"
```

There are a lot more styles. We include a dataset as a character vector within the package, accessible via the `get_styles()` function, e.g., 


```r
get_styles()[1:5]
```

```
#> [1] "academy-of-management-review"                   
#> [2] "acm-sig-proceedings-long-author-list"           
#> [3] "acm-sig-proceedings"                            
#> [4] "acm-sigchi-proceedings-extended-abstract-format"
#> [5] "acm-sigchi-proceedings"
```

`bibtex`


```r
cat(cr_cn(dois = "10.1126/science.169.3946.635", format = "bibtex"))
```

```
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
```

```
#> Boettiger; C (2012). "Regime shifts in ecology and evolution (PhD
#> Dissertation)." <URL: http://doi.org/10.6084/m9.figshare.97218>,
#> <URL: http://dx.doi.org/10.6084/m9.figshare.97218>.
```

## Citation count

Citation count, using OpenURL


```r
cr_citation_count(doi="10.1371/journal.pone.0042793")
```

```
#> [1] 7
```

## Search Crossref metadata API

There are two functions that use an older Crossre API: `cr_search()` and `cr_search_free()`. You can of course use them, but the newer Crossref API available through various functions (`cr_agency()`, `cr_fundref()`, `cr_journals()`, `cr_licenses()`, `cr_members()`, `cr_prefixes()`, and `cr_works()`) is more powerful and will recieve more support going forward. The following functions (of the newer set just mentioend) all use the [CrossRef API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

### Look up funder information


```r
cr_fundref(query="NSF")
```

```
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
```

```
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

### Search works (i.e., articles, books, etc.)


```r
cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'), limit=1)
```

```
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
cr_journals(issn=c('1803-2427','2326-4225'))
```

```
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
```

```
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
cr_prefixes(prefixes=c('10.1016','10.1371','10.1023','10.4176','10.1093'))
```

```
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
cr_members(query='ecology', limit = 5)
```

```
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
```

```
#>  [1] "10.1017/s0022050700092342"        "10.5631/jibirin.79.2073"         
#>  [3] "10.1111/j.1745-3933.2008.00437.x" "10.1190/1.1892296"               
#>  [5] "10.1097/00001756-200307180-00016" "10.1016/s0002-8703(96)90261-6"   
#>  [7] "10.1002/9781444351071.wbeghm146"  "10.1134/1.1825531"               
#>  [9] "10.1017/cbo9780511609220.008"     "10.1111/j.1469-7793.2000.00223.x"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
```

```
#> [1] "10.17660/actahortic.2004.645.22" "10.1017/cbo9780511665202.009"
```

### The older functions and API

Search by author


```r
cr_search(query = c("renear", "palmer"), rows = 3, sort = "year")[1:2,-6]
```

```
#>                                                   doi     score
#> 1         http://dx.doi.org/10.1007/978-3-658-12433-5 0.7333419
#> 2 http://dx.doi.org/10.13110/merrpalmquar1982.62.1.fm 0.6914014
#>   normalizedScore                                 title
#> 1              22 Berufsbezogene Kreativitätsdiagnostik
#> 2              21                          Front Matter
#>                                                                  fullCitation
#> 1               Carolin Palmer, 2016, 'Berufsbezogene Kreativitätsdiagnostik'
#> 2 2016, 'Front Matter', <i>Merrill-Palmer Quarterly</i>, vol. 62, no. 1, p. i
#>   year
#> 1 2016
#> 2 2016
```

Search by DOI


```r
cr_search(doi = "10.1890/10-0340.1")[,-6]
```

```
#>                                   doi   score normalizedScore
#> 1 http://dx.doi.org/10.1890/10-0340.1 18.1204             100
#>                                                            title
#> 1 The arcsine is asinine: the analysis of proportions in ecology
#>                                                                                                                                           fullCitation
#> 1 David I. Warton, Francis K. C. Hui, 2011, 'The arcsine is asinine: the analysis of proportions in ecology', <i>Ecology</i>, vol. 92, no. 1, pp. 3-10
#>   year
#> 1 2011
```

Free search


```r
queries <- c("Piwowar sharing data PLOS one", "Priem Scientometrics 2.0 social web",
  "William Gunn A Crosstalk Between Myeloma Cells",
 "karthik ram Metapopulation dynamics override local limits")
cr_search_free(queries)[,-4]
```

```
#>                                                        text match
#> 1                             Piwowar sharing data PLOS one  TRUE
#> 2                       Priem Scientometrics 2.0 social web  TRUE
#> 3            William Gunn A Crosstalk Between Myeloma Cells  TRUE
#> 4 karthik ram Metapopulation dynamics override local limits  TRUE
#>                                              doi    score
#> 1 http://dx.doi.org/10.1371/journal.pone.0000308 3.327027
#> 2        http://dx.doi.org/10.5210/fm.v15i7.2874 3.583743
#> 3  http://dx.doi.org/10.1634/stemcells.2005-0220 2.817906
#> 4            http://dx.doi.org/10.1890/08-0228.1 3.960837
```
