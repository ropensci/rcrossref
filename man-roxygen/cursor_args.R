#' @param cursor (character) Cursor character string to do deep paging.
#' Default is None. Pass in '*' to start deep paging. Any combination of
#' query, filters and facets may be used with deep paging cursors.
#' While the \code{limit} parameter may be specified along with cursor,
#' offset and sample cannot be used with the cursor. See 
#' https://github.com/CrossRef/rest-api-doc#deep-paging-with-cursors
#' @param cursor_max (integer) Max records to retrieve. Only used when
#' cursor param used. Because deep paging can result in continuous requests
#' until all are retrieved, use this parameter to set a maximum number of
#' records. Of course, if there are less records found than this value,
#' you will get only those found. When cursor pagination is being used
#' the \code{limit} parameter sets the chunk size per request.
#' 
#' @section Deep paging (using the cursor):
#' When using the cursor, a character string called \code{next-cursor} is
#' returned from Crossref that we use to do the next request, and so on. We 
#' use a while loop to get number of results up to the value of
#' \code{cursor_max}. Since we are doing each request for you, you may not
#' need the \code{next-cursor} string, but if you do want it, you can get
#' to it by indexing into the result like \code{x$meta$next_cursor}
#' 
#' Note that you can pass in curl options when using cursor, via \code{"..."}
