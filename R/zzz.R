cr_compact <- function(x) Filter(Negate(is.null), x)

asl <- function(z) {
  # z <- tolower(z)
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

cr_GET <- function(endpoint, args, todf = TRUE, on_error = warning, parse = TRUE, ...) {
  url <- sprintf("http://api.crossref.org/%s", endpoint)
  if (length(args) == 0) {
    res <- GET(url, ...)
  } else {
    res <- GET(url, query = args, ...)
  }
  doi <- gsub("works/|/agency|funders/", "", endpoint)
  if (!res$status_code < 300) {
    on_error(sprintf("%s: %s", res$status_code, get_err(res)), call. = FALSE)
    list(message = NA)
  } else {
    stopifnot(res$headers$`content-type` == "application/json;charset=UTF-8")
    res <- content(res, as = "text")
    if (parse) jsonlite::fromJSON(res, todf) else res
  }
}

get_err <- function(x) {
  tmp <- content(x)
  if (is(tmp, "list")) {
    tmp$message[[1]]$message
  } else {
    if (is(tmp, "HTMLInternalDocument")) {
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
           as(d[[i]], colClasses[i]) ))
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

ifnullna <- function(x) {
  if (is.null(x)) NA else x
}

prep_args <- function(query, filter, offset, limit, sample, sort, order, facet, cursor) {
  check_limit(limit)
  filter <- filter_handler(filter)
  facet <- if (facet) "t" else NULL
  cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                  sample = sample, sort = sort, order = order, facet = facet,
                  cursor = cursor))
  
}
