#' Search CrossRef licenses
#'
#' @export
#'
#' @template args
#' @template moreargs
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#'
#' @examples 
#' \donttest{
#' cr_licenses()
#' }
#' 
#' \dontrun{
#' # query for something, e.g. a publisher
#' cr_licenses(query = 'elsevier')
#' 
#' # what license types does elsevier support
#' cr_licenses(filter = c(member=78))
#' 
#' # filter by an issn of a journal
#' cr_licenses(filter = c(issn='2090-8091'))
#' 
#' # What licenses does a reasearcher with a particular ORCID publish under
#' cr_licenses(filter = c(orcid='0000-0003-1340-5202'))
#' }

`cr_licenses` <- function(query = NULL, filter = NULL, offset = NULL, limit = NULL, sample = NULL, 
  sort = NULL, order = NULL, .progress="none", ...)
{
  filter <- filter_handler(filter)
  args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                          sample = sample, sort = sort, order = order))
  
  tmp <- licenses_GET(args=args, ...)
  df <- rbind_all(lapply(tmp$message$items, data.frame, stringsAsFactors=FALSE))
  meta <- parse_meta(tmp)
  list(meta=meta, data=df)
}

licenses_GET <- function(args, ...) cr_GET("licenses", args, todf = FALSE, ...)
