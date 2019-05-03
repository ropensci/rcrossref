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
#> [3] "aci-materials-journal"               
#> [4] "acm-sig-proceedings-long-author-list"
#> [5] "acm-sig-proceedings"
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
#>                            doi count
#> 1 10.1371/journal.pone.0042793    25
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
#> 1            10          NSF           0             20
#> 
#> $data
#> # A tibble: 10 x 6
#>    id     name          alt.names         uri       tokens         location
#>    <chr>  <chr>         <chr>             <chr>     <chr>          <chr>   
#>  1 50110… Norsk Sykepl… NSF, Norwegian N… http://d… norsk, sykepl… <NA>    
#>  2 10000… Center for H… CHM, NSF, Univer… http://d… center, for, … United …
#>  3 10000… National Sle… NSF               http://d… national, sle… United …
#>  4 50110… National Str… NSF               http://d… national, str… <NA>    
#>  5 10000… Statens Natu… Danish National … http://d… statens, natu… Denmark 
#>  6 10000… Office of th… NSF Office of th… http://d… office, of, t… United …
#>  7 50110… National Sci… National Science… http://d… national, sci… <NA>    
#>  8 10000… National Sci… NSF               http://d… national, sci… United …
#>  9 50110… National Nat… NSFC-Yunnan Join… http://d… national, nat… China   
#> 10 50110… National Nat… Natural Science … http://d… national, nat… China   
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
#> 1       2452441           NA           0              1
#> 
#> $data
#> # A tibble: 1 x 25
#>   container.title created deposited published.online doi   indexed issn 
#>   <chr>           <chr>   <chr>     <chr>            <chr> <chr>   <chr>
#> 1 The Cryosphere  2013-0… 2018-07-… 2013-02-11       10.5… 2019-0… 1994…
#> # … with 18 more variables: issue <chr>, issued <chr>, member <chr>,
#> #   page <chr>, prefix <chr>, publisher <chr>, reference.count <chr>,
#> #   score <chr>, source <chr>, title <chr>, type <chr>, url <chr>,
#> #   volume <chr>, abstract <chr>, author <list>, link <list>,
#> #   license <list>, reference <list>
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
#> # A tibble: 2 x 53
#>   title publisher issn  last_status_che… deposits_abstra… deposits_orcids…
#>   <chr> <chr>     <chr> <date>           <lgl>            <lgl>           
#> 1 Jour… "De Gruy… 1805… 2019-03-24       TRUE             FALSE           
#> 2 Jour… American… 2326… 2019-03-24       FALSE            FALSE           
#> # … with 47 more variables: deposits <lgl>,
#> #   deposits_affiliations_backfile <lgl>,
#> #   deposits_update_policies_backfile <lgl>,
#> #   deposits_similarity_checking_backfile <lgl>,
#> #   deposits_award_numbers_current <lgl>,
#> #   deposits_resource_links_current <lgl>, deposits_articles <lgl>,
#> #   deposits_affiliations_current <lgl>, deposits_funders_current <lgl>,
#> #   deposits_references_backfile <lgl>, deposits_abstracts_backfile <lgl>,
#> #   deposits_licenses_backfile <lgl>,
#> #   deposits_award_numbers_backfile <lgl>,
#> #   deposits_open_references_backfile <lgl>,
#> #   deposits_open_references_current <lgl>,
#> #   deposits_references_current <lgl>,
#> #   deposits_resource_links_backfile <lgl>,
#> #   deposits_orcids_backfile <lgl>, deposits_funders_backfile <lgl>,
#> #   deposits_update_policies_current <lgl>,
#> #   deposits_similarity_checking_current <lgl>,
#> #   deposits_licenses_current <lgl>, affiliations_current <dbl>,
#> #   similarity_checking_current <dbl>, funders_backfile <dbl>,
#> #   licenses_backfile <dbl>, funders_current <dbl>,
#> #   affiliations_backfile <dbl>, resource_links_backfile <dbl>,
#> #   orcids_backfile <dbl>, update_policies_current <dbl>,
#> #   open_references_backfile <dbl>, orcids_current <dbl>,
#> #   similarity_checking_backfile <dbl>, references_backfile <dbl>,
#> #   award_numbers_backfile <dbl>, update_policies_backfile <dbl>,
#> #   licenses_current <dbl>, award_numbers_current <dbl>,
#> #   abstracts_backfile <dbl>, resource_links_current <dbl>,
#> #   abstracts_current <dbl>, open_references_current <dbl>,
#> #   references_current <dbl>, total_dois <int>, current_dois <int>,
#> #   backfile_dois <int>
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
#> 1            34     elsevier           0             20
#> 
#> $data
#> # A tibble: 34 x 2
#>    URL                                                      work.count
#>    <chr>                                                         <int>
#>  1 http://aspb.org/publications/aspb-journals/open-articles          1
#>  2 http://creativecommons.org/licenses/by-nc-nd/3.0/                13
#>  3 http://creativecommons.org/licenses/by-nc-nd/4.0/                 7
#>  4 http://creativecommons.org/licenses/by-nc/4.0                     1
#>  5 http://creativecommons.org/licenses/by-nc/4.0/                    2
#>  6 http://creativecommons.org/licenses/by/2.0                        1
#>  7 http://creativecommons.org/licenses/by/3.0/                       1
#>  8 http://creativecommons.org/licenses/by/4.0                        3
#>  9 http://creativecommons.org/licenses/by/4.0/                       6
#> 10 http://doi.wiley.com/10.1002/tdm_license_1                      155
#> # … with 24 more rows
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
#> 1            19      ecology           0              5
#> 
#> $data
#> # A tibble: 5 x 56
#>      id primary_name location last_status_che… total.dois current.dois
#>   <int> <chr>        <chr>    <date>           <chr>      <chr>       
#> 1   336 Japanese So… 5-3 Yon… 2019-04-16       1220       145         
#> 2  1950 Journal of … Suite 8… 2019-04-16       27         0           
#> 3  2080 The Japan S… 5-3 Yon… 2019-04-16       691        21          
#> 4  2151 Ecology and… 5-3 Yon… 2019-04-16       404        60          
#> 5  2169 Italian Soc… Diparti… 2019-04-16       1286       302         
#> # … with 50 more variables: backfile.dois <chr>, prefixes <chr>,
#> #   coverge.affiliations.current <chr>,
#> #   coverge.similarity.checking.current <chr>,
#> #   coverge.funders.backfile <chr>, coverge.licenses.backfile <chr>,
#> #   coverge.funders.current <chr>, coverge.affiliations.backfile <chr>,
#> #   coverge.resource.links.backfile <chr>, coverge.orcids.backfile <chr>,
#> #   coverge.update.policies.current <chr>,
#> #   coverge.open.references.backfile <chr>, coverge.orcids.current <chr>,
#> #   coverge.similarity.checking.backfile <chr>,
#> #   coverge.references.backfile <chr>,
#> #   coverge.award.numbers.backfile <chr>,
#> #   coverge.update.policies.backfile <chr>,
#> #   coverge.licenses.current <chr>, coverge.award.numbers.current <chr>,
#> #   coverge.abstracts.backfile <chr>,
#> #   coverge.resource.links.current <chr>, coverge.abstracts.current <chr>,
#> #   coverge.open.references.current <chr>,
#> #   coverge.references.current <chr>,
#> #   flags.deposits.abstracts.current <chr>,
#> #   flags.deposits.orcids.current <chr>, flags.deposits <chr>,
#> #   flags.deposits.affiliations.backfile <chr>,
#> #   flags.deposits.update.policies.backfile <chr>,
#> #   flags.deposits.similarity.checking.backfile <chr>,
#> #   flags.deposits.award.numbers.current <chr>,
#> #   flags.deposits.resource.links.current <chr>,
#> #   flags.deposits.articles <chr>,
#> #   flags.deposits.affiliations.current <chr>,
#> #   flags.deposits.funders.current <chr>,
#> #   flags.deposits.references.backfile <chr>,
#> #   flags.deposits.abstracts.backfile <chr>,
#> #   flags.deposits.licenses.backfile <chr>,
#> #   flags.deposits.award.numbers.backfile <chr>,
#> #   flags.deposits.open.references.backfile <chr>,
#> #   flags.deposits.open.references.current <chr>,
#> #   flags.deposits.references.current <chr>,
#> #   flags.deposits.resource.links.backfile <chr>,
#> #   flags.deposits.orcids.backfile <chr>,
#> #   flags.deposits.funders.backfile <chr>,
#> #   flags.deposits.update.policies.current <chr>,
#> #   flags.deposits.similarity.checking.current <chr>,
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
#>  [1] "10.2174/187221207782411584"        
#>  [2] "10.1016/b978-0-08-202565-8.50005-5"
#>  [3] "10.1016/0003-9861(72)90232-9"      
#>  [4] "10.1093/nq/s4-v.130.607h"          
#>  [5] "10.1109/epepemc.2012.6397467"      
#>  [6] "10.1016/j.psychsport.2013.02.004"  
#>  [7] "10.7247/jtomc.2014.1695"           
#>  [8] "10.1109/sensor.1995.721776"        
#>  [9] "10.1080/00268977100100441"         
#> [10] "10.1002/jcp.24935"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
```

```
#> [1] "10.1007/s10708-010-9338-x"   "10.1007/978-94-007-0354-4_1"
```

