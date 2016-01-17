#' @param .progress Show a \code{plyr}-style progress bar? Options are "none", "text", 
#' "tk", "win", and "time".  See \code{\link[plyr]{create_progress_bar}} for details 
#' of each. Only used when passing in multiple ids (e.g., multiple DOIs, DOI prefixes,
#' etc.)
#' @param ... Named parameters passed on to \code{\link[httr]{GET}}
