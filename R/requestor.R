Requestor <- R6::R6Class("Requestor",
  public = list(
  path = NA,
  cursor = NA,
  args = list(),
  cursor_max = NA,
  cursor_out = list(),
  should_parse = FALSE,
  progress = FALSE,

  initialize = function(path, args, cursor, cursor_max, should_parse,
    .progress) {

    if (!missing(path)) self$path <- path
    if (!missing(cursor)) self$cursor <- cursor
    if (!missing(args)) self$args <- args
    if (!missing(cursor_max)) self$cursor_max <- cursor_max
    if (!missing(should_parse)) self$should_parse <- should_parse
    if (!missing(.progress)) {
      if (!inherits(.progress, "logical")) .progress <- FALSE
      self$progress <- .progress
    }
  },
  GETcursor = function(...) {
    res <- cr_GET(self$path, self$args, todf = FALSE, 
                  parse = self$should_parse, ...)
    if (self$should_parse) {
      cu <- res$message$`next-cursor`
      tot <- length(res$message$items)
      max_avail <- res$message$`total-results`
    } else {
      js <- jsonlite::fromJSON(res, FALSE)
      cu <- js$message$`next-cursor`
      tot <- length(js$message$items)
      max_avail <- js$message$`total-results`
    }
    self$cursor_out <- list(res)
    totals <- tot
    iter <- 1
    totcount <- totals

    if (self$progress) {
      pb <- utils::txtProgressBar(
        min = 1, 
        max = min(max_avail, self$cursor_max) / 
          self$args$rows %||% res$message$`items-per-page`,
        initial = 1, style = 3)
      on.exit(close(pb))
    }

    while (!is.null(cu) && self$cursor_max > totcount && totcount < max_avail) {
      iter <- iter + 1
      if (self$progress) utils::setTxtProgressBar(pb, iter)
      self$args$cursor <- cu
      res <- cr_GET(endpoint = self$path, self$args, todf = FALSE, 
                    parse = self$should_parse, ...)
      if (self$should_parse) {
        cu <- res$message$`next-cursor`
        tot <- length(res$message$items)
      } else {
        js <- jsonlite::fromJSON(res, FALSE)
        cu <- js$message$`next-cursor`
        tot <- length(js$message$items)
      }
      self$cursor_out[[iter]] <- res
      totals[iter] <- tot
      totcount <- sum(totals)
    }
  },
  parse = function(parse = TRUE) {
    x <- self$cursor_out
    meta <- parse_meta(x[[1]])
    meta$next_cursor <- x[[length(x)]]$message$`next-cursor`
    list(meta = meta,
         data = tibble::as_tibble(bind_rows(lapply(x, function(z) {
           bind_rows(lapply(z$message$items, parse_works))
         }))),
         facets = cr_compact(
           lapply(x, function(z) parse_facets(z$message$facets))
          )
    )
  }
))

empty <- function(l) {
  is_length_zero <- function(z) {
    length(z) == 0
  }
  tmp <- Filter(Negate(is_length_zero), l)
  if (length(tmp) == 1 && inherits(tmp, "list")) {
    tmp[[1]]
  } else {
    tmp
  }
}
