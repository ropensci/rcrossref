makeurl <- function(x, y) structure(x, class = "tdmurl", type=y)
print.tdmurl <- function(x, ...) {
  cat("<url> ", x[[1]], "\n", sep = "")
}

#' Coerce a url to a tdmurl with a specific type
#' 
#' @name as.tdmurl
#' @examples 
#' as.tdmurl("http://downloads.hindawi.com/journals/bmri/2014/201717.xml", "xml")
#' as.tdmurl("http://downloads.hindawi.com/journals/bmri/2014/201717.pdf", "pdf")
as.tdmurl <- function(x, y) UseMethod("as.tdmurl")

#' @export
#' @rdname as.tdmurl
as.tdmurl.tdmurl <- function(x, y) x

#' @export
#' @rdname as.tdmurl
as.tdmurl.character <- function(x, y) makeurl(check_url(x), y)

check_url <- function(x) if(!grepl("http://", x)) stop("Not a proper url") else x
