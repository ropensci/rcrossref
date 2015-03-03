#' This function is defunct
#'
#' @export
#' @rdname cr_citation-defunct
#' @keywords internal

cr_citation <- function(...) {
  .Defunct(new = "cr_cn", package = "rcrossref", msg = "Removed - see cr_cn()")
}


#' Defunct functions in rcrossref
#' 
#' \itemize{
#'  \item \code{\link{cr_citation}}: Crossref is trying to sunset their OpenURL API, which 
#'  this function uses. So this function is now removed. See the function \code{\link{cr_cn}}, 
#'  which does the same things, but with more functionality, using the new Crossref API.
#' }
#' 
#' The above function will be removed in a future version of this package.
#' 
#' @name rcrossref-defunct
NULL
