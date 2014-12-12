context("testing cr_citation_count")

a <- cr_citation_count(doi="10.1371/journal.pone.0042793")
b <- cr_citation_count(doi="10.1016/j.fbr.2012.01.001")

test_that("cr_citation_count returns correct class", {
  expect_is(a, "numeric")
  expect_is(b, "numeric")
})

test_that("cr_citation_count returns correct length", {
  expect_equal(length(a), 1)
  expect_equal(length(b), 1)
})

test_that("cr_citation_count fails correctly", {
  library('httr')
  expect_error(cr_citation_count(doi="10.1371/journal.pone.0042793", config=timeout(0.001)))
  expect_equal(cr_citation_count("10.1371/journal.pone.004"), NA)
})
