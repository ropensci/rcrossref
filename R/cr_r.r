#' Get a random set of DOI's through CrossRef.
#'
#' @export
#' 
#' @param sample The number of returned random DOIs. Maximum is 1000, default 20.
#'    Note that a request for 1000 random DOIs will take a few seconds to
#'    complete, whereas a request for 20 will take ~1 second.
#' @param ... Further args passed on to \code{\link{cr_works}}
#' 
#' @return A character vector of DOIs
#' @references \url{http://random.labs.crossref.org/}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @seealso \code{\link{cr_search}}, \code{\link{cr_citation}}, \code{\link{cr_search_free}}
#' @examples \dontrun{
#' # Default search gets 10 random DOIs
#' cr_r()
#' }

`cr_r` <- function(sample = 10, ...) {
  tmp <- cr_works(sample = sample, ...)
  dois <- suppressWarnings(tryCatch(tmp$data$DOI, error = function(e) e))
  if (inherits(dois, "error")) NULL else dois
}
