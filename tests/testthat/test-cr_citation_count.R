context("testing cr_citation_count")

test_that("cr_citation_count returns", {
  skip_on_cran()

  # one
  a <- cr_citation_count(doi="10.1371/journal.pone.0042793")
  # many
  b <- cr_citation_count(doi=c("10.1371/journal.pone.0042793", 
    "10.1016/j.fbr.2012.01.001"))

  # correct classes
  expect_is(a, "data.frame")
  expect_named(a, c('doi', 'count'))
  expect_is(a$doi, "character")
  expect_is(a$count, "numeric")

  expect_is(b, "data.frame")
  expect_named(b, c('doi', 'count'))
  expect_is(b$doi, "character")
  expect_is(b$count, "numeric")

  # correct length
  expect_equal(NROW(a), 1)
  expect_equal(NROW(b), 2)
})

test_that("cr_citation_count fails correctly", {
  skip_on_cran()

  expect_error(cr_citation_count(doi="10.1371/journal.pone.0042793", timeout_ms = 1))
  expect_equal(cr_citation_count("10.1371/journal.pone.004")$count, NA_integer_)
})

Sys.sleep(2)

