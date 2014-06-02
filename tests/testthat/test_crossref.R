context("Testing crossref")

test_that("Random crossref search returns correct result type", {
	 random_list <- cr_r(type = 'journal_article')
	 expect_is(random_list, "list")
})
