cr_compact <- function(x) Filter(Negate(is.null), x)

filter_handler <- function(x){
  if(is.null(x)){ NULL } else{
    nn <- names(x)
    newnn <- gsub("_", "-", nn)
    names(x) <- newnn
    args <- list()
    for(i in seq_along(x)){
      args[[i]] <- paste(names(x[i]), unname(x[i]), sep = ":")
    }
    paste0(args, collapse = ",")
  }
}

#' Crossref api internal handler
#' 
#' @param url endpoint
#' @param args Query args
#' @param ... curl options
#' @keywords internal
cr_GET <- function(endpoint, args, todf=TRUE, ...)
{
  url <- sprintf("http://api.crossref.org/%s", endpoint)
  response <- GET(url, query = args, ...)
  doi <- gsub("works/|/agency", "", endpoint)
  if(!response$status_code < 300){
    warning(sprintf("%s: %s %s", response$status_code, doi, response$headers$statusmessage), call. = FALSE)
    list(message=NA)
  } else {
    assert_that(response$headers$`content-type` == "application/json;charset=UTF-8")
    res <- content(response, as = "text")
    jsonlite::fromJSON(res, todf)
  }
}
