#' Crosscite - citation formatter
#'
#' @export
#' @param dois Search by a single DOI or many DOIs.
#' @param style a CSL style (for text format only). See \code{\link{get_styles}}
#' for options. Default: apa. If there's a style that CrossRef doesn't support you'll get a
#' \code{(500) Internal Server Error}
#' @param locale Language locale. See \code{?Sys.getlocale}
#' @template moreargs
#' @details See \url{http://www.crosscite.org/cn/} for more info on the
#'   	Crossref Content Negotiation API service.
#'
#' This function is now deprecated. It will be removed in the next version
#' of this package. Use \code{\link{cr_cn}} instead.
#'
#' @examples \dontrun{
#' crosscite("10.5284/1011335")
#' crosscite(c('10.5169/SEALS-52668','10.2314/GBV:493109919','10.2314/GBV:493105263',
#'    '10.2314/GBV:487077911','10.2314/GBV:607866403'))
#' }

`crosscite` <- function(dois, style = 'apa', locale = "en-US", .progress = "none", ...) {
  .Deprecated(new = "cr_cn", package = "rcrossref",
              msg = "crosscite is deprecated - will be removed in next version, use cr_cn")
  if(length(dois) > 1) {
    llply(dois, function(z, ...) {
      out = try(ccite(z, style, locale, ...), silent=TRUE)
      if("try-error" %in% class(out)) {
        warning(paste0("Failure in resolving '", z, "'. See error detail in results."))
        out <- list(doi=z, error=out[[1]])
      }
      return(out)
    }, .progress=.progress)
  } else {
    ccite(dois, style, locale, ...)
  }
}

ccite <- function(doi, style, locale, ...) {
  args <- cr_compact(list(doi = doi, style = style, locale = locale))
  res <- GET(ccurl(), query = args, make_rcrossref_ua(), ...)
  stop_for_status(res)
  gsub("\n", "", ct_utf8(res))
}

ccurl <- function() "http://crosscite.org/citeproc/format"
