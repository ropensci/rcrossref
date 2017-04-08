#' Get list of styles from github.com/citation-style-language/styles
#' @export
#' @param ... Named parameters passed on to [crul::HttpClient]
#' @examples \dontrun{
#' x <- get_styles()
#' x[1:10]
#' }
get_styles <- function(...) {
  cli <- crul::HttpClient$new(
    url = "https://api.github.com/repos/citation-style-language/styles/commits?per_page=1",
    headers = list(
      `User-Agent` = rcrossref_ua(), `X-USER-AGENT` = rcrossref_ua()
    )
  )
  comm <- cli$get(...)
  commres <- jsonlite::fromJSON(comm$parse("UTF-8"), FALSE)
  sha <- commres[[1]]$sha
  cli2 <- crul::HttpClient$new(
    url = paste0("https://api.github.com/repos/citation-style-language/styles/git/trees/", sha),
    headers = list(
      `User-Agent` = rcrossref_ua(), `X-USER-AGENT` = rcrossref_ua()
    )
  )
  sty <- cli2$get(...)
  res <- jsonlite::fromJSON(sty$parse("UTF-8"), FALSE)
  files <- sapply(res$tree, "[[", "path")
  csls <- grep("\\.csl", files, value = TRUE)
  vapply(csls, function(x) strsplit(x, "\\.csl")[[1]][[1]], "", USE.NAMES = FALSE)
}
