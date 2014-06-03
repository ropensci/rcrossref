#' Search the CrossRef Fundref API - the funders endpoint
#' 
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @import httr RJSONIO assertthat
#' @export
#' @param dois Search by a single DOI or many DOIs.
#' @template args
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' @examples \dontrun{
#' cr_fundref_funders(query="NSF")
#' cr_fundref_funders(query="NSF", limit=1)
#' cr_fundref_funders(dois='10.13039/100000001')
#' cr_fundref_funders(dois='10.13039/100000001', works=TRUE, limit=2)
#' out <- cr_fundref_funders(dois=c('10.13039/100000001','10.13039/100000015'))
#' out['10.13039/100000001']
#' out[['10.13039/100000001']]
#' 
#' cr_fundref_funders(dois='10.13039/100000001')
#' cr_fundref_funders(dois='10.13039/100000001')
#' 
#' # Curl options
#' library('httr')
#' cr_fundref_funders(dois='10.13039/100000001', config=verbose())
#' }

`cr_fundref_funders` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL, 
  limit = NULL,  sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, ...)
{
  foo <- function(x){
    path <- if(!is.null(x)){
      if(works) sprintf("funders/%s/works", x) else sprintf("funders/%s", x)
    } else { "funders" }
    filter <- filter_handler(filter)
    facet <- if(facet) "t" else NULL
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                            sample = sample, sort = sort, order = order, facet = facet))
    fundref_GET(path, args, ...)
  }

  if(length(dois) > 1){
    res <- lapply(dois, foo)
    res <- lapply(res, "[[", "message")
    names(res) <- dois
    res
  } else { foo(dois)$message }
}


#' Search the CrossRef Fundref API - the members endpoint
#' 
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @export
#' @param member_ids One or more member ids. See examples. ALternatively, you can query for them
#' using the query parameter.
#' @template args
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' @examples \dontrun{
#' cr_fundref_members(member_ids=98)
#' cr_fundref_members(query='hindawi')
#' out <- cr_fundref_members(member_ids=c(10,98))
#' out[['10']]$counts
#' out[['98']]$coverage
#' 
#' # curl options
#' library('httr')
#' cr_fundref_members(member_ids=98, config=verbose())
#' }

`cr_fundref_members` <- function(member_ids = NULL, query = NULL, filter = NULL, offset = NULL, 
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, ...)
{
  foo <- function(x){  
    path <- if(!is.null(x)) sprintf("members/%s", x) else "members"
    filter <- filter_handler(filter)
    facet <- if(facet) "t" else NULL
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                            sample = sample, sort = sort, order = order, facet = facet))
    fundref_GET(path, args, ...)
  }
  
  if(length(member_ids) > 1){
    res <- lapply(member_ids, foo)
    res <- lapply(res, "[[", "message")
    names(res) <- member_ids
    res
  } else { foo(member_ids)$message }
}

#' Search the CrossRef Fundref API - the works endpoint
#' 
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @export
#' @param dois Search by a single DOI or many DOIs.
#' @template args
#' @examples \dontrun{
#' # Works funded by the NSF
#' cr_fundref_works(query="NSF")
#' # Works that include renear but not ontologies
#' cr_fundref_works(query="renear+-ontologies")
#' # Filter
#' cr_fundref_works(query="global state", filter='has-orcid:true', limit=1)
#' # Filter by multiple fields
#' cr_fundref_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'))
#' 
#' # Querying dois
#' cr_fundref_works(dois='10.1063/1.3593378')
#' cr_fundref_works(dois='10.1007/12080.1874-1746')
#' cr_fundref_works(dois=c('10.1007/12080.1874-1746','10.1007/10452.1573-5125',
#'                        '10.1111/(issn)1442-9993'))
#'
#' # Include facetting in results
#' cr_fundref_works(query="NSF", facet=TRUE)
#' ## Get facets only, by setting limit=0
#' cr_fundref_works(query="NSF", facet=TRUE, limit=0)
#' 
#' # Sort results
#' cr_fundref_works(query="ecology", sort='relevance', order="asc")
#' res <- cr_fundref_works(query="ecology", sort='score', order="asc")
#' sapply(res$items, "[[", "score")
#' 
#' # Get a random number of results
#' cr_fundref_works(sample=1)
#' cr_fundref_works(sample=10)
#' }

`cr_fundref_works` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL, 
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, ...)
{
  foo <- function(x){
    path <- if(!is.null(x)) sprintf("works/%s", x) else "works"
    filter <- filter_handler(filter)
    facet <- if(facet) "t" else NULL
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                            sample = sample, sort = sort, order = order, facet = facet))
    fundref_GET(path, args, ...)
  }
  
  if(length(dois) > 1){
    res <- lapply(dois, foo)
    res <- lapply(res, "[[", "message")
    names(res) <- dois
    res
  } else { foo(dois)$message }
}

filter_handler <- function(x){
  if(is.null(x)){ NULL } else{
    nn <- names(x)
    newnn <- gsub("_", "-", nn)
    names(x) <- newnn
    args <- list()
    for(i in seq_along(x)){
      args[[i]] <- paste(names(x[i]), unname(x[i]), sep = ":")
    }
    paste0(args, collapse = ",")
  }
}

#' Check the DOI minting agency on one or more dois
#'
#' @export
#' @param dois (character) One or more article or organization dois.
#' @param ... Named parameters passed on to httr::GET
#' @details See \url{bit.ly/1nIjfN5} for more info on the Fundref API service.
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @examples \dontrun{
#' cr_agency(dois = '10.13039/100000001')
#' res <- cr_agency(dois = c('10.13039/100000001','10.13039/100000015'))
#' res[['10.13039/100000015']]
#' }

`cr_agency` <- function(dois = NULL, ...)
{
  foo <- function(x){
    fundref_GET(endpoint = sprintf("works/%s/agency", x), args=list(), ...)
  }
  if(length(dois) > 1){
    res <- lapply(dois, foo)
    res <- lapply(res, "[[", "message")
    names(res) <- dois
    res
  } else { foo(dois)$message }
}

#' Fundref api internal handler
#' @param url endpoint
#' @param args Query args
#' @param ... curl options
#' @keywords internal
fundref_GET <- function(endpoint, args, ...)
{
  url <- sprintf("http://api.crossref.org/%s", endpoint)
  response <- GET(url, query = args, ...)
  doi <- gsub("works/|/agency", "", endpoint)
  if(!response$status_code < 300){
    warning(sprintf("%s: %s %s", response$status_code, doi, response$headers$statusmessage), call. = FALSE)
    list(message=NA)
  } else {  
    assert_that(response$headers$`content-type` == "application/json;charset=UTF-8")
    res <- content(response, as = "text")
    fromJSON(res, simplifyWithNames = FALSE)
  }
}