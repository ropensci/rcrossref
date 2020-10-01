#' Search CrossRef works (articles)
#'
#' @export
#' @family crossref
#' @param dois Search by a single DOI or many DOIs.  Note that using this
#' parameter at the same time as the `query`, `limit`, `select` or `flq`
#' parameter will result in an error.
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
#' @param parse (logical) Whether to output json `FALSE` or parse to
#' list `TRUE`. Default: `FALSE`
#' @param async (logical) use async HTTP requests. Default: `FALSE`
#'
#' @section Beware:
#' The API will only work for CrossRef DOIs.
#'
#' @section Functions:
#' \itemize{
#'  \item `cr_works()` - Does data request and parses to data.frame for
#'  easy downstream consumption
#'  \item `cr_works_()` - Does data request, and gives back json (default)
#'  or lists, with no attempt to parse to data.frame's
#' }
#'
#' @section Explanation of some data fields:
#' \itemize{
#'  \item score: a term frequency, inverse document frequency score that
#'  comes from the Crossref Solr backend, based on bibliographic metadata
#'  fields title, publication title, authors, ISSN, publisher, and
#'  date of publication.
#' }
#'
#' @references
#' https://github.com/CrossRef/rest-api-doc
#'
#' @examples \dontrun{
#' # Works funded by the NSF
#' cr_works(query="NSF")
#'
#' # Works that include renear but not ontologies
#' cr_works(query="renear+-ontologies")
#'
#' # Filter
#' cr_works(query="global state", filter=c(has_orcid=TRUE), limit=3)
#' # Filter by multiple fields
#' cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'))
#' # Only full text articles
#' cr_works(filter=c(has_full_text = TRUE))
#' # has affilitation data
#' cr_works(filter=c(has_affiliation = TRUE))
#' # has abstract
#' cr_works(filter=c(has_abstract = TRUE))
#' # has clinical trial number
#' cr_works(filter=c(has_clinical_trial_number = TRUE))
#'
#' # Querying dois
#' cr_works(dois='10.1063/1.3593378')
#' cr_works('10.1371/journal.pone.0033693')
#' cr_works(dois='10.1007/12080.1874-1746')
#' cr_works(dois=c('10.1007/12080.1874-1746','10.1007/10452.1573-5125',
#'    '10.1111/(issn)1442-9993'))
#'
#' # progress bar
#' cr_works(dois=c('10.1007/12080.1874-1746','10.1007/10452.1573-5125'),
#'    .progress="text")
#'
#' # Include facetting in results
#' cr_works(query="NSF", facet=TRUE)
#' ## Get facets only, by setting limit=0
#' cr_works(query="NSF", facet=TRUE, limit=0)
#' ## you can also set facet to a query
#' cr_works(facet = "license:*", limit=0)
#'
#' # Sort results
#' cr_works(query="ecology", sort='relevance', order="asc")
#' res <- cr_works(query="ecology", sort='score', order="asc")
#' res$data$score
#' cr_works(query="ecology", sort='published')
#' x=cr_works(query="ecology", sort='published-print')
#' x=cr_works(query="ecology", sort='published-online')
#'
#' # Get a random number of results
#' cr_works(sample=1)
#' cr_works(sample=10)
#'
#' # You can pass in dot separated fields to filter on specific fields
#' cr_works(filter=c(award.number='CBET-0756451',
#'    award.funder='10.13039/100000001'))
#'
#' # Use the cursor for deep paging
#' cr_works(query="NSF", cursor = "*", cursor_max = 300, limit = 100)
#' cr_works(query="NSF", cursor = "*", cursor_max = 300, limit = 100,
#'    facet = TRUE)
#' ## with optional progress bar
#' x <- cr_works(query="NSF", cursor = "*", cursor_max = 1200, limit = 200, 
#'   .progress = TRUE)
#'
#' # Low level function - does no parsing to data.frame, get json or a list
#' cr_works_(query = "NSF")
#' cr_works_(query = "NSF", parse=TRUE)
#' cr_works_(query="NSF", cursor = "*", cursor_max = 300, limit = 100)
#' cr_works_(query="NSF", cursor = "*", cursor_max = 300, limit = 100,
#'    parse=TRUE)
#'
#' # field queries
#' ## query.author
#' res <- cr_works(query = "ecology", flq = c(query.author = 'Boettiger'))
#'
#' ## query.container-title
#' res <- cr_works(query = "ecology",
#'   flq = c(`query.container-title` = 'Ecology'))
#'
#' ## query.author and query.bibliographic
#' res <- cr_works(query = "ecology",
#'   flq = c(query.author = 'Smith', query.bibliographic = 'cell'))
#'
#' # select only certain fields to return
#' res <- cr_works(query = "NSF", select = c('DOI', 'title'))
#' names(res$data)
#'
#' # asyc
#' queries <- c("ecology", "science", "cellular", "birds", "European",
#'   "bears", "beets", "laughter", "hapiness", "funding")
#' res <- cr_works(query = queries, async = TRUE)
#' res_json <- cr_works_(query = queries, async = TRUE)
#' unname(vapply(res_json, class, ""))
#' jsonlite::fromJSON(res_json[[1]])
#'
#' queries <- c("ecology", "science", "cellular")
#' res <- cr_works(query = queries, async = TRUE, verbose = TRUE)
#' res
#'
#' # time
#' queries <- c("ecology", "science", "cellular", "birds", "European",
#'   "bears", "beets", "laughter", "hapiness", "funding")
#' system.time(cr_works(query = queries, async = TRUE))
#' system.time(lapply(queries, function(z) cr_works(query = z)))
#' }

