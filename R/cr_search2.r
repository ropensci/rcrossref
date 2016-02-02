# Search the CrossRef Metatdata API.
#
# @param query Query terms.
# @param doi Search by a single DOI or many DOIs.
# @param page Page to return from results.
# @param rows Number of records to return.
# @param sort Sort either by "score" or "year".
# @param year Year to search.
# @param type Record type, e.g., "Journal Article" or "Journal Issue"
#
# @details See \url{http://search.labs.crossref.org/} for more info on this
#   	Crossref API service.
# @examples \dontrun{
# cr_search2(query = c("renear", "palmer"))
# }

cr_search2 <- function(query, doi = NULL, page = NULL, rows = NULL,
                      sort = NULL, year = NULL, type = NULL)
{
  url = "http://search.labs.crossref.org/dois"

  replacenull <- function(x){
    x[sapply(x, is.null)] <- NA
    x
  }
  if(!is.null(doi)){ doi <- as.character(doi) } else {doi <- doi}
  if(is.null(doi)){
    args <- cr_compact(list(q=query, page=page, rows=rows, sort=sort, year=year, type=type))
    tt <- GET(url, query=args)
    stop_for_status(tt)
    res <- ct_utf8(tt)
    out <- fromJSON(res)
    out2 <- llply(out, replacenull)
    output <- ldply(out2, function(x) as.data.frame(x, stringsAsFactors = FALSE))
    if(nrow(output)==0){"no results"} else{output}
  } else
  {
    doicall <- function(x) {
      args <- cr_compact(list(q=x, page=page, rows=rows, sort=sort, year=year, type=type))
      out <- ct_utf8(GET(url, query=args))
      out2 <- llply(out, replacenull)
      output <- ldply(out2, function(x) as.data.frame(x, stringsAsFactors = FALSE))
      if(nrow(output)==0){"no results"} else{output}
    }
    ldply(doi, doicall)
  }
}
