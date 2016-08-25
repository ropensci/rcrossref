#' Get a PMID from a DOI, and vice versa.
#'
#' @export
#' @param x (character) One doi, pmid, or pmcid
#' @param type (character) one of doi, pmid, or pmcid
#' @param ... Curl args passed on to \code{\link[httr]{GET}}.
#' @references Uses the http://www.ncbi.nlm.nih.gov/pmc/tools/id-converter-api/
#' @examples \dontrun{
#' # get a pmid/pmcid from a doi
#' id_converter("10.1038/ng.590")
#' 
#' # pmid to doi/pmcid
#' id_converter("20495566", "pmid")
#' 
#' # pmcid to doi/pmid
#' id_converter("PMC2883744", "pmcid")
#' 
#' # error, wrong type passed for id given
#' # id_converter("PMC2883744", "doi")
#' }
`id_converter` <- function(x, type = "doi", ...){
  args <- list(tool = "my_tool", email = "my_email@example.com", 
               ids = x, idtype = type, format = "json")
  res <- GET(idcon_base(), query = args, ...)
  if (res$status_code > 201) stop(jsonlite::fromJSON(ct_utf8(res))$message, 
                                  call. = FALSE)
  jsonlite::fromJSON(ct_utf8(res))
}

idcon_base <- function() "http://www.ncbi.nlm.nih.gov/pmc/utils/idconv/v1.0"
