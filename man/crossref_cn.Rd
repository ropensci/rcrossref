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
  See \url{http://www.crosscite.org/cn/} for more info on
  this Crossref Content Negotiation API service.
}
\examples{
\dontrun{
crossref_cn(doi = "10.1126/science.169.3946.635")
crossref_cn(doi = "10.1126/science.169.3946.635", header="citeprocjson")
crossref_cn(doi = "10.1126/science.169.3946.635", header="ris")
crossref_cn(doi = "10.1126/science.169.3946.635", header="formattedtextcitation")
crossref_cn(doi = "10.1126/science.169.3946.635", header="formattedtextcitation", style="apa")
}
}
\author{
  Scott Chamberlain \email{myrmecocystus@gmail.com}
}

