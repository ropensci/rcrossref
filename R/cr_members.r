#' Search CrossRef members
#'
#' @export
#' @importFrom dplyr tbl_df
#' 
#' @param member_ids One or more member ids. See examples. ALternatively, you can query for them
#' using the query parameter.
#' @template args
#' @template moreargs
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' @param facet (logical) Include facet results.
#' 
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' 
#' @examples \donttest{
#' cr_members(member_ids=98)
#' cr_members(member_ids=98, works=TRUE)
#' cr_members(member_ids=c(10,98,45,1,9))
#' cr_members(member_ids=c(10,98,45,1,9), works=TRUE)
#' 
#' cr_members(query='hindawi')
#' cr_members(query='ecology')
#'
#' # curl options
#' library('httr')
#' cr_members(member_ids=98, config=verbose())
#' }

`cr_members` <- function(member_ids = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  .progress="none", ...)
{
  filter <- filter_handler(filter)
  facet <- if(facet) "t" else NULL
  args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                          sample = sample, sort = sort, order = order, facet = facet))
  
  if(length(member_ids) > 1){
    res <- llply(member_ids, member_GET, args=args, works=works, ..., .progress=.progress)
    out <- lapply(res, "[[", "message")
    out <- if(works) do.call(c, lapply(out, function(x) lapply(x$items, parse_works))) else lapply(out, parse_members)
    df <- rbind_all(out)
    meta <- if(works) data.frame(member_ids=member_ids, do.call(rbind, lapply(res, parse_meta)), stringsAsFactors = FALSE) else NULL
    facets <- lapply(res, function(x) parse_facets(x$message$facets))
    names(facets) <- member_ids
    list(meta=meta, data=df, facets=facets)
  } else if(length(member_ids) == 1) { 
    tmp <- member_GET(member_ids, args=args, works=works, ...)
    out <- if(works) rbind_all(lapply(tmp$message$items, parse_works)) else parse_members(tmp$message)
    meta <- if(works) data.frame(member_id=member_ids, parse_meta(tmp), stringsAsFactors = FALSE) else NULL
    list(meta=meta, data=out, facets=parse_facets(tmp$message$facets))
  } else {
    tmp <- member_GET(NULL, args=args, works=works, ...)
    df <- rbind_all(lapply(tmp$message$items, parse_members))
    meta <- parse_meta(tmp)
    list(meta=meta, data=df, facets=NULL)
  }
}

member_GET <- function(x, args, works, ...){
  path <- if(!is.null(x)){
    if(works) sprintf("members/%s/works", x) else sprintf("members/%s", x)
  } else { "members" }
  cr_GET(path, args, FALSE, ...)
}

parse_members <- function(x){
  data.frame(id=x$id, primary_name=x$`primary-name`, location=x$location, 
             last_status_check_time=convtime(x$`last-status-check-time`),
             names2underscore(x$counts),
             prefixes=paste_longer(x$prefixes),
             coverge=names2underscore(x$coverage),
             flags=names2underscore(x$flags),
             names=paste_longer(x$names),
             tokens=paste_longer(x$tokens),
             stringsAsFactors = FALSE)  
}
