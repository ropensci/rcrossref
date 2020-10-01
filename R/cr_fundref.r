#' Search the CrossRef Fundref API
#'
#' @export
#' @family crossref
#' @param dois Search by a single DOI or many DOIs.
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
#' This function name changing to `cr_funders` in the next version -
#' both work for now
#'
#' @references
#' https://github.com/CrossRef/rest-api-doc
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
#' ## get facets back
#' cr_funders("10.13039/100000001", works=TRUE, facet=TRUE, limit = 0)
#' cr_funders("10.13039/100000001", works=TRUE, facet="license:*", limit = 0)
#' cr_funders('100000001', works = TRUE, cursor = "*", cursor_max = 500,
#'    limit = 100, facet=TRUE)
#'
#' # Curl options
#' cr_funders(dois='10.13039/100000001', verbose = TRUE)
#'
#' # If not found, and > 1 DOI given, those not found dropped
#' cr_funders(dois=c("adfadfaf","asfasf"))
#' cr_funders(dois=c("adfadfaf","asfasf"), works=TRUE)
#' cr_funders(dois=c("10.13039/100000001","asfasf"))
#' cr_funders(dois=c("10.13039/100000001","asfasf"), works=TRUE)
#'
#' # Use the cursor for deep paging
#' cr_funders('100000001', works = TRUE, cursor = "*", cursor_max = 500,
#'    limit = 100)
#' cr_funders(c('100000001', '100000002'), works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100)
#' ## with optional progress bar
#' cr_funders('100000001', works = TRUE, cursor = "*", cursor_max = 500,
#'    limit = 100, .progress = TRUE)
#'
#' # Low level function - does no parsing to data.frame, get json or a list
#' cr_funders_(query = 'nsf')
#' cr_funders_('10.13039/100000001')
#' cr_funders_(query = 'science', parse=TRUE)
#' cr_funders_('10.13039/100000001', works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100)
#' cr_funders_('10.13039/100000001', works = TRUE, cursor = "*",
#'    cursor_max = 300, limit = 100, parse = TRUE)
#'
#' # field queries
#' ## query.container-title
#' cr_funders('10.13039/100000001', works = TRUE,
#'   flq = c(`query.container-title` = 'Ecology'))
#' 
#' # select only certain fields to return
#' res <- cr_funders('10.13039/100000001', works = TRUE, 
#'   select = c('DOI', 'title'))
#' names(res$data)
#' }
`cr_funders` <- function(dois = NULL, query = NULL, filter = NULL,
  offset = NULL, limit = NULL,  sample = NULL, sort = NULL, order = NULL,
  facet=FALSE, works = FALSE, cursor = NULL, cursor_max = 5000,
  .progress="none", flq = NULL, select = NULL, ...) {

  args <- prep_args(query, filter, offset, limit, sample, sort,
                    order, facet, cursor, flq, select)
  if (length(dois) > 1) {
    res <- llply(dois, fundref_GET, args = args, works = works,
                 cursor = cursor, cursor_max = cursor_max, ...,
                 .progress = .progress)
    if (!is.null(cursor)) {
      out <- lapply(res, "[[", "data")
      df <- tibble::as_tibble(bind_rows(out))
      facets <- stats::setNames(lapply(res, function(x) parse_facets(x$facets)),
                                dois)
      facets <- if (all(vapply(facets, is.null, logical(1)))) NULL else facets
      list(data = df, facets = facets)
    } else {
      out <- stats::setNames(lapply(res, "[[", "message"), dois)
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
            df <- tibble::as_tibble(bind_rows(do.call('c', tmp)))
            facets <- stats::setNames(lapply(res, function(x)
              parse_facets(x$facets)), dois)
            facets <- if (all(vapply(facets, is.null, logical(1))))
              NULL else facets
            list(data = df, facets = facets)
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
                       cursor_max = cursor_max, .progress = .progress, ...)
    if (!is.null(cursor)) {
      res
    } else {
      if (is.null(res$message)) {
        list(meta = NA, data = NA)
      } else {
        if (is.null(dois)) {
          list(
            meta = parse_meta(res),
            data = tibble::as_tibble(bind_rows(lapply(res$message$items, parse_fundref))),
            facets = parse_facets(res$message$facets)
          )
        } else {
          if (works) {
            wout <- tibble::as_tibble(bind_rows(lapply(res$message$items, parse_works)))
            meta <- parse_meta(res)
          } else {
            wout <- parse_fund(res$message)
            meta <- NULL
          }
          list(
            meta = meta,
            data = wout,
            facets = parse_facets(res$message$facets)
          )
        }
      }
    }
  }
}

#' @export
#' @rdname cr_funders
`cr_funders_` <- function(dois = NULL, query = NULL, filter = NULL,
  offset = NULL, limit = NULL,  sample = NULL, sort = NULL, order = NULL,
  facet=FALSE, works = FALSE, cursor = NULL, cursor_max = 5000,
  .progress="none", parse=FALSE, flq = NULL, select = NULL, ...) {

  args <- prep_args(query, filter, offset, limit, sample, sort, order,
                    facet, cursor, flq, select)
  if (length(dois) > 1) {
    llply(dois, fundref_GET_, args = args, works = works,
          cursor = cursor, cursor_max = cursor_max, parse = parse, ...,
          .progress = .progress)
  } else {
    fundref_GET_(dois, args = args, works = works, cursor = cursor,
                cursor_max = cursor_max, parse = parse, ...)
  }
}

fundref_GET <- function(x, args, works, cursor = NULL, cursor_max = NULL,
  .progress, ...) {

  path <- if (!is.null(x)) {
    if (works) sprintf("funders/%s/works", x) else sprintf("funders/%s", x)
  } else {
    "funders"
  }

  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = TRUE, .progress = .progress)
    rr$GETcursor(...)
    rr$parse()
  } else {
    cr_GET(path, args, todf = FALSE, ...)
  }
}

fundref_GET_ <- function(x, args, works, cursor = NULL, cursor_max = NULL,
                         parse, .progress, ...) {
  path <- if (!is.null(x)) {
    if (works) sprintf("funders/%s/works", x) else sprintf("funders/%s", x)
  } else {
    "funders"
  }

  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = parse, .progress = .progress)
    rr$GETcursor(...)
    rr$cursor_out
  } else {
    cr_GET(path, args, todf = FALSE, parse = parse, ...)
  }
}

parse_fund <- function(x) {
  if (is.null(x) || all(is.na(x))) {
    NA
  } else {
    desc <- unlist(x$descendants)
    hier <- data.frame(id=names(unlist(x$`hierarchy-names`)),
                       name=unname(unlist(x$`hierarchy-names`)),
                       stringsAsFactors = FALSE)
    df <- data.frame(
      name=x$name, location=x$location, work_count=x$`work-count`,
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
  data.frame(as.list(unlist(lapply(keys, manip, y=zzz))),
             stringsAsFactors = FALSE)
}
