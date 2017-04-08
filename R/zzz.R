cr_compact <- function(x) Filter(Negate(is.null), x)

asl <- function(z) {
  if (is.logical(z) || tolower(z) == "true" || tolower(z) == "false") {
    if (z) {
      return('true')
    } else {
      return('false')
    }
  } else {
    return(z)
  }
}

rcrossref_ua <- function() {
  versions <- c(paste0("r-curl/", utils::packageVersion("curl")),
                paste0("crul/", utils::packageVersion("crul")),
                sprintf("rOpenSci(rcrossref/%s)", 
                        utils::packageVersion("rcrossref")))
  paste0(versions, collapse = " ")
}

cr_GET <- function(endpoint, args, todf = TRUE, on_error = warning, parse = TRUE, ...) {
  url <- sprintf("https://api.crossref.org/%s", endpoint)
  cli <- crul::HttpClient$new(
    url = url,
    headers = list(
      `User-Agent` = rcrossref_ua(),
      `X-USER-AGENT` = rcrossref_ua()
    )
  )
  if (length(args) == 0) {
    res <- cli$get(...)
  } else {
    res <- cli$get(query = args, ...)
  }
  doi <- gsub("works/|/agency|funders/", "", endpoint)
  if (!res$status_code < 300) {
    on_error(sprintf("%s: %s - (%s)", res$status_code, get_err(res), doi), call. = FALSE)
    list(message = NULL)
  } else {
    stopifnot(res$response_headers$`content-type` == "application/json;charset=UTF-8")
    res <- res$parse("UTF-8")
    if (parse) jsonlite::fromJSON(res, todf) else res
  }
}

get_err <- function(x) {
  xx <- x$parse("UTF-8")
  if (is.null(x$response_headers$`content-type`)) {
    rr <- tryCatch(jsonlite::fromJSON(xx), error = function(e) e)
    if (inherits(rr, "error")) {
      tmp <- xx
    } else {
      tmp <- rr$message$description
    }
  } else if (x$response_headers$`content-type` == "text/plain") {
    tmp <- xx
  } else if (x$response_headers$`content-type` == "text/html") {
    html <- xml2::read_html(xx)
    tmp <- xml2::xml_text(xml2::xml_find_first(html, '//h3[@class="info"]'))
  } else if (x$response_headers$`content-type` == "application/json;charset=UTF-8") {
    tmp <- jsonlite::fromJSON(xx, FALSE)
  } else {
    tmp <- xx
  }
  if (inherits(tmp, "list")) {
    tmp$message[[1]]$message
  } else {
    if (any(class(tmp) %in% c("HTMLInternalDocument", "xml_document"))) {
      return("Server error - check your query - or api.crossref.org may be experiencing problems")
    } else {
      return(tmp)
    }
  }
}

col_classes <- function(d, colClasses) {
  colClasses <- rep(colClasses, len = length(d))
  d[] <- lapply(seq_along(d), function(i)
    switch(colClasses[i],
           numeric = as.numeric(d[[i]]),
           character = as.character(d[[i]]),
           Date = as.Date(d[[i]], origin = '1970-01-01'),
           POSIXct = as.POSIXct(d[[i]], origin = '1970-01-01'),
           factor = as.factor(d[[i]]),
           as(d[[i]], colClasses[i])))
  d
}

check_limit <- function(x) {
  if (!is.null(x)) {
    if (x > 1000) {
      stop("limit parameter must be 1000 or less",
           call. = FALSE)
    }
  }
}

check_number <- function(x) {
  call <- deparse(substitute(x))
  if (!is.null(x)) {
    tt <- tryCatch(as.numeric(x), warning = function(w) w)
    if (inherits(tt, "warning") || !class(x) %in% c('integer', 'numeric')) {
      stop(call, " value illegal, must be an integer", call. = FALSE)
    }
  }
}

ifnullna <- function(x) {
  if (is.null(x)) NA else x
}

flq_set <- c(
  'query.title',
  'query.container-title',
  'query.author',
  'query.editor',
  'query.chair',
  'query.translator',
  'query.contributor'
)

field_query_handler <- function(x) {
  if (is.null(x)) {
    NULL
  } else {
    if (!all(names(x) %in% flq_set)) {
      stop("field query not in acceptable set, see ?cr_works", call. = FALSE)
    }
    as.list(x)
  }
}

prep_args <- function(query, filter, offset, limit, sample, sort, 
                      order, facet, cursor, flq) {
  check_limit(limit)
  check_number(offset)
  check_number(sample)
  filter <- filter_handler(filter)
  flq <- field_query_handler(flq)
  stopifnot(class(facet) %in% c('logical', 'character'))
  if (inherits(facet, "logical")) {
    facet <- if (facet) "t" else NULL
  }
  cr_compact(
    c(
      list(query = query, filter = filter, offset = offset, rows = limit,
           sample = sample, sort = sort, order = order, facet = facet,
           cursor = cursor),
      flq
    )
  )
}

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x
