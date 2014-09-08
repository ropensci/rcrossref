#' Search the CrossRef Fundref API - the works endpoint
#'
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @export
#' 
#' @param dois Search by a single DOI or many DOIs.
#' @template args
#' @template moreargs
#' @examples \dontrun{
#' # Works funded by the NSF
#' cr_works(query="NSF")
#' # Works that include renear but not ontologies
#' cr_works(query="renear+-ontologies")
#' # Filter
#' cr_works(query="global state", filter='has-orcid:true', limit=1)
#' # Filter by multiple fields
#' cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'))
#'
#' # Querying dois
#' cr_works(dois='10.1063/1.3593378')
#' cr_works(dois='10.1007/12080.1874-1746')
#' cr_works(dois=c('10.1007/12080.1874-1746','10.1007/10452.1573-5125',
#'                        '10.1111/(issn)1442-9993'))
#'
#' # Include facetting in results
#' cr_works(query="NSF", facet=TRUE)
#' ## Get facets only, by setting limit=0
#' cr_works(query="NSF", facet=TRUE, limit=0)
#'
#' # Sort results
#' cr_works(query="ecology", sort='relevance', order="asc")
#' res <- cr_works(query="ecology", sort='score', order="asc")
#' sapply(res$items, "[[", "score")
#'
#' # Get a random number of results
#' cr_works(sample=1)
#' cr_works(sample=10)
#' }

`cr_works` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, .progress="none", ...)
{
  foo <- function(x){
    path <- if(!is.null(x)) sprintf("works/%s", x) else "works"
    filter <- filter_handler(filter)
    facet <- if(facet) "t" else NULL
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                            sample = sample, sort = sort, order = order, facet = facet))
    cr_GET(endpoint = path, args, ...)
  }
  
  if(length(dois) > 1){
    res <- llply(dois, foo, .progress=.progress)
    res <- lapply(res, "[[", "message")
    names(res) <- dois
    res
  } else { foo(dois)$message }
}
