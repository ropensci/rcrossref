#' @param cursor (character) Cursor character string to do deep paging. Default is None.
#' Pass in '*' to start deep paging. Any combination of query, filters and facets may be
#' used with deep paging cursors. While rows may be specified along with cursor, offset
#' and sample cannot be used.
#' See https://github.com/CrossRef/rest-api-doc/blob/master/rest_api.md#deep-paging-with-cursors
#' @param cursor_max (integer) Max records to retrieve. Only used when cursor param used. 
#' Because deep paging can result in continuous requests until all are retrieved, use this
#' parameter to set a maximum number of records. Of course, if there are less records
#' found than this value, you will get only those found.
