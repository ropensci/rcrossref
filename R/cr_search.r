#' Search the CrossRef Metatdata API.
#'
#' @export
#'
#' @param query Query terms.
#' @param doi Search by a single DOI or many DOIs.
#' @param page Page to return from results.
#' @param rows Number of records to return.
#' @param sort Sort either by "score" or "year".
#' @param year Year to search.
#' @param type Record type, e.g., "Journal Article" or "Journal Issue"
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#'
#' @details See \url{http://search.labs.crossref.org/help/api} for more info on this
#' 		Crossref API service.
#' @seealso \code{\link{cr_r}}, \code{\link{cr_citation}}, \code{\link{cr_search_free}}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples 
#' \donttest{
#' cr_search(query = c("renear", "palmer"))
#' }
#'
#' \dontrun{
#' # limit to 4 results
#' cr_search(query = c("renear", "palmer"), rows = 4)
#'
#' # get more results than standard
#' cr_search(query = c("renear", "palmer"), rows = 40)
#'
#' # sort results by score
#' cr_search(query = c("renear", "palmer"), rows = 10, sort = "score")
#'
#' # sort results by year
#' cr_search(query = c("renear", "palmer"), rows = 10, sort = "year")
#'
#' # get results for a certain year
#' cr_search(query = c("renear", "palmer"), year = 2010)
#'
#' # search by a single DOI
#' cr_search(doi = "10.1890/10-0340.1")
#'
#' # search for many DOI's
#' cr_search(doi = c("10.1890/10-0340.1","10.1016/j.fbr.2012.01.001",
#'                   "10.1111/j.1469-8137.2012.04121.x"))
#'
#' # find all the records of articles from a journal ISBN
#' cr_search(query = "1461-0248", type="Journal Article")
#' 
#' # curl stuff
#' library('httr')
#' cr_search(doi = "10.1890/10-0340.1", config=verbose())
#' cr_search(query = c("renear", "palmer"), rows = 40, config=progress())
#' }

`cr_search` <- function(query=NULL, doi = NULL, page = NULL, rows = NULL, sort = NULL, 
  year = NULL, type = NULL, ...)
{
  url <- "http://search.labs.crossref.org/dois"
  if(!is.null(doi)){ doi <- as.character(doi) } else {doi <- doi}
  if(is.null(doi)){
    cr_search_GET(url, query, page, rows, sort, year, type, ...)
  } else
  {
    ldply(doi, function(z) cr_search_GET(url, x=z, page, rows, sort, year, type, ...))
  }
}

cr_search_GET <- function(url, x, page, rows, sort, year, type, ...){
  args <- cr_compact(list(q=x, page=page, rows=rows, sort=sort, year=year, type=type))
  tt <- GET(url, query=args, ...)
  stop_for_status(tt)
  res <- content(tt, as = "text")
  tmp <- fromJSON(res)
  if(nrow(tmp) == 0) "no results" else tmp
}
