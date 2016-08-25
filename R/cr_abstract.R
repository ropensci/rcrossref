#' Get abstract
#' 
#' @export
#' @param doi (character) a DOI, required.
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' # abstract found
#' cr_abstract(doi = '10.1109/TASC.2010.2088091')
#' 
#' # doi not found
#' # cr_abstract(doi = '10.5284/1011335')
#' 
#' # abstract not found, throws warning
#' # cr_abstract(doi = '10.1126/science.169.3946.635')
#' # cr_abstract(doi = '10.1371/journal.pone.0033693')
#' # cr_abstract(doi = '10.1007/12080.1874-1746')
#' 
#' # cr_abstract(cr_r(1))
#' }
cr_abstract <- function(doi, ...) {
  url <- paste0('http://api.crossref.org/works/', doi, '.xml')
  res <- GET(url, make_rcrossref_ua(), config(followlocation = 1), ...)
  stop_for_status(res)
  txt <- content(res, "text", encoding = "UTF-8")
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

# out <- list()
# for (i in seq_along(dois)) {
#   cat(i, "\n")
#   out[[i]] <- tryCatch(cr_abstract(dois[i]), error = function(e) e)
# }
