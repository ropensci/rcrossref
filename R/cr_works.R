#' Search CrossRef works (articles)
#'
#' @importFrom dplyr rbind_all 
#' @export
#' 
#' @param dois Search by a single DOI or many DOIs.
#' @template args
#' @template moreargs
#' @param facet (logical) Include facet results.
#' 
#' @details BEWARE: The API will only work for CrossRef DOIs.
#' @references \url{https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md}
#' 
#' @examples \dontrun{
#' # Works funded by the NSF
#' cr_works(query="NSF")
#' 
#' # Works that include renear but not ontologies
#' cr_works(query="renear+-ontologies")
#' 
#' # Filter
#' cr_works(query="global state", filter=c(has_orcid=TRUE), limit=3)
#' # Filter by multiple fields
#' cr_works(filter=c(has_orcid=TRUE, from_pub_date='2004-04-04'))
#' # Only full text articles 
#' cr_works(filter=c(has_full_text = TRUE))
#'
#' # Querying dois
#' cr_works(dois='10.1063/1.3593378')
#' cr_works('10.1371/journal.pone.0033693')
#' cr_works(dois='10.1007/12080.1874-1746')
#' cr_works(dois=c('10.1007/12080.1874-1746','10.1007/10452.1573-5125', '10.1111/(issn)1442-9993'))
#'
#' # Include facetting in results
#' cr_works(query="NSF", facet=TRUE)
#' ## Get facets only, by setting limit=0
#' cr_works(query="NSF", facet=TRUE, limit=0)
#'
#' # Sort results
#' cr_works(query="ecology", sort='relevance', order="asc")
#' res <- cr_works(query="ecology", sort='score', order="asc")
#' res$data$score
#'
#' # Get a random number of results
#' cr_works(sample=1)
#' cr_works(sample=10)
#' 
#' # You can pass in dot separated fields to filter on specific fields
#' cr_works(filter=c(award.number='CBET-0756451', award.funder='10.13039/100000001'))
#' }

`cr_works` <- function(dois = NULL, query = NULL, filter = NULL, offset = NULL,
  limit = NULL, sample = NULL, sort = NULL, order = NULL, facet=FALSE, .progress="none", ...)
{
  foo <- function(x, ...){
    path <- if (!is.null(x)) sprintf("works/%s", x) else "works"
    filter <- filter_handler(filter)
    facet <- if (facet) "t" else NULL
    args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                            sample = sample, sort = sort, order = order, facet = facet))
    cr_GET(endpoint = path, args, todf = FALSE, ...)
  }
  
  if(length(dois) > 1){
    res <- llply(dois, foo, .progress=.progress, ...)
    res <- lapply(res, "[[", "message")
    res <- lapply(res, parse_works)
    df <- rbind_all(res)
    #exclude rows with empty DOI value until CrossRef API supports input validation
    if(nrow(df[df$DOI == "",]) > 0)
     warning("only data with valid CrossRef dois returned",  call. = FALSE)
    df <- df[!df$DOI == "",]
 #  df$dois <- dois
    list(meta=NULL, data=df, facets=NULL)
  } else { 
    tmp <- foo(dois, ...)
    if(is.null(dois)){
      meta <- parse_meta(tmp)
      list(meta=meta, data=rbind_all(lapply(tmp$message$items, parse_works)), facets=parse_facets(tmp$message$facets))
    } else {
      list(meta=NULL, data=parse_works(tmp$message), facets=NULL)
    }
  }
}

parse_meta <- function(x){
  tmp <- x$message[ !names(x$message) %in% c('facets','items') ]
  st <- tmp$query$`search-terms`
  data.frame(total_results=tmp$`total-results`, 
             search_terms=if(is.null(st)) NA else st, 
             start_index=tmp$query$`start-index`, 
             items_per_page=tmp$`items-per-page`,
             stringsAsFactors = FALSE)
}

convtime <- function(x){
  if(is.null(x)){ NA } else {
    tt <- format(x, digits=20)
    tt <- substr(tt, 1, nchar(tt)-3)
    as.Date(as.POSIXct(as.numeric(tt), origin="1970-01-01", tz = "GMT"))
  }
}

parse_facets <- function(x){
  tmp <- lapply(x, function(z) ldply(z$values))
  if(length(tmp) == 0) NULL else tmp
}

parse_works <- function(zzz){
  keys <- c('subtitle','issued','score','prefix','container-title','reference-count','deposited',
            'title','type','DOI','URL','source','publisher','indexed','member','page','ISBN',
            'subject','author','issue','ISSN','volume','license')
  manip <- function(which="issued", y){
    res <- switch(which, 
                  license = list(parse_license(y[[which]])),
                  issued = list(paste0(sprintf("%02d", unlist(y[[which]]$`date-parts`)), collapse = "-")),
                  deposited = list(make_date(y[[which]]$`date-parts`)),
                  indexed = list(make_date(y[[which]]$`date-parts`)),
                  subtitle = list(y[[which]]),
                  score = list(y[[which]]),
                  prefix = list(y[[which]]),
                  `reference-count` = list(y[[which]]),
                  page = list(y[[which]]),
                  type = list(y[[which]]),
                  DOI = list(y[[which]]),
                  URL = list(y[[which]]),
                  source = list(y[[which]]),
                  publisher = list(y[[which]]),
                  member = list(y[[which]]),
                  ISSN = list(paste0(unlist(y[[which]]), collapse = ",")),
                  subject = list(paste0(unlist(y[[which]]), collapse = ",")),
                  title = list(paste0(unlist(y[[which]]), collapse = ",")),
                  `container-title` = list(paste0(unlist(y[[which]]), collapse = ","))
    )
    res <- if(is.null(res) || length(res) == 0) NA else res
    if(length(res[[1]]) > 1){
      names(res[[1]]) <- paste(which, names(res[[1]]), sep = "_")
      as.list(unlist(res))
    } else {
      names(res) <- which
      res
    }
  }
  if(all(is.na(zzz))) NULL else data.frame(as.list(unlist(lapply(keys, manip, y=zzz))), stringsAsFactors = FALSE)
}

parse_license <- function(x){
  if(is.null(x)){
    NULL
  } else {
    date <- make_date(x[[1]]$start$`date-parts`)
    data.frame(date=date, x[[1]][!names(x[[1]]) == "start"], stringsAsFactors = FALSE)
  }
}

make_date <- function(x) paste0(sprintf("%02d", unlist(x)), collapse="-")
