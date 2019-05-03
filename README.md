rcrossref
=========



[![cran checks](https://cranchecks.info/badges/worst/rcrossref)](https://cranchecks.info/pkgs/rcrossref)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://api.travis-ci.org/ropensci/rcrossref.png)](https://travis-ci.org/ropensci/rcrossref)
[![Build status](https://ci.appveyor.com/api/projects/status/jbo6y7dg4qiq7mol/branch/master)](https://ci.appveyor.com/project/sckott/rcrossref/branch/master)
[![codecov.io](https://codecov.io/github/ropensci/rcrossref/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rcrossref?branch=master)
[![rstudio mirror downloads](http://cranlogs.r-pkg.org/badges/rcrossref)](https://github.com/metacran/cranlogs.app)
[![cran version](http://www.r-pkg.org/badges/version/rcrossref)](https://cran.r-project.org/package=rcrossref)

R interface to various CrossRef APIs
====================================


## CrossRef documentation

* Crossref API: [https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md)
* Crossref metadata search API (http://search.labs.crossref.org/)
* CrossRef [DOI Content Negotiation](http://citation.crosscite.org/docs.html)
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

### Register for the Polite Pool

If you are intending to access Crossref regularly you will want to send your email address with your queries. This has the advantage that queries are placed in the polite pool of servers. Including your email address is good practice as described in the Crossref documentation under [Good manners](https://github.com/CrossRef/rest-api-doc). The second advantage is that Crossref can contact you if there is a problem with a query.

Details on how to register your email in a call can be found at `?rcrossref-package`. To pass your email address to Crossref, simply store it as an environment variable in .Renviron like this:

Open file: file.edit("~/.Renviron")

Add email address to be shared with Crossref crossref_email= "name@example.com"

Save the file and restart your R session

To stop sharing your email when using rcrossref simply delete it from your .Renviron file. 

## Citation search

Use CrossRef's [DOI Content Negotiation](http://citation.crosscite.org/docs.html) service, where you can citations back in various formats, including `apa`


```r
cr_cn(dois = "10.1126/science.169.3946.635", format = "text", style = "apa")
#> [1] "Frank, H. S. (1970). The Structure of Ordinary Water: New data and interpretations are yielding new insights into this fascinating substance. Science, 169(3946), 635–641. doi:10.1126/science.169.3946.635"
```

`bibtex`


```r
cat(cr_cn(dois = "10.1126/science.169.3946.635", format = "bibtex"))
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
cr_citation_count(doi = "10.1371/journal.pone.0042793")
#>                            doi count
#> 1 10.1371/journal.pone.0042793    25
```

## Search Crossref metadata API

The following functions all use the [CrossRef API](https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md).

### Look up funder information


```r
cr_funders(query = "NSF")
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

### Search works (i.e., articles)


```r
cr_works(filter = c(has_orcid = TRUE, from_pub_date = '2004-04-04'), limit = 1)
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
cr_journals(issn = c('1803-2427','2326-4225'))
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
cr_prefixes(prefixes = c('10.1016','10.1371','10.1023','10.4176','10.1093'))
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
cr_members(query = 'ecology', limit = 5)
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
#>  [1] "10.1097/00005110-199711000-00007"  
#>  [2] "10.4079/vol1iss1pp65-66"           
#>  [3] "10.4172/2161-038x.s5-003"          
#>  [4] "10.1111/j.1540-6261.1967.tb02994.x"
#>  [5] "10.1080/095740401750534484"        
#>  [6] "10.4236/jssm.2017.103026"          
#>  [7] "10.1159/000448755"                 
#>  [8] "10.1021/ja01175a045"               
#>  [9] "10.1149/05810.0087ecst"            
#> [10] "10.1016/0378-1135(90)90004-f"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
#> [1] "10.1016/j.bbcan.2012.03.004"       
#> [2] "10.1111/j.1476-5381.1950.tb00568.x"
```

## Get full text

Publishers can optionally provide links in the metadata they provide to Crossref for full text of the work, but that data is often missing. Find out more about it at [http://tdmsupport.crossref.org/](http://tdmsupport.crossref.org/).

Get some DOIs for articles that provide full text, and that have `CC-BY 3.0` licenses (i.e., more likely to actually be open)


```r
out <-
  cr_works(filter = list(has_full_text = TRUE,
    license_url = "http://creativecommons.org/licenses/by/3.0/"))
(dois <- out$data$doi)
#>  [1] "10.1016/j.celrep.2013.01.013"     "10.1016/j.biortech.2013.01.084"  
#>  [3] "10.1016/j.epsl.2013.01.005"       "10.1016/j.neuropharm.2013.01.024"
#>  [5] "10.1016/j.ebcr.2012.12.001"       "10.1155/2013/121692"             
#>  [7] "10.1155/2013/158969"              "10.1155/2013/721606"             
#>  [9] "10.1155/2013/150397"              "10.1155/2013/178138"             
#> [11] "10.1155/2013/710579"              "10.1155/2013/528279"             
#> [13] "10.1155/2013/634670"              "10.1155/2013/729162"             
#> [15] "10.1155/2013/127497"              "10.1155/2013/635086"             
#> [17] "10.1155/2013/263285"              "10.1155/2013/248159"             
#> [19] "10.1155/2013/748687"              "10.1155/2013/673601"
```

From the output of `cr_works` we can get full text links if we know where to look:


```r
do.call("rbind", out$data$link)
#> # A tibble: 55 x 4
#>    URL                       content.type content.version intended.applica…
#>    <chr>                     <chr>        <chr>           <chr>            
#>  1 https://api.elsevier.com… text/xml     vor             text-mining      
#>  2 https://api.elsevier.com… text/plain   vor             text-mining      
#>  3 https://api.elsevier.com… text/xml     vor             text-mining      
#>  4 https://api.elsevier.com… text/plain   vor             text-mining      
#>  5 https://api.elsevier.com… text/xml     vor             text-mining      
#>  6 https://api.elsevier.com… text/plain   vor             text-mining      
#>  7 https://api.elsevier.com… text/xml     vor             text-mining      
#>  8 https://api.elsevier.com… text/plain   vor             text-mining      
#>  9 https://api.elsevier.com… text/xml     vor             text-mining      
#> 10 https://api.elsevier.com… text/plain   vor             text-mining      
#> # … with 45 more rows
```

From there, you can grab your full text, but because most links require
authentication, enter another package: `crminer`.

You'll need package `crminer` for the rest of the work.

Onc we have DOIs, get URLs to full text content


```r
if (!requireNamespace("crminer")) {
  install.packages("crminer")
}
```


```r
library(crminer)
(links <- crm_links("10.1155/2014/128505"))
#> $pdf
#> <url> http://downloads.hindawi.com/archive/2014/128505.pdf
#> 
#> $xml
#> <url> http://downloads.hindawi.com/archive/2014/128505.xml
#> 
#> $unspecified
#> <url> http://downloads.hindawi.com/archive/2014/128505.pdf
```

Then use those URLs to get full text


```r
crm_pdf(links)
#> <document>/Users/sckott/Library/Caches/R/crminer/128505.pdf
#>   Pages: 1
#>   No. characters: 1565
#>   Created: 2014-09-15
```

See also [fulltext](https://github.com/ropensci/fulltext) for getting scholarly text 
for text mining.


## Meta

* Please [report any issues or bugs](https://github.com/ropensci/rcrossref/issues).
* License: MIT
* Get citation information for `rcrossref` in R doing `citation(package = 'rcrossref')`
* Please note that this project is released with a [Contributor Code of Conduct](CODE_OF_CONDUCT.md). By participating in this project you agree to abide by its terms.

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles.

---

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)
