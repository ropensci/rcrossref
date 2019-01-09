#' Search the CrossRef Metadata API.
#' 
#' @export
#' @rdname cr_search-defunct
#' @keywords internal
`cr_search` <- function(...) {
  .Defunct(
    package = "rcrossref", 
    msg = "Removed - see cr_works(), cr_journals(), etc. for similar functionality"
  )
}
