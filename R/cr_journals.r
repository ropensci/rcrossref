#' Search CrossRef journals
#'
#' @export
#'
#' @param issn (character) One or more ISSN's. Format: XXXX-XXXX.
#' @template args
#' @template moreargs
#' @template cursor_args
#' @template field_queries
#' @param facet (logical) Include facet results. Boolean or string with
#' field to facet on. Valid fields are *, affiliation, funder-name,
#' funder-doi, orcid, container-title, assertion, archive, update-type,
#' issn, published, source, type-name, publisher-name, license,
#' category-name, assertion-group. Default: `FALSE`
#' @param works (logical) If `TRUE`, works returned as well, if not then not.
#' @param parse (logical) Whether to output json `FALSE` or parse to
#' list `TRUE`. Default: `FALSE`
#'
#' @details  BEWARE: The API will only work for CrossRef DOIs.
#'
#' Note that some parameters are ignored unless `works=TRUE`: sample, sort,
#' order, filter
#' 
#' @section Explanation of some data fields:
#' \itemize{
#'  \item backfile_dois: Back file records have a publication date older than 
#'  two years ago.
#'  \item current_dois: Current records are anything published in the last 
#'  two years. 
#' }
#' @references
#' <https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md>
#' @examples \dontrun{
#' cr_journals(issn="2167-8359")
#' cr_journals()
#' cr_journals(issn="2167-8359", works=TRUE)
#' cr_journals(issn=c('1803-2427','2326-4225'))
#' cr_journals(query="ecology")
#' cr_journals(issn="2167-8359", query='ecology', works=TRUE,
#'    sort='score', order="asc")
#' cr_journals(issn="2167-8359", query='ecology', works=TRUE, sort='score',
#'    order="desc")
#' cr_journals(issn="2167-8359", works=TRUE,
#'    filter=c(from_pub_date='2014-03-03'))
#' cr_journals(query="peerj")
#' cr_journals(issn='1803-2427', works=TRUE)
#' cr_journals(issn='1803-2427', works=TRUE, sample=1)
#' cr_journals(limit=2)
#'
#' ## get facets back
#' cr_journals('1803-2427', works=TRUE, facet=TRUE)
#' cr_journals('1803-2427', works=TRUE, facet="published:*", limit = 0)
#' cr_journals(issn=c('1803-2427','2326-4225'), works=TRUE,
#'   facet="published:*", limit = 10)
#'
#' # Use the cursor for deep paging
#' cr_journals(issn='1932-6203', works = TRUE, cursor = "*", cursor_max = 500,
#'    limit = 100)
#' cr_journals(c('1932-6203', '0028-0836'), works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100)
#'
#' # fails, if you want works, you must give an ISSN
#' # cr_journals(query = "ecology", filter=c(has_full_text = TRUE),
#' #    works = TRUE)
#'
#' # Low level function - does no parsing to data.frame, get json or a list
#' cr_journals_(query = 'ecology')
#' cr_journals_("2167-8359")
#' cr_journals_(query = 'ecology', parse=TRUE)
#' cr_journals_("2167-8359", works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100)
#' cr_journals_("2167-8359", works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100, parse = TRUE)
#'
#' # field queries
#' ## query.author
#' cr_journals("2167-8359", works = TRUE, flq = c(`query.author` = 'Jane'))
#' }

