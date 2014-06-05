context("Testing crossref")

test_that("Random crossref search returns correct result type", {
	 random_list <- cr_r(type = 'journal_article')
	 expect_is(random_list, "list")
})


test_that("We can parse fighshare DOIs into bibentry type", {
   entry <- cr_cn("10.6084/m9.figshare.97218", "bibentry")
})
