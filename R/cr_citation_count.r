#' Get a citation count via CrossRef OpenURL
#'
#' @export
#'
#' @param doi (character) One or more digital object identifiers. If 
#' `async=FALSE` we do synchronous HTTP requests in an `lapply` call, but 
#' if `async=TRUE`, we do asynchronous HTTP requests.
#' @param url (character) the url for the function (should be left to default)
#' @param key your Crossref OpenURL email address, either enter, or loads
#' from `.Rprofile`. We use a default, so you don't need to pass this.
#' @param async (logical) use async HTTP requests. Default: `FALSE`
#' @param ... Curl options passed on to [crul::HttpClient()]
#'
#' @return a data.frame, with columns `doi` and `count`. The count column 
#' has numeric values that are the citation count for that DOI, or `NA` if 
#' not found or no count available
#' 
#' @details See https://www.crossref.org/labs/openurl/ for more info on this
#' Crossref API service.
#'
#' This number is also known as **cited-by**
#'
#' Note that this number may be out of sync/may not match that that the
#' publisher is showing (if they show it) for the same DOI/article.
#'
#' We've contacted Crossref about this, and they have confirmed this.
#' Unfortunately, we can not do anything about this.
#'
#' I would imagine it's best to use this data instead of from the publishers,
#' and this data you can get programatically :)
#' 
#' @section failure behavior:
#' When a DOI does not exist, we may not get a proper HTTP status code 
#' to throw a proper stop status, so we grep on the text itself, and throw
#' a stop if only one DOI passed and not using async, or warning if more
#' than one DOI passed or if using async.
#'
#' @seealso [cr_search()], [cr_r()]
#' @author Carl Boettiger \email{cboettig@@gmail.com}, 
#' Scott Chamberlain
#' @examples \dontrun{
#' cr_citation_count(doi="10.1371/journal.pone.0042793")
#' cr_citation_count(doi="10.1016/j.fbr.2012.01.001")
#' ## many
#' dois <- c("10.1016/j.fbr.2012.01.001", "10.1371/journal.pone.0042793")
#' cr_citation_count(doi = dois)
#' # DOI not found
#' cr_citation_count(doi="10.1016/j.fbr.2012")
#' 
#' # asyc
#' dois <- c("10.1016/j.fbr.2012.01.001", "10.1371/journal.pone.0042793", 
#'  "10.1016/j.fbr.2012", "10.1109/tsp.2006.874779", "10.1007/bf02231542", 
#'  "10.1007/s00277-016-2782-z", "10.1002/9781118339893.wbeccp020", 
#'  "10.1177/011542659200700105", "10.1002/chin.197444438", 
#'  "10.1002/9781118619599.ch4", "10.1007/s00466-012-0724-8", 
#'  "10.1017/s0376892900029477", "10.1167/16.12.824")
#' res <- cr_citation_count(doi = dois, async = TRUE)
#' ## verbose curl
#' res <- cr_citation_count(doi = dois, async = TRUE, verbose = TRUE)
#' res
#' ## time comparison
#' system.time(cr_citation_count(doi = dois, async = TRUE))
#' system.time(cr_citation_count(doi = dois, async = FALSE))
#' 
#' # from a set of random DOIs
#' cr_citation_count(cr_r(50), async = TRUE)
#' }

cr_citation_count <- function(doi, url = "http://www.crossref.org/openurl/",
	key = "cboettig@ropensci.org", async = FALSE, ...) {

  if (async) {
    cr_cc_async(doi, url, key, ...)
  } else {
    out <- lapply(doi, cr_cc, ur = url, key = key, ...)
    data.frame(doi = doi, count = unlist(out), stringsAsFactors = FALSE)
  }
}

cr_cc <- function(doi, url, key, ...) {
  args <- list(id = paste("doi:", doi, sep = ""), pid = as.character(key),
                 noredirect = as.logical(TRUE))
  cli <- crul::HttpClient$new(
    url = url,
    headers = list(
      `User-Agent` = rcrossref_ua(), `X-USER-AGENT` = rcrossref_ua()
    )
  )
  cite_count <- cli$get(query = args, ...)
  cite_count$raise_for_status()
  txt <- cite_count$parse("UTF-8")
  if (grepl("malformed doi", txt, ignore.case = TRUE)) {
    warning("Malformed DOI: ", doi, call. = FALSE)
    return(NA_integer_)
  }
  ans <- xml2::read_xml(cite_count$parse("UTF-8"))
  if (get_attr(ans, "status") == "unresolved") {
    NA_integer_
  } else {
    as.numeric(get_attr(ans, "fl_count"))
  }
}

get_attr <- function(xml, attr){
  xml2::xml_attr(xml2::xml_find_all(xml, sprintf("//*[@%s]", attr)), attr)
}
