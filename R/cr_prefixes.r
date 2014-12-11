#' Search CrossRef prefixes
#'
#' @export
#'
#' @param prefixes (character) Publisher prefixes, one or more in a vector or list. Required.
#' @template args
#' @template moreargs
#' @param facet (logical) Include facet results. Facet data not yet included in output.
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' 
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' 
#' Note that any one publisher can have more than one DOI. If you want to search on 
#' all DOIs for a publisher, pass in all DOIs, or see \code{\link{cr_members}}, and pass in the 
#' \code{member_ids} parameter.
#' 
#' Notes from CrossRef (quoting them):
#' 
#' The prefix of a CrossRef DOI does NOT indicate who currently owns the DOI. It only 
#' reflects who originally registered the DOI. CrossRef metadata has an \code{owner_prefix} 
#' element that records the current owner of the CrossRef DOI in question.
#' 
#' CrossRef also has member IDs for depositing organisations. A single member may control multiple 
#' owner prefixes, which in turn may control a number of DOIs. When looking at works published by 
#' a certain organisaton, member IDs and the member routes should be used.
#'
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' @examples 
#' \donttest{
#' cr_prefixes(prefixes="10.1016")
#' }
#' 
#' \dontrun{
#' cr_prefixes(prefixes="10.1016", works=TRUE)
#' cr_prefixes(prefixes=c('10.1016','10.1371','10.1023','10.4176','10.1093'))
#' cr_prefixes(prefixes=c('10.1016','10.1371'), works=TRUE)
#' cr_works(prefixes="10.1016", filter=c(has_full_text=TRUE), limit=5)
#' cr_works(prefixes="10.1016", query='ecology', limit=4)
#' cr_works(prefixes="10.1016", query='ecology', limit=4)
#' 
#' # facets
#' ## if works is FALSE, then facets ignored
#' cr_prefixes(prefixes="10.1016", works=FALSE, facet=TRUE)
#' ## get facets back
#' cr_prefixes(prefixes="10.1016", works=TRUE, facet=TRUE)
#' cr_prefixes(prefixes=c('10.1016','10.1371'), works=TRUE, facet=TRUE)
#' }

`cr_prefixes` <- function(prefixes, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  .progress="none", ...)
{
  filter <- filter_handler(filter)
  facet_log <- facet
  facet <- if(facet) "t" else NULL
  args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                          sample = sample, sort = sort, order = order, facet = facet))

  if(length(prefixes) > 1){
    res <- llply(prefixes, prefixes_GET, args=args, works=works, ..., .progress=.progress)
    out <- lapply(res, "[[", "message")
    out <- if(works) do.call(c, lapply(out, function(x) lapply(x$items, parse_works))) else lapply(out, data.frame, stringsAsFactors=FALSE)
    df <- rbind_all(out)
    meta <- if(works) data.frame(prefix=prefixes, do.call(rbind, lapply(res, parse_meta)), stringsAsFactors = FALSE) else NULL
    if(facet_log){ 
      ft <- Map(function(x, y){ 
        rr <- list(parse_facets(x$message$facets)); names(rr) <- y; rr 
      }, res, prefixes) 
    } else { ft <- list() } 
    list(meta=meta, data=df, facets=ft)
  } else {
    tmp <- prefixes_GET(prefixes, args, works=works, ...)
    out <- if(works) rbind_all(lapply(tmp$message$items, parse_works)) else data.frame(tmp$message, stringsAsFactors=FALSE)
    meta <- if(works) data.frame(prefix=prefixes, parse_meta(tmp), stringsAsFactors = FALSE) else NULL
    list(meta=meta, data=out, facets=parse_facets(tmp$message$facets))
  }
}

prefixes_GET <- function(x, args, works, ...){
  path <- if(works) sprintf("prefixes/%s/works", x) else sprintf("prefixes/%s", x)
  cr_GET(path, args, todf = FALSE, ...)
}
