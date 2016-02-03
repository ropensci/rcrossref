#' Deprecated functions in rcrossref
#' 
#' These functions still work but will be removed (defunct) in the next version.
#' 
#' \itemize{
#'  \item \code{\link{cr_search}}: The functionality of this function can be achieved with
#'  the new Crossref API. See functions \code{\link{cr_works}} et al.
#'  \item \code{\link{cr_search_free}}: The functionality of this function can be achieved with
#'  the new Crossref API. See functions \code{\link{cr_works}} et al.
#'  \item \code{\link{crosscite}}: The functionality of this function can be achieved with
#'  \code{\link{cr_cn}}
#' }
#' 
#' @name rcrossref-deprecated
NULL

#' Defunct functions in rcrossref
#' 
#' These functions are gone, no longer available.
#' 
#' \itemize{
#'  \item \code{\link{cr_citation}}: Crossref is trying to sunset their OpenURL API, which 
#'  this function uses. So this function is now removed. See the function \code{\link{cr_cn}}, 
#'  which does the same things, but with more functionality, using the new Crossref API.
#'  \item \code{\link{pmid2doi}} and \code{\link{doi2pmid}}: The API behind these functions
#'  is down for good, see \code{\link{id_converter}} for similar functionality.
#' }
#' 
#' @name rcrossref-defunct
NULL
