#' Get text mining links via the CrossRef works endpoint
#'
#' @param dois One or more DOIs.
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' 
#' @examples \dontrun{
#' # elife
#' out <- cr_members(4374, filter=c(has_full_text = TRUE), works = TRUE)
#' dois <- out$data$DOI[1:5]
#' cr_works_links(dois)
#' 
#' # hindawi
#' out <- cr_members(98, filter=c(has_full_text = TRUE), works = TRUE)
#' dois <- out$data$DOI[1:5]
#' cr_works_links(dois)
#' 
#' cr_works_links(dois = "10.1016/j.fm.2004.01.001")
#' dois <- c("10.1016/s0747-7171(03)00168-8","10.1016/j.fm.2004.01.002","10.1016/j.fm.2004.01.007")
#' }

`cr_works_links` <- function(dois = NULL, ...)
{
  get_links <- function(x) cr_GET(endpoint = sprintf("works/%s", x), list(), FALSE, ...)$message$link
  setNames(lapply(dois, get_links, ...), dois)
}
