\name{crossref_citation_count}
\alias{crossref_citation_count}
\title{Lookup article info via CrossRef with DOI and get a citation.}
\usage{
crossref_citation_count(doi, url = "http://www.crossref.org/openurl/",
  key = "cboettig@ropensci.org", ..., curl = getCurlHandle())
}
\arguments{
  \item{doi}{digital object identifier for an article in
  PLoS Journals}

  \item{url}{the PLoS API url for the function (should be
  left to default)}

  \item{key}{your PLoS API key, either enter, or loads from
  .Rprofile}

  \item{...}{optional additional curl options (debugging
  tools mostly)}

  \item{curl}{If using in a loop, call getCurlHandle()
  first and pass the returned value in here (avoids
  unnecessary footprint)}
}
\value{
citation count
}
\description{
Options to get formatted citations as bibtext or plain
text.
}
\details{
See \url{http://labs.crossref.org/openurl/} for more info
on this Crossref API service.
}
\examples{
\dontrun{
crossref_citation_count(doi="10.1371/journal.pone.0042793")
}
}
\author{
Carl Boettiger \email{cboettig@gmail.com}
}
\seealso{
\code{\link{crossref_search}}, \code{\link{crossref_r}},
\code{\link{crossref_search_free}}
}

