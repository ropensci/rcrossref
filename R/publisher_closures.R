elife <- function() {
  list(
    name = "elife",
    member_id = 4374,
    url_pdf = 'https://elifesciences.org/content/4/e%s-download.pdf',
    url_xml = NULL,
    do_url = function(x, y) sprintf(x, y),
    get_id = function(x) strsplit(strsplit(x, "/")[[1]][2], "\\.")[[1]][2]
  )
}

nber <- function() {
  list(
    member_id = 1960,
    url_pdf = 'http://www.nber.org/papers/w%s.pdf',
    url_xml = NULL,
    do_url = function(x, y) sprintf(x, y),
    get_id = function(x) strextract(strsplit(x, "/")[[1]][2], "[0-9]+")
  )
}

plos <- function() {
  list(
    name = "plos",
    member_id = 340,
    url_pdf = NULL,
    url_xml = NULL,
    do_url = function(x, type) {
      doijournal <- strsplit(x, "\\.")[[1]][[3]]
      journal <- switch(doijournal,
                        pone = 'plosone',
                        pbio = 'plosbiology',
                        pmed = 'plosmedicine',
                        pgen = 'plosgenetics',
                        pcbi = 'ploscompbiol',
                        ppat = 'plospathogens',
                        pntd = 'plosntds',
                        pctr = 'plosclinicaltrials')
      if ("plosclinicaltrials" == journal) {
        ub <- 'http://journals.plos.org/plosclinicaltrials/article/asset?id=%s.%s'
        sprintf(ub, x, toupper(type))
      } else {
        ub <- 'http://www.journals.plos.org/%s/article/asset?id=%s.%s'
        sprintf(ub, journal, x, toupper(type))
      }
    }
  )
}

# full_text_urls <- function(doi){
#   doijournal <- strsplit(x, "\\.")[[1]][[3]]
#   journal <- switch(doijournal,
#                     pone = 'plosone',
#                     pbio = 'plosbiology',
#                     pmed = 'plosmedicine',
#                     pgen = 'plosgenetics',
#                     pcbi = 'ploscompbiol',
#                     ppat = 'plospathogens',
#                     pntd = 'plosntds',
#                     pctr = 'plosclinicaltrials')
#   if ("plosclinicaltrials" == journal) {
#     ub <- 'http://journals.plos.org/plosclinicaltrials/article/asset?id=%s.XML'
#     sprintf(ub, x)
#   } else {
#     ub <- 'http://www.journals.plos.org/%s/article/asset?id=%s.XML'
#     sprintf(ub, journal, x)
#   }
# }
# 
# 
# 'http://journals.plos.org/plosone/article/asset?id=10.1371%2Fjournal.pone.0153419.XML&download='
# 'http://journals.plos.org/plosone/article/asset?id=10.1371%2Fjournal.pone.0153419.PDF'
# 
# 'http://journals.plos.org/plosbiology/article/asset?id=10.1371%2Fjournal.pbio.1002457.XML&download='
# 'http://journals.plos.org/plosbiology/article/asset?id=10.1371%2Fjournal.pbio.1002457.PDF'
# 
# 'http://journals.plos.org/plosmedicine/article/asset?id=10.1371%2Fjournal.pmed.1002010.XML&download='
# 'http://journals.plos.org/plosmedicine/article/asset?id=10.1371%2Fjournal.pmed.1002010.PDF'
# 
# 'http://journals.plos.org/ploscompbiol/article/asset?id=10.1371%2Fjournal.pcbi.1004709.XML&download='
# 'http://journals.plos.org/ploscompbiol/article/asset?id=10.1371%2Fjournal.pcbi.1004709.PDF'
