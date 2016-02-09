#' R Client for Various CrossRef APIs.
#' 
#' @section Crossref APIs:
#' rcrossref interacts with the main Crossref metadata search API at 
#' \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}, the old metadata
#' search API at \url{http://search.labs.crossref.org/}, their DOI Content Negotiation  
#' service at \url{http://www.crosscite.org/cn/}, and the \emph{Text and Data Mining} 
#' project \url{http://tdmsupport.crossref.org/}.
#' 
#' @section Deprecated and Defunct:
#' See \code{\link{rcrossref-deprecated}} and \code{\link{rcrossref-defunct}} for 
#' details.
#' 
#' @section What am I actually searching?:
#' When you use the \code{cr_*()} functions in this package, you are using the Crossref 
#' search API described at \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}.
#' When you search with query terms, on Crossref servers they are not searching full text, or 
#' even abstracts of articles, but only what is available in the data that is returned to you. 
#' That is, they search article titles, authors, etc. For some discussion on this, see
#' \url{https://github.com/CrossRef/rest-api-doc/issues/101}.
#' 
#' @section Text mining:
#' We provide the ability to do text mining in this package. See functions 
#' \code{\link{cr_ft_links}} and \code{\link{cr_ft_text}}. However, another package
#' \pkg{fulltext} is designed solely for text mining, so try it for serious text 
#' mining. 
#' 
#' @section High and Low Level APIs:
#' For the Crossref search API (the functions \code{\link{cr_funders}}, \code{\link{cr_journals}}, 
#' \code{\link{cr_licenses}}, \code{\link{cr_members}}, \code{\link{cr_prefixes}}, 
#' \code{\link{cr_types}}, \code{\link{cr_works}}), there is a high level API and a low level. 
#' The high level is accessible through those functions just listed (e.g., \code{\link{cr_works}}), 
#' whereas the low level is accessible via the same fxn name with an underscore (e.g., 
#' \code{\link{cr_works_}}). The high level API does data requests, and parses to data.frame's.
#' Since the high level API functions have been around a while, we didn't want to break
#' their behavior, so the low level API functions are separate, and only do the data
#' request, giving back json or a list, with no attempt to parse any further. The 
#' low level API functions will be faster because there's much less parsing, and 
#' therefore less prone to potential errors due to changes in the Crossref API that
#' could cause parsing errors. Note that cursor feature works with both high and low level.
#'
#' @importFrom utils modifyList packageVersion
#' @importFrom methods is as
#' @importFrom stats setNames
#' @importFrom dplyr rbind_all bind_rows tbl_df
#' @importFrom R6 R6Class
#' @importFrom xml2 read_xml xml_attr xml_find_all
#' @importFrom bibtex read.bib
#' @importFrom httr GET POST stop_for_status content_type_json accept_json content
#' write_disk accept http_status parse_url add_headers config user_agent
#' @importFrom jsonlite toJSON fromJSON
#' @importFrom plyr rbind.fill llply ldply
#' @name rcrossref-package
#' @aliases rcrossref
#' @docType package
#' @keywords package
NULL
