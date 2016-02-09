#' Search the CrossRef Fundref API
#'
#' @export
#' 
#' @param dois Search by a single DOI or many DOIs.
#' @template args
#' @template moreargs
#' @template cursor_args
#' @param facet (logical) Include facet results. Default: \code{FALSE}
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' @param parse (logical) Whether to output json \code{FALSE} or parse to 
#' list \code{TRUE}. Default: \code{FALSE}
#' 
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' 
#' This function name changing to \code{cr_funders} in the next version - both work for now
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' 
#' @section NOTE:
#' Funders without IDs don't show up on the /funders route, and in this 
#' function. Some funders don't have assigned IDs in Crossref's system, 
#' so won't show up in searches. 
#' 
#' @examples \dontrun{
#' cr_funders(query="NSF", limit=1)
#' cr_funders(query="NSF")
#' cr_funders(dois='10.13039/100000001')
#' out <- cr_funders(dois=c('10.13039/100000001','10.13039/100000015'))
#' out['10.13039/100000001']
#' out[['10.13039/100000001']]
#' 
#' cr_funders(dois='10.13039/100000001')
#' cr_funders(dois='10.13039/100000001', works=TRUE, limit=5)
#'
#' cr_funders(dois=c('10.13039/100000001','10.13039/100000015'))
#' cr_funders(dois=c('10.13039/100000001','10.13039/100000015'), works=TRUE)
#'
#' # Curl options
#' library('httr')
#' cr_funders(dois='10.13039/100000001', config=verbose())
#' 
#' # If not found, and > 1 DOI given, those not found dropped
#' cr_funders(dois=c("adfadfaf","asfasf"))
#' cr_funders(dois=c("adfadfaf","asfasf"), works=TRUE)
#' cr_funders(dois=c("10.13039/100000001","asfasf"))
#' cr_funders(dois=c("10.13039/100000001","asfasf"), works=TRUE)
#'
#' # Use the cursor for deep paging
#' cr_funders('100000001', works = TRUE, cursor = "*", cursor_max = 500, limit = 100)
#' cr_funders(c('100000001', '100000002'), works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100) 
#'    
#' # Low level function - does no parsing to data.frame, get json or a list
#' cr_funders_(query = 'nsf')
#' cr_funders_('10.13039/100000001')
#' cr_funders_(query = 'science', parse=TRUE)
#' cr_funders_('10.13039/100000001', works = TRUE, cursor = "*", 
#'    cursor_max = 300, limit = 100)
#' cr_funders_('10.13039/100000001', works = TRUE, cursor = "*", 
#'    cursor_max = 300, limit = 100, parse = TRUE)
#' }
`cr_fundref` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL,  sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  cursor = NULL, cursor_max = 5000, .progress="none", ...) {
  
  .Deprecated(msg = "function name changing to cr_funders in the next version\nboth work for now")
  args <- prep_args(query, filter, offset, limit, sample, sort, order, facet, cursor)
  if (length(dois) > 1) {
    res <- llply(dois, fundref_GET, args = args, works = works, 
                 cursor = cursor, cursor_max = cursor_max, ..., .progress = .progress)
    if (!is.null(cursor)) {
      out <- lapply(res, "[[", "data")
      bind_rows(out)
    } else {
      out <- setNames(lapply(res, "[[", "message"), dois)
      if (any(is.na(out))) {
        out <- cr_compact(lapply(out, function(x) {
          if (all(is.na(x))) NULL else x
        }))
      }
      if (length(out) == 0) {
        NA
      } else {
        if (works) {
          if (all(sapply(out, function(z) length(z$items)) == 0)) {
            NA
          } else {
            tmp <- lapply(out, function(x) lapply(x$items, parse_works))
            tmp <- tmp[!sapply(tmp, length) == 0]
            rbind_all(do.call('c', tmp))
          }
        } else {
          if (all(sapply(out, function(z) length(z)) == 0)) {
            NA
          } else {
            lapply(out, parse_fund)
          }
        }
      }
    }
  } else { 
    res <- fundref_GET(dois, args = args, works = works, cursor = cursor, 
                       cursor_max = cursor_max, ...) 
    if (!is.null(cursor)) {
      res
    } else {
      if (is.null(res$message)) {
        list(meta = NA, data = NA)
      } else {
        if (is.null(dois)) {
          list(meta = parse_meta(res), 
               data = rbind_all(lapply(res$message$items, parse_fundref)))
        } else {
          if (works) {
            wout <- rbind_all(lapply(res$message$items, parse_works))
            meta <- parse_meta(res)
          } else {
            wout <- parse_fund(res$message)
            meta <- NULL
          }
          list(meta = meta, data = wout)
        }
      }
    }
  }
}

#' @export
#' @rdname cr_fundref
`cr_funders` <- `cr_fundref`

#' @export
#' @rdname cr_fundref
`cr_funders_` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL,  sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  cursor = NULL, cursor_max = 5000, .progress="none", parse=FALSE, ...) {
  
  args <- prep_args(query, filter, offset, limit, sample, sort, order, facet, cursor)
  if (length(dois) > 1) {
    llply(dois, fundref_GET_, args = args, works = works, 
          cursor = cursor, cursor_max = cursor_max, parse = parse, ..., .progress = .progress)
  } else { 
    fundref_GET_(dois, args = args, works = works, cursor = cursor, 
                cursor_max = cursor_max, parse = parse, ...)
  }
}

fundref_GET <- function(x, args, works, cursor = NULL, cursor_max = NULL, ...){
  path <- if (!is.null(x)) {
    if (works) sprintf("funders/%s/works", x) else sprintf("funders/%s", x)
  } else { 
    "funders" 
  }
  
  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max, 
                        should_parse = TRUE, ...)
    rr$GETcursor()
    rr$parse()
  } else {
    cr_GET(path, args, todf = FALSE, ...)
  }
}

fundref_GET_ <- function(x, args, works, cursor = NULL, cursor_max = NULL, parse, ...){
  path <- if (!is.null(x)) {
    if (works) sprintf("funders/%s/works", x) else sprintf("funders/%s", x)
  } else { 
    "funders" 
  }
  
  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max, 
                        should_parse = parse, ...)
    rr$GETcursor()
    rr$cursor_out
  } else {
    cr_GET(path, args, todf = FALSE, parse = parse, ...)
  }
}

parse_fund <- function(x) {
  if (is.null(x) || is.na(x)) {
    NA
  } else {
    desc <- unlist(x$descendants)
    hier <- data.frame(id=names(unlist(x$`hierarchy-names`)), 
                       name=unname(unlist(x$`hierarchy-names`)), stringsAsFactors = FALSE)
    df <- data.frame(name=x$name, location=x$location, work_count=x$`work-count`, 
                     descendant_work_count=x$`descendant-work-count`,
                     id=x$id, tokens=paste0(x$tokens, collapse = ", "), 
                     alt.names=paste0(x$`alt-names`, collapse = ", "), 
                     uri=x$uri, stringsAsFactors = FALSE)
    list(data=df, descendants=desc, hierarchy=hier)
  }
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
