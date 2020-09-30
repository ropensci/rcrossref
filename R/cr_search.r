#' Search the CrossRef Metadata API.
#' 
#' @export
#' @rdname cr_search-defunct
#' @keywords internal
`cr_search` <- function(...) { # nocov start
  .Defunct(
    package = "rcrossref", 
    msg = "Removed - see cr_works(), cr_journals(), etc. for similar functionality"
  )
} # nocov end
