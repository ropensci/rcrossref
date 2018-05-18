cr_cc_async <- function(doi, url, key, ...) {
  cli <- crul::AsyncVaried$new(
    .list = make_cc_queries(url, key, doi, ...))
  cli$request()
  cli$status()
  cli$responses()
  out <- lapply(cli$parse(), function(z) {
    if (grepl("malformed doi", z, ignore.case = TRUE)) {
      warning("Malformed DOI: ", doi, call. = FALSE)
      return(NA_integer_)
    }
    ans <- xml2::read_xml(z)
    if (get_attr(ans, "status") == "unresolved") {
      NA_integer_
    } else {
      as.numeric(get_attr(ans, "fl_count"))
    }
  })
  data.frame(doi = doi, count = unlist(out), stringsAsFactors = FALSE)
}

make_cc_queries <- function(url, key, doi, ...) {
  lapply(doi, function(z) {
    args <- list(id = paste("doi:", z, sep = ""), pid = as.character(key),
                 noredirect = as.logical(TRUE))
    crul::HttpRequest$new(url = url,
      headers = list(
        `User-Agent` = rcrossref_ua(),
        `X-USER-AGENT` = rcrossref_ua()
      ),
      opts = list(...)
    )$get(query = args)
  })
}
