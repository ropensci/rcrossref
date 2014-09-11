#' Search CrossRef members
#'
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @export
#' 
#' @param member_ids One or more member ids. See examples. ALternatively, you can query for them
#' using the query parameter.
#' @template args
#' @template moreargs
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' @examples \dontrun{
#' cr_members(member_ids=98)
#' cr_members(query='hindawi')
#' out <- cr_members(member_ids=c(10,98))
#' out[['10']]$counts
#' out[['98']]$coverage
#'
#' # curl options
#' library('httr')
#' cr_members(member_ids=98, config=verbose())
#' }

`cr_members` <- function(member_ids = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  .progress="none", ...)
{
  foo <- function(x){
    path <- if(!is.null(x)) sprintf("members/%s", x) else "members"
    filter <- filter_handler(filter)
    facet <- if(facet) "t" else NULL
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                            sample = sample, sort = sort, order = order, facet = facet))
    cr_GET(path, args, ...)
  }
  
  if(length(member_ids) > 1){
    res <- llply(member_ids, foo, .progress=.progress)
    res <- lapply(res, "[[", "message")
    names(res) <- member_ids
    res
  } else { foo(member_ids)$message }
}
