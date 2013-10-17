#' Search the CrossRef Metatdata API.
#' 
#' @importFrom httr GET add_headers stop_for_status content
#' @importFrom plyr compact
#' @param dois Search by a single DOI or many DOIs.
#' @param format name of the format.
#' @param style a CSL style (for text format only)
#' @param locale language locale
#' @details See \url{http://www.crosscite.org/cn/} for more info on this 
#'   	Crossref Content Negotiation API service.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' crossref_cn("10.1126/science.169.3946.635", "citeproc-json") 
#' crossref_cn("10.1126/science.169.3946.635", "rdf-xml") 
#' crossref_cn("10.1126/science.169.3946.635", "crossref-xml") 
#' crossref_cn("10.1126/science.169.3946.635", "bibtex") 
#' # return an R bibentry type
#' crossref_cn("10.1126/science.169.3946.635", "bibentry") 
#' return an apa style citation
#' crossref_cn("10.1126/science.169.3946.635", "text", "apa") 
#' }
#' @export
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
  if(format == "text")
    type <- paste(type, "; style = ", style, "; locale = ", locale, sep="")
  response <- GET(url, add_headers(Accept = type))
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



