#' Search CrossRef members
#'
#' @export
#' @family crossref
#' @param member_ids One or more member ids. See examples. Alternatively,
#' you can query for them using the query parameter.
#' @template args
#' @template moreargs
#' @template cursor_args
#' @template field_queries
#' @template sorting
#' @param facet (logical) Include facet results. Boolean or string with
#' field to facet on. Valid fields are *, affiliation, funder-name,
#' funder-doi, orcid, container-title, assertion, archive, update-type,
#' issn, published, source, type-name, publisher-name, license,
#' category-name, assertion-group. Default: `FALSE`
#' @param works (logical) If `TRUE`, works returned as well, if not then not.
#' @param parse (logical) Whether to output json `FALSE` or parse to
#' list `TRUE`. Default: `FALSE`
#'
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references
#' <https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md>
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
#' cr_members(member_ids=98, works=TRUE, facet=TRUE, limit = 0)
#' cr_members(member_ids=98, works=TRUE, facet="license:*", limit = 0)
#'
#' # curl options
#' cr_members(member_ids=98, verbose = TRUE)
#'
#' # Use the cursor for deep paging
#' cr_members(member_ids=98, works = TRUE, cursor = "*",
#'    cursor_max = 500, limit = 100)
#' cr_members(member_ids=c(10, 98, 45), works = TRUE, cursor = "*",
#'    cursor_max = 200, limit = 100)
#' ## with optional progress bar
#' cr_members(member_ids=98, works = TRUE, cursor = "*",
#'    cursor_max = 500, limit = 100, .progress = TRUE)
#' 
#' # data not found
#' # cr_members(query="adfdf")
#' # cr_members(member_ids=c(323234343434,3434343434), works=TRUE, facet=TRUE)
#' # cr_members(member_ids=c(323234343434,3434343434,98), works=TRUE,facet=TRUE)
#'
#' # Low level function - does no parsing to data.frame, get json or a list
#' cr_members_(query = 'hindawi')
#' cr_members_(member_ids = 98)
#' cr_members_(query = 'hindawi', parse=TRUE)
#' cr_members_(member_ids = 98, works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100)
#' cr_members_(member_ids = 98, works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100, parse=TRUE)
#'
#' # field queries
#' ## query.container-title
#' cr_members(98, works = TRUE, flq = c(`query.container-title` = 'Ecology'))
#' 
#' 
#' # select only certain fields to return
#' res <- cr_members(98, works = TRUE, select = c('DOI', 'title'))
#' names(res$data)
#' }
`cr_members` <- function(member_ids = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE,
  cursor = NULL, cursor_max = 5000, .progress="none", flq = NULL, select = NULL, ...) {

  args <- prep_args(query, filter, offset, limit, sample, sort, order,
                    facet, cursor, flq, select)
  if (length(member_ids) > 1) {
    res <- llply(member_ids, member_GET, args = args, works = works,
                 cursor = cursor, cursor_max = cursor_max, ...,
                 .progress = .progress)
    if (!is.null(cursor)) {
      out <- lapply(res, "[[", "data")
      df <- tbl_df(bind_rows(out))
      facets <- stats::setNames(lapply(res, function(x) parse_facets(x$facets)), member_ids)
      facets <- if (all(vapply(facets, is.null, logical(1)))) NULL else facets
      list(data = df, facets = facets)
    } else {
      out <- lapply(res, "[[", "message")
      if (all(vapply(out, is.null, logical(1)))) {
        list(meta = NULL, data = NULL, facets = NULL)
      } else {
        # remove any slots not found
        member_ids <- member_ids[which(vapply(res, function(z) !is.null(z$message), logical(1)))]
        res <- Filter(function(z) !is.null(z$message), res)
        out <- cr_compact(out)
        outdat <- if (works) do.call("c", lapply(out, function(x) lapply(x$items, parse_works))) else lapply(out, parse_members)
        df <- tbl_df(bind_rows(outdat))
        meta <- if (works) data.frame(member_ids = member_ids, do.call(rbind, lapply(res, parse_meta)), stringsAsFactors = FALSE) else NULL
        facets <- stats::setNames(lapply(res, function(x) parse_facets(x$message$facets)), member_ids)
        facets <- if (all(vapply(facets, is.null, logical(1)))) NULL else facets
        list(meta = meta, data = df, facets = facets)
      }
    }
  } else if (length(member_ids) == 1) {
    tmp <- member_GET(member_ids, args = args, works = works,
                      cursor = cursor, cursor_max = cursor_max, 
                      .progress = .progress, ...)
    if (!is.null(cursor)) {
      tmp
    } else {
      if (is.null(tmp$message)) {
        list(meta = NULL, data = NULL, facets = NULL)
      } else {
        out <- if (works) tbl_df(bind_rows(lapply(tmp$message$items, parse_works))) else parse_members(tmp$message)
        meta <- if (works) data.frame(member_id = member_ids, parse_meta(tmp), stringsAsFactors = FALSE) else NULL
        list(meta = meta, data = out, facets = parse_facets(tmp$message$facets))
      }
    }
  } else {
    tmp <- member_GET(NULL, args = args, works = works, ...)
    if (is.null(tmp$message)) {
      list(meta = NULL, data = NULL, facets = NULL)
    } else {
      df <- tbl_df(bind_rows(lapply(tmp$message$items, parse_members)))
      meta <- parse_meta(tmp)
      list(meta = meta, data = df, facets = NULL)
    }
  }
}

#' @export
#' @rdname cr_members
`cr_members_` <- function(member_ids = NULL, query = NULL, filter = NULL,
  offset = NULL, limit = NULL, sample = NULL, sort = NULL, order = NULL,
  facet=FALSE, works = FALSE, cursor = NULL, cursor_max = 5000,
  .progress="none", parse=FALSE, flq = NULL, select = NULL, ...) {

  args <- prep_args(query, filter, offset, limit, sample, sort,
                    order, facet, cursor, flq, select)
  if (length(member_ids) > 1) {
    llply(member_ids, member_GET_, args = args, works = works,
          cursor = cursor, cursor_max = cursor_max, parse = parse,
          .progress = .progress, ...)
  } else {
    member_GET_(member_ids, args = args, works = works,
               cursor = cursor, cursor_max = cursor_max, parse = parse, ...)
  }
}

member_GET <- function(x, args, works, cursor = NULL, cursor_max = NULL, .progress, ...){
  path <- if (!is.null(x)) {
    if (works) sprintf("members/%s/works", x) else sprintf("members/%s", x)
  } else {
    "members"
  }

  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = TRUE, .progress = .progress, ...)
    rr$GETcursor()
    rr$parse()
  } else {
    cr_GET(endpoint = path, args, FALSE, parse = TRUE, ...)
  }
}

member_GET_ <- function(x, args, works, cursor = NULL, cursor_max = NULL,
                        parse, .progress, ...) {
  path <- if (!is.null(x)) {
    if (works) sprintf("members/%s/works", x) else sprintf("members/%s", x)
  } else {
    "members"
  }

  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = parse, .progress = .progress, ...)
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
      lout[[i]] <-
        data.frame(
          stats::setNames(v[[i]], paste0("link", i, "_", names(v[[i]]))),
          stringsAsFactors = FALSE
        )
    }
    do.call("cbind", lout)
  } else {
    NULL
  }
}
