#' Search CrossRef licenses
#'
#' @export
#'
#' @param query Query terms
#' @param offset Number of record to start at, from 1 to infinity.
#' @param limit Number of results to return in the query. Not relavant when searching with specific
#' dois. Default: 20. Max: 1000
#' @param sample (integer) Number of random results to return. when you use the sample parameter, 
#' the rows and offset parameters are ignored.
#' @param sort (character) Field to sort on, one of score, relevance, updated, deposited, indexed, 
#' or published.
#' @param order (character) Sort order, one of 'asc' or 'desc'
#' @param .progress Show a \code{plyr}-style progress bar? Options are "none", "text", "tk", "win, 
#' and "time".  See \code{\link[plyr]{create_progress_bar}} for details of each.
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' 
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' @details NOTE: The API route behind this function does not support filters any more, so
#' the \code{filter} parameter has been removed.
#'
#' @examples \dontrun{
#' cr_licenses()
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
