#' Check the DOI minting agency on one or more dois
#'
#' @export
#' 
#' @param dois (character) One or more article or organization dois.
#' @template moreargs
#' @references 
#' \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' cr_agency(dois = '10.13039/100000001')
#' cr_agency(
#'   dois = c('10.13039/100000001','10.13039/100000015','10.5284/1011335'))
#' }

`cr_agency` <- function(dois = NULL, .progress="none", ...) {
  foo <- function(x, y, ...){
    cr_GET(
      endpoint = sprintf("works/%s/agency", x), 
      args = list(), 
      parse = TRUE, ...)
  }
  if (length(dois) > 1) {
    res <- llply(dois, foo, y = .progress, ...)
    res <- lapply(res, "[[", "message")
    names(res) <- dois
    res
  } else { 
    foo(dois, ...)$message 
  }
}
