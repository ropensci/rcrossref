#' Get full text from a DOI
#'
#' @export
#' @param url (character) A URL.
#' @param type (character) One of xml, plain, pdf, or all
#' @param path (character) Path to store pdfs in. Default: \code{~/.crossref/}
#' @param overwrite (logical) Overwrite file if it exists already? Default: TRUE
#' @param read (logical) If reading a pdf, this toggles whether we extract text from
#' the pdf or simply download. If TRUE, you get the text from the pdf back. If FALSE,
#' you only get back the metadata. Default: TRUE
#' @param verbose (logical) Print progress messages. Default: TRUE
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
#' @details Note that \code{\link{cr_ft_text}},
#' \code{\link{cr_ft_pdf}}, \code{\link{cr_ft_xml}}, \code{\link{cr_ft_plain}}
#' are not vectorized.
#' 
#' Note that some links returned will not in fact lead you to full text 
#' content as you would understandbly think and expect. That is, if you 
#' use the \code{filter} parameter with e.g., \code{\link{cr_works}} and 
#' filter to only full text content, some links may actually give back
#' only metadata for an article. Elsevier is perhaps the worst offender, 
#' for one because they have a lot of entries in Crossref TDM, but most
#' of the links that are apparently full text are not in facct full text, 
#' but only metadata.
#' @examples \dontrun{
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
#' ## You can use cr_ft_xml, cr_ft_plain, and cr_ft_pdf to go directly to that format
#' out <-
#'  cr_works(filter = list(has_full_text = TRUE,
#'    license_url="http://creativecommons.org/licenses/by/3.0/"))
#' (links <- cr_ft_links(out$data$DOI[10], "all"))
#' cr_ft_xml(links)
#' cr_ft_pdf(links)
#' }

cr_ft_text <- function(url, type='xml', path = "~/.crossref", overwrite = TRUE, read=TRUE, verbose=TRUE, ...)
{
  switch( pick_type(type, url),
          xml = getTEXT(get_url(url, 'xml'), type, ...),
          plain = getTEXT(get_url(url, 'xml'), type, ...),
          pdf = getPDF(get_url(url, 'pdf'), path, overwrite, type, read, verbose, ...)
  )
}

get_url <- function(a,b){
  if(is(a, "tdmurl")) a[[1]] else a[[b]]
}

#' @export
#' @rdname cr_ft_text
cr_ft_plain <- function(url, path = "~/.crossref", overwrite = TRUE, read=TRUE, verbose=TRUE, ...)
  getTEXT(url$plain[[1]], "plain", ...)

#' @export
#' @rdname cr_ft_text
cr_ft_xml <- function(url, path = "~/.crossref", overwrite = TRUE, read=TRUE, verbose=TRUE, ...)
  getTEXT(url$xml[[1]], "xml", ...)

#' @export
#' @rdname cr_ft_text
cr_ft_pdf <- function(url, path = "~/.crossref", overwrite = TRUE, read=TRUE, verbose=TRUE, ...)
  getPDF(url$pdf[[1]], path, overwrite, "pdf", read, verbose, ...)

pick_type <- function(x, z){
  x <- match.arg(x, c("xml","plain","pdf"))
  if(length(z) == 1) {
    avail <- attr(z, which="type")
  } else {
    avail <- vapply(z, function(x) attr(x, which="type"), character(1), USE.NAMES = FALSE)
  }
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
