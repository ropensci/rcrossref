#' ## IEEE
#' link <- "http://ieeexplore.ieee.org/iel5/23/5658062/05604718.pdf?arnumber=5604718"
#' out <- cr_members(263, filter=c(has_full_text = TRUE), works = TRUE)
#' link <- cr_ft_links(out$data$DOI[20], "pdf")
#' res <- cr_ft_text(url = link, type = "pdf")
#' 
#' ### elsevier OA articles
#' #### one license is for open access articles, but none with full text available
#' # cr_works(filter=list(license_url="http://www.elsevier.com/open-access/userlicense/1.0/",
#' #                      has_full_text=TRUE))
