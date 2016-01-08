#' Search the CrossRef Metatdata for DOIs using free form references.
#'
#' @export
#'
#' @param query Reference query; a character vector of length 1 or greater,
#' 		comma-separated of course.
#' @param url Base url for the Crossref metadata API.
#'
#' @details Have to have at least three terms in each search query.
#' @seealso \code{\link{cr_search}}, \code{\link{cr_r}}, \code{\link{cr_citation}}
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' # search with title, author, year, and journal
#' cr_search_free(query = "Piwowar Sharing Detailed Research Data Is Associated with
#' Increased Citation Rate PLOS one 2007")
#'
#' cr_search_free(query="Renear 2012") # too few words, need at least 3
#'
#' cr_search_free(query=c("Renear 2012","Piwowar sharing data PLOS one")) # multiple queries
#'
#' # Get a DOI and get the citation using cr_search
#' doi <- cr_search_free(query="Piwowar sharing data PLOS one")$doi
#' cr_search(doi = doi)
#'
#' # Queries can be quite complex too
#' cr_search_free("M. Henrion, D. J. Mortlock, D. J. Hand, and A. Gandy, \"A Bayesian
#' approach to star-galaxy classification,\" Monthly Notices of the Royal Astronomical Society,
#' vol. 412, no. 4, pp. 2286-2302, Apr. 2011.")
#'
#' # Lots of queries
#' queries <- c("Piwowar sharing data PLOS one", "Priem Scientometrics 2.0 social web",
#'	"William Gunn A Crosstalk Between Myeloma Cells",
#'  "karthik ram Metapopulation dynamics override local limits")
#' cr_search_free(queries)
#' }

`cr_search_free` <- function(query, url = "http://search.crossref.org/links")
{
	tt <- POST(url, config = c(content_type_json(), accept_json()), body=jsonlite::toJSON(query))
  stop_for_status(tt)
  res <- content(tt, as = "text")
	fromJSON(res)$results
}
