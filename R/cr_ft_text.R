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
#' @param cache (logical) Use cached files or not. All files are written to your machine
#' locally, so this doesn't affect that. This only states whether you want to use
#' cached version so that you don't have to download the file again. The steps of
#' extracting and reading into R still have to be performed when \code{cache=TRUE}.
#' Default: TRUE
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
#' ## pensoft
#' out <- cr_members(2258, filter=c(has_full_text = TRUE), works = TRUE)
#' (links <- cr_ft_links(out$data$DOI[1], "all"))
#' ### xml
#' cr_ft_text(links, 'xml')
#' ### pdf
#' cr_ft_text(links, "pdf", read=FALSE)
#' cr_ft_text(links, "pdf")
#'
#' ### another pensoft e.g.
#' links <- cr_ft_links("10.3897/phytokeys.42.7604", "all")
#' pdf_read <- cr_ft_text(url = links, type = "pdf", read=FALSE, verbose = FALSE)
#' pdf <- cr_ft_text(links, "pdf", verbose = FALSE)
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
#' ## You can use cr_ft_xml, cr_ft_plain, and cr_ft_pdf to go directly to that format
#' licenseurl <- "http://creativecommons.org/licenses/by/3.0/"
#' out <- cr_works(filter = list(has_full_text = TRUE, license_url = licenseurl))
#' (links <- cr_ft_links(out$data$DOI[10], "all"))
#' cr_ft_xml(links)
#' cr_ft_pdf(links)
#'
#' # Caching, for PDFs
#' out <- cr_members(2258, filter=c(has_full_text = TRUE), works = TRUE)
#' (links <- cr_ft_links(out$data$DOI[10], "all"))
#' cr_ft_text(links, type = "pdf", cache=FALSE)
#' system.time( cacheyes <- cr_ft_text(links, type = "pdf", cache=TRUE) )
#' system.time( cacheyes <- cr_ft_text(links, type = "pdf", cache=TRUE) ) # second time is faster
#' system.time( cacheno <- cr_ft_text(links, type = "pdf", cache=FALSE) )
#' identical(cacheyes, cacheno)
#'
#'
#' ###################### Things to stay away from
#' ## elife
#' #### Stay away from eLife for now, they aren't setting content types right, etc.
#'
#' ## elsevier - they don't actually give full text, ha ha, jokes on us!
#' ## requires extra authentication, which we may include later on
#' # out <- cr_members(78, filter=c(has_full_text = TRUE), works = TRUE)
#' # links <- cr_ft_links(out$data$DOI[1], "all")
#' # cr_ft_text(links, 'xml') # notice how this is just metadata
#' ### elsevier articles that are open access
#' #### one license is for open access articles, but none with full text available
#' # cr_works(filter=list(license_url="http://www.elsevier.com/open-access/userlicense/1.0/",
#' #                      has_full_text=TRUE))
#' }

cr_ft_text <- function(url, type='xml', path = "~/.crossref", overwrite = TRUE,
  read=TRUE, verbose=TRUE, cache=TRUE, ...)
{
  switch( pick_type(type, url),
          xml = getTEXT(get_url(url, 'xml'), type, ...),
          plain = getTEXT(get_url(url, 'xml'), type, ...),
          pdf = getPDF(get_url(url, 'pdf'), path, overwrite, type, read, verbose, cache, ...)
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
cr_ft_pdf <- function(url, path = "~/.crossref", overwrite = TRUE, read=TRUE, cache=FALSE, verbose=TRUE, ...)
  getPDF(url$pdf[[1]], path, overwrite, "pdf", read, verbose, cache, ...)

pick_type <- function(x, z){
  x <- match.arg(x, c("xml","plain","pdf"))
  if(length(z) == 1) {
    avail <- attr(z, which="type")
  } else {
    avail <- vapply(z, function(x) attr(x, which="type"), character(1), USE.NAMES = FALSE)
  }
  if(!x %in% avail) stop("Chosen type not available in links", call. = FALSE)
  x
}

getTEXT <- function(x, type, ...){
  res <- GET(x, ...)
  switch(type,
         xml = XML::xmlParse(httr::content(res, as = "text")),
         plain = httr::content(res, as = "text"))
}

getPDF <- function(url, path, overwrite, type, read, verbose, cache=FALSE, ...) {
  if (!file.exists(path)) dir.create(path, showWarnings = FALSE, recursive = TRUE)

  # pensoft special handling
  if ( grepl("pensoft", url[[1]]) ) {
    filepath <- file.path(path, paste0(sub("/", ".", attr(url, "doi")), ".pdf"))
  } else {
    ff <- if ( !grepl(type, basename(url)) ) paste0(basename(url), ".", type) else basename(url)
    filepath <- file.path(path, ff)
  }

  filepath <- path.expand(filepath)
  if (cache && file.exists(filepath)) {
    if ( !file.exists(filepath) ) {
      stop( sprintf("%s not found", filepath), call. = FALSE)
    }
  } else {
    if (verbose) message("Downloading pdf...")
    res <- GET(url, accept("application/pdf"), write_disk(path = filepath, overwrite = overwrite), ...)
    filepath <- res$request$output$path
  }

  if (read) {
    if (verbose) message("Exracting text from pdf...")
    extract_xpdf(path = filepath, ...)
  } else {
    filepath
  }
}
