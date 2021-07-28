#' Get abstract
#' 
#' @export
#' @param doi (character) a DOI, required.
#' @param ... Named parameters passed on to \code{\link[crul]{HttpClient}}
#' @examples \dontrun{
#' # abstract found
#' cr_abstract('10.1109/TASC.2010.2088091')
#' cr_abstract("10.1175//2572.1")
#' cr_abstract("10.1182/blood.v16.1.1039.1039")
#' 
#' # doi not found
#' # cr_abstract(doi = '10.5284/1011335')
#' 
#' # abstract not found, throws error
#' # cr_abstract(doi = '10.1126/science.169.3946.635')
#' 
#' # a random DOI
#' # cr_abstract(cr_r(1))
#' }
cr_abstract <- function(doi, ...) {
  url <- paste0('https://api.crossref.org/works/', doi, '/transform/application/vnd.crossref.unixsd+xml')
  cli <- crul::HttpClient$new(
    url = url,
    opts = list(followlocation = 1),
    headers = list(
      `User-Agent` = rcrossref_ua(),
      `X-USER-AGENT` = rcrossref_ua()
    )
  )
  res <- cli$get(...)
  res$raise_for_status()
  txt <- res$parse("UTF-8")
  xml <- tryCatch(read_xml(txt), error = function(e) e)
  if (inherits(xml, "error")) {
    stop(doi, " not found ", call. = FALSE)
  }
  tt <- tryCatch(xml_find_first(xml, "//jats:abstract"), 
                 warning = function(w) w)
  if (inherits(tt, "warning")) {
    stop("no abstract found for ", doi, call. = FALSE)
  }
  xml_text(tt)
}
