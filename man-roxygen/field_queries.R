#' @param flq field queries. One or more field queries. Acceptable set of
#' field query parameters are:
#' \itemize{
#'  \item \code{query.container-title}	- Query container-title aka.
#'  publication name
#'  \item \code{query.author} - Query author first and given names
#'  \item \code{query.editor} - Query editor first and given names
#'  \item \code{query.chair}	- Query chair first and given names
#'  \item \code{query.translator} - Query translator first and given names
#'  \item \code{query.contributor} - Query author, editor, chair and
#'  translator first and given names
#'  \item \code{query.bibliographic} - Query bibliographic information, useful
#'  for citation lookup. Includes titles, authors, ISSNs and publication years
#'  \item \code{query.affiliation} - Query contributor affiliations
#' }
#' 
#' Note: \code{query.title} has been removed - use \code{query.bibliographic}
#' as a replacement
