#' Search the CrossRef Fundref API - the funders endpoint
#'
#' BEWARE: The API will only work for CrossRef DOIs.
#'
#' @import httr RJSONIO assertthat plyr
#' @export
#' @param dois Search by a single DOI or many DOIs.
#' @template args
#' @param works (logical) If TRUE, works returned as well, if not then not.
#' @examples \dontrun{
#' cr_fundref(query="NSF")
#' cr_fundref(query="NSF", limit=1)
#' cr_fundref(dois='10.13039/100000001')
#' cr_fundref(dois='10.13039/100000001', works=TRUE, limit=2)
#' out <- cr_fundref(dois=c('10.13039/100000001','10.13039/100000015'))
#' out['10.13039/100000001']
#' out[['10.13039/100000001']]
#'
#' cr_fundref(dois='10.13039/100000001')
#' cr_fundref(dois='10.13039/100000001')
#'
#' # Curl options
#' library('httr')
#' cr_fundref(dois='10.13039/100000001', config=verbose())
#' }

`cr_fundref` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL,  sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  .progress="none", ...)
{
  foo <- function(x){
    path <- if(!is.null(x)){
      if(works) sprintf("funders/%s/works", x) else sprintf("funders/%s", x)
    } else { "funders" }
    filter <- filter_handler(filter)
    facet <- if(facet) "t" else NULL
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                            sample = sample, sort = sort, order = order, facet = facet))
    cr_GET(path, args, ...)
  }

  if(length(dois) > 1){
    res <- llply(dois, foo, .progress=.progress)
    res <- lapply(res, "[[", "message")
    names(res) <- dois
    res
  } else { foo(dois)$message }
}
