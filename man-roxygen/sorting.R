#' @param sort Field to sort on. Acceptable set of fields to sort on: 
#' \itemize{
#'  \item \code{score} OR \code{relevance} - Sort by relevance score
#'  \item \code{updated} - Sort by date of most recent change to metadata. 
#'  Currently the same as deposited.
#'  \item \code{deposited} - Sort by time of most recent deposit
#'  \item \code{indexed} - Sort by time of most recent index
#'  \item \code{published} - Sort by publication date
#'  \item \code{published-print} - Sort by print publication date
#'  \item \code{published-online} - Sort by online publication date
#'  \item \code{issued} - Sort by issued date (earliest known publication date)
#'  \item \code{is-referenced-by-count} - Sort by number of times this DOI is 
#'  referenced by other Crossref DOIs
#'  \item \code{references-count} - Sort by number of references included in 
#'  the references section of the document identified by this DOI
#' }
