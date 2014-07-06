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
#' @param facet (logical) Include facet results.
#' @param progress Show a \code{plyr}-style progress bar? Options are "none", "text", "tk", "win, and "time".  See \link[pkg:plyr]{create_progress_bar} for details of each.
#' @param ... Named parameters passed on to httr::GET
#' 
#' @details See \url{bit.ly/1nIjfN5} for more info on the Fundref API service.
#' 
#' See the filters vignette for options for filters.
#' 
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}