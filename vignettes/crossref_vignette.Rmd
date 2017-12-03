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
#> [2] "accident-analysis-and-prevention"               
#> [3] "acm-sig-proceedings-long-author-list"           
#> [4] "acm-sig-proceedings"                            
#> [5] "acm-sigchi-proceedings-extended-abstract-format"
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

## Citation count

Citation count, using OpenURL


```r
cr_citation_count(doi="10.1371/journal.pone.0042793")
```

```
#> [1] 17
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
#> [1] "Crossref"
```

### Search works (i.e., articles, books, etc.)


```r
cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'), limit=1)
```

```
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1       1078354           NA           0              1
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
cr_journals(issn=c('1803-2427','2326-4225'))
```

```
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
```

```
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
```

```
#>  [1] "10.1097/nt.0000000000000083"   "10.3796/ksft.2016.52.1.072"   
#>  [3] "10.1016/j.jtho.2016.11.645"    "10.1038/sj.bjp.0705959"       
#>  [5] "10.1016/s0735-1097(04)90810-8" "10.1007/bf01048109"           
#>  [7] "10.2172/6478328"               "10.1601/ex.6391"              
#>  [9] "10.1103/physreve.64.011702"    "10.1039/c6ra11800c"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
```

```
#> [1] "10.7554/elife.08177.003" "10.1039/b003410j"
```