cr_works <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE,
  cursor = NULL, cursor_max = 5000, .progress="none", flq = NULL,
  select = NULL, async = FALSE, ...) {

  if (cursor_max != as.integer(cursor_max)) {
    stop("cursor_max must be an integer", call. = FALSE)
  }
  args <- prep_args(query, filter, offset, limit, sample, sort, order,
                    facet, cursor, flq, select)

  stopifnot(is.logical(async))
  if (async) {
    return(cr_async("works", c(dois, args), ...))
  }

  if (length(dois) > 1) {
    res <- llply(dois, cr_get_cursor, args = args, cursor = cursor,
                 cursor_max = cursor_max, .progress = .progress, ...)
    res <- lapply(res, "[[", "message")
    res <- lapply(res, parse_works)
    df <- tibble::as_tibble(bind_rows(res))
    #exclude rows with empty DOI value until CrossRef API supports
    #input validation
    if (nrow(df[df$doi == "", ]) > 0) {
      warning("only data with valid CrossRef DOIs returned",  call. = FALSE)
    }
    df <- df[!df$doi == "", ]
    list(meta = NULL, data = df, facets = NULL)
  } else {
    tmp <- cr_get_cursor(dois, args = args, cursor = cursor,
                         cursor_max = cursor_max, .progress, ...)
    if (is.null(dois)) {
      if (!is.null(cursor) || is.null(tmp$message)) {
        tmp
      } else {
        meta <- parse_meta(tmp)
        list(meta = meta,
             data = tibble::as_tibble(bind_rows(lapply(tmp$message$items, parse_works))),
             facets = parse_facets(tmp$message$facets))
      }
    } else {
      list(meta = NULL, data = tibble::as_tibble(parse_works(tmp$message)), facets = NULL)
    }
  }
}

#' @export
#' @rdname cr_works
cr_works_ <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE,
  cursor = NULL, cursor_max = 5000, .progress="none", parse=FALSE,
  flq = NULL, select = NULL, async = FALSE, ...) {

  if (cursor_max != as.integer(cursor_max)) {
    stop("cursor_max must be an integer", call. = FALSE)
  }
  args <- prep_args(query, filter, offset, limit, sample, sort, order,
                    facet, cursor, flq, select)

  stopifnot(is.logical(async))
  if (async) {
    return(cr_async("works", c(dois, args), parse = FALSE, ...))
  }

  if (length(dois) > 1) {
    llply(dois, cr_get_cursor_, args = args, cursor = cursor,
          cursor_max = cursor_max, parse = parse, .progress = .progress, ...)
  } else {
    cr_get_cursor_(dois, args = args, cursor = cursor,
                   cursor_max = cursor_max, parse = parse,
                   .progress = .progress, ...)
  }
}

