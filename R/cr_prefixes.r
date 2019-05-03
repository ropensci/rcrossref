#' Search CrossRef prefixes
#'
#' @export
#' @family crossref
#' @param prefixes (character) Publisher prefixes, one or more in a vector or
#' list. Required.
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
#'
#' Note that any one publisher can have more than one DOI. If you want to
#' search on all DOIs for a publisher, pass in all DOIs, or see
#' [cr_members()], and pass in the `member_ids` parameter.
#'
#' Notes from CrossRef (quoting them):
#'
#' The prefix of a CrossRef DOI does NOT indicate who currently owns the DOI.
#' It only reflects who originally registered the DOI. CrossRef metadata has
#' an `owner_prefix` element that records the current owner of the
#' CrossRef DOI in question.
#'
#' CrossRef also has member IDs for depositing organisations. A single member
#' may control multiple owner prefixes, which in turn may control a number of
#' DOIs. When looking at works published by a certain organisation, member
#' IDs and the member routes should be used.
#'
#' @references
#' <https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md>
#'
#' @examples \dontrun{
#' cr_prefixes(prefixes="10.1016")
#' cr_prefixes(prefixes="10.1016", works=TRUE)
#' cr_prefixes(prefixes=c('10.1016','10.1371','10.1023','10.4176','10.1093'))
#' cr_prefixes(prefixes=c('10.1016','10.1371'), works=TRUE)
#' cr_prefixes(prefixes="10.1016", works=TRUE, filter=c(has_full_text=TRUE), 
#'   limit=5)
#' cr_prefixes(prefixes="10.1016", works=TRUE, query='ecology', limit=4)
#' cr_prefixes(prefixes="10.1016", works=TRUE, query='ecology', limit=4)
#'
#' # facets - only avail. when works=TRUE
#' cr_prefixes(prefixes="10.1016", works=TRUE, facet=TRUE)
#' cr_prefixes(prefixes="10.1016", works=TRUE, facet="license:*", limit=0)
#' cr_prefixes(prefixes=c('10.1016','10.1371'), works=TRUE, facet=TRUE,
#'   limit=0)
#'
#' # Use the cursor for deep paging
#' cr_prefixes("10.1016", works = TRUE, cursor = "*", cursor_max = 500,
#'    limit = 100)
#' cr_prefixes(c('10.1016', '10.1371'), works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100)
#' ## with optional progress bar
#' cr_prefixes("10.1016", works = TRUE, cursor = "*", cursor_max = 500,
#'    limit = 100, .progress = TRUE)
#'
#' # Low level function - does no parsing to data.frame, get json or a list
#' cr_prefixes_("10.1016")
#' cr_prefixes_(c('10.1016', '10.1371'))
#' cr_prefixes_("10.1016", works = TRUE, query = 'ecology', limit = 10)
#' cr_prefixes_("10.1016", works = TRUE, query = 'ecology', parse=TRUE,
#'    limit = 10)
#' cr_prefixes_("10.1016", works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100)
#' cr_prefixes_("10.1016", works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100, parse = TRUE)
#'
#' # field queries
#' ## query.container-title
#' cr_prefixes("10.1016", works = TRUE,
#'   flq = c(`query.container-title` = 'Ecology'))
#' 
#' # select only certain fields to return
#' res <- cr_prefixes("10.1016", works = TRUE, select = c('DOI', 'title'))
#' names(res$data)
#' }

`cr_prefixes` <- function(prefixes, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE,
  works = FALSE, cursor = NULL, cursor_max = 5000, .progress="none",
  flq = NULL, select = NULL, ...) {

  args <- prep_args(query, filter, offset, limit, sample, sort, order,
                    facet, cursor, flq, select)
  if (length(prefixes) > 1) {
    res <- llply(prefixes, prefixes_GET, args = args, works = works,
                 cursor = cursor, cursor_max = cursor_max, ...,
                 .progress = .progress)
    if (!is.null(cursor)) {
      out <- lapply(res, "[[", "data")
      bind_rows(out)
    } else {
      out <- lapply(res, "[[", "message")
      out <- if (works) {
        do.call(c, lapply(out, function(x) lapply(x$items, parse_works)))
      } else {
        lapply(out, DataFrame)
      }
      df <- bind_rows(out)
      meta <- if (works) {
        data.frame(prefix = prefixes, do.call(rbind, lapply(res, parse_meta)),
                   stringsAsFactors = FALSE)
      } else {
        NULL
      }
      if (facet) {
        ft <- Map(function(x, y) {
          rr <- list(parse_facets(x$message$facets)); names(rr) <- y; rr
        }, res, prefixes)
      } else {
        ft <- list()
      }
      list(meta = meta, data = df, facets = ft)
    }
  } else {
    tmp <- prefixes_GET(prefixes, args, works = works, cursor = cursor,
                        cursor_max = cursor_max, .progress = .progress, ...)
    if (!is.null(cursor)) {
      tmp
    } else {
      out <- if (works) {
        bind_rows(lapply(tmp$message$items, parse_works))
      } else {
        DataFrame(tmp$message)
      }
      meta <- if (works) {
        data.frame(prefix = prefixes, parse_meta(tmp), stringsAsFactors = FALSE)
      } else {
        NULL
      }
      list(meta = meta, data = out, facets = parse_facets(tmp$message$facets))
    }
  }
}

#' @export
#' @rdname cr_prefixes
`cr_prefixes_` <- function(prefixes, query = NULL, filter = NULL, 
  offset = NULL, limit = NULL, sample = NULL, sort = NULL, order = NULL, 
  facet=FALSE, works = FALSE, cursor = NULL, cursor_max = 5000, 
  .progress="none", parse=FALSE, flq = NULL, select = NULL, ...) {

  args <- prep_args(query, filter, offset, limit, sample, sort, order,
                    facet, cursor, flq, select)
  if (length(prefixes) > 1) {
    llply(prefixes, prefixes_GET_, args = args, works = works,
          cursor = cursor, cursor_max = cursor_max, parse = parse,
          ..., .progress = .progress)
  } else {
    prefixes_GET_(prefixes, args, works = works, cursor = cursor,
                  cursor_max = cursor_max, parse = parse, ...)
  }
}

prefixes_GET <- function(x, args, works, cursor = NULL, cursor_max = NULL, 
  .progress = "none", ...) {

  path <- if (works) sprintf("prefixes/%s/works", x) else sprintf("prefixes/%s", x)
  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = TRUE, .progress = .progress, ...)
    rr$GETcursor()
    rr$parse()
  } else {
    cr_GET(path, args, todf = FALSE, ...)
  }
}

prefixes_GET_ <- function(x, args, works, cursor = NULL, cursor_max = NULL, parse,
  .progress, ...) {

  path <- if (works) sprintf("prefixes/%s/works", x) else sprintf("prefixes/%s", x)
  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = parse, .progress = .progress, ...)
    rr$GETcursor()
    rr$cursor_out
  } else {
    cr_GET(path, args, todf = FALSE, parse = parse, ...)
  }
}

DataFrame <- function(x) {
  if (is.null(x) || length(x) == 0) return(data.frame(NULL))
  x[ sapply(x, function(y) if (is.null(y) || length(y) == 0) TRUE else FALSE)] <- NA
  data.frame(x, stringsAsFactors = FALSE)
}
