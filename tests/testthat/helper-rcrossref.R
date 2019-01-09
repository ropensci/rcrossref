# set up vcr
library("vcr")
invisible(vcr::vcr_configure(
    dir = "../fixtures",
    filter_sensitive_data = list(
        "<crossref_email>" = Sys.getenv("crossref_email")
    )
))

pj <- function(x) jsonlite::fromJSON(x)
