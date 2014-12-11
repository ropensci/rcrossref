#' Get a PMID from a DOI, and vice versa.
#'
#' @export
#' @param x (character) One or more DOIs or PMIDs
#' @param simplify (logical) Whether to simplify result to vector.
#' @param ... Curl args passed on to \code{\link[httr]{GET}}.
#' @references Uses the \url{http://www.pmid2doi.org/} REST API.
#' @examples 
#' \donttest{
#' # get a pmid from a doi
#' doi2pmid("10.1016/0006-2944(75)90147-7")
#' }
#' 
#' \dontrun{
#' # More examples
#' ## dois to pmids
#' doi2pmid("10.1016/0006-2944(75)90147-7", TRUE)
#' doi2pmid(c("10.1016/0006-2944(75)90147-7","10.1186/gb-2008-9-5-r89"))
#' 
#' ## pmids to dois
#' pmid2doi(18507872)
#' pmid2doi(18507872, TRUE)
#' pmid2doi(c(1,2,3))
#' 
#' ## pass in curl options
#' library('httr')
#' pmid2doi(18507872, config=verbose())
#' }
`pmid2doi` <- function(x, simplify = FALSE, ...){
  res <- GET(paste0(pdbase(), "doi"), query = list(pmids = pbr(x)), ...)
  stopifnot(res$headers$`content-type` == "application/json;charset=UTF-8")
  df <- jsonlite::fromJSON(content(res, as = "text"))
  if(!simplify) df else df$doi
}

#' @export
#' @rdname pmid2doi
`doi2pmid` <- function(x, simplify = FALSE, ...){
  res <- GET(paste0(pdbase(), "pmid"), query = list(dois = pbr(sapply(x, function(y) paste0('\"', y, '\"')))), ...)
  stopifnot(res$headers$`content-type` == "application/json;charset=UTF-8")
  df <- jsonlite::fromJSON(content(res, as = "text"))
  if(!simplify) df else df$pmid
}

pdbase <- function() 'http://www.pmid2doi.org/rest/json/batch/'

pbr <- function(x) if(is.null(x)) NULL else sprintf("[%s]", paste0(x, collapse = ","))