cr_get_cursor <- function(x, args, cursor, cursor_max, .progress, ...) {
  path <- if (!is.null(x)) sprintf("works/%s", x) else "works"
  if (!is.null(cursor)) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = TRUE, .progress = .progress)
    rr$GETcursor(...)
    rr$parse()
  } else {
    cr_GET(endpoint = path, args, todf = FALSE, ...)
  }
}

cr_get_cursor_ <- function(x, args, cursor, cursor_max, parse, .progress, ...) {
  path <- if (!is.null(x)) sprintf("works/%s", x) else "works"
  if (!is.null(cursor)) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = parse, .progress = .progress)
    rr$GETcursor(...)
    rr$cursor_out
  } else {
    cr_GET(endpoint = path, args, todf = FALSE, parse = parse, ...)
  }
}

parse_meta <- function(x) {
  if (is.null(x$message)) return(data.frame(NULL))
  tmp <- x$message[ !names(x$message) %in% c('facets','items') ]
  st <- tmp$query$`search-terms`
  data.frame(total_results = tmp$`total-results`,
             search_terms = if (is.null(st)) NA else st,
             start_index = tmp$query$`start-index`,
             items_per_page = tmp$`items-per-page`,
             stringsAsFactors = FALSE)
}

convtime <- function(x){
  if (is.null(x)) {
    NA
  } else {
    tt <- format(x, digits = 20)
    tt <- substr(tt, 1, nchar(tt) - 3)
    as.Date(as.POSIXct(as.numeric(tt), origin = "1970-01-01", tz = "GMT"))
  }
}

parse_facets <- function(x){
  tmp <- lapply(x, function(z) ldply(z$values))
  if (length(tmp) == 0) NULL else tmp
}

