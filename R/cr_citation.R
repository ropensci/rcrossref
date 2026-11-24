#' This function is defunct
#'
#' Use [cr_cn()] to retrieve citations by DOI.
#'
#' @export
#' @rdname cr_citation-defunct
#' @keywords internal
cr_citation <- function(...) { # nocov start
  .Defunct(new = "cr_cn", package = "rcrossref", msg = "Removed - see cr_cn()")
} # nocov end
