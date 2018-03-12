cr_async <- function(endpoint, args, ...) {
  if (length(args) == 0) stop('no arguments passed to async call')
  lengths <- vapply(args, length, 1)
  if (length(lengths > 1) > 1) {
    stop("only one parameter can have > 1 value")
  }
  iter <- args[lengths > 1]
  args[names(iter)] <- NULL

  cli <- crul::AsyncVaried$new(.list = make_queries(args, iter, ...))
  cli$request()
  cli$status()
  cli$responses()
  lapply(cli$parse(), function(z) {
    dplyr::tbl_df(dplyr::bind_rows(
      lapply(jsonlite::fromJSON(z, simplifyVector = FALSE)$message$items,
        parse_works)
    ))
  })
}

make_queries <- function(qr, x, ...) {
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
