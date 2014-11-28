#' Check the DOI minting agency on one or more dois
#'
#' @export
#' 
#' @param dois (character) One or more article or organization dois.
#' @template moreargs
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \donttest{
#' cr_agency(dois = '10.13039/100000001')
#' res <- cr_agency(dois = c('10.13039/100000001','10.13039/100000015'))
#' res[['10.13039/100000015']]
#' }

`cr_agency` <- function(dois = NULL, .progress="none", ...)
{
  foo <- function(x, y){
    cr_GET(endpoint = sprintf("works/%s/agency", x), args=list(), .progress=y, ...)
  }
  if(length(dois) > 1){
    res <- llply(dois, foo, y=.progress)
    res <- lapply(res, "[[", "message")
    names(res) <- dois
    res
  } else { foo(dois, y = .progress)$message }
}
