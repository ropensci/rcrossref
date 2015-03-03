#' Get citations in various formats from CrossRef.
#'
#' @export
#'
#' @param dois Search by a single DOI or many DOIs.
#' @param format Name of the format. One of "rdf-xml", "turtle", "citeproc-json", "text", 
#' "ris", "bibtex", "crossref-xml", "datacite-xml","bibentry", or "crossref-tdm"
#' @param style a CSL style (for text format only). See \code{\link{get_styles}} 
#' for options. Default: apa. If there's a style that CrossRef doesn't support you'll get a 
#' \code{(500) Internal Server Error}
#' @param locale Language locale. See \code{?Sys.getlocale}
#' @template moreargs
#' @details See \url{http://www.crosscite.org/cn/} for more info on the
#'   	Crossref Content Negotiation API service.
#'
#' @examples \dontrun{
#' cr_cn(dois="10.1126/science.169.3946.635")
#' cr_cn(dois="10.1126/science.169.3946.635", format="citeproc-json")
#' cr_cn("10.1126/science.169.3946.635", "rdf-xml")
#' cr_cn("10.1126/science.169.3946.635", "crossref-xml")
#' cr_cn("10.1126/science.169.3946.635", "bibtex")
#' 
#' # return an R bibentry type
#' cr_cn("10.1126/science.169.3946.635", "bibentry")
#' cr_cn("10.6084/m9.figshare.97218", "bibentry")
#' 
#' # return an apa style citation
#' cr_cn("10.1126/science.169.3946.635", "text", "apa")
#' cr_cn("10.1126/science.169.3946.635", "text", "harvard3")
#' cr_cn("10.1126/science.169.3946.635", "text", "elsevier-harvard")
#' cr_cn("10.1126/science.169.3946.635", "text", "ecoscience")
#' cr_cn("10.1126/science.169.3946.635", "text", "heredity")
#' cr_cn("10.1126/science.169.3946.635", "text", "oikos")
#'
#' # example with many DOIs
#' dois <- cr_r(2)
#' cr_cn(dois, "text", "apa")
#' 
#' # Cycle through random styles - print style on each try
#' stys <- get_styles()
#' foo <- function(x){
#'  cat(sprintf("<Style>:%s\n", x), sep = "\n\n")
#'  cr_cn("10.1126/science.169.3946.635", "text", style=x)
#' }
#' foo(sample(stys, 1))
#' }

`cr_cn` <- function(dois, format = "text", style = 'apa', locale = "en-US", .progress="none", ...){
  format <- match.arg(format, c("rdf-xml", "turtle", "citeproc-json",
                                "text", "ris", "bibtex", "crossref-xml",
                                "datacite-xml", "bibentry", "crossref-tdm"))
  cn <- function(doi, ...){
    url <- paste("http://dx.doi.org", doi, sep="/")
    pick <- c(
           "rdf-xml" = "application/rdf+xml",
           "turtle" = "text/turtle",
           "citeproc-json" = "application/vnd.citationstyles.csl+json",
           "text" = "text/x-bibliography",
           "ris" = "application/x-research-info-systems",
           "bibtex" = "application/x-bibtex",
           "crossref-xml" = "application/vnd.crossref.unixref+xml",
           "datacite-xml" = "application/vnd.datacite.datacite+xml",
           "bibentry" = "application/x-bibtex",
           "crossref-tdm" = "application/vnd.crossref.unixsd+xml")
    type <- pick[[format]]
    if(format == "text")
      type <- paste(type, "; style = ", style, "; locale = ", locale, sep="")
    response <- GET(url, ..., add_headers(Accept = type, followlocation = TRUE))
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
           "bibentry" = "text/plain",
           "crossref-tdm" = "text/xml")
    parser <- select[[format]]
    out <- content(response, "parsed", parser, "UTF-8")
    if(format == "text")
      out <- gsub("\n", "", out)
    if(format == "bibentry")
      out <- parse_bibtex(out)
    out
  }

  if(length(dois) > 1)
    llply(dois, function(z, ...) {
      out = try(cn(z, ...), silent=TRUE)
      if("try-error" %in% class(out)) {
        warning(paste0("Failure in resolving '", z, "'. See error detail in results."))
        out <- list(doi=z, error=out[[1]])
      }
      return(out)
    }, .progress=.progress)
  else
    cn(dois, ...)
}

#' @import bibtex
parse_bibtex <- function(x){
  x <- gsub("@[Dd]ata", "@Misc", x)
  writeLines(x, "tmpscratch.bib")
  output <- read.bib("tmpscratch.bib")
  unlink("tmpscratch.bib")
  output
}
