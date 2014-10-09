#' Search CrossRef members
#'
#' BEWARE: The API will only work for CrossRef DOIs.
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
#' @examples \dontrun{
#' cr_members(member_ids=98)
#' cr_members(member_ids=98, works=TRUE)
#' cr_members(member_ids=c(10,98,45,1,9))
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
    rbind_all(lapply(res, function(y) parse_members(y$message)))
  } else { 
    tmp <- foo(member_ids)$message
    if(!"items" %in% names(tmp)){
      parse_members(tmp) 
    } else {
      for(i in seq_along(tmp$items)){
        if(class(tmp$items[[i]]) == "list"){ 
          tmp$items[[i]] <- paste_longer(unlist(tmp$items[[i]]))
        }
      }
      tmp$items <- cbind(tmp$items, tmp$items$counts)
      tmp$items$counts <- NULL
      tmp$items <- cbind(tmp$items, tmp$items$coverage)
      tmp$items$coverage <- NULL
      tmp$items <- cbind(tmp$items, tmp$items$flags)
      tmp$items$flags <- NULL
      list(items=tbl_df(tmp$items), data.frame(tmp[!names(tmp) == 'items'], stringsAsFactors = FALSE))
    }
  }
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
