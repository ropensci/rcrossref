#' Lookup article info via CrossRef with DOI and get a citation.
#'
#' Options to get formatted citations as bibtext or plain text.
#'
#' @export
#'
#' @param doi digital object identifier for an article in PLoS Journals
#' @param title return the title of the paper or not (defaults to FALSE)
#' @param url the PLoS API url for the function (should be left to default)
#' @param key your PLoS API key, either enter, or loads from .Rprofile
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#'
#' @return Metadata from DOI in R's bibentry format.
#' @details See \url{http://labs.crossref.org/openurl/} for more info on this
#' 		Crossref API service.
#' @seealso \code{\link{cr_cn}} does a very similar thing
#' @author Carl Boettiger \email{cboettig@@gmail.com}
#' @examples \donttest{
#' cr_citation(doi="10.1371/journal.pone.0042793")
#' print(cr_citation("10.3998/3336451.0009.101"), style="Bibtex")
#' print(cr_citation("10.3998/3336451.0009.101"), style="text")
#' }

cr_citation <- function(doi, title = FALSE, url = "http://www.crossref.org/openurl/",
	key = "cboettig@gmail.com", ...)
{
  ## Assemble a url query such as:
  #http://www.crossref.org/openurl/?id=doi:10.3998/3336451.0009.101&noredirect=true&pid=API_KEY&format=unixref
  args <- list(id = paste("doi:", doi, sep=""), pid=as.character(key),
                         noredirect=as.logical(TRUE), format=as.character("unixref"))
  tt <- GET(url, query=args, ...)
  stop_for_status(tt)
  res <- content(tt, as = "text")
  ans <- xmlParse(res)
  formatcrossref(ans)
}


#' Convert crossref XML into a bibentry object
#'
#' @importFrom XML xpathSApply xmlValue
#' @param a crossref XML output
#' @return a bibentry format of the output
#' @details internal helper function
#' @keywords internal
formatcrossref <- function(a){
 authors <- person(family=as.list(xpathSApply(a, "//surname", xmlValue)),
                  given=as.list(xpathSApply(a, "//given_name", xmlValue)))
  rref <- bibentry(
        bibtype = "Article",
        title = check_missing(xpathSApply(a, "//titles/title", xmlValue)),
        author = check_missing(authors),
        journal = check_missing(xpathSApply(a, "//full_title", xmlValue)),
        year = check_missing(xpathSApply(a,
          "//journal_article/publication_date/year", xmlValue)[[1]]),
        month =xpathSApply(a,
          "//journal_article/publication_date/month", xmlValue),
        volume = xpathSApply(a, "//journal_volume/volume", xmlValue),
        doi = xpathSApply(a, "//journal_article/doi_data/doi", xmlValue)
#         issn = xpathSApply(a, "//issn[@media_type='print']", xmlValue)
#        url = xpathSApply(a, "//journal_article/doi_data/resource", xmlValue)
        )
 rref
}

# Title, author, journal, & year cannot be missing, so return "NA" if they are
# Avoid errors in bibentry calls when a required field is not specified.
check_missing <- function(x){
 if(length(x)==0)
  out <- "NA"
 else
  out <- x
  out
}
