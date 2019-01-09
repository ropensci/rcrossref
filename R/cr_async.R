cr_async <- function(endpoint, args, parse = TRUE, ...) {
  if (length(args) == 0) stop('no arguments passed to async call')
  lengths <- vapply(args, length, 1)
  if (length(lengths[unname(lengths) > 1]) > 1) {
    stop("async: only one parameter can have > 1 value")
  }
  if (!any(unname(lengths) > 1)) {
    stop("async: at least one parameter must be length > 1")
  }
  iter <- args[lengths > 1]
  args[names(iter)] <- NULL

  cli <- crul::AsyncVaried$new(
    .list = make_queries(endpoint, args, iter, ...))
  cli$request()
  cli$status()
  cli$responses()
  txt <- cli$parse()
  if (!parse) return(txt)
  lapply(txt, function(z) {
    dplyr::tbl_df(dplyr::bind_rows(
      lapply(jsonlite::fromJSON(z, simplifyVector = FALSE)$message$items,
        parse_works)
    ))
  })
}

make_queries <- function(endpoint, qr, x, ...) {
  nm <- names(x)
  lapply(x[[1]], function(z) {
    qr <- modifyList(qr, stats::setNames(list(z), nm))
    crul::HttpRequest$new(url = "https://api.crossref.org",
      headers = list(
        `User-Agent` = rcrossref_ua(),
        `X-USER-AGENT` = rcrossref_ua()
      ),
      opts = list(...)
    )$get(endpoint, query = qr)
  })
}
