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

CrossRef's [DOI Content Negotiation](http://citation.crosscite.org/docs.html) service, where you can citations back in various formats, including `apa`


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

```
#> Boettiger C (2012). "Regime shifts in ecology and evolution (PhD
#> Dissertation)." doi: 10.6084/m9.figshare.97218 (URL:
#> http://doi.org/10.6084/m9.figshare.97218), <URL:
#> https://doi.org/10.6084/m9.figshare.97218>.
```

## Citation count

Citation count, using OpenURL


```r
cr_citation_count(doi="10.1371/journal.pone.0042793")
```

```
#> [1] 13
```

## Search Crossref metadata API

The following functions all use the [CrossRef API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

### Look up funder information


```r
cr_funders(query="NSF")
```

```
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
#> 1        689036           NA           0              1
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
cr_journals(issn=c('1803-2427','2326-4225'))
```

```
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
```

```
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
cr_prefixes(prefixes=c('10.1016','10.1371','10.1023','10.4176','10.1093'))
```

```
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
cr_members(query='ecology', limit = 5)
```

```
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
```

```
#>  [1] "10.1016/j.chemosphere.2012.06.036"
#>  [2] "10.1117/12.2249178"               
#>  [3] "10.1111/j.1469-8137.2004.01086.x" 
#>  [4] "10.1016/j.orthtr.2014.07.013"     
#>  [5] "10.1086/633704"                   
#>  [6] "10.1017/s0020860400090355"        
#>  [7] "10.1111/coep.12229"               
#>  [8] "10.1524/ract.1967.8.4.214"        
#>  [9] "10.1016/s0040-4020(01)98752-6"    
#> [10] "10.1021/nl200189w"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
```

```
#> [1] "10.1163/ej.9789024727186.123-268.6"
#> [2] "10.1016/0044-8486(76)90026-0"
```

