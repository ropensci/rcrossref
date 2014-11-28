#' Lookup article info via CrossRef with DOI and get a citation count.
#'
#' @importFrom XML xmlParse xpathSApply xmlAttrs
#' @export
#'
#' @param doi digital object identifier for an article in PLoS Journals
#' @param url the PLoS API url for the function (should be left to default)
#' @param key your PLoS API key, either enter, or loads from .Rprofile
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#'
#' @return citation count
#' @details See \url{http://labs.crossref.org/openurl/} for more info on this
#' 		Crossref API service.
#' @seealso \code{\link{cr_search}}, \code{\link{cr_r}}, \code{\link{cr_search_free}}
#' @author Carl Boettiger \email{cboettig@@gmail.com}
#' @examples \donttest{
#' cr_citation_count(doi="10.1371/journal.pone.0042793")
#' cr_citation_count(doi="10.1016/j.fbr.2012.01.001")
#' }

cr_citation_count <- function(doi, url = "http://www.crossref.org/openurl/",
	key = "cboettig@ropensci.org", ...)
{
  ## Assemble a url query such as:
  #http://www.crossref.org/openurl/?id=doi:10.3998/3336451.0009.101&noredirect=true&pid=API_KEY&format=unixref
  args <- list(id = paste("doi:", doi, sep=""), pid = as.character(key),
               noredirect = as.logical(TRUE))
#  args$format=as.character("unixref")
  cite_count <- GET(url, query = args, ...)
  stop_for_status(cite_count)
  cite_count_data <- content(cite_count, as = "text")
  ans <- xmlParse(cite_count_data)
  as.numeric(xpathSApply(ans, "//*[@fl_count]",  function(x) xmlAttrs(x)[["fl_count"]]))
}
