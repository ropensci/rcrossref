#' @param query Query terms
#' @param filter Filter options. See examples for usage examples
#' and \code{\link{filters}} for what filters are available.
#' \code{filter} is available for use with \code{cr_works} and 
#' other \code{crossref} family functions with \code{works=TRUE}
#' @param offset Number of record to start at. Minimum: 1. For
#' \code{\link{cr_works}}, and any function setting \code{works = TRUE},
#' the maximum offset value is 10000. For larger requests use \code{cursor}.
#' @param limit Number of results to return in the query. Not relavant when
#' searching with specific dois. Default: 20. Max: 1000
#' @param sample (integer) Number of random results to return. when you use
#' the sample parameter, the rows and offset parameters are ignored.
#' Ignored unless \code{works=TRUE}. Max: 100
#' @param order (character) Sort order, one of 'asc' or 'desc'
#' @param select (character) One or more field to return (only those fields 
#' are returned)
#' 
#' @note See the "Rate limiting" seciton in [rcrossref] to get 
#' into the "fast lane"