parse_works <- function(zzz){
  keys <- c('alternative-id','archive','container-title','created',
            'deposited','published-print','published-online','DOI',
            'funder','indexed','ISBN',
            'ISSN','issue','issued','license', 'link','member','page',
            'prefix','publisher', 'score','source',
            'reference-count', 'references-count', 'is-referenced-by-count',
            'subject','subtitle','title', 'type','update-policy','URL',
            'volume','abstract', 'language', 'short-container-title')
  manip <- function(which="issued", y) {
    res <- switch(
      which,
      `alternative-id` = list(paste0(unlist(y[[which]]),
                                     collapse = ",")),
      `archive` = list(y[[which]]),
      `container-title` = list(paste0(unlist(y[[which]]),
                                      collapse = ",")),
      `short-container-title` = list(paste0(unlist(y[[which]]),
                                      collapse = ",")),
      created = list(make_date(y[[which]]$`date-parts`)),
      deposited = list(make_date(y[[which]]$`date-parts`)),
      `published-print` = list(make_date(y[[which]]$`date-parts`)),
      `published-online` = list(make_date(y[[which]]$`date-parts`)),
      DOI = list(y[[which]]),
      indexed = list(make_date(y[[which]]$`date-parts`)),
      ISBN = list(paste0(unlist(y[[which]]), collapse = ",")),
      ISSN = list(paste0(unlist(y[[which]]), collapse = ",")),
      issue = list(y[[which]]),
      issued = list(
        paste0(
          sprintf("%02d",
                  unlist(y[[which]]$`date-parts`)), collapse = "-")
      ),
      member = list(y[[which]]),
      page = list(y[[which]]),
      prefix = list(y[[which]]),
      publisher = list(y[[which]]),
      `reference-count` = list(y[[which]]),
      `references-count` = list(y[[which]]),
      `is-referenced-by-count` = list(y[[which]]),
      `language` = list(y[[which]]),
      score = list(y[[which]]),
      source = list(y[[which]]),
      subject = list(paste0(unlist(y[[which]]), collapse = ",")),
      subtitle = list(y[[which]]),
      title = list(paste0(unlist(y[[which]]), collapse = ",")),
      type = list(y[[which]]),
      `update-policy` = list(y[[which]]),
      URL = list(y[[which]]),
      volume = list(y[[which]]),
      abstract = list(y[[which]])
    )

    res <- if (is.null(res) || length(res) == 0) NA else res
    if (length(res[[1]]) > 1) {
      names(res[[1]]) <- paste(which, names(res[[1]]), sep = "_")
      as.list(unlist(res))
    } else {
      names(res) <- which
      res
    }
  }

  if (is.null(zzz)) {
    NULL
  } else if (all(is.na(zzz))) {
    NULL
  } else {
    tmp <- unlist(lapply(keys, manip, y = zzz))
    out_tmp <- data.frame(
      as.list(Filter(function(x) nchar(x) > 0, tmp)),
      stringsAsFactors = FALSE)
    out_tmp$assertion <- list(parse_todf(zzz$assertion)) %||% NULL
    out_tmp$author <- list(parse_todf(zzz$author)) %||% NULL
    out_tmp$funder <- list(parse_todf(zzz$funder)) %||% NULL
    out_tmp$link <- list(parse_todf(zzz$link)) %||% NULL
    if (!is.null(zzz$`content-domain`)) {
      out_tmp$content_domain <- list(
        data.frame(domain=paste0(unlist(zzz$`content-domain`$domain), collapse=","), 
          crossmark_restriction=unlist(zzz$`content-domain`$`crossmark-restriction`))) %||% NULL
    }
    out_tmp$update_to <- list(tibble::as_tibble(bind_rows(lapply(zzz$`update-to`, parse_update_to)))) %||% NULL
    out_tmp$license <- list(tibble::as_tibble(bind_rows(lapply(zzz$license, parse_license)))) %||% NULL
    out_tmp$`clinical-trial-number` <- list(parse_todf(zzz$`clinical-trial-number`)) %||% NULL
    out_tmp$reference <- list(parse_todf(zzz$reference)) %||% NULL
    out_tmp <- Filter(function(x) length(unlist(x)) > 0, out_tmp)
    names(out_tmp) <- tolower(names(out_tmp))
    return(out_tmp)
  }
}

parse_awards <- function(x) {
  as.list(stats::setNames(
    vapply(x, function(z) paste0(unlist(z$award), collapse = ","), ""),
    vapply(x, "[[", "", "name")
  ))
}

parse_license <- function(x){
  if (is.null(x)) {
    NULL
  } else {
    date <- make_date(x$start$`date-parts`)
    data.frame(date = date, x[!names(x) == "start"],
               stringsAsFactors = FALSE)
  }
}

parse_update_to <- function(x){
  if (is.null(x)) {
    NULL
  } else {
    date <- make_date(x$updated$`date-parts`)
    data.frame(date = date, x[!names(x) == "updated"],
               stringsAsFactors = FALSE)
  }
}

parse_ctn <- function(x){
  if (is.null(x)) {
    NULL
  } else {
    stats::setNames(x[[1]], c('number', 'registry'))
  }
}

parse_todf <- function(x){
  if (is.null(x)) {
    NULL
  } else {
    tibble::as_tibble(bind_rows(lapply(x, function(w) {
      if ("list" %in% vapply(w, class, "")) {
        w <- unlist(w, recursive = FALSE)
        if ("list" %in% vapply(w, class, "")) {
          w <- unlist(w, recursive = FALSE)
        }
      }
      if (length(w) == 0) return(NULL)
      w[sapply(w, function(b) length(b) == 0)] <- NULL
      data.frame(w, stringsAsFactors = FALSE)
    })))
  }
}

make_date <- function(x) paste0(sprintf("%02d", unlist(x)), collapse = "-")
