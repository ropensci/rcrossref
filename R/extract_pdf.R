#' Extract text from a single pdf document.
#' 
#' @export
#' @param path Path to a file
#' @return An object of class xpdf_char
#' @details 
#' Download xpdf from \url{http://www.foolabs.com/xpdf/download.html}
#' @examples \dontrun{
#' path <- system.file("examples", "MairChamberlain2014RJournal.pdf", 
#'    package = "rcrossref")
#' (res_xpdf <- extract_xpdf(path))
#' res_xpdf$meta
#' res_xpdf$data
#' }
extract_xpdf <- function(path){
  path <- path.expand(path)
  system2("pdftotext", shQuote(path))
  newpath <- sub("\\.pdf", ".txt", path)
  res <- paste(readLines(newpath, warn = FALSE), collapse = ", ")
  meta <- pdf_info_via_xpdf(path)
  structure(list(meta = meta, data = res), class = "xpdf_char", path = path)
}

#' @export
print.xpdf_char <- function(x, ...) {
  cat("<document>", attr(x, "path"), "\n", sep = "")
  cat("  Pages: ", x$meta$Pages, "\n", sep = "")
  cat("  Title: ", x$meta$Title, "\n", sep = "")
  cat("  Producer: ", x$meta$Producer, "\n", sep = "")
  cat("  Creation date: ", as.character(as.Date(x$meta$CreationDate)), "\n", 
      sep = "")
}

get_cmds <- function(...){
  d <- list(...)
  if (length(d) == 0) "" else d
}

pdf_info_via_xpdf <- function(file, options = NULL){
  outfile <- tempfile("pdfinfo")
  on.exit(unlink(outfile))
  status <- system2("pdfinfo", c(options, shQuote(normalizePath(file))), 
                    stdout = outfile)
  lines <- readLines(outfile, warn = FALSE)
  tmp <- do.call("c", lapply(lines, function(x){
    x <- gsub("[^\x20-\x7F]", "", x) # remove unicode characters
    as.list(stats::setNames(strtrim(sub("^:", "", strextract(x, ":\\s.+$"))), 
                     sub(":", "", strextract(x, "^[A-Za-z]+\\s?[A-Za-z]+:"))))
  }))
  fmt <- "%a %b %d %X %Y"
  modifyList(tmp, list(CreationDate = strptime(tmp$CreationDate, fmt), 
                       ModDate = strptime(tmp$ModDate, fmt),
                       Pages = as.integer(tmp$Pages)))
}

strextract <- function(str, pattern) regmatches(str, regexpr(pattern, str))
strtrim <- function(str) gsub("^\\s+|\\s+$", "", str)
