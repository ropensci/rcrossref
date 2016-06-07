#' Crosswalk
#' 
#' @keywords internal
#' @param member (character) Crossref member ID
#' @param publisher (character) publisher name
#' @param doi A DOi (character)
#' @param url (character)
#' @param pub (list)
#' @param patterns (list)
#' @param included (logical)
#' @details
#' \strong{Methods}
#'   \describe{
#'     \item{\code{get_member()}}{
#'       Get publisher Crossref member ID
#'     }
#'     \item{\code{get_publisher()}}{
#'       Get publisher parsers.
#'     }
#'     \item{\code{make_url()}}{
#'       Make a url
#'     }
#'     \item{\code{publisher_info()}}{
#'       Get publisher info, metadata
#'     }
#'   }
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' # eLife
#' doi <- "10.7554/eLife.07404"
#' x <- Crosswalk$new(doi = doi)
#' x$get_member()
#' x$member
#' x$get_publisher()
#' x$pub
#' x$make_url()
#' x$url
#' x$publisher_info()
#' 
#' # NBER
#' doi <- '10.3386/w17454'
#' x <- Crosswalk$new(doi = doi)
#' x$make_url()
#' x$url
#' 
#' # PLOS
#' doi <- "10.1371/journal.pcbi.1004709"
#' x <- Crosswalk$new(doi = doi)
#' x$make_url()
#' x$url
#' }
Crosswalk <- R6::R6Class(
  "Crosswalk",
  public = list(
    member = NA,
    publisher = NA,
    doi = NA,
    url = NA,
    pub = NULL,
    patterns = NULL,
    included = TRUE,
    
    initialize = function(doi) {
      if (!missing(doi)) self$doi <- doi
      # load pubpatterns
      path <- path.expand("~/github/ropenscilabs/pubpatterns/src")
      files <- list.files(path, full.names = TRUE)
      self$patterns <- lapply(files, jsonlite::fromJSON)
    },
    
    get_member = function() {
      # when offline
      # self$member <- switch(
      #   private$doi_prefix(),
      #   "10.7554" = 4374,
      #   "10.3386" = 1960,
      #   "10.1371" = 340
      # )
      tmp <- suppressWarnings(cr_works(self$doi))
      self$member <- if (!is.null(tmp$data)) as.numeric(basename(tmp$data$member)) else NULL
      return(self$member)
    },
    
    get_publisher = function() {
      if (is.na(self$member)) self$get_member()
      if (self$member %in% private$member_ids()) {
        self$pub <- Filter(function(x) x$crossref_member == self$member, patterns)[[1]]
      } else {
        self$included <- FALSE
      }
    },
    
    make_url = function(type = "xml") {
      if (all(is.null(self$pub))) self$get_publisher()
      if (self$included) self$url <- switch(
        type, 
        xml = if (!is.null(self$pub$urls)) sprintf(self$pub$urls$xml, strextract(self$doi, self$pub$regex)),
        pdf = if (!is.null(self$pub$urls)) sprintf(self$pub$urls$pdf, strextract(self$doi, self$pub$regex))
      )
      #if (self$included) self$url <- x$pub$do_url(x$pub$url, x$pub$get_id(self$doi))
    },

    publisher_info = function() {
      list(
        publisher = self$member,
        doi = self$doi
      )
    }
  ),
  
  private = list(
    member_ids = function() {
      pluck(self$patterns, "crossref_member", 1)
    },
    
    doi_prefix = function() {
      strsplit(self$doi, "/")[[1]][1]
    }
  )
)
