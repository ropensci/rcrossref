rcrossref: R interface to CrossRef APIs
=======================================



[![cran checks](https://cranchecks.info/badges/worst/rcrossref)](https://cranchecks.info/pkgs/rcrossref)
[![Project Status: Active - The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
[![Build Status](https://api.travis-ci.org/ropensci/rcrossref.png)](https://travis-ci.org/ropensci/rcrossref)
[![Build status](https://ci.appveyor.com/api/projects/status/jbo6y7dg4qiq7mol/branch/master)](https://ci.appveyor.com/project/sckott/rcrossref/branch/master)
[![codecov.io](https://codecov.io/github/ropensci/rcrossref/coverage.svg?branch=master)](https://codecov.io/github/ropensci/rcrossref?branch=master)
[![rstudio mirror downloads](https://cranlogs.r-pkg.org/badges/rcrossref)](https://github.com/metacran/cranlogs.app)
[![cran version](https://www.r-pkg.org/badges/version/rcrossref)](https://cran.r-project.org/package=rcrossref)

## CrossRef documentation

* Crossref API: https://github.com/CrossRef/rest-api-doc#readme
* Crossref's API issue tracker: https://gitlab.com/crossref/issues
* Crossref metadata search API: https://www.crossref.org/labs/crossref-metadata-search/
* Crossref DOI Content Negotiation: https://citation.crosscite.org/docs.html
* Crossref Text and Data Mining (TDM) Services: https://tdmsupport.crossref.org/

## Installation

Stable version from CRAN


```r
install.packages("rcrossref")
```

Or development version from GitHub


```r
remotes::install_github("ropensci/rcrossref")
```

Load `rcrossref`


```r
library('rcrossref')
```

### Register for the Polite Pool

If you are intending to access Crossref regularly you will want to send your email address with your queries. This has the advantage that queries are placed in the polite pool of servers. Including your email address is good practice as described in the Crossref documentation under Good manners (https://github.com/CrossRef/rest-api-doc#good-manners--more-reliable-service). The second advantage is that Crossref can contact you if there is a problem with a query.

Details on how to register your email in a call can be found at `?rcrossref-package`. To pass your email address to Crossref, simply store it as an environment variable in .Renviron like this:

Open file: `file.edit("~/.Renviron")`

Add email address to be shared with Crossref `crossref_email= "name@example.com"`

Save the file and restart your R session

To stop sharing your email when using rcrossref simply delete it from your .Renviron file. 

## Citation search

Use CrossRef's DOI Content Negotiation (https://citation.crosscite.org/docs.html) service, where you can citations back in various formats, including `apa`


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
#> list()
```

## Citation count

Citation count, using OpenURL


```r
cr_citation_count(doi = "10.1371/journal.pone.0042793")
#>                            doi count
#> 1 10.1371/journal.pone.0042793    38
```

## Search Crossref metadata API

The following functions all use the CrossRef API https://github.com/CrossRef/rest-api-doc#readme

### Look up funder information


```r
cr_funders(query = "NSF")
#> $meta
#>   total_results search_terms start_index items_per_page
#> 1            17          NSF           0             20
#> 
#> $data
#> # A tibble: 17 x 6
#>    id     name            alt.names          uri        tokens          location
#>    <chr>  <chr>           <chr>              <chr>      <chr>           <chr>   
#>  1 50110… National Scien… NSF, National Sci… http://dx… national, scie… <NA>    
#>  2 10000… National Sleep… NSF                http://dx… national, slee… United …
#>  3 10000… National Scien… USA NSF, US NSF, … http://dx… national, scie… United …
#>  4 10000… Office of the … NSF Office of the… http://dx… office, of, th… United …
#>  5 50110… National Natur… NNSF of China, NS… http://dx… national, natu… China   
#>  6 10001… BioXFEL Scienc… National Science … http://dx… bioxfel, scien… United …
#>  7 50110… Norsk Sykeplei… NSF, Norwegian Nu… http://dx… norsk, sykeple… <NA>    
#>  8 10000… Center for Hie… CHM, NSF, Univers… http://dx… center, for, h… United …
#>  9 10001… Kansas NSF EPS… KNE, NSF EPSCoR    http://dx… kansas, nsf, e… United …
#> 10 50110… Natural Scienc… Anhui Provincial … http://dx… natural, scien… China   
#> 11 10000… Statens Naturv… Danish National S… http://dx… statens, natur… <NA>    
#> 12 50110… National Strok… NSF                http://dx… national, stro… <NA>    
#> 13 50110… NSFC-Henan Joi… NSFC-Henan Provin… http://dx… nsfc, henan, j… China   
#> 14 50110… National Natur… NSFC-Yunnan Joint… http://dx… national, natu… China   
#> 15 50110… National Natur… NSFC-Shandong Joi… http://dx… national, natu… China   
#> 16 10001… Innovative Res… Fund for innovati… http://dx… innovative, re… China   
#> 17 10001… National Outst… National Outstand… http://dx… national, outs… China   
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
#> 1       3682545           NA           0              1
#> 
#> $data
#> # A tibble: 1 x 23
#>   alternative.id container.title created deposited published.online doi  
#>   <chr>          <chr>           <chr>   <chr>     <chr>            <chr>
#> 1 2004-19607-00… Neuropsychology 2004-1… 2019-02-… 2004-10          10.1…
#> # … with 17 more variables: indexed <chr>, issn <chr>, issue <chr>,
#> #   issued <chr>, member <chr>, page <chr>, prefix <chr>, publisher <chr>,
#> #   reference.count <chr>, score <chr>, source <chr>, title <chr>, type <chr>,
#> #   url <chr>, volume <chr>, author <list>, link <list>
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
#> 1 Jour… "De Gruy… 1805… 2020-03-17       TRUE             FALSE           
#> 2 Jour… "America… 2326… 2020-03-11       FALSE            FALSE           
#> # … with 47 more variables: deposits <lgl>,
#> #   deposits_affiliations_backfile <lgl>,
#> #   deposits_update_policies_backfile <lgl>,
#> #   deposits_similarity_checking_backfile <lgl>,
#> #   deposits_award_numbers_current <lgl>,
#> #   deposits_resource_links_current <lgl>, deposits_articles <lgl>,
#> #   deposits_affiliations_current <lgl>, deposits_funders_current <lgl>,
#> #   deposits_references_backfile <lgl>, deposits_abstracts_backfile <lgl>,
#> #   deposits_licenses_backfile <lgl>, deposits_award_numbers_backfile <lgl>,
#> #   deposits_open_references_backfile <lgl>,
#> #   deposits_open_references_current <lgl>, deposits_references_current <lgl>,
#> #   deposits_resource_links_backfile <lgl>, deposits_orcids_backfile <lgl>,
#> #   deposits_funders_backfile <lgl>, deposits_update_policies_current <lgl>,
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
#> 1            38     elsevier           0             20
#> 
#> $data
#> # A tibble: 38 x 2
#>    URL                                                      work.count
#>    <chr>                                                         <int>
#>  1 http://aspb.org/publications/aspb-journals/open-articles          1
#>  2 http://creativecommons.org/licenses/by-nc-nd/3.0/                11
#>  3 http://creativecommons.org/licenses/by-nc-nd/4.0/                13
#>  4 http://creativecommons.org/licenses/by-nc/4.0/                    3
#>  5 http://creativecommons.org/licenses/by/2.0                        1
#>  6 http://creativecommons.org/licenses/by/3.0/                       1
#>  7 http://creativecommons.org/licenses/by/3.0/igo/                   1
#>  8 http://creativecommons.org/licenses/by/4.0                        9
#>  9 http://creativecommons.org/licenses/by/4.0/                      15
#> 10 http://doi.wiley.com/10.1002/tdm_license_1                      137
#> # … with 28 more rows
```

### Search based on DOI prefixes


```r
cr_prefixes(prefixes = c('10.1016','10.1371','10.1023','10.4176','10.1093'))
#> $meta
#> NULL
#> 
#> $data
#>                               member                                    name
#> 1   http://id.crossref.org/member/78                             Elsevier BV
#> 2  http://id.crossref.org/member/340        Public Library of Science (PLoS)
#> 3  http://id.crossref.org/member/297 Springer Science and Business Media LLC
#> 4 http://id.crossref.org/member/1989                    Co-Action Publishing
#> 5  http://id.crossref.org/member/286           Oxford University Press (OUP)
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
#> 1            22      ecology           0              5
#> 
#> $data
#> # A tibble: 5 x 56
#>      id primary_name location last_status_che… total.dois current.dois
#>   <int> <chr>        <chr>    <date>           <chr>      <chr>       
#> 1   336 Japanese So… 5-3 Yon… 2020-03-18       1273       141         
#> 2  1950 Journal of … Suite 8… 2020-03-18       0          0           
#> 3  2080 The Japan S… 5-3 Yon… 2020-03-18       700        19          
#> 4  2151 Ecology and… 5-3 Yon… 2020-03-18       414        37          
#> 5  2169 Italian Soc… Diparti… 2020-03-18       1360       224         
#> # … with 50 more variables: backfile.dois <chr>, prefixes <chr>,
#> #   coverge.affiliations.current <chr>,
#> #   coverge.similarity.checking.current <chr>, coverge.funders.backfile <chr>,
#> #   coverge.licenses.backfile <chr>, coverge.funders.current <chr>,
#> #   coverge.affiliations.backfile <chr>, coverge.resource.links.backfile <chr>,
#> #   coverge.orcids.backfile <chr>, coverge.update.policies.current <chr>,
#> #   coverge.open.references.backfile <chr>, coverge.orcids.current <chr>,
#> #   coverge.similarity.checking.backfile <chr>,
#> #   coverge.references.backfile <chr>, coverge.award.numbers.backfile <chr>,
#> #   coverge.update.policies.backfile <chr>, coverge.licenses.current <chr>,
#> #   coverge.award.numbers.current <chr>, coverge.abstracts.backfile <chr>,
#> #   coverge.resource.links.current <chr>, coverge.abstracts.current <chr>,
#> #   coverge.open.references.current <chr>, coverge.references.current <chr>,
#> #   flags.deposits.abstracts.current <chr>,
#> #   flags.deposits.orcids.current <chr>, flags.deposits <chr>,
#> #   flags.deposits.affiliations.backfile <chr>,
#> #   flags.deposits.update.policies.backfile <chr>,
#> #   flags.deposits.similarity.checking.backfile <chr>,
#> #   flags.deposits.award.numbers.current <chr>,
#> #   flags.deposits.resource.links.current <chr>, flags.deposits.articles <chr>,
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
#>  [1] "10.32387/prokla.v41i165.332"   "10.1016/j.toxlet.2016.06.2117"
#>  [3] "10.1016/s0140-6736(99)02080-2" "10.26717/bjstr.2018.02.000741"
#>  [5] "10.1134/s0021364015040025"     "10.1021/cen-v059n019.p006a"   
#>  [7] "10.2307/40147801"              "10.1007/s00421-016-3378-y"    
#>  [9] "10.1016/j.talanta.2007.10.030" "10.1134/1.1780558"
```

You can pass in the number of DOIs you want back (default is 10)


```r
cr_r(2)
#> [1] "10.2307/250291"        "10.2991/3ca-13.2013.9"
```

## Get full text

Publishers can optionally provide links in the metadata they provide to Crossref for full text of the work, but that data is often missing. Find out more about it at https://support.crossref.org/hc/en-us/articles/215750183-Crossref-Text-and-Data-Mining-Services

Get some DOIs for articles that provide full text, and that have `CC-BY 3.0` licenses (i.e., more likely to actually be open)


```r
out <-
  cr_works(filter = list(has_full_text = TRUE,
    license_url = "http://creativecommons.org/licenses/by/3.0/"))
(dois <- out$data$doi)
#>  [1] "10.1016/s0370-2693(01)01497-6" "10.1016/s0370-2693(01)01503-9"
#>  [3] "10.1016/s0370-2693(01)01507-6" "10.1016/s0370-2693(01)01486-1"
#>  [5] "10.1016/s0370-2693(01)01512-x" "10.1016/s0370-2693(01)01518-0"
#>  [7] "10.1016/s0370-2693(02)01156-5" "10.1016/s0370-2693(02)01161-9"
#>  [9] "10.1016/s0370-2693(02)01162-0" "10.1016/s0370-2693(02)01163-2"
#> [11] "10.1016/s0370-2693(02)01166-8" "10.1016/s0370-2693(02)01170-x"
#> [13] "10.1016/s0370-2693(02)01174-7" "10.1016/s0370-2693(02)01179-6"
#> [15] "10.1016/s0370-2693(02)01181-4" "10.1016/s0370-2693(01)01471-x"
#> [17] "10.1016/s0370-2693(01)01473-3" "10.1016/s0370-2693(01)01467-8"
#> [19] "10.1016/s0370-2693(01)01505-2" "10.1016/s0370-2693(02)01172-3"
```

From the output of `cr_works` we can get full text links if we know where to look:


```r
do.call("rbind", out$data$link)
#> # A tibble: 40 x 4
#>    URL                            content.type content.version intended.applica…
#>    <chr>                          <chr>        <chr>           <chr>            
#>  1 https://api.elsevier.com/cont… text/xml     vor             text-mining      
#>  2 https://api.elsevier.com/cont… text/plain   vor             text-mining      
#>  3 https://api.elsevier.com/cont… text/xml     vor             text-mining      
#>  4 https://api.elsevier.com/cont… text/plain   vor             text-mining      
#>  5 https://api.elsevier.com/cont… text/xml     vor             text-mining      
#>  6 https://api.elsevier.com/cont… text/plain   vor             text-mining      
#>  7 https://api.elsevier.com/cont… text/xml     vor             text-mining      
#>  8 https://api.elsevier.com/cont… text/plain   vor             text-mining      
#>  9 https://api.elsevier.com/cont… text/xml     vor             text-mining      
#> 10 https://api.elsevier.com/cont… text/plain   vor             text-mining      
#> # … with 30 more rows
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

See also fulltext (https://github.com/ropensci/fulltext) for getting scholarly text 
for text mining.


## Meta

* Please report any issues or bugs: https://github.com/ropensci/rcrossref/issues
* License: MIT
* Get citation information for `rcrossref` in R doing `citation(package = 'rcrossref')`
* Please note that this project is released with a [Contributor Code of Conduct][coc]. By participating in this project you agree to abide by its terms.

---

This package is part of a richer suite called [fulltext](https://github.com/ropensci/fulltext), along with several other packages, that provides the ability to search for and retrieve full text of open access scholarly articles.

---

[![rofooter](https://ropensci.org/public_images/github_footer.png)](https://ropensci.org)

[coc]: https://github.com/ropensci/rcrossref/blob/master/CODE_OF_CONDUCT.md
