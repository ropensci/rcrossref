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
#> [1] 21
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
#>    id     location  name          alt.names        uri       tokens       
#>    <chr>  <chr>     <chr>         <chr>            <chr>     <chr>        
#>  1 50110… Norway    Norsk Sykepl… NSF, Norwegian … http://d… norsk, sykep…
#>  2 10000… United S… Center for H… CHM, NSF, Unive… http://d… center, for,…
#>  3 10000… United S… National Sle… NSF              http://d… national, sl…
#>  4 50110… Sri Lanka National Sci… National Scienc… http://d… national, sc…
#>  5 10000… Denmark   Statens Natu… Danish National… http://d… statens, nat…
#>  6 10000… United S… Office of th… NSF Office of t… http://d… office, of, …
#>  7 50110… Australia National Str… NSF              http://d… national, st…
#>  8 10000… United S… National Sci… NSF              http://d… national, sc…
#>  9 50110… China     National Nat… NSFC-Yunnan Joi… http://d… national, na…
#> 10 50110… China     National Nat… Natural Science… http://d… national, na…
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
#> 1       1614119           NA           0              1
#> 
#> $data
#> # A tibble: 1 x 26
#>   alternative.id container.title created deposited doi   indexed issn 
#>   <chr>          <chr>           <chr>   <chr>     <chr> <chr>   <chr>
#> 1 S200529011400… Journal of Acu… 2014-0… 2017-06-… 10.1… 2018-0… 2005…
#> # ... with 19 more variables: issue <chr>, issued <chr>, member <chr>,
#> #   page <chr>, prefix <chr>, publisher <chr>, reference.count <chr>,
#> #   score <chr>, source <chr>, title <chr>, type <chr>,
#> #   update.policy <chr>, url <chr>, volume <chr>, assertion <list>,
#> #   author <list>, funder <list>, link <list>, license <list>
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
#> 1 Jour… "De Gruy… 1805… 2018-08-06       TRUE             FALSE           
#> 2 Jour… American… 2326… 2018-08-06       FALSE            FALSE           
#> # ... with 47 more variables: deposits <lgl>,
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
#> 1            25     elsevier           0             20
#> 
#> $data
#> # A tibble: 25 x 2
#>    URL                                                      work.count
#>    <chr>                                                         <int>
#>  1 http://aspb.org/publications/aspb-journals/open-articles          1
#>  2 http://creativecommons.org/licenses/by-nc-nd/3.0/                13
#>  3 http://creativecommons.org/licenses/by-nc-nd/4.0/                 8
#>  4 http://creativecommons.org/licenses/by-nc/4.0/                    2
#>  5 http://creativecommons.org/licenses/by/3.0/                       1
#>  6 http://creativecommons.org/licenses/by/4.0                        2
#>  7 http://creativecommons.org/licenses/by/4.0/                       2
#>  8 http://doi.wiley.com/10.1002/tdm_license_1                      157
#>  9 http://doi.wiley.com/10.1002/tdm_license_1.1                   2175
#> 10 http://journals.iucr.org/services/copyrightpolicy.html           10
#> # ... with 15 more rows
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
#> 3  http://id.crossref.org/member/297     Springer Nature America, Inc
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
#> # A tibble: 5 x 56
#>      id primary_name location last_status_che… total.dois current.dois
#>   <int> <chr>        <chr>    <date>           <chr>      <chr>       
#> 1   336 Japanese So… 5-3 Yon… 2018-08-06       1167       157         
#> 2  1950 Journal of … Suite 8… 2018-08-06       27         0           
#> 3  2080 The Japan S… 5-3 Yon… 2018-08-06       685        35          
#> 4  2151 Ecology and… 5-3 Yon… 2018-08-06       385        53          
#> 5  2169 Italian Soc… Diparti… 2018-08-06       1217       367         
#> # ... with 50 more variables: backfile.dois <chr>, prefixes <chr>,
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
#>  [1] "10.1016/1359-6454(95)00161-3"              
#>  [2] "10.1016/s0893-9659(99)00209-8"             
#>  [3] "10.1007/978-3-319-13449-9_8"               
#>  [4] "10.7788/daem.1987.43.1.354"                
#>  [5] "10.1007/978-3-476-05468-5_19"              
#>  [6] "10.1016/s0026-0657(01)80575-0"             
#>  [7] "10.2307/259363"                            
#>  [8] "10.4028/www.scientific.net/amm.519-520.294"
#>  [9] "10.1111/ajco.12021_1"                      
#> [10] "10.3384/diss.diva-132634"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
```

```
#> [1] "10.1016/j.ijhydene.2009.12.070" "10.1177/097492840105700301"
```

