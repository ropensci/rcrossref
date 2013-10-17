
#' @include RCurl
crossref_cn <- function(dois, 
                        format = c("rdf-xml", "turtle", "citeproc-json",
                                   "text", "ris", "bibtex", "crossref-xml",
                                   "datacite-xml", "bibentry"),
                        style = NULL,
                        locale = "en-US"){

  format <- match.arg(format)
  lapply(dois, function(doi){
  url <- paste("http://dx.doi.org", doi, sep="/")
  pick<- c(
         "rdf-xml" = "application/rdf+xml",
         "turtle" = "text/turtle",
         "citeproc-json" = "application/vnd.citationstyles.csl+json",
         "text" = "text/x-bibliography",
         "ris" = "application/x-research-info-systems",
         "bibtex" = "application/x-bibtex",
         "crossref-xml" = "application/vnd.crossref.unixref+xml",
         "datacite-xml" = "application/vnd.datacite.datacite+xml",
         "bibentry" = "application/x-bibtex")
  type <- pick[[format]]
  response <- GET(url, add_headers(Accept = type, style = style, locale = locale))
  select <- c(
         "rdf-xml" = "text/xml",
         "turtle" = "text/plain",
         "citeproc-json" = "application/json",
         "text" = "text/plain",
         "ris" = "text/plain",
         "bibtex" = "text/plain",
         "crossref-xml" = "text/xml",
         "datacite-xml" = "text/xml",
         "bibentry" = "application/x-bibtex")
  parser <- select[[format]]
  content(response, "parsed", parser) 
  })
}

#' @import bibtex
parse_bibtex <- function(x){ 
  writeLines(x, "tmp.bib")
  output <- read.bib("tmp.bib")
  unlink("tmp.bib")
  output 
}


crossref_cn("10.1126/science.169.3946.635", "citeproc-json") 

crossref_cn("10.1126/science.169.3946.635", "rdf-xml") 
crossref_cn("10.1126/science.169.3946.635", "crossref-xml") 
crossref_cn("10.1126/science.169.3946.635", "bibtex") 
crossref_cn("10.1126/science.169.3946.635", "bibentry") 

