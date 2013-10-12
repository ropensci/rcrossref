\name{crossref_cn}
\alias{crossref_cn}
\title{Search the CrossRef Metatdata API.}
\usage{
  crossref_cn(doi = NULL, header = "bibtex")
}
\arguments{
  \item{doi}{Search by a single DOI or many DOIs.}

  \item{header}{Header.}
}
\description{
  Search the CrossRef Metatdata API.
}
\details{
  See \url{http://search.labs.crossref.org/help/api} for
  more info on this Crossref API service.
}
\examples{
\dontrun{
crossref_cn(doi = "10.1126/science.169.3946.635")
crossref_cn(doi = "10.1126/science.169.3946.635")
}
}
\author{
  Scott Chamberlain \email{myrmecocystus@gmail.com}
}
\seealso{
  \code{\link{crossref_r}},
  \code{\link{crossref_citation}},
  \code{\link{crossref_search_free}}
}

