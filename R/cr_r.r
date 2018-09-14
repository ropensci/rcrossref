#' Get a random set of DOI's through CrossRef.
#'
#' @export
#'
#' @param sample The number of returned random DOIs. Maximum: 100. Default: 20.
#' @param ... Further args passed on to [cr_works()]
#' @return A character vector of DOIs
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' # Default search gets 10 random DOIs
#' cr_r()
#'
#' # Get 30 DOIs
#' cr_r(30)
#' }
`cr_r` <- function(sample = 10, ...) {
  tmp <- cr_works(sample = sample, ...)
  dois <- suppressWarnings(tryCatch(tmp$data$doi, error = function(e) e))
  if (inherits(dois, "error")) NULL else dois
}
