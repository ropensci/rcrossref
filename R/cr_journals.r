#' Search CrossRef journals
#'
#' @export
#' 
#' @param issn One or more ISSN's. Format is XXXX-XXXX.
#' @template args
#' @template moreargs
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' 
#' @details  BEWARE: The API will only work for CrossRef DOIs.
#' 
#' Note that some parameters are ignored unless \code{works=TRUE}: sample, sort, 
#' order, filter
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' @examples \dontrun{
#' cr_journals(issn="2167-8359")
#' cr_journals()
#' cr_journals(issn="2167-8359", works=TRUE)
#' cr_journals(issn=c('1803-2427','2326-4225'))
#' cr_journals(query="ecology")
#' cr_journals(issn="2167-8359", query='ecology', works=TRUE, sort='score', order="asc")
#' cr_journals(issn="2167-8359", query='ecology', works=TRUE, sort='score', order="desc")
#' cr_journals(issn="2167-8359", works=TRUE, filter=c(from_pub_date='2014-03-03'))
#' cr_journals(query="peerj")
#' cr_journals(issn='1803-2427', works=TRUE)
#' cr_journals(issn='1803-2427', works=TRUE, sample=1)
#' cr_journals(limit=2)
#' 
#' # fails, if you want works, you must give an ISSN
#' # cr_journals(query = "ecology", filter=c(has_full_text = TRUE), works = TRUE)
#' }

`cr_journals` <- function(issn = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, works=FALSE, .progress="none", ...)
{
  if(works) if(is.null(issn)) stop("If `works=TRUE`, you must give a journal ISSN", call. = FALSE)
  
  foo <- function(x){
    path <- if(!is.null(x)){
      if(works) sprintf("journals/%s/works", x) else sprintf("journals/%s", x)
    } else { "journals" }
    filter <- filter_handler(filter)
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                            sample = sample, sort = sort, order = order))
    cr_GET(endpoint = path, args, todf = FALSE, ...)
  }
  
  if(length(issn) > 1){
    res <- llply(issn, foo, .progress=.progress)
    res <- lapply(res, "[[", "message")
    res <- lapply(res, parse_works)
    df <- rbind_all(res)
    #exclude rows with empty ISSN value until CrossRef API supports input validation
    if(nrow(df[df$ISSN == "",]) > 0)
      warning("only data with valid ISSN returned",  call. = FALSE)
    df <- df[!df$ISSN == "",]
#   df$issn <- issn
    df
  } else {
    tmp <- foo(issn)
    if(!is.null(issn)){
      if(works){ 
        meta <- parse_meta(tmp)
        dat <- rbind_all(lapply(tmp$message$items, parse_works)) 
      } else {
        meta <- NULL
        dat <- parse_journal(tmp$message)
      }
      list(meta=meta, data=dat)
    } else {
      fxn <- if(works) parse_works else parse_journal
      meta <- parse_meta(tmp)
      list(meta=meta, data=rbind_all(lapply(tmp$message$items, fxn)))
    }
  }
}

parse_journal <- function(x){
  if(!is.null(x$flags)) names(x$flags) <- names2underscore(names(x$flags)) else x$flags <- NA
  if(!is.null(x$coverage)) names(x$coverage) <- names2underscore(names(x$coverage)) else x$coverage <- NA
  if(!is.null(x$counts)) names(x$counts) <- names2underscore(names(x$counts)) else x$counts <- NA
  data.frame(title=x$title, publisher=x$publisher, issn=paste_longer(x$ISSN[[1]]), 
             last_status_check_time=convtime(x$`last-status-check-time`),
             x$flags,
             x$coverage,
             x$counts,
             stringsAsFactors = FALSE)
}

paste_longer <- function(w) if(length(w) > 1) paste(w, collapse=", ") else w[[1]]
names2underscore <- function(w) t(sapply(w, function(z) gsub("-", "_", z), USE.NAMES = FALSE))
