context("testing cr_licenses")

a <- cr_licenses()
b <- cr_licenses(query = 'elsevier')

test_that("cr_licenses returns correct class", {
  expect_is(a, "list")
  expect_is(a$meta, "data.frame")
  expect_is(a$data, "data.frame")
  expect_is(a$data$URL, "character")
  
  expect_is(b, "list")
  expect_is(b$meta, "data.frame")
  expect_is(b$data, "data.frame")
  expect_is(b$data, "tbl_df")
  expect_is(b$data$URL, "character")
})

test_that("cr_licenses dimensions are correct", {
  expect_equal(length(a), 2)
  expect_equal(NCOL(a$data), 2)
  expect_equal(length(b), 2)
  expect_equal(NCOL(b$data), 2)
})

test_that("cr_licenses fails correctly", {
  library('httr')
  expect_error(cr_licenses(config=timeout(0.01)))
  expect_equal(NROW(cr_licenses(query = "adfaaf")$data), 0)
  expect_error(cr_licenses(filter=''))
})
