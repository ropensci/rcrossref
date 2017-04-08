#' Deprecated functions in rcrossref
#'
#' None at the moment
#'
#' @name rcrossref-deprecated
NULL

#' Defunct functions in rcrossref
#'
#' These functions are gone, no longer available.
#'
#' \itemize{
#'  \item [cr_citation()]: Crossref is trying to sunset their
#'  OpenURL API, which  this function uses. So this function is now removed.
#'  See the function [cr_cn()], which does the same things, but with
#'  more functionality, using the new Crossref API.
#'  \item [pmid2doi()] and [doi2pmid()]: The API behind
#'  these functions is down for good, see [id_converter()] for
#'  similar functionality.
#'  \item [cr_search()]: The functionality of this function can
#'  be achieved with the new Crossref API. See functions [cr_works()]
#'  et al.
#'  \item [cr_search_free()]: The functionality of this function can
#'  be achieved with the new Crossref API. See functions [cr_works()]
#'  et al.
#'  \item [crosscite()]: The functionality of this function can be
#'  achieved with [cr_cn()]
#'  \item [cr_fundref()]: Crossref changed their name "fundref"
#'  to "funders", so we've changed our function, see [cr_funders()]
#'  \item [cr_ft_text()]: This function and other text mining
#'  functions are incorporated in a new package `crminer`.
#'  \item [cr_ft_links()]: This function and other text mining
#'  functions are incorporated in a new package `crminer`.
#'  \item [cr_ft_pdf()]: This function and other text mining
#'  functions are  incorporated in a new package `crminer`.
#'  \item [cr_ft_plain()]: This function and other text mining
#'  functions are incorporated in a new package `crminer`.
#'  \item [cr_ft_text()]: This function and other text mining
#'  functions are incorporated in a new package `crminer`.
#'  \item [cr_ft_xml()]: This function and other text mining
#'  functions are incorporated in a new package `crminer`.
#'  \item [as.tdmurl()]: This function and other text mining
#'  functions are incorporated in a new package `crminer`.
#'  \item [extract_xpdf()]: This function and other text mining
#'  functions are incorporated in a new package `crminer`.
#' }
#'
#' @name rcrossref-defunct
NULL

#' fundref
#'
#' @export
#' @rdname cr_fundref-defunct
#' @keywords internal
`cr_fundref` <- function(...) {
  .Defunct(
    new = "cr_funders",
    package = "rcrossref",
    msg = "Removed - see cr_funders()"
  )
}
