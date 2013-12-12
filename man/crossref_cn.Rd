\name{crossref_cn}
\alias{crossref_cn}
\title{Search the CrossRef Metatdata API.}
\usage{
crossref_cn(dois, format = c("rdf-xml", "turtle", "citeproc-json", "text",
  "ris", "bibtex", "crossref-xml", "datacite-xml", "bibentry"), style = NULL,
  locale = "en-US")
}
\arguments{
  \item{dois}{Search by a single DOI or many DOIs.}

  \item{format}{name of the format.}

  \item{style}{a CSL style (for text format only)}

  \item{locale}{language locale}
}
\description{
Search the CrossRef Metatdata API.
}
\details{
See \url{http://www.crosscite.org/cn/} for more info on
this Crossref Content Negotiation API service.
}
\examples{
\dontrun{
crossref_cn("10.1126/science.169.3946.635", "citeproc-json")
crossref_cn("10.1126/science.169.3946.635", "rdf-xml")
crossref_cn("10.1126/science.169.3946.635", "crossref-xml")
crossref_cn("10.1126/science.169.3946.635", "bibtex")
# return an R bibentry type
crossref_cn("10.1126/science.169.3946.635", "bibentry")
return an apa style citation
crossref_cn("10.1126/science.169.3946.635", "text", "apa")
}
}
\author{
Scott Chamberlain \email{myrmecocystus@gmail.com}
}

