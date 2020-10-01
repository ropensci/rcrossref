#' Search CrossRef journals
#'
#' @export
#' @family crossref
#' @param issn (character) One or more ISSN's. Format: XXXX-XXXX.
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
#' https://github.com/CrossRef/rest-api-doc
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
#' ## with optional progress bar
#' cr_journals(issn='1932-6203', works = TRUE, cursor = "*", cursor_max = 90,
#'    limit = 30, .progress = TRUE)
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
#' 
#' # select only certain fields to return
#' res <- cr_journals('2167-8359', works = TRUE, 
#'   select = c('DOI', 'title'))
#' names(res$data)
#' }

`cr_journals` <- function(issn = NULL, query = NULL, filter = NULL,
  offset = NULL, limit = NULL, sample = NULL, sort = NULL, order = NULL,
  facet = FALSE, works=FALSE, cursor = NULL, cursor_max = 5000,
  .progress="none", flq = NULL, select = NULL, ...) {

  if (works) {
    if (is.null(issn)) {
      stop("If `works=TRUE`, you must give a journal ISSN", call. = FALSE)
    }
  }
  args <- prep_args(query, filter, offset, limit, sample,
                    sort, order, facet, cursor, flq, select)

  if (length(issn) > 1) {
    res <- llply(issn, journal_GET, args = args, works = works,
                 cursor = cursor, cursor_max = cursor_max, ...,
                 .progress = .progress)
    if (!is.null(cursor)) {
      out <- lapply(res, "[[", "data")
      df <- tibble::as_tibble(bind_rows(out))
      facets <- stats::setNames(lapply(res, function(x) parse_facets(x$facets)),
                                issn)
      facets <- if (all(vapply(facets, is.null, logical(1)))) NULL else facets
      list(data = df, facets = facets)
    } else {
      res2 <- lapply(res, "[[", "message")
      # remove NULLs
      res2 <- cr_compact(res2)

      if (works) {
        tmp <- lapply(res2, function(z) bind_rows(lapply(z$items, parse_works)))
        df <- tibble::as_tibble(bind_rows(tmp))
      } else {
        dat <- lapply(res2, function(z) if (is.null(z)) NULL else parse_journal(z))
        df <- tibble::as_tibble(bind_rows(dat))
      }
      
      #exclude rows with empty ISSN value until CrossRef API
      #supports input validation
      if (NROW(df[df$issn == "", ]) > 0) {
        warning("only data with valid issn returned",  call. = FALSE)
      }
      df <- df[!df$issn == "", ]

      # facets
      facets <- lapply(res2, function(x) parse_facets(x$facets))
      facets <- if (all(vapply(facets, is.null, logical(1)))) {
        NULL
      } else {
        stats::setNames(facets,
          vapply(res2, function(z) {
            if ("issn" %in% names(z)) z[['issn']][[1]] else z$items[[1]]$issn[[1]]$value
          }, "")
        )
      }
      list(data = df, facets = facets)
    }
  } else {
    tmp <- journal_GET(issn, args, works, cursor, cursor_max,
      .progress = .progress, ...)
    if (!is.null(cursor)) {
      tmp
    } else {
      if (!is.null(issn)) {
        if (works) {
          meta <- parse_meta(tmp)
          dat <- tibble::as_tibble(bind_rows(lapply(tmp$message$items, parse_works)))
        } else {
          dat <- if (is.null(tmp$message)) NULL else parse_journal(tmp$message)
        }
        list(meta = NULL, data = dat, facets = parse_facets(tmp$message$facets))
      } else {
        fxn <- if (works) parse_works else parse_journal
        meta <- parse_meta(tmp)
        list(
          meta = meta,
          data = tibble::as_tibble(bind_rows(lapply(tmp$message$items, fxn))),
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
  .progress="none", parse=FALSE, flq = NULL, select = NULL, ...) {

  if (works) {
    if (is.null(issn)) {
      stop("If `works=TRUE`, you must give a journal ISSN", call. = FALSE)
    }
  }
  args <- prep_args(query, filter, offset, limit, sample, sort, order,
                    facet, cursor, flq, select)
  if (length(issn) > 1) {
    llply(issn, journal_GET_, args = args, works = works,
          cursor = cursor, cursor_max = cursor_max,
          parse = parse, ..., .progress = .progress)
  } else {
    journal_GET_(issn, args, works, cursor, cursor_max, parse, ...)
  }
}

journal_GET <- function(x, args, works, cursor = NULL, cursor_max = NULL,
  .progress, ...) {

  path <- if (!is.null(x)) {
    if (works) sprintf("journals/%s/works", x) else sprintf("journals/%s", x)
  } else {
    "journals"
  }

  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = TRUE, .progress = .progress)
    rr$GETcursor(...)
    rr$parse()
  } else {
    cr_GET(endpoint = path, args, todf = FALSE, parse = TRUE, ...)
  }
}

journal_GET_ <- function(x, args, works, cursor = NULL, cursor_max = NULL,
                         parse, .progress, ...) {
  path <- if (!is.null(x)) {
    if (works) sprintf("journals/%s/works", x) else sprintf("journals/%s", x)
  } else {
    "journals"
  }

  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = parse, .progress = .progress)
    rr$GETcursor(...)
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
