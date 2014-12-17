#' Get full text links from a DOI
#' 
#' @keywords internal
#' @param doi A DOI
#' @param type One of xml, plain, pdf, or all 
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' @examples \donttest{
#' # pdf link
#' cr_ft_links(doi = "10.5555/515151", "pdf")
#' 
#' # xml and plain text links
#' out <- cr_works(filter=c(has_full_text = TRUE))
#' dois <- out$data$DOI
#' cr_ft_links(dois[2], "xml")
#' cr_ft_links(dois[1], "plain")
#' cr_ft_links(dois[1], "all")
#' 
#' # No links
#' cr_ft_links(cr_r(1), "xml")
#' 
#' # get full text
#' ## elife
#' out <- cr_members(4374, filter=c(has_full_text = TRUE), works = TRUE)
#' (links <- cr_ft_links(out$data$DOI[10], "all"))
#' ### xml
#' cr_ft_text(links, 'xml')
#' ### pdf
#' cr_ft_text(links, "pdf", read=FALSE)
#' cr_ft_text(links, "pdf")
#' 
#' ## pensoft
#' out <- cr_members(2258, filter=c(has_full_text = TRUE), works = TRUE)
#' (links <- cr_ft_links(out$data$DOI[1], "all"))
#' ### xml
#' cr_ft_text(links, 'xml')
#' ### pdf
#' cr_ft_text(links, "pdf", read=FALSE)
#' cr_ft_text(links, "pdf")
#' 
#' ## hindawi
#' out <- cr_members(98, filter=c(has_full_text = TRUE), works = TRUE)
#' (links <- cr_ft_links(out$data$DOI[1], "all"))
#' ### xml
#' cr_ft_text(links, 'xml')
#' ### pdf
#' cr_ft_text(links, "pdf", read=FALSE)
#' cr_ft_text(links, "pdf")
#' 
#' ## search for works with full text, and with CC-BY 3.0 license
#' ### you can see available licenses with cr_licenses() function
#' out <- 
#'  cr_works(filter = list(has_full_text = TRUE,
#'    license_url="http://creativecommons.org/licenses/by/3.0/"))
#' (links <- cr_ft_links(out$data$DOI[10], "all"))
#' cr_ft_text(links, 'xml')
#' 
#' ## elsevier - they don't actually give full text, ha ha, jokes on us!
#' out <- cr_members(78, filter=c(has_full_text = TRUE), works = TRUE)
#' links <- cr_ft_links(out$data$DOI[1], "all")
#' cr_ft_text(links, 'xml') # notice how this is just metadata
#' 
#' ## You can use cr_xml, cr_plain, and cr_pdf to go directly to that format
#' out <- 
#'  cr_works(filter = list(has_full_text = TRUE,
#'    license_url="http://creativecommons.org/licenses/by/3.0/"))
#' (links <- cr_ft_links(out$data$DOI[10], "all"))
#' cr_xml(links)
#' cr_pdf(links)
#' }

cr_ft_links <- function(doi, type='xml', ...)
{
  url <- sprintf("http://dx.doi.org/%s", doi)
  res <- GET(url, hd_turtle(), ...)
  stopifnot(res$headers$`content-type` == hd_turtle()$httpheader[[1]])
  tt <- res$headers$link
  if(is.null(tt)) NULL else get_type(x=tt, y=type)
}

#' @export
#' @rdname cr_ft_links
cr_ft_text <- function(url, type='xml', path = "~/.crossref", overwrite = TRUE, read=TRUE, verbose=TRUE, ...)
{
  switch( pick_type(type, url),
         xml = getTEXT(url$xml[[1]], type, ...),
         plain = getTEXT(url$plain[[1]], type, ...),
         pdf = getPDF(url$pdf[[1]], path, overwrite, type, read, verbose, ...)
  )
}

