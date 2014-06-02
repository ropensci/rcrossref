#' Search the CrossRef Fundref API - the funders endpoint
#' 
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @import httr RJSONIO assertthat
#' @export
#' @param funder_dois Search by a single DOI or many DOIs.
#' @param format name of the format.
#' @param style a CSL style (for text format only)
#' @param locale language locale
#' @param ... Named parameters passed on to httr::GET
#' @details See \url{bit.ly/1nIjfN5} for more info on the Fundref API service.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' cr_fundref_funders(query="NSF")
#' cr_fundref_funders(query="NSF", limit=1)
#' cr_fundref_funders(funder_dois='10.13039/100000001')
#' out <- cr_fundref_funders(funder_dois=c('10.13039/100000001','10.13039/100000015'))
#' out['10.13039/100000001']
#' out[['10.13039/100000001']]
#' 
#' # Check the DOI minting agency
#' cr_agency(funder_dois='10.13039/100000001')
#' 
#' cr_fundref_funders(funder_dois='10.13039/100000001')
#' cr_fundref_funders(funder_dois='10.13039/100000001')
#' 
#' # Curl options
#' library('httr')
#' cr_fundref_funders(funder_dois='10.13039/100000001', config=verbose())
#' }

# http://link.aip.org/link/applab/v98/i21/p216101/pdf/CHORUS

# http://api.crossref.org/members/98
# http://api.crossref.org/members?query=hindawi

# http://api.crossref.org/funders?query=NSF
# http://api.crossref.org/funders/10.13039/100000001/works?filter=has-license:true
# http://api.crossref.org/funders/10.13039/100000001/works?filter=has-license:true&rows=0
# http://api.crossref.org/funders/10.13039/100000001/works?offset=20
# http://api.crossref.org/funders/10.13039/100000001/works
# http://api.crossref.org/funders/10.13039/100000001

`cr_fundref_funders` <- function(funder_dois = NULL, query = NULL, filter = NULL, offset = NULL, 
  limit = NULL, works = FALSE, ...)
{
  foo <- function(x){
    path <- if(!is.null(x)){
      if(works) sprintf("funders/%s/works", x) else sprintf("funders/%s", x)
    } else { "funders" }
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit))
    fundref_GET(path, args, ...)
#     response <- GET(url, query = args, ...)
#     
#     assert_that(response$status_code < 300)
#     assert_that(response$headers$`content-type` == "application/json;charset=UTF-8")
#     
#     res <- content(response, as = "text")
#     fromJSON(res, simplifyWithNames = FALSE)
  }

  if(length(funder_dois) > 1){
    res <- lapply(funder_dois, foo)
    names(res) <- funder_dois
    res
  } else { foo(funder_dois) }
}


#' Search the CrossRef Fundref API - the members endpoint
#' 
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @import httr RJSONIO assertthat
#' @export
#' @param dois Search by a single DOI or many DOIs.
#' @param format name of the format.
#' @param style a CSL style (for text format only)
#' @param locale language locale
#' @param ... Named parameters passed on to httr::GET
#' @details See \url{bit.ly/1nIjfN5} for more info on the Fundref API service.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' cr_fundref_members(member_ids='10.13039/100000001')
#' out <- cr_fundref_members(member_ids=c('10.13039/100000001','10.13039/100000015'))
#' out['10.13039/100000001']
#' out[['10.13039/100000001']]
#' }

`cr_fundref_members` <- function(member_ids = NULL, query = NULL, filter = NULL, offset = NULL, 
  limit = NULL, ...)
{
  foo <- function(x){
    url <- "http://api.crossref.org/members"
    
    if(!is.null(x))
      url <- paste(url, "/", x, sep = "")
    
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit))
    response <- GET(url, query = args, ...)
    
    assert_that(response$status_code < 300)
    assert_that(response$headers$`content-type` == "application/json;charset=UTF-8")
    
    res <- content(response, as = "text")
    fromJSON(res, simplifyWithNames = FALSE)
  }
  
  if(length(member_ids) > 1){
    res <- lapply(member_ids, foo)
    names(res) <- member_ids
    res
  } else { foo(member_ids) }
}


#' Search the CrossRef Fundref API - the works endpoint
#' 
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @import httr RJSONIO assertthat
#' @export
#' @param dois Search by a single DOI or many DOIs.
#' @param format name of the format.
#' @param style a CSL style (for text format only)
#' @param locale language locale
#' @param ... Named parameters passed on to httr::GET
#' @details See \url{bit.ly/1nIjfN5} for more info on the Fundref API service.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' cr_fundref_works(query="NSF")
#' cr_fundref_works(dois='10.13039/100000001')
#' cr_fundref_works(dois='10.13039/100000001')
#' }

`cr_fundref_works` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL, 
  limit = NULL, ...)
{
  foo <- function(x){
    url <- "http://api.crossref.org/works"
    
    if(!is.null(x))
      url <- paste(url, "/", x, sep = "")
    
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit))
    response <- GET(url, query = args, ...)
    
    assert_that(response$status_code < 300)
    assert_that(response$headers$`content-type` == "application/json;charset=UTF-8")
    
    res <- content(response, as = "text")
    fromJSON(res, simplifyWithNames = FALSE)
  }
  
  if(length(dois) > 1){
    res <- lapply(dois, foo)
    names(res) <- dois
    res
  } else { foo(dois) }
}

# http://api.crossref.org/works/10.1063/1.3593378
# http://api.crossref.org/works?filter=has-funder:true&rows=0


#' Check the DOI minting agency
#'
#' @export
#' @param dois (character) One or more article or organization dois.
#' @param ... Named parameters passed on to httr::GET
#' @details See \url{bit.ly/1nIjfN5} for more info on the Fundref API service.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' cr_agency(dois = '10.13039/100000001')
#' cr_agency(dois = c('10.13039/100000001','10.13039/100000015'))
#' }

`cr_agency` <- function(dois = NULL, ...)
{
  foo <- function(x){
    fundref_GET(sprintf("works/%s/agency", x), list(), ...)
  }
  do_call(dois)
#   if(length(dois) > 1){
#     res <- lapply(dois, foo)
#     names(res) <- dois
#     res
#   } else { foo(dois) }
}

#' Fundref api internal handler
#' @param url endpoint
#' @param args Query args
#' @param ... curl options
#' @keywords internal
fundref_GET <- function(endpoint, args, ...){
  url <- sprintf("http://api.crossref.org/%s", endpoint)
  response <- GET(url, query = args, ...)
  assert_that(response$status_code < 300)
  assert_that(response$headers$`content-type` == "application/json;charset=UTF-8")
  res <- content(response, as = "text")
  fromJSON(res, simplifyWithNames = FALSE)
}

do_call <- function(x){  
  if(length(x) > 1){
    res <- lapply(x, foo)
    names(res) <- x
    res
  } else { foo(x) }
}