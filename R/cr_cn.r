#' Get citations in various formats from CrossRef.
#'
#' @export
#'
#' @param dois Search by a single DOI or many DOIs.
#' @param format Name of the format. One of "rdf-xml", "turtle",
#' "citeproc-json", "citeproc-json-ish", "text", "ris", "bibtex" (default),
#' "crossref-xml", "datacite-xml","bibentry", or "crossref-tdm". The format
#' "citeproc-json-ish" is a format that is not quite proper citeproc-json
#' @param style a CSL style (for text format only). See [get_styles()]
#' for options. Default: apa. If there's a style that CrossRef doesn't support
#' you'll get a  `(500) Internal Server Error`
#' @param locale Lansguage locale. See `?Sys.getlocale`
#' @param raw (logical) Return raw text in the format given by `format`
#' parameter. Default: `FALSE`
#' @param url (character) Base URL for the content negotiation request. 
#' Default: "https://doi.org"
#' 
#' @template moreargs
#' @details See <http://citation.crosscite.org/docs.html> for more info
#' on the Crossref Content Negotiation API service.
#'
#'   DataCite DOIs: Some values of the `format` parameter won't work with
#'   DataCite DOIs, i.e. "citeproc-json", "crossref-xml", "crossref-tdm",
#'     "onix-xml".
#'
#'   MEDRA DOIs only work with "rdf-xml", "turtle", "citeproc-json-ish", "ris",
#'   "bibtex", "bibentry", "onix-xml".
#'
#'   See examples below.
#'
#'   See [cr_agency()]
#'
#'   Note that the format type `citeproc-json` uses the CrossRef API at
#'   `api.crossref.org`, while all others are content negotiated via
#'   `http://data.crossref.org`, `http://data.datacite.org` or
#'   `http://data.medra.org`. DOI agency is checked first (see
#'   [cr_agency()]).
#'
#' @examples \dontrun{
#' cr_cn(dois="10.1126/science.169.3946.635")
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
#'  cat(cr_cn("10.1126/science.169.3946.635", "text", style=x))
#' }
#' foo(sample(stys, 1))
#'
#' # Using DataCite DOIs
#' ## some formats don't work
#' # cr_cn("10.5284/1011335", "crossref-xml")
#' # cr_cn("10.5284/1011335", "crossref-tdm")
#' ## But most do work
#' cr_cn("10.5284/1011335", "text")
#' cr_cn("10.5284/1011335", "datacite-xml")
#' cr_cn("10.5284/1011335", "rdf-xml")
#' cr_cn("10.5284/1011335", "turtle")
#' cr_cn("10.5284/1011335", "citeproc-json-ish")
#' cr_cn("10.5284/1011335", "ris")
#' cr_cn("10.5284/1011335", "bibtex")
#' cr_cn("10.5284/1011335", "bibentry")
#'
#' # Using Medra DOIs
#' cr_cn("10.3233/ISU-150780", "onix-xml")
#'
#' # Get raw output
#' cr_cn(dois = "10.1002/app.27716", format = "citeproc-json", raw = TRUE)
#'
#' # sometimes messy DOIs even work
#' ## in this case, a DOI minting agency can't be found
#' ## but we proceed anyway, just assuming it's "crossref"
#' cr_cn("10.1890/0012-9615(1999)069[0569:EDILSA]2.0.CO;2")
#' 
#' # Use a different base url
#' cr_cn("10.1126/science.169.3946.635", "text", url = "https://data.datacite.org")
#' cr_cn("10.1126/science.169.3946.635", "text", url = "http://dx.doi.org")
#' cr_cn("10.1126/science.169.3946.635", "text", "heredity", url = "http://dx.doi.org")
#' cr_cn("10.5284/1011335", url = "https://citation.crosscite.org/format", 
#'    style = "oikos")
#' cr_cn("10.5284/1011335", url = "https://citation.crosscite.org/format", 
#'    style = "plant-cell-and-environment")
#' cr_cn("10.5284/1011335", url = "https://data.datacite.org", 
#'    style = "plant-cell-and-environment")
#' }

