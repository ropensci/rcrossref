#' Get citations in various formats from CrossRef.
#'
#' @export
#'
#' @param dois Search by a single DOI or many DOIs.
#' @param format Name of the format. One of "rdf-xml", "turtle", "citeproc-json", 
#' "citeproc-json-ish", "text", "ris", "bibtex" (default), "crossref-xml", 
#' "datacite-xml","bibentry", or "crossref-tdm". The format "citeproc-json-ish"
#' is a format that is not quite proper citeproc-json
#' @param style a CSL style (for text format only). See \code{\link{get_styles}} 
#' for options. Default: apa. If there's a style that CrossRef doesn't support 
#' you'll get a  \code{(500) Internal Server Error}
#' @param locale Language locale. See \code{?Sys.getlocale}
#' @param raw (logical) Return raw text in the format given by \code{format} 
#' parameter. Default: FALSE
#' @template moreargs
#' @details See \url{http://www.crosscite.org/cn/} for more info on the
#' Crossref Content Negotiation API service.
#'
#' DataCite DOIs: Some values of the \code{format} parameter won't work with 
#' DataCite DOIs, but most do. See examples below.
#' 
#' See \code{\link{cr_agency}}
#' 
#' Note that the format type \code{citeproc-json} uses the CrossRef API at 
#' \code{api.crossref.org}, while all others use \code{http://dx.doi.org}.
#'
#' @examples \dontrun{
#' cr_cn(dois="10.16126/science.169.3946.635")
#' cr_cn(dois="10.1126/science.169.3946.635", "citeproc-json")
#' cr_cn(dois="10.1126/science.169.3946.635", "citeproc-json-ish")
#' cr_cn("10.1126/science.169.3946.635", "rdf-xml")
#' cr_cn("10.1126/science.169.3946.635", "crossref-xml")
#' cr_cn("10.1126/science.169.3946.635", "text")
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
#' 
#' # Using DataCite DOIs
#' ## some formats don't work
#' # cr_cn("10.5284/1011335", "text")
#' # cr_cn("10.5284/1011335", "crossref-xml")
#' # cr_cn("10.5284/1011335", "crossref-tdm")
#' ## But most do work
#' cr_cn("10.5284/1011335", "datacite-xml")
#' cr_cn("10.5284/1011335", "rdf-xml")
#' cr_cn("10.5284/1011335", "turtle")
#' cr_cn("10.5284/1011335", "citeproc-json")
#' cr_cn("10.5284/1011335", "ris")
#' cr_cn("10.5284/1011335", "bibtex")
#' cr_cn("10.5284/1011335", "bibentry")
#' cr_cn("10.5284/1011335", "bibtex")
#' 
#' dois <- c('10.5167/UZH-30455','10.5167/UZH-49216','10.5167/UZH-503',
#'           '10.5167/UZH-38402','10.5167/UZH-41217')
#' cat(cr_cn(dois[1]))
#' cat(cr_cn(dois[2]))
#' cat(cr_cn(dois[3]))
#' cat(cr_cn(dois[4]))
#' 
#' # Get raw output
#' cr_cn(dois = "10.1002/app.27716", format = "citeproc-json", raw = TRUE)
#' }

`cr_cn` <- function(dois, format = "bibtex", style = 'apa', 
                    locale = "en-US", raw = FALSE, .progress="none", ...) {
  
  format <- match.arg(format, c("rdf-xml", "turtle", "citeproc-json",
                                "citeproc-json-ish", "text", "ris", "bibtex", 
                                "crossref-xml", "datacite-xml", "bibentry", 
                                "crossref-tdm"))
  cn <- function(doi, ...){
    url <- paste("http://dx.doi.org", doi, sep = "/")
    pick <- c(
           "rdf-xml" = "application/rdf+xml",
           "turtle" = "text/turtle",
           "citeproc-json" = "transform/application/vnd.citationstyles.csl+json",
           "citeproc-json-ish" = "application/vnd.citationstyles.csl+json",
           "text" = "text/x-bibliography",
           "ris" = "application/x-research-info-systems",
           "bibtex" = "application/x-bibtex",
           "crossref-xml" = "application/vnd.crossref.unixref+xml",
           "datacite-xml" = "application/vnd.datacite.datacite+xml",
           "bibentry" = "application/x-bibtex",
           "crossref-tdm" = "application/vnd.crossref.unixsd+xml")
    type <- pick[[format]]
    if (format == "citeproc-json") {
      response <- GET(file.path("http://api.crossref.org/works", doi, type), ...)
    } else {
      if (format == "text") {
        type <- paste(type, "; style = ", style, "; locale = ", locale, sep = "")
      }
      response <- GET(url, ..., add_headers(Accept = type, followlocation = TRUE))
    }
    warn_status(response)
    if (response$status_code < 202) {
      select <- c(
        "rdf-xml" = "text/xml",
        "turtle" = "text/plain",
        "citeproc-json" = "application/json",
        "citeproc-json-ish" = "application/json",
        "text" = "text/plain",
        "ris" = "text/plain",
        "bibtex" = "text/plain",
        "crossref-xml" = "text/xml",
        "datacite-xml" = "text/xml",
        "bibentry" = "text/plain",
        "crossref-tdm" = "text/xml")
      parser <- select[[format]]
      if (raw) {
        content(response, "text")
      } else {
        out <- content(response, "parsed", parser, "UTF-8")
        if (format == "text") {
          out <- gsub("\n", "", out)
        }
        if (format == "bibentry") {
          out <- parse_bibtex(out)
        }
        out
      }
    }
  }

  if (length(dois) > 1) {
    llply(dois, function(z, ...) {
      out = try(cn(z, ...), silent = TRUE)
      if ("try-error" %in% class(out)) {
        warning(paste0("Failure in resolving '", z, "'. See error detail in results."))
        out <- list(doi = z, error = out[[1]])
      }
      return(out)
    }, .progress = .progress)
  } else {
    cn(dois, ...)
  }
}

#' @importFrom bibtex read.bib
parse_bibtex <- function(x){
  x <- gsub("@[Dd]ata", "@Misc", x)
  writeLines(x, "tmpscratch.bib")
  output <- read.bib("tmpscratch.bib")
  unlink("tmpscratch.bib")
  output
}

warn_status <- function(x) {
  if(x$status_code > 202) {
    mssg <- content(x)
    if(!is.character(mssg)) {
      mssg <- if(x$status_code == 406) {
        "(406) - probably bad format type"
      } else {
        http_status(x)$message
      }
    } else {
      mssg <- paste(sprintf("(%s)", x$status_code), "-", mssg)
    }
    warning(sprintf("%s w/ %s", gsub("%2F", "/", httr::parse_url(x$url)$path), mssg))
  }
}
