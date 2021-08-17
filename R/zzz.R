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
                        utils::packageVersion("rcrossref")),
                get_email())
  paste0(versions, collapse = " ")
}

cr_GET <- function(endpoint, args, todf = TRUE, on_error = warning, parse = TRUE,
                   ...) {
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
    on_error(sprintf("%s (%s): %s - %s", res$status_code, err_type(res),
      get_route(res), get_err(res)), call. = FALSE)
    list(message = NULL)
  } else {
    #stopifnot(res$response_headers$`content-type` == "application/json;charset=UTF-8")
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
  } else if (
    (x$response_headers$`content-type` == "application/json;charset=utf-8" ||
    x$response_headers$`content-type` == "application/json") && jsonlite::validate(xx) == TRUE
  ) {
    tmp <- jsonlite::fromJSON(xx, FALSE)
  } else {
    tmp <- xx
  }
  if (inherits(tmp, "list")) {
    if (any(haz_names(tmp$message))) {
      mssg <- tryCatch(tmp$message$description, error = function(e) e)
      if (inherits(mssg, "error")) tmp$message$message else mssg
    } else {
      tmp$message[[1]]$message
    }
  } else {
    if (any(class(tmp) %in% c("HTMLInternalDocument", "xml_document"))) {
      return("Server error - check your query - or api.crossref.org may be experiencing problems")
    } else {
      return(tmp)
    }
  }
}

get_route <- function(x) {
  ff <- crul::url_parse(x$url)
  paste0("/", ff$path)
}

err_type <- function(x) {
  if (x$status_code >= 200 && x$status_code < 300) return("success")
  if (x$status_code >= 300 && x$status_code < 400) return("redirection")
  if (x$status_code >= 400 && x$status_code < 500) return("client error")
  if (x$status_code >= 500) return("server error")
}

# modified from purrr:::rep_along
repp_along <- function(x, y) {
  rep(y, length.out = length(x))
}

# modified from purrr:::has_names
haz_names <- function (x) {
  nms <- names(x)
  if (is.null(nms)) {
    repp_along(x, FALSE)
  } else {
    !(is.na(nms) | nms == "")
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

assert <- function(x, y) {
  if (!is.null(x)) {
    if (!inherits(x, y)) {
      stop(deparse(substitute(x)), " must be of class ",
          paste0(y, collapse = ", "), call. = FALSE)
    }
  }
}

ifnullna <- function(x) {
  if (is.null(x)) NA else x
}

flq_set <- c(
  'query.container-title',
  'query.author',
  'query.editor',
  'query.chair',
  'query.translator',
  'query.contributor',
  'query.bibliographic',
  'query.affiliation'
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
                      order, facet, cursor, flq, select) {
  check_number(limit)
  check_limit(limit)
  check_number(offset)
  check_number(sample)
  filter <- filter_handler(filter)
  flq <- field_query_handler(flq)
  assert(facet, c('logical', 'character'))
  if (inherits(facet, "logical")) {
    facet <- if (facet) star_facet() else NULL
  }
  if (!is.null(select)) {
    stopifnot(inherits(select, "character"))
    select <- paste0(select, collapse = ",")
  }
  cr_compact(
    c(
      list(query = query, filter = filter, offset = offset, rows = limit,
           sample = sample, sort = sort, order = order, facet = facet,
           cursor = cursor, select = select),
      flq
    )
  )
}

`%||%` <- function(x, y) if (is.null(x) || length(x) == 0) y else x


#' Share email with Crossref in `.Renviron`
#'
#' @noRd
get_email <- function() {
  email <- Sys.getenv("crossref_email")
  if (identical(email, "")) {
    NULL
  } else {
    paste0("(mailto:", val_email(email), ")")
  }
}

#' Email checker
#'
#' It implementents the following regex stackoverflow solution
#' http://stackoverflow.com/a/25077140
#'
#' @param email email address (character string)
#'
#' @noRd
val_email <- function(email) {
  if (!grepl(email_regex(), email))
    stop("Email address seems not properly formatted - Please check your .Renviron!",
         call. = FALSE)
  return(email)
}

#' Email regex
#'
#' From \url{http://stackoverflow.com/a/25077140}
#'
#' @noRd
email_regex <-
  function()
    "^[_a-z0-9-]+(\\.[_a-z0-9-]+)*@[a-z0-9-]+(\\.[a-z0-9-]+)*(\\.[a-z]{2,4})$"

chk4pk <- function(x) {
  if (!requireNamespace(x, quietly = TRUE)) {
    stop("Please install ", x, call. = FALSE)
  } else {
    invisible(TRUE)
  }
}

#' Star facet
#'
#' Listing all facets no longer works in new API. Here's the string to request
#' all valid facets.
#' @noRd
star_facet <- function() paste("issn:*",
  "container-title:*",
  "journal-issue:*",
  "link-application:*",
  "affiliation:*",
  "assertion:*",
  "assertion-group:*",
  "orcid:*",
  "update-type:*",
  "funder-name:*",
  "archive:*",
  "category-name:*",
  "relation-type:*",
  "published:*",
  "source:*",
  "type-name:*",
  "publisher-name:*",
  "journal-volume:*",
  "license:*",
  "funder-doi:*", sep = ",")