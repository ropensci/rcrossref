#' Get list of styles from github.com/citation-style-language/styles
#' @export
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' @examples \dontrun{
#' get_styles()[1:5]
#' }

get_styles <- function(...){
  comm <- GET("https://api.github.com/repos/citation-style-language/styles/commits?per_page=1", ...)
  commres <- jsonlite::fromJSON(ct_utf8(comm), FALSE)
  sha <- commres[[1]]$sha
  sty <- GET(sprintf("https://api.github.com/repos/citation-style-language/styles/git/trees/%s", sha))
  res <- jsonlite::fromJSON(ct_utf8(sty), FALSE)
  files <- sapply(res$tree, "[[", "path")
  csls <- grep("\\.csl", files, value = TRUE)
  vapply(csls, function(x) strsplit(x, "\\.csl")[[1]][[1]], "", USE.NAMES = FALSE)
}