`cr_journals` <- function(issn = NULL, query = NULL, filter = NULL,
  offset = NULL, limit = NULL, sample = NULL, sort = NULL, order = NULL,
  facet = FALSE, works=FALSE, cursor = NULL, cursor_max = 5000,
  .progress="none", flq = NULL, email = NULL, ...) {

  if (works) {
    if (is.null(issn)) {
      stop("If `works=TRUE`, you must give a journal ISSN", call. = FALSE)
    }
  }
  args <- prep_args(query, filter, offset, limit, sample,
                    sort, order, facet, cursor, flq)

  if (length(issn) > 1) {
    res <- llply(issn, journal_GET, args = args, email = email, works = works,
                 cursor = cursor, cursor_max = cursor_max, ...,
                 .progress = .progress)
    if (!is.null(cursor)) {
      out <- lapply(res, "[[", "data")
      df <- tbl_df(bind_rows(out))
      facets <- stats::setNames(lapply(res, function(x) parse_facets(x$facets)),
                                issn)
      facets <- if (all(vapply(facets, is.null, logical(1)))) NULL else facets
      list(data = df, facets = facets)
    } else {
      res <- lapply(res, "[[", "message")
      # remove NULLs
      res <- cr_compact(res)
      tmp <- lapply(res, parse_works)
      df <- tbl_df(bind_rows(tmp))
      #exclude rows with empty ISSN value until CrossRef API
      #supports input validation
      if (nrow(df[df$ISSN == "", ]) > 0) {
        warning("only data with valid ISSN returned",  call. = FALSE)
      }
      df <- df[!df$ISSN == "", ]
      facets <- stats::setNames(
        lapply(res, function(x) parse_facets(x$facets)),
        vapply(res, function(z) z[['ISSN']][[1]], "")
      )
      facets <- if (all(vapply(facets, is.null, logical(1)))) NULL else facets
      list(data = df, facets = facets)
    }
  } else {
    tmp <- journal_GET(issn, args, works, cursor, cursor_max, ...)
    if (!is.null(cursor)) {
      tmp
    } else {
      if (!is.null(issn)) {
        if (works) {
          meta <- parse_meta(tmp)
          dat <- tbl_df(bind_rows(lapply(tmp$message$items, parse_works)))
        } else {
          dat <- if (is.null(tmp$message)) NULL else parse_journal(tmp$message)
        }
        list(meta = NULL, data = dat, facets = parse_facets(tmp$message$facets))
      } else {
        fxn <- if (works) parse_works else parse_journal
        meta <- parse_meta(tmp)
        list(
          meta = meta,
          data = tbl_df(bind_rows(lapply(tmp$message$items, fxn))),
          facets = parse_facets(tmp$message$facets)
        )
      }
    }
  }
}

#' @export
#' @rdname cr_journals
`cr_journals_` <- function(issn = NULL, query = NULL, filter = NULL,
  offset = NULL, limit = NULL, sample = NULL, sort = NULL, order = NULL,
  facet = FALSE, works=FALSE, cursor = NULL, cursor_max = 5000,
  .progress="none", parse=FALSE, flq = NULL, email = NULL, ...) {

  if (works) {
    if (is.null(issn)) {
      stop("If `works=TRUE`, you must give a journal ISSN", call. = FALSE)
    }
  }
  args <- prep_args(query, filter, offset, limit, sample, sort, order,
                    facet, cursor, flq)
  if (length(issn) > 1) {
    llply(issn, journal_GET_, args = args, email = email, works = works,
          cursor = cursor, cursor_max = cursor_max,
          parse = parse, ..., .progress = .progress)
  } else {
    journal_GET_(issn, args, works, cursor, cursor_max, parse, ...)
  }
}

journal_GET <- function(x, args, works, cursor = NULL, cursor_max = NULL, ...){
  path <- if (!is.null(x)) {
    if (works) sprintf("journals/%s/works", x) else sprintf("journals/%s", x)
  } else {
    "journals"
  }

  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, email = email, cursor_max = cursor_max,
                        should_parse = TRUE, ...)
    rr$GETcursor()
    rr$parse()
  } else {
    cr_GET(endpoint = path, args, todf = FALSE, parse = TRUE, ...)
  }
}

journal_GET_ <- function(x, args, works, cursor = NULL, cursor_max = NULL,
                         parse, ...){
  path <- if (!is.null(x)) {
    if (works) sprintf("journals/%s/works", x) else sprintf("journals/%s", x)
  } else {
    "journals"
  }

  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, email = email, cursor_max = cursor_max,
                        should_parse = parse, ...)
    rr$GETcursor()
    rr$cursor_out
  } else {
    cr_GET(endpoint = path, args, todf = FALSE, parse = parse, ...)
  }
}

parse_journal <- function(x) {
  if (!is.null(x$flags)) {
    names(x$flags) <- names2underscore(names(x$flags))
  } else {
    x$flags <- NA
  }
  if (!is.null(x$coverage)) {
    names(x$coverage) <- names2underscore(names(x$coverage))
  } else {
    x$coverage <- NA
  }
  if (!is.null(x$counts)) {
    names(x$counts) <- names2underscore(names(x$counts))
  } else {
    x$counts <- NA
  }
  issn <- if (length(x$ISSN) == 0) NULL else x$ISSN[[1]]
  data.frame(title = x$title, publisher = x$publisher, issn = paste_longer(issn),
             last_status_check_time = convtime(x$`last-status-check-time`),
             x$flags,
             x$coverage,
             x$counts,
             stringsAsFactors = FALSE)
}

paste_longer <- function(w) {
  w <- if (length(w) > 1) paste(w, collapse = ", ") else w[[1]]
  if (is.null(w)) NA else w
}

names2underscore <- function(w) {
  t(sapply(w, function(z) gsub("-", "_", z), USE.NAMES = FALSE))
}
