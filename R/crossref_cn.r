#' Search the CrossRef Metatdata API.
#' 
#' @importFrom httr GET add_headers stop_for_status content
#' @importFrom plyr compact
#' @param doi Search by a single DOI or many DOIs.
#' @param header Header.
#' @details See \url{http://www.crosscite.org/cn/} for more info on this 
#'   	Crossref Content Negotiation API service.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' crossref_cn(doi = "10.1126/science.169.3946.635")
#' crossref_cn(doi = "10.1126/science.169.3946.635", header="citeprocjson")
#' crossref_cn(doi = "10.1126/science.169.3946.635", header="ris")
#' crossref_cn(doi = "10.1126/science.169.3946.635", header="formattedtextcitation")
#' crossref_cn(doi = "10.1126/science.169.3946.635", header="formattedtextcitation", style="apa")
#' }
#' @export
crossref_cn <- function(doi = NULL, header="bibtex")
{
  header <- switch(header, 
                   rdfxml = "application/rdf+xml",
                   rdfturtle = "text/turtle",
                   citeprocjson = "application/vnd.citationstyles.csl+json",
                   formattedtextcitation = "text/x-bibliography",
                   ris = "application/x-research-info-systems",
                   bibtex =	"application/x-bibtex",
                   crossrefuixrefxml =	"application/vnd.crossref.unixref+xml",
                   datacitexml =	"application/vnd.datacite.datacite+xml")
  url <- sprintf("http://dx.doi.org/%s", doi)
  args <- compact(list())
  out <- GET(url, query=args, add_headers(Accept = header))
  stop_for_status(out)
  content(out, "text")
}