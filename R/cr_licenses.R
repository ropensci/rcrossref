#' Search CrossRef licenses
#'
#' @export
#'
#' @param query Query terms
#' @param offset Number of record to start at, from 1 to infinity.
#' @param limit Number of results to return in the query. Not relavant when searching with specific
#' dois. Default: 20. Max: 1000
#' @param sort (character) Field to sort on, one of score, relevance, updated, deposited, indexed,
#' or published.
#' @param order (character) Sort order, one of 'asc' or 'desc'
#' @param .progress Show a \code{plyr}-style progress bar? Options are "none", "text", "tk", "win,
#' and "time".  See \code{\link[plyr]{create_progress_bar}} for details of each.
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' @param parse (logical) Whether to output json \code{FALSE} or parse to
#' list \code{TRUE}. Default: \code{FALSE}
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
#'
#' # Low level function - does no parsing to data.frame, get json or a list
#' cr_licenses_()
#' cr_licenses_(query = "elsevier")
#' cr_licenses_(query = "elsevier", parse=TRUE)
#' }

`cr_licenses` <- function(query = NULL, offset = NULL, limit = NULL,
  sort = NULL, order = NULL, .progress="none", ...) {

  calls <- names(sapply(match.call(expand.dots = TRUE), deparse))[-1]
  if ("filter" %in% calls)
    stop("The parameter filter has been removed")

  check_limit(limit)
  args <- cr_compact(list(query = query, offset = offset, rows = limit,
                          sort = sort, order = order))

  tmp <- licenses_GET(args = args, parse = TRUE, ...)
  df <- rbind_all(lapply(tmp$message$items, data.frame, stringsAsFactors = FALSE))
  meta <- parse_meta(tmp)
  list(meta = meta, data = df)
}

#' @export
#' @rdname cr_licenses
`cr_licenses_` <- function(query = NULL, offset = NULL, limit = NULL,
  sort = NULL, order = NULL, .progress="none", parse = FALSE, ...) {

  check_limit(limit)
  args <- cr_compact(list(query = query, offset = offset, rows = limit,
                          sort = sort, order = order))
  licenses_GET(args = args, parse = parse, ...)
}

licenses_GET <- function(args, parse, ...) {
  cr_GET("licenses", args, todf = FALSE, on_error = stop, parse = parse, ...)
}
