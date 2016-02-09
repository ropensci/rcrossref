#' Lookup article info via CrossRef with DOI and get a citation count.
#'
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
#' @examples \dontrun{
#' cr_citation_count(doi="10.1371/journal.pone.0042793")
#' cr_citation_count(doi="10.1016/j.fbr.2012.01.001")
#' # DOI not found
#' cr_citation_count(doi="10.1016/j.fbr.2012")
#' }

cr_citation_count <- function(doi, url = "http://www.crossref.org/openurl/",
	key = "cboettig@ropensci.org", ...)
{
  ## Assemble a url query such as:
  args <- list(id = paste("doi:", doi, sep = ""), pid = as.character(key),
               noredirect = as.logical(TRUE))
  cite_count <- GET(url, query = args, make_rcrossref_ua(), ...)
  stop_for_status(cite_count)
  ans <- xml2::read_xml(ct_utf8(cite_count))
  if (get_attr(ans, "status") == "unresolved") NA else as.numeric(get_attr(ans, "fl_count"))
}

get_attr <- function(xml, attr){
  xml2::xml_attr(xml2::xml_find_all(xml, sprintf("//*[@%s]", attr)), attr)
}
