#' Search the CrossRef Fundref API
#'
#' @export
#' 
#' @param dois Search by a single DOI or many DOIs.
#' @template args
#' @template moreargs
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' 
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' 
#' @examples \donttest{
#' cr_fundref(query="NSF")
#' cr_fundref(query="NSF", limit=1)
#' cr_fundref(dois='10.13039/100000001')
#' out <- cr_fundref(dois=c('10.13039/100000001','10.13039/100000015'))
#' out['10.13039/100000001']
#' out[['10.13039/100000001']]
#' 
#' cr_fundref(dois='10.13039/100000001')
#' cr_fundref(dois='10.13039/100000001', works=TRUE, limit=5)
#'
#' cr_fundref(dois=c('10.13039/100000001','10.13039/100000015'))
#' cr_fundref(dois=c('10.13039/100000001','10.13039/100000015'), works=TRUE)
#'
#' # Curl options
#' library('httr')
#' cr_fundref(dois='10.13039/100000001', config=verbose())
#' }

`cr_fundref` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL,  sample = NULL, sort = NULL, order = NULL, works = FALSE, 
  .progress="none", ...)
{
  filter <- filter_handler(filter)
  args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                          sample = sample, sort = sort, order = order))
  
  if(length(dois) > 1){
    res <- llply(dois, fundref_GET, args=args, works=works, ..., .progress=.progress)
    out <- lapply(res, "[[", "message")
    if(works){
      rbind_all(do.call(c, lapply(out, function(x) lapply(x$items, parse_works))))
    } else { 
      tmp <- lapply(out, parse_fund)
      structure(tmp, .Names=dois)
    }
  } else { 
    res <- fundref_GET(dois, args=args, works=works, ...) 
    if(is.null(dois)){
      list(meta=parse_meta(res), 
           data=rbind_all(lapply(res$message$items, parse_fundref)))
    } else {
      if(works){
        wout <- rbind_all(lapply(res$message$items, parse_works))
        meta <- parse_meta(res)
      } else {
        wout <- parse_fund(res$message)
        meta <- NULL
      }
      list(meta=meta, data=wout)
    }
  }
}

fundref_GET <- function(x, args, works, ...){
  path <- if(!is.null(x)){
    if(works) sprintf("funders/%s/works", x) else sprintf("funders/%s", x)
  } else { "funders" }
  cr_GET(path, args, todf = FALSE, ...)
}

parse_fund <- function(x){
  desc <- unlist(x$descendants)
#   unlist(x$hierarchy)
  hier <- data.frame(id=names(unlist(x$`hierarchy-names`)), 
             name=unname(unlist(x$`hierarchy-names`)), stringsAsFactors = FALSE)
  df <- data.frame(name=x$name, location=x$location, work_count=x$`work-count`, 
                   descendant_work_count=x$`descendant-work-count`,
                   id=x$id, tokens=paste0(x$tokens, collapse = ", "), 
                   alt.names=paste0(x$`alt-names`, collapse = ", "), 
                   uri=x$uri, stringsAsFactors = FALSE)
  list(data=df, descendants=desc, hierarchy=hier)
}

parse_fundref <- function(zzz){
  keys <- c('id','location','name','alt-names','uri','tokens')
  manip <- function(which="id", y){
    res <- switch(which, 
                  id = list(y[[which]]),
                  location = list(y[[which]]),
                  name = list(y[[which]]),
                  `alt-names` = list(paste0(y[[which]], collapse = ", ")),
                  uri = list(y[[which]]),
                  tokens = list(paste0(y[[which]], collapse = ", "))
    )
    res <- if(is.null(res) || length(res) == 0) NA else res
    if(length(res[[1]]) > 1){
      names(res[[1]]) <- paste(which, names(res[[1]]), sep = "_")
      as.list(unlist(res))
    } else {
      names(res) <- which
      res
    }
  }
  data.frame(as.list(unlist(lapply(keys, manip, y=zzz))), stringsAsFactors = FALSE)
}