`cr_cn` <- function(dois, format = "bibtex", style = 'apa',
  locale = "en-US", raw = FALSE, .progress = "none", url = NULL, ...) {

  format <- match.arg(format, c("rdf-xml", "turtle", "citeproc-json",
                                "citeproc-json-ish", "text", "ris", "bibtex",
                                "crossref-xml", "datacite-xml", "bibentry",
                                "crossref-tdm", "onix-xml"))

  cn <- function(doi, ...){
    agency_id <- suppressWarnings(GET_agency_id(doi))
    if (is.null(agency_id)) {
      warning(doi, " agency not found - proceeding with 'crossref' ...",
              call. = FALSE)
      agency_id <- "crossref"
    }

    assert(url, "character")
    if (is.null(url)) url <- "https://doi.org"
    # need separate setup for citation.crosscite.org vs. others
    args <- list()
    if (grepl("citation.crosscite.org", url)) {
      args <- cr_compact(list(doi = doi, lang = locale, style = style))
    } else {
      url <- file.path(url, doi)
    }

    # check cn data provider
    if (!format %in% supported_cn_types[[agency_id]]) {
      stop(paste0("Format '", format, "' for '", doi,
                  "' is not supported by the DOI registration agency: '",
                  agency_id, "'.\nTry one of the following formats: ",
                  paste0(supported_cn_types[[agency_id]], collapse = ", ")))
    }
    pick <- c(
           "rdf-xml" = "application/rdf+xml",
           "turtle" = "text/turtle",
           "citeproc-json" =
             "transform/application/vnd.citationstyles.csl+json",
           "citeproc-json-ish" = "application/vnd.citationstyles.csl+json",
           "text" = "text/x-bibliography",
           "ris" = "application/x-research-info-systems",
           "bibtex" = "application/x-bibtex",
           "crossref-xml" = "application/vnd.crossref.unixref+xml",
           "datacite-xml" = "application/vnd.datacite.datacite+xml",
           "bibentry" = "application/x-bibtex",
           "crossref-tdm" = "application/vnd.crossref.unixsd+xml",
           "onix-xml" = "application/vnd.medra.onixdoi+xml")
    type <- pick[[format]]
    if (format == "citeproc-json") {
      cli <- crul::HttpClient$new(
        url = file.path("https://api.crossref.org/works", doi, type),
        headers = list(
          `User-Agent` = rcrossref_ua(), `X-USER-AGENT` = rcrossref_ua()
        )
      )
      response <- cli$get(...)
    } else {
      if (format == "text") {
        type <- paste(type, "; style = ", style, "; locale = ", locale,
                      sep = "")
      }
      cli <- crul::HttpClient$new(
        url = url,
        opts = list(followlocation = 1),
        headers = list(
          `User-Agent` = rcrossref_ua(), `X-USER-AGENT` = rcrossref_ua(),
          Accept = type
        )
      )
      response <- cli$get(query = args, ...)
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
        "crossref-tdm" = "text/xml",
        "onix-xml" = "text/xml")
      parser <- select[[format]]
      if (raw) {
        response$parse("UTF-8")
      } else {
        out <- response$parse("UTF-8")
        if (format == "text") {
          out <- gsub("\n", "", out)
        }
        if (format == "bibentry") {
          out <- parse_bibtex(out)
        }
        if (parser == "application/json") {
          out <- jsonlite::fromJSON(out)
        }
        if (parser == "text/xml") {
          out <- xml2::read_xml(out)
        }
        out
      }
    }
  }

  if (length(dois) > 1) {
    llply(dois, function(z, ...) {
      out <- try(cn(z, ...), silent = TRUE)
      if ("try-error" %in% class(out)) {
        warning(
          paste0("Failure in resolving '", z,
                 "'. See error detail in results."),
          call. = FALSE
        )
        out <- list(doi = z, error = out[[1]])
      }
      return(out)
    }, .progress = .progress)
  } else {
    cn(dois, ...)
  }
}

parse_bibtex <- function(x){
  x <- gsub("@[Dd]ata", "@Misc", x)
  writeLines(x, "tmpscratch.bib")
  out <- bibtex::do_read_bib("tmpscratch.bib", 
    srcfile = srcfile("tmpscratch.bib"))
  unlink("tmpscratch.bib")
  if (length(out) > 0) {
    out <- out[[1]]
    atts <- attributes(out)
    attsuse <- atts[c('key', 'entry')]
    out <- c(as.list(out), attsuse)
  } else {
    out <- list()
  }
  return(out)
}

warn_status <- function(x) {
  if (x$status_code > 202) {
    mssg <- x$parse("UTF-8")
    if (!is.character(mssg)) {
      mssg <- if (x$status_code == 406) {
        "(406) - probably bad format type"
      } else {
        x$status_http()$message
      }
    } else {
      mssg <- paste(sprintf("(%s)", x$status_code), "-", mssg)
    }
    warning(
      sprintf(
        "%s w/ %s",
        gsub("%2F", "/", crul::url_parse(x$url)$path),
        mssg
      ),
      call. = FALSE
    )
  }
}

#' Get doi agency id to identify resource location
#'
#' @param x doi
#' @keywords internal
GET_agency_id <- function(x, ...) {
  if (is.null(x)) {
    stop("no doi for doi agency check provided", call. = FALSE)
  }
  cr_agency(x)$agency$id
}

# Supported content types
# See http://www.crosscite.org/cn/
supported_cn_types <- list(
  crossref = c("rdf-xml", "turtle", "citeproc-json", "citeproc-json-ish",
               "text", "ris", "bibtex", "crossref-xml", "bibentry",
               "crossref-tdm"),
  datacite = c("rdf-xml", "turtle", "datacite-xml", "citeproc-json-ish", "text",
               "ris", "bibtex", "bibentry"),
  medra = c("rdf-xml", "turtle", "citeproc-json-ish", "ris", "bibtex",
            "bibentry", "onix-xml")
)
