#' Search CrossRef licenses
#'
#' @export
#'
#' @template args
#' @template moreargs
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' @details NOTE: The API route behind this function does not support filters any more, so
#' the \code{filter} parameter has been removed.
#'
#' @examples 
#' \donttest{
#' cr_licenses()
#' }
#' 
#' \dontrun{
#' # query for something, e.g. a publisher
#' cr_licenses(query = 'elsevier')
#' }

`cr_licenses` <- function(query = NULL, offset = NULL, limit = NULL, sample = NULL, 
  sort = NULL, order = NULL, .progress="none", ...) {
  
  calls <- names(sapply(match.call(expand.dots = TRUE), deparse))[-1]
  if("filter" %in% calls)
    stop("The parameter filter has been removed")
  
  args <- cr_compact(list(query = query, offset = offset, rows = limit,
                          sample = sample, sort = sort, order = order))
  
  tmp <- licenses_GET(args=args, ...)
  df <- rbind_all(lapply(tmp$message$items, data.frame, stringsAsFactors=FALSE))
  meta <- parse_meta(tmp)
  list(meta=meta, data=df)
}

licenses_GET <- function(args, ...) cr_GET("licenses", args, todf = FALSE, ...)