#' @export
#' @rdname cr_ft_links
cr_txt <- function(url, path = "~/.crossref", overwrite = TRUE, read=TRUE, verbose=TRUE, ...) 
  getTEXT(url$plain[[1]], "plain", ...)

#' @export
#' @rdname cr_ft_links
cr_xml <- function(url, path = "~/.crossref", overwrite = TRUE, read=TRUE, verbose=TRUE, ...) 
  getTEXT(url$xml[[1]], "xml", ...)

#' @export
#' @rdname cr_ft_links
cr_pdf <- function(url, path = "~/.crossref", overwrite = TRUE, read=TRUE, verbose=TRUE, ...)
  getPDF(url$pdf[[1]], path, overwrite, "pdf", read, verbose, ...)

pick_type <- function(x, z){
  x <- match.arg(x, c("xml","plain","pdf"))
  avail <- vapply(z, function(x) attr(x, which="type"), character(1), USE.NAMES = FALSE)
  if(!x %in% avail) stop("Chosen type value not available in links", call. = FALSE)
  x
}

getTEXT <- function(x, type, ...){
  res <- GET(x, ...)
  switch(type, 
         xml = XML::xmlParse(httr::content(res, as = "text")),
         plain = httr::content(res, as = "text"))
}

getPDF <- function(url, path, overwrite, type, read, verbose, ...) {
  if(!file.exists(path)) dir.create(path, showWarnings = FALSE, recursive = TRUE)
  ff <- if( !grepl(type, basename(url)) ) paste0(basename(url), ".", type) else basename(url)
  filepath <- file.path(path, ff)
  # filepath <- file.path(path, paste0(basename(url), ".", type))
  if(verbose) message("Downloading pdf...")
  res <- GET(url, accept("application/pdf"), write_disk(path = filepath, overwrite = overwrite), ...)
  writepath <- res$request$writer[[1]]
  if(read){
    if(verbose) message("Exracting text from pdf...")
    extract_xpdf(path=writepath, ...)
  } else { 
    writepath
  }
}

hd <- function(header){
  add_headers(Accept = "application/vnd.crossref.unixsd+xml")
}

hd_turtle <- function(header){
  add_headers(Accept = "text/turtle")
}

get_type <- function(x, y = 'xml') {
  res <- parse_urls(x)
  withtype <- Filter(function(x) any("type" %in% names(x)), res)
  withtype <- setNames(withtype, sapply(withtype, function(x) strsplit(x$type, "/")[[1]][[2]]))
  if(grepl("elife", res[[1]]$url)) 
    withtype <- c(withtype, setNames(list(modifyList(withtype[[1]], list(type = "application/xml"))), "xml"))
  else
    withtype <- withtype
  if(y == "all"){
    lapply(withtype, function(b) makeurl(b$url, st(b$type)))
  } else {
    y <- match.arg(y, c('xml','plain','pdf'))
    makeurl(cr_compact(sapply(y, function(r) withtype[[r]]$url)), y)
    # y <- grep(y, c("text/xml","text/plain","application/xml","application/pdf"), value = TRUE)
  }
}

st <- function(x) strsplit(x, "/")[[1]][[2]]

parse_urls <- function(x) {
  lapply(strsplit(x, ",")[[1]], function(z) {
    zz <- gsub("\\s", "", strsplit(z, ";")[[1]])
    url <- strextract(zz[1], "http://[\\?=:_&a-zA-Z\\./0-9-]+")
    other <- sapply(zz[2:length(zz)], function(w) { 
      nn <- gsub('\\"', "", strsplit(w, "=")[[1]])
      setNames(nn[2], nn[1])
    }, USE.NAMES=FALSE)
    as.list(c(url=url, other))
  })
}

# cr_full_text <- function(url, ...)
# {
#   res <- GET(url[[1]])
# #   stopifnot(res$headers$`content-type` == hd()$httpheader[[1]])
#   tt <- res$headers$link
#   if(is.null(tt)) stop("No full text links", call. = FALSE)
#   get_type(tt, type)
# }
