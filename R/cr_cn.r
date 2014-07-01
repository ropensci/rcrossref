#' Search the CrossRef Metatdata API.
#'
#' @import httr
#' @export
#' 
#' @param dois Search by a single DOI or many DOIs.
#' @param format name of the format.
#' @param style a CSL style (for text format only)
#' @param locale language locale
#' @param ... optional additional curl options (debugging tools mostly) passed on to httr::GET
#' 
#' @details See \url{http://www.crosscite.org/cn/} for more info on this
#'   	Crossref Content Negotiation API service.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' cr_cn(dois="10.1126/science.169.3946.635", format="citeproc-json")
#' cr_cn("10.1126/science.169.3946.635", "rdf-xml")
#' cr_cn("10.1126/science.169.3946.635", "crossref-xml")
#' cr_cn("10.1126/science.169.3946.635", "bibtex")
#' # return an R bibentry type
#' cr_cn("10.1126/science.169.3946.635", "bibentry")
#' # return an apa style citation - eg. not working right now., 406 error
#' cr_cn("10.1126/science.169.3946.635", "text", "apa")
#' 
#' # example with many DOIs
#' dois <- cr_r(10)
#' cr_cn(dois, "text", "apa")
#' }

cr_cn <- function(dois, format = c("rdf-xml", "turtle", "citeproc-json",
                                   "text", "ris", "bibtex", "crossref-xml",
                                   "datacite-xml", "bibentry"),
                        style = NULL,
                        locale = "en-US", ...){
  format <- match.arg(format)
  cn <- function(doi){
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
    response <- GET(url, add_headers(Accept = type), ...)
    stop_for_status(response)
    select <- c(
           "rdf-xml" = "text/xml",
           "turtle" = "text/plain",
           "citeproc-json" = "application/json",
           "text" = "text/plain",
           "ris" = "text/plain",
           "bibtex" = "text/plain",
           "crossref-xml" = "text/xml",
           "datacite-xml" = "text/xml",
           "bibentry" = "text/plain")
    parser <- select[[format]]
    out <- content(response, "parsed", parser)
    if(format == "bibentry")
      out = parse_bibtex(out)
    out
  }

  if(length(dois) > 1)
    lapply(dois, function(z) {
      out = try(cn(z))
      if("try-error" %in% class(out), silent=TRUE) {
        warning(paste0("Failure in resolving '", z, "'. See error detail in results."))
        out = list(doi=z, error=out[[1]],)
      }
      return(out) 
    })
  else
    cn(dois)
}

#' @import bibtex 
parse_bibtex <- function(x){
  x <- gsub("@[Dd]ata", "@Misc", x)
  writeLines(x, "tmpscratch.bib")
  output <- read.bib("tmpscratch.bib")
  unlink("tmpscratch.bib")
  output
}
