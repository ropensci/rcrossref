#' Get a citation count via CrossRef OpenURL
#'
#' @export
#'
#' @param doi (character) digital object identifier for an article
#' @param url (character) the url for the function (should be left to default)
#' @param key your Crossref OpenURL email address, either enter, or loads
#' from `.Rprofile`. We use a default, so you don't need to pass this.
#' @param ... Curl options passed on to [crul::HttpClient()]
#'
#' @return single numeric value - the citation count, or NA if not found or
#' no count available
#' @details See <http://labs.crossref.org/openurl/> for more info on this
#' Crossref API service.
#'
#' This number is also known as **cited-by**
#'
#' Note that this number may be out of sync/may not match that that the
#' publisher is showing (if they show it) for the same DOI/article.
#'
#' We've contacted Crossref about this, and they have confirmed this.
#' Unfortunately, we can not do anything about this.
#'
#' I would imagine it's best to use this data instead of from the publishers,
#' and this data you can get programatically :)
#'
#' @seealso [cr_search()], [cr_r()]
#' @author Carl Boettiger \email{cboettig@@gmail.com}
#' @examples \dontrun{
#' cr_citation_count(doi="10.1371/journal.pone.0042793")
#' cr_citation_count(doi="10.1016/j.fbr.2012.01.001")
#' # DOI not found
#' cr_citation_count(doi="10.1016/j.fbr.2012")
#' }

cr_citation_count <- function(doi, url = "http://www.crossref.org/openurl/",
	key = "cboettig@ropensci.org", ...) {

  args <- list(id = paste("doi:", doi, sep = ""), pid = as.character(key),
               noredirect = as.logical(TRUE))
  cli <- crul::HttpClient$new(
    url = url,
    headers = list(
      `User-Agent` = rcrossref_ua(), `X-USER-AGENT` = rcrossref_ua()
    )
  )
  cite_count <- cli$get(query = args, ...)
  cite_count$raise_for_status()
  ans <- xml2::read_xml(cite_count$parse("UTF-8"))
  if (get_attr(ans, "status") == "unresolved") {
    NA
  } else {
    as.numeric(get_attr(ans, "fl_count"))
  }
}

get_attr <- function(xml, attr){
  xml2::xml_attr(xml2::xml_find_all(xml, sprintf("//*[@%s]", attr)), attr)
}
