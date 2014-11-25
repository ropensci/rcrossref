all: move rmd2md

move:
		cp inst/vign/crossref_filters.md vignettes;\
		cp inst/vign/crossref_vignette.md vignettes

rmd2md:
		cd vignettes;\
		mv crossref_filters.md crossref_filters.Rmd;\
		mv crossref_vignette.md crossref_vignette.Rmd
