rcrossref
=========

[![Build status](https://ci.appveyor.com/api/projects/status/jbo6y7dg4qiq7mol/branch/master)](https://ci.appveyor.com/project/sckott/rcrossref/branch/master)

R interface to the CrossRef API tools

Getting started
---------------

* [Register](http://www.crossref.org/requestaccount/) an email address with the CrossRef API as you'll need an API key for some functions.

API docs

* Fundref: [source 1](https://github.com/CrossRef/rest-api-doc/blob/master/funder_kpi_api.md), [source 2](http://crosstech.crossref.org/2014/04/%E2%99%AB-researchers-just-wanna-have-funds-%E2%99%AB.html), [source 3](http://help.crossref.org/#fundref-api)
* [Content negotiation](http://www.crosscite.org/cn/)
* [Metadata search]()
* [Text and data mining (TDM)](http://tdmsupport.crossref.org/)


## Installation


```r
install.packages("devtools")
devtools::install_github("ropensci/rcrossref")
```

Load `rcrossref`


```r
library('rcrossref')
```


## Usage

Citations


```r
cr_citation(doi="10.1371/journal.pone.0042793")
```

```
## Calvo R, Zheng Y, Kumar S, Olgiati A, Berkman L and Mock N (2012).
## "Well-Being and Social Capital on Planet Earth: Cross-National
## Evidence from 142 Countries." _PLoS ONE_, *7*. <URL:
## http://dx.doi.org/10.1371/journal.pone.0042793>.
```

Citation count


```r
cr_citation_count(doi="10.1371/journal.pone.0042793")
```

```
## [1] 3
```

Look up funder information with Fundref


```r
cr_fundref(query="NSF")
```

```
## $items
##             id      location
## 1 501100004190        Norway
## 2 501100001809         China
## 3 501100000930     Australia
## 4    100000001 United States
## 5    100006445 United States
## 6    100000179 United States
##                                                                 name
## 1                                            Norsk Sykepleierforbund
## 2                       National Natural Science Foundation of China
## 3                                         National Stroke Foundation
## 4                                        National Science Foundation
## 5 Center for Hierarchical Manufacturing, National Science Foundation
## 6                                         NSF Office of the Director
##                                                                         alt-names
## 1                                              NSF, Norwegian Nurses Organisation
## 2                                                                            NSFC
## 3                                                                             NSF
## 4                                                                             NSF
## 5 University of Massachusetts NSF Center for Hierarchical Manufacturing, CHM, NSF
## 6                                                                              OD
##                                       uri
## 1 http://dx.doi.org/10.13039/501100004190
## 2 http://dx.doi.org/10.13039/501100001809
## 3 http://dx.doi.org/10.13039/501100000930
## 4    http://dx.doi.org/10.13039/100000001
## 5    http://dx.doi.org/10.13039/100006445
## 6    http://dx.doi.org/10.13039/100000179
##                                                                                                                                                            tokens
## 1                                                                                                  norsk, sykepleierforbund, nsf, norwegian, nurses, organisation
## 2                                                                                                         national, natural, science, foundation, of, china, nsfc
## 3                                                                                                                               national, stroke, foundation, nsf
## 4                                                                                                                              national, science, foundation, nsf
## 5 center, for, hierarchical, manufacturing, national, science, foundation, university, of, massachusetts, nsf, center, for, hierarchical, manufacturing, chm, nsf
## 6                                                                                                                              nsf, office, of, the, director, od
## 
## $`total-results`
## [1] 6
## 
## $query
## $query$`search-terms`
## [1] "NSF"
## 
## $query$`start-index`
## [1] 0
## 
## 
## $`items-per-page`
## [1] 20
```

Check the DOI minting agency


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

Search Crossref metadata


```r
cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'), limit=1)
```

```
## $query
## $query$`search-terms`
## NULL
## 
## $query$`start-index`
## [1] 0
## 
## 
## $`items-per-page`
## [1] 1
## 
## $items
##   subtitle
## 1     NULL
##                                                                 subject
## 1 Earth-Surface Processes, Ecology, Evolution, Behavior and Systematics
##    date-parts score                                prefix
## 1 2013, 6, 14     1 http://id.crossref.org/prefix/10.5194
##                                                                                                                                                                       author
## 1 Domaizon, Savichtcheva, Debroas, Arnaud, Villar, Pignol, Alric, Perga, I., O., D., F., C., C., B., M. E., http://orcid.org/0000-0001-9785-3082, NA, NA, NA, NA, NA, NA, NA
##   container-title reference-count      page deposited.date-parts
## 1  Biogeosciences               0 3817-3838          2013, 6, 14
##   deposited.timestamp issue
## 1           1.371e+12     6
##                                                                                                      title
## 1 DNA from lake sediments reveals the long-term dynamics and diversity of <i>Synechococcus</i> assemblages
##              type                     DOI      ISSN
## 1 journal-article 10.5194/bg-10-3817-2013 1726-4189
##                                         URL   source       publisher
## 1 http://dx.doi.org/10.5194/bg-10-3817-2013 CrossRef Copernicus GmbH
##   indexed.date-parts indexed.timestamp volume
## 1        2014, 5, 22         1.401e+12     10
##                               member
## 1 http://id.crossref.org/member/3145
## 
## $`total-results`
## [1] 89004
## 
## $facets
## named list()
```


## Meta

Please [report any issues or bugs](https://github.com/ropensci/rcrossref/issues).

License: MIT

This package is part of the [rOpenSci](http://ropensci.org/packages) project.

To cite package `rcrossref` in publications use:

```coffee
To cite package ‘rcrossref’ in publications use:

  Carl Boettiger, Ted Harte, Scott Chamberlain and Karthik Ram (2013). rcrossref: R Interface to the CrossRef APIs. R package version 0.1.
  https://github.com/ropensci/rcrossref

A BibTeX entry for LaTeX users is

  @Manual{,
    title = {rcrossref: R Interface to the CrossRef APIs},
    author = {Carl Boettiger and Ted Harte and Scott Chamberlain and Karthik Ram},
    year = {2013},
    note = {R package version 0.1},
    url = {https://github.com/ropensci/rcrossref},
  }
```

Get citation information for `rcrossref` in R doing `citation(package = 'rcrossref')`

[![](http://ropensci.org/public_images/github_footer.png)](http://ropensci.org)
