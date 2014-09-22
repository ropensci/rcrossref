#' @param query Query terms
#' @param filter Filter options. See details.
#' @param offset Number of record to start at, from 1 to infinity.
#' @param limit Number of results to return in the query. Not relavant when searching with specific
#' dois. Default: 20. Max: 1000
#' @param sample (integer) Number of random results to return. when you use the sample parameter, 
#' the rows and offset parameters are ignored.
#' @param sort (character) Field to sort on, one of score, relevance, updated, deposited, indexed, 
#' or published.
#' @param order (character) Sort order, one of 'asc' or 'desc'
#' 
#' @details See \url{bit.ly/1nIjfN5} for more info on the Fundref API service.
#' 
#' See the filters vignette for options for filters.
