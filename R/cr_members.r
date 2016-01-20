#' Search CrossRef members
#'
#' @export
#' 
#' @param member_ids One or more member ids. See examples. ALternatively, you can query for them
#' using the query parameter.
#' @template args
#' @template moreargs
#' @template cursor_args
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' @param facet (logical) Include facet results. Default: \code{FALSE}
#' @param parse (logical) Whether to output json \code{FALSE} or parse to 
#' list \code{TRUE}. Default: \code{FALSE}
#' 
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' 
#' @examples \dontrun{
#' cr_members(member_ids=98)
#' cr_members(member_ids=340)
#' 
#' cr_members(member_ids=98, works=TRUE)
#' cr_members(member_ids=c(10,98,45,1,9))
#' cr_members(member_ids=c(10,98,45,1,9), works=TRUE)
#' 
#' cr_members(query='hindawi')
#' cr_members(query='ecology')
#' 
#' # facets
#' cr_members(member_ids=98, works=TRUE, facet=TRUE)
#'
#' # curl options
#' library('httr')
#' cr_members(member_ids=98, config=verbose())
#' 
#' # Use the cursor for deep paging
#' cr_members(member_ids=98, works = TRUE, cursor = "*", cursor_max = 500, limit = 100)
#' cr_members(member_ids=c(10, 98, 45), works = TRUE, cursor = "*", cursor_max = 200, limit = 100)
#' 
#' # data not found
#' # cr_members(query="adfdf")
#' # cr_members(member_ids=c(323234343434,3434343434), works=TRUE, facet=TRUE)
#' # cr_members(member_ids=c(323234343434,3434343434,98), works=TRUE, facet=TRUE)
#' 
#' # Low level function - does no parsing to data.frame, get json or a list
#' cr_members_(query = 'hindawi')
#' cr_members_(member_ids = 98)
#' cr_members_(query = 'hindawi', parse=TRUE)
#' cr_members_(member_ids = 98, works = TRUE, cursor = "*", 
#'    cursor_max = 300, limit = 100)
#' cr_members_(member_ids = 98, works = TRUE, cursor = "*", 
#'    cursor_max = 300, limit = 100, parse=TRUE)
#' }
`cr_members` <- function(member_ids = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  cursor = NULL, cursor_max = 5000, .progress="none", ...) {
  
  args <- prep_args(query, filter, offset, limit, sample, sort, order, facet, cursor)
  if (length(member_ids) > 1) {
    res <- llply(member_ids, member_GET, args = args, works = works,  
                 cursor = cursor, cursor_max = cursor_max, ..., .progress = .progress)
    if (!is.null(cursor)) {
      out <- lapply(res, "[[", "data")
      df <- bind_rows(out)
      facets <- setNames(lapply(res, function(x) parse_facets(x$facets)), member_ids)
      facets <- if (all(vapply(facets, is.null, logical(1)))) NULL else facets
      list(data = df, facets = facets)
    } else {
      out <- lapply(res, "[[", "message")
      if ( all(is.na(out)) ) {
        list(meta = NULL, data = NULL, facets = NULL)
      } else {
        # remove any slots not found
        res <- res[!is.na(out)]
        member_ids <- member_ids[!is.na(out)]
        out <- out[!is.na(out)]
        # continue...
        out <- if (works) do.call("c", lapply(out, function(x) lapply(x$items, parse_works))) else lapply(out, parse_members)
        df <- rbind_all(out)
        meta <- if (works) data.frame(member_ids = member_ids, do.call(rbind, lapply(res, parse_meta)), stringsAsFactors = FALSE) else NULL
        facets <- setNames(lapply(res, function(x) parse_facets(x$message$facets)), member_ids)
        facets <- if (all(vapply(facets, is.null, logical(1)))) NULL else facets
        list(meta = meta, data = df, facets = facets)
      }
    }
  } else if (length(member_ids) == 1) { 
    tmp <- member_GET(member_ids, args = args, works = works, 
                      cursor = cursor, cursor_max = cursor_max, ...)
    if (!is.null(cursor)) {
      tmp
    } else {
      if (all(is.na(tmp$message))) {
        list(meta = NULL, data = NULL, facets = NULL)
      } else {
        out <- if (works) rbind_all(lapply(tmp$message$items, parse_works)) else parse_members(tmp$message)
        meta <- if (works) data.frame(member_id = member_ids, parse_meta(tmp), stringsAsFactors = FALSE) else NULL
        list(meta = meta, data = out, facets = parse_facets(tmp$message$facets))
      }
    }
  } else {
    tmp <- member_GET(NULL, args = args, works = works, ...)
    if (all(is.na(tmp$message))) {
      list(meta = NULL, data = NULL, facets = NULL)
    } else {
      df <- rbind_all(lapply(tmp$message$items, parse_members))
      meta <- parse_meta(tmp)
      list(meta = meta, data = df, facets = NULL)
    }
  }
}

#' @export
#' @rdname cr_members
`cr_members_` <- function(member_ids = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  cursor = NULL, cursor_max = 5000, .progress="none", parse=FALSE, ...) {
  
  args <- prep_args(query, filter, offset, limit, sample, sort, order, facet, cursor)
  if (length(member_ids) > 1) {
    llply(member_ids, member_GET_, args = args, works = works,  
          cursor = cursor, cursor_max = cursor_max, parse = parse, .progress = .progress, ...)
  } else { 
    member_GET_(member_ids, args = args, works = works, 
               cursor = cursor, cursor_max = cursor_max, parse = parse, ...)
  }
}

member_GET <- function(x, args, works, cursor = NULL, cursor_max = NULL, ...){
  path <- if (!is.null(x)) {
    if (works) sprintf("members/%s/works", x) else sprintf("members/%s", x)
  } else { 
    "members" 
  }
  
  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max, 
                        should_parse = TRUE, ...)
    rr$GETcursor()
    rr$parse()
  } else {
    cr_GET(path, args, FALSE, parse = TRUE, ...)
  }
}

member_GET_ <- function(x, args, works, cursor = NULL, cursor_max = NULL, parse, ...) {
  path <- if (!is.null(x)) {
    if (works) sprintf("members/%s/works", x) else sprintf("members/%s", x)
  } else { 
    "members" 
  }
  
  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max, 
                        should_parse = parse, ...)
    rr$GETcursor()
    rr$cursor_out
  } else {
    cr_GET(path, args, FALSE, parse = parse, ...)
  }
}

parse_members <- function(x){
  data.frame(id = ifnullna(x$id), 
             primary_name = ifnullna(x$`primary-name`), 
             location = ifnullna(x$location), 
             last_status_check_time = convtime(x$`last-status-check-time`),
             names2underscore(x$counts),
             prefixes = paste_longer(x$prefixes),
             coverge = names2underscore(x$coverage),
             flags = names2underscore(x$flags),
             names = paste_longer(x$names),
             tokens = paste_longer(x$tokens),
             stringsAsFactors = FALSE)  
}

get_links <- function(v) {
  if (!is.null(v)) {
    lout <- list()
    for (i in seq_along(v)) {
      lout[[i]] <- data.frame(setNames(v[[i]], paste0("link", i, "_", names(v[[i]]))), stringsAsFactors = FALSE)
    }
    do.call("cbind", lout)
  } else {
    NULL
  }
}
