#' Get full text links from a DOI
#' 
#' @export
#' @param doi A DOI
#' @param type One of xml, plain, pdf, or all 
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' @details Note that \code{\link{cr_ft_links}} is not vectorized. 
#' 
#' Note that some links returned will not in fact lead you to full text 
#' content as you would understandbly think and expect. That is, if you 
#' use the \code{filter} parameter with e.g., \code{\link{cr_works}} and 
#' filter to only full text content, some links may actually give back
#' only metadata for an article. Elsevier is perhaps the worst offender, 
#' for one because they have a lot of entries in Crossref TDM, but most
#' of the links that are apparently full text are not in fact full text, 
#' but only metadata. You can get full text if you are part of a subscribing
#' institution to that specific Elsever content, but otherwise, you're SOL.
#' 
#' Note that there are still some bugs in the data returned form CrossRef. 
#' For example, for the publisher eLife, they return a single URL with 
#' content-type application/pdf, but the URL is not for a PDF, but for both
#' XML and PDF, and content-type can be set with that URL as either XML or
#' PDF to get that type. Anyway, expect changes...
#' 
#' @return \code{NULL} if no full text links given; a list of tdmurl objects if
#' links found.
#' 
#' @examples \dontrun{
#' # pdf link
#' cr_ft_links(doi = "10.5555/515151", "pdf")
#' cr_ft_links(doi = "10.5555/515151", "pdf")
#' 
#' # all links
#' cr_ft_links(doi = "10.3897/phytokeys.42.7604", type = "all")
#' 
#' # Get doi first from other fxn, then pass here
#' out <- cr_works(filter=c(has_full_text = TRUE), limit = 50)
#' dois <- out$data$DOI
#' cr_ft_links(dois[2], "xml")
#' cr_ft_links(dois[1], "plain")
#' cr_ft_links(dois[1], "all")
#' 
#' # (most likely) No links
#' cr_ft_links(cr_r(1))
#' cr_ft_links(doi="10.3389/fnagi.2014.00130")
#' }

cr_ft_links <- function(doi, type='xml', ...)
{
  res <- cr_works_links(dois = doi, ...)[[1]]
  if(is.null(res)){
    NULL 
  } else {  
    elife <- if(grepl("elife", res[[1]]$URL)) TRUE else FALSE
    withtype <- if(type=='all') res else Filter(function(x) grepl(type, x$`content-type`), res)
    if(is.null(withtype) || length(withtype) == 0){
      NULL
    } else {
      withtype <- setNames(withtype, sapply(withtype, function(x){
        if(x$`content-type` == "unspecified"){
          "unspecified"
        } else {
          strsplit(x$`content-type`, "/")[[1]][[2]]
        }
      }))
      if(elife)
        withtype <- c(withtype, setNames(list(modifyList(withtype[[1]], list(`content-type` = "application/xml"))), "xml"))
      if(type == "all"){
        lapply(withtype, function(b) makeurl(b$URL, st(b$`content-type`), doi))
      } else {
        y <- match.arg(type, c('xml','plain','pdf','unspecified'))
        makeurl(withtype[[y]]$URL, y, doi)
      }
    }
  }
}

cr_works_links <- function(dois = NULL, ...)
{
  get_links <- function(x) cr_GET(endpoint = sprintf("works/%s", x), list(), FALSE, ...)$message$link
  setNames(lapply(dois, get_links, ...), dois)
}

st <- function(x){
  if(grepl("/", x)) 
    strsplit(x, "/")[[1]][[2]]
  else
    x
}

# cr_ft_links <- function(doi, type='xml', ...)
# {
#   url <- sprintf("http://dx.doi.org/%s", doi)
#   res <- GET(url, hd_turtle(), ...)
#   stopifnot(res$headers$`content-type` == hd_turtle()$httpheader[[1]])
#   tt <- res$headers$link
#   if(is.null(tt)) NULL else get_type(x=tt, y=type, z=doi)
# }

# hd <- function(header){
#   add_headers(Accept = "application/vnd.crossref.unixsd+xml")
# }
# 
# hd_turtle <- function(header){
#   add_headers(Accept = "text/turtle")
# }

# get_type <- function(x, y = 'xml', z) {
#   res <- parse_urls(x)
#   withtype <- Filter(function(x) any("type" %in% names(x)), res)
#   withtype <- setNames(withtype, sapply(withtype, function(x) strsplit(x$type, "/")[[1]][[2]]))
#   if(grepl("elife", res[[1]]$url)) 
#     withtype <- c(withtype, setNames(list(modifyList(withtype[[1]], list(type = "application/xml"))), "xml"))
#   else
#     withtype <- withtype
#   if(y == "all"){
#     lapply(withtype, function(b) makeurl(b$url, st(b$type), z))
#   } else {
#     y <- match.arg(y, c('xml','plain','pdf'))
#     makeurl(cr_compact(sapply(y, function(r) withtype[[r]]$url)), y, z)
#     # y <- grep(y, c("text/xml","text/plain","application/xml","application/pdf"), value = TRUE)
#   }
# }

# parse_urls <- function(x) {
#   lapply(strsplit(x, ",")[[1]], function(z) {
#     zz <- gsub("\\s", "", strsplit(z, ";")[[1]])
#     url <- strextract(zz[1], "http://[\\?=:_&a-zA-Z\\./0-9-]+")
#     other <- sapply(zz[2:length(zz)], function(w) { 
#       nn <- gsub('\\"', "", strsplit(w, "=")[[1]])
#       setNames(nn[2], nn[1])
#     }, USE.NAMES=FALSE)
#     as.list(c(url=url, other))
#   })
# }
