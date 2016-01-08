# sacbox::load_defaults(cr_works)
# path="works"
# query="NSF"
# cursor="*"
# limit=100
# cursor_max=500
# (args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit, cursor = cursor)))
# 
# rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max)
# rr$GETcursor()
# rr$parse()

Requestor <- R6::R6Class("Requestor",
  public = list(
  path = NA,
  cursor = NA,
  args = list(),
  cursor_max = NA,
  cursor_out = list(),
  initialize = function(path, args, cursor, cursor_max) {
    if (!missing(path)) self$path <- path
    if (!missing(cursor)) self$cursor <- cursor
    if (!missing(args)) self$args <- args
    if (!missing(cursor_max)) self$cursor_max <- cursor_max
  },
  GETcursor = function(...) {
    res <- cr_GET(self$path, self$args, todf = FALSE, ...)
    cu <- res$message$`next-cursor`
    tot <- length(res$message$items)
    max_avail <- res$message$`total-results`
    self$cursor_out <- list(res)
    iter <- 1
    while (!is.null(cu) && self$cursor_max > tot && tot < max_avail) {
      iter <- iter + 1
      self$args$cursor = cu
      res <- cr_GET(endpoint = self$path, self$args, todf = FALSE)
      cu <- res$message$`next-cursor`
      self$cursor_out[[iter]] <- res
      tot <- sum(vapply(self$cursor_out, function(z) length(z$message$items), 1))
    }
  },
  parse = function(parse = TRUE) {
    x <- self$cursor_out
    meta <- parse_meta(x[[1]])
    list(meta = meta,
         data = bind_rows(lapply(x, function(z) bind_rows(lapply(z$message$items, parse_works)))),
         facets = cr_compact(lapply(x, function(z) parse_facets(z$message$facets)))
    )
  }
))

empty <- function(l) {
  is_length_zero <- function(z) {
    length(z) == 0
  }
  tmp <- Filter(Negate(is_length_zero), l)
  if (length(tmp) == 1 && is(tmp, "list")) {
    tmp[[1]]
  } else {
    tmp
  }
}
