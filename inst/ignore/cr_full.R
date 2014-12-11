#' Get full text links from a DOI
#' 
#' @importFrom stringr str_extract
#' @keywords internal
#' @param doi A DOI
#' @param type One of xml, plain, pdf, or all 
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' # pdf link
#' cr_full_links(doi = "10.5555/515151", "pdf")
#' 
#' # xml and plain text links
#' out <- cr_works(filter=c(has_full_text = TRUE))
#' dois <- out$data$DOI
#' cr_full_links(dois[2], "xml")
#' cr_full_links(dois[1], "plain")
#' cr_full_links(dois[1], "all")
#' 
#' # No links
#' cr_full_links(doi = cr_r(1), "xml")
#' }

cr_full_links <- function(doi, type='xml', ...)
{
  url <- sprintf("http://dx.doi.org/%s", doi)
  res <- GET(url, hd(), ...)
  stopifnot(res$headers$`content-type` == hd()$httpheader[[1]])
  # linkres <- GET(res$headers$location, hd())
  # stopifnot(res$headers$`content-type` == hd()$httpheader[[1]])
  # tt <- res$headers$location
  tt <- res$headers$link
  if(is.null(tt)) NULL else get_type(x=tt, y=type)
}

cr_full_text <- function(url, ...)
{
  res <- GET(url[[1]])
#   stopifnot(res$headers$`content-type` == hd()$httpheader[[1]])
  tt <- res$headers$link
  if(is.null(tt)) stop("No full text links", call. = FALSE)
  get_type(tt, type)
}

hd <- function(header){
  add_headers(Accept = "application/vnd.crossref.unixsd+xml")
}

get_type <- function(x, y = 'xml') {
  res <- parse_urls(x)
  withtype <- Filter(function(x) any("type" %in% names(x)), res)
  withtype <- setNames(withtype, sapply(withtype, "[[", "type"))
  if(y == "all"){
    lapply(withtype, "[[", "url")
  } else {
    y <- match.arg(y, c('xml','plain','pdf'))
    y <- grep(y, c("text/xml","text/plain","application/xml","application/pdf"), value = TRUE)
    cr_compact(sapply(y, function(r) withtype[[r]]$url))
#     withtype[[y]]$url
  }
}

parse_urls <- function(x) {
  lapply(strsplit(x, ",")[[1]], function(z) {
    zz <- gsub("\\s", "", strsplit(z, ";")[[1]])
    url <- str_extract(zz[1], "http://[\\?=:a-zA-Z\\./0-9-]+")
    other <- sapply(zz[2:length(zz)], function(w) { 
      nn <- gsub('\\"', "", strsplit(w, "=")[[1]])
      setNames(nn[2], nn[1])
    }, USE.NAMES=FALSE)
    as.list(c(url=url, other))
  })
}
