cr_compact <- function(x) Filter(Negate(is.null), x)

filter_handler <- function(x){
  if (is.null(x)) { 
    NULL 
  } else {
    nn <- names(x)
    if (any(nn %in% others)) {
      nn <- sapply(nn, function(x) {
        if (x %in% others) {
          switch(x, 
                 license_url = 'license.url',
                 license_version = 'license.version',
                 license_delay = 'license.delay',
                 full_text_version = 'full-text.version',
                 full_text_type = 'full-text.type',
                 award_number = 'award.number',
                 award_funder = 'award.funder')
        } else { 
          x 
        }
      }, USE.NAMES = FALSE)
    }
    newnn <- gsub("_", "-", nn)
    names(x) <- newnn
    x <- sapply(x, asl)
    args <- list()
    for (i in seq_along(x)) {
      args[[i]] <- paste(names(x[i]), unname(x[i]), sep = ":")
    }
    paste0(args, collapse = ",")
  }
}

asl <- function(z) {
  # z <- tolower(z)
  if (is.logical(z) || tolower(z) == "true" || tolower(z) == "false") {
    if (z) {
      return('true')
    } else {
      return('false')
    }
  } else {
    return(z)
  }
}

others <- c('license_url','license_version','license_delay','full_text_version','full_text_type',
            'award_number','award_funder')
filterchoices <- c(
  'has_funder','funder','prefix','member','from_index_date','until_index_date',
  'from_deposit_date','until_deposit_date','from_update_date','until_update_date',
  'from_first_deposit_date','until_first_deposit_date','from_pub_date','until_pub_date',
  'has_license','license_url','license_version','license_delay','has_full_text',
  'full_text_version','full_text_type','public_references','has_references','has_archive',
  'archive','has_orcid','orcid','issn','type','directory','doi','updates','is_update',
  'has_update_policy','container_title','publisher_name','category_name','type_name'
)

cr_GET <- function(endpoint, args, todf=TRUE, ...) {
  url <- sprintf("http://api.crossref.org/%s", endpoint)
  if (length(args) == 0) {
    res <- GET(url, ...)
  } else {
    res <- GET(url, query = args, ...)
  }
  doi <- gsub("works/|/agency|funders/", "", endpoint)
  if (!res$status_code < 300) {
    warning(sprintf("%s: %s", res$status_code, get_err(res)), call. = FALSE)
    list(message =  NA)
  } else {
    stopifnot(res$headers$`content-type` == "application/json;charset=UTF-8")
    res <- content(res, as = "text")
    jsonlite::fromJSON(res, todf)
  }
}

get_err <- function(x) {
  tmp <- content(x)
  if (is(tmp, "list")) {
    tmp$message[[1]]$message
  } else {
    if (is(tmp, "HTMLInternalDocument")) {
      return("Server error - check your query - or api.crossref.org may be experiencing problems")
    } else {
      return(tmp)
    }
  }
}

col_classes <- function(d, colClasses) {
  colClasses <- rep(colClasses, len = length(d))
  d[] <- lapply(seq_along(d), function(i) 
    switch(colClasses[i], 
           numeric = as.numeric(d[[i]]), 
           character = as.character(d[[i]]), 
           Date = as.Date(d[[i]], origin = '1970-01-01'), 
           POSIXct = as.POSIXct(d[[i]], origin = '1970-01-01'), 
           factor = as.factor(d[[i]]),
           as(d[[i]], colClasses[i]) ))
  d
}
