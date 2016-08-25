cr_compact <- function(x) Filter(Negate(is.null), x)

ct_utf8 <- function(x) httr::content(x, as = "text", encoding = "UTF-8")

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

make_rcrossref_ua <- function() {
  c(
    httr::user_agent(rcrossref_ua()),
    httr::add_headers(`X-USER-AGENT` = rcrossref_ua())
  )
}

rcrossref_ua <- function() {
  versions <- c(paste0("r-curl/", utils::packageVersion("curl")),
                paste0("httr/", utils::packageVersion("httr")),
                sprintf("rOpenSci(rcrossref/%s)", utils::packageVersion("rcrossref")))
  paste0(versions, collapse = " ")
}

cr_GET <- function(endpoint, args, todf = TRUE, on_error = warning, parse = TRUE, ...) {
  url <- sprintf("http://api.crossref.org/%s", endpoint)
  if (length(args) == 0) {
    res <- GET(url, make_rcrossref_ua(), ...)
  } else {
    res <- GET(url, query = args, make_rcrossref_ua(), ...)
  }
  doi <- gsub("works/|/agency|funders/", "", endpoint)
  if (!res$status_code < 300) {
    on_error(sprintf("%s: %s - (%s)", res$status_code, get_err(res), doi), call. = FALSE)
    list(message = NULL)
  } else {
    stopifnot(res$headers$`content-type` == "application/json;charset=UTF-8")
    res <- ct_utf8(res)
    if (parse) jsonlite::fromJSON(res, todf) else res
  }
}

get_err <- function(x) {
  xx <- ct_utf8(x)
  if (x$headers$`content-type` == "text/plain") {
    tmp <- xx
  } else if (x$headers$`content-type` == "text/html") {
    html <- xml2::read_html(xx)
    tmp <- xml2::xml_text(xml2::xml_find_one(html, '//h3[@class="info"]'))
  } else if (x$headers$`content-type` == "application/json;charset=UTF-8") {
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

prep_args <- function(query, filter, offset, limit, sample, sort, order, facet, cursor) {
  check_limit(limit)
  check_number(offset)
  check_number(sample)
  filter <- filter_handler(filter)
  facet <- if (facet) "t" else NULL
  cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                  sample = sample, sort = sort, order = order, facet = facet,
                  cursor = cursor))

}
