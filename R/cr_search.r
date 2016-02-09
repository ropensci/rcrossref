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
#' @examples \dontrun{
#' cr_search(query = c("renear", "palmer"))
#'
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
#' # find all the records of articles from a journal ISBN
#' cr_search(query = "1461-0248", type="Journal Article")
#'
#' # curl stuff
#' library('httr')
#' cr_search(doi = "10.1890/10-0340.1", config=verbose())
#' cr_search(query = c("renear", "palmer"), rows = 40, config=progress())
#' }

`cr_search` <- function(query=NULL, doi=NULL, page=NULL, rows=NULL, sort=NULL,
  year=NULL, type=NULL, ...) {
  
  .Deprecated(package = "rcrossref",
              msg = "cr_search is deprecated, and will be removed in next version, see cr_works et al.")
  #url <- "http://search.labs.crossref.org/dois"
  url <- "http://search.crossref.org/dois"
  if (!is.null(doi)) {
    doi <- as.character(doi)
  }
  if (is.null(doi)) {
    cr_search_GET(url, query, page, rows, sort, year, type, ...)
  } else {
    ldply(doi, function(z) cr_search_GET(url, x = z, page, rows, sort, year, type, ...))
  }
}

cr_search_GET <- function(url, x, page, rows, sort, year, type, ...){
  if (!is.null(x)) {
    if (length(x) > 1) x <- paste0(x, collapse = " ")
  }
  args <- cr_compact(list(q = x, page = page, rows = rows,
                          sort = sort, year = year, type = type))
  tt <- GET(url, query = args, make_rcrossref_ua(), ...)
  stop_for_status(tt)
  res <- ct_utf8(tt)
  tmp <- jsonlite::fromJSON(res)
  if (NROW(tmp) == 0) NULL else col_classes(tmp, c("character","numeric","integer","character","character","character","numeric"))
}

asnum <- function(x){
  tmp <- tryCatch(as.numeric(x), warning = function(w) w)
  if (is(tmp, "simpleWarning")) x else tmp
}
