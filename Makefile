RSCRIPT = Rscript --no-init-file

all: move rmd2md

move:
		cp inst/vign/crossref_filters.md vignettes;\
		cp inst/vign/crossref_vignette.md vignettes

rmd2md:
		cd vignettes;\
		mv crossref_filters.md crossref_filters.Rmd;\
		mv crossref_vignette.md crossref_vignette.Rmd

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

check:
	${RSCRIPT} -e "devtools::check(document = FALSE, cran = TRUE)"

test:
	${RSCRIPT} -e "devtools::test()"

revdep:
	${RSCRIPT} -e "revdepcheck::revdep_reset(); revdepcheck::revdep_check()"

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"
