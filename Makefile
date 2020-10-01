PACKAGE := $(shell grep '^Package:' DESCRIPTION | sed -E 's/^Package:[[:space:]]+//')
RSCRIPT = Rscript --no-init-file

vign:
	cd vignettes;\
	${RSCRIPT} -e "Sys.setenv(NOT_CRAN='true'); knitr::knit('rcrossref.Rmd.og', output = 'rcrossref.Rmd')";\
	cd ..

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples(run = TRUE)"

check: build
	_R_CHECK_CRAN_INCOMING_=FALSE R CMD CHECK --as-cran --no-manual `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -f `ls -1tr ${PACKAGE}*gz | tail -n1`
	@rm -rf ${PACKAGE}.Rcheck

checkwindows:
	${RSCRIPT} -e "devtools::check_win_devel(quiet = TRUE); devtools::check_win_release(quiet = TRUE)"

test:
	${RSCRIPT} -e "devtools::test()"

revdep:
	${RSCRIPT} -e "revdepcheck::revdep_reset(); revdepcheck::revdep_check()"

readme:
	${RSCRIPT} -e "knitr::knit('README.Rmd')"
