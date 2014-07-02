context("Testing crossref")

random_list <- cr_r(type = 'journal_article')

test_that("Random crossref search returns correct result type", {
	 expect_is(random_list, "character")
})

entry <- cr_cn("10.6084/m9.figshare.97218", "bibentry")

test_that("We can parse fighshare DOIs into bibentry type", {
  expect_is(entry, "bibentry")
})