#' R Client for Various CrossRef APIs.
#' 
#' rcrossref interacts with the main Crossref metadata search API at 
#' \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}, the old metadata
#' search API at \url{http://search.labs.crossref.org/}, the CrossRef OpenURL service 
#' \url{http://www.crossref.org/openurl/}, and their DOI Content Negotiation  service at
#' \url{http://www.crosscite.org/cn/}.
#'
#' @name rcrossref-package
#' @aliases rcrossref
#' @docType package
#' @title R Client for Various CrossRef APIs.
#' @keywords package
NULL

#' Deprecated functions in rcrossref
#' 
#' \itemize{
#'  \item \code{\link{cr_citation}}: Crossref is trying to sunset their OpenURL API, which 
#'  this function uses. So this function will be removed in a future version of this 
#'  package. See the function \code{\link{cr_cn}}, which does the same things, but with
#'  more functionality, using the new Crossref API.
#' }
#' 
#' The above function will be removed in a future version of this package.
#' 
#' @name rcrossref-deprecated
NULL
