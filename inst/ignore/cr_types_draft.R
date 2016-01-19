`cr_types` <- function(types = NULL, query = NULL, filter = NULL, offset = NULL, limit = NULL, 
  sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  cursor = NULL, cursor_max = 5000, .progress="none", ...) {
  
  res <- cr_types_(types, query, filter, offset, limit, sample, sort, order, 
            facet, works, cursor, cursor_max, .progress, ...)
  res
  # if (length(types) > 1) {
  #   if (!is.null(cursor)) {
  #     out <- lapply(res, "[[", "data")
  #     bind_rows(out)
  #   } else {
  #     out <- lapply(res, "[[", "message")
  #     out <- if (works) do.call(c, lapply(out, function(x) lapply(x$items, parse_works))) else lapply(out, DataFrame)
  #     df <- rbind_all(out)
  #     meta <- if (works) data.frame(types = types, do.call(rbind, lapply(res, parse_meta)), stringsAsFactors = FALSE) else NULL
  #     if (facet_log) { 
  #       ft <- Map(function(x, y){ 
  #         rr <- list(parse_facets(x$message$facets)); names(rr) <- y; rr 
  #       }, res, types) 
  #     } else {
  #       ft <- list() 
  #     }
  #     list(meta = meta, data = df, facets = ft)
  #   }
  # } else {
  #   if (!is.null(cursor)) {
  #     res
  #   } else {
  #     if (all(is.na(res))) {
  #       list(meta = NA, data = NA)
  #     } else {
  #       if (is.null(types)) {
  #         list(meta = list(count = res$message$`total-results`), 
  #              data = bind_rows(lapply(res$message$items, parse_type)))
  #       } else {
  #         if (works) {
  #           wout <- rbind_all(lapply(res$message$items, parse_works))
  #           meta <- parse_meta(res)
  #         } else {
  #           wout <- parse_type(res$message)
  #           meta <- NULL
  #         }
  #         list(meta = meta, data = wout)
  #       }
  #     }
  #   }
  # }
}

`cr_types_` <- function(types = NULL, query = NULL, filter = NULL, offset = NULL, limit = NULL, 
  sample = NULL, sort = NULL, order = NULL, facet=FALSE, works = FALSE, 
  cursor = NULL, cursor_max = 5000, .progress="none", parse=FALSE, ...) {
  
  check_limit(limit)
  filter <- filter_handler(filter)
  facet_log <- facet
  facet <- if (facet) "t" else NULL
  args <- cr_compact(list(query = query, filter = filter, offset = offset, rows = limit,
                          sample = sample, sort = sort, order = order, facet = facet,
                          cursor = cursor))
  
  if (length(types) > 1) {
    llply(types, types_GET, args = args, works = works,
          cursor = cursor, cursor_max = cursor_max,
          parse = parse, ..., .progress = .progress)
  } else {
    types_GET(types, args, works = works, cursor = cursor,
               cursor_max = cursor_max, parse = parse, ...)
  }
}

types_GET <- function(x, args, works, cursor = NULL, cursor_max = NULL, parse, cursor_parse, ...){
  path <- if (!is.null(x)) {
    if (works) sprintf("types/%s/works", x) else sprintf("types/%s", x)
  } else { 
    "types" 
  }
  
  cursor_parse <- get_args(...)
  
  if (!is.null(cursor) && works) {
    rr <- Requestor$new(path = path, args = args, cursor_max = cursor_max,
                        should_parse = TRUE, ...)
    rr$GETcursor()
    if (cursor_parse) rr$parse() else rr$cursor_out
  } else {
    cr_GET(path, args, todf = FALSE, on_error = stop, parse = parse, ...)
  }
}

get_args <- function(...) {
  tmp <- list(...)
  tmp[names(tmp) == "cursor_parse"][[1]]
}
