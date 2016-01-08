#' R Client for Various CrossRef APIs.
#' 
#' rcrossref interacts with the main Crossref metadata search API at 
#' \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}, the old metadata
#' search API at \url{http://search.labs.crossref.org/}, their DOI Content Negotiation  
#' service at \url{http://www.crosscite.org/cn/}, and the \emph{Text and Data Mining} 
#' project \url{http://tdmsupport.crossref.org/}.
#' 
#' Note that functions that use the OpenURL service are now deprecated, and will be defunct 
#' soon.
#'
#' @importFrom utils modifyList
#' @importFrom methods is as
#' @importFrom stats setNames
#' @importFrom dplyr rbind_all bind_rows tbl_df
#' @importFrom R6 R6Class
#' @importFrom XML xmlParse xpathSApply xmlAttrs
#' @importFrom bibtex read.bib
#' @importFrom httr GET POST stop_for_status content_type_json accept_json content
#' write_disk accept http_status parse_url add_headers
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom plyr rbind.fill llply ldply
#' @name rcrossref-package
#' @aliases rcrossref
#' @docType package
#' @title R Client for Various CrossRef APIs.
#' @keywords package
NULL
