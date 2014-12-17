#' Coerce a url to a tdmurl with a specific type
#' 
#' @export
#' @param url A URL.
#' @param type A document type, one of xml, pdf, or plain
#' @examples 
#' as.tdmurl("http://downloads.hindawi.com/journals/bmri/2014/201717.xml", "xml")
#' as.tdmurl("http://downloads.hindawi.com/journals/bmri/2014/201717.pdf", "pdf")
as.tdmurl <- function(url, type) UseMethod("as.tdmurl")

#' @export
#' @rdname as.tdmurl
as.tdmurl.tdmurl <- function(url, type) url

#' @export
#' @rdname as.tdmurl
as.tdmurl.character <- function(url, type) makeurl(check_url(url), type)

#' @export
print.tdmurl <- function(x, ...) {
  cat("<url> ", x[[1]], "\n", sep = "")
}

makeurl <- function(x, y) structure(x, class = "tdmurl", type=y)
check_url <- function(x) if(!grepl("http://", x)) stop("Not a proper url") else x
