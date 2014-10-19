all: move rmd2md

move:
		cp inst/vign/crossref_filters.md vignettes

rmd2md:
		cd vignettes;\
		mv crossref_filters.md crossref_filters.Rmd
