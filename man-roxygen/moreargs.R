#' @param .progress Show a \code{plyr}-style progress bar? Options are "none", "text", 
#' "tk", "win", and "time".  See \code{\link[plyr]{create_progress_bar}} for details 
#' of each. Only used when passing in multiple ids (e.g., multiple DOIs, DOI prefixes,
#' etc.), or when using the \code{cursor} param. When using the \code{cursor} param,
#' this argument only accept a boolean, either \code{TRUE} or \code{FALSE}; any
#' non-boolean is coerced to \code{FALSE}.
#' @param ... Named parameters passed on to \code{\link[crul]{HttpClient}}
