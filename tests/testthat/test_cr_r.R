context("testing cr_r")

a <- cr_r(1)
b <- cr_r(5)
c <- cr_r(20)
d <- cr_r(20, query="ecology")
e <- cr_r(5, filter=c(award.funder='10.13039/100000001'))

test_that("cr_r returns correct class", {
  expect_is(a, "character")
  expect_is(b, "character")
  expect_is(c, "character")
  expect_is(d, "character")
  expect_is(e, "character")
})

test_that("cr_r dimensions are correct", {
  expect_equal(length(a), 1)
  expect_equal(length(b), 5)
  expect_equal(length(c), 20)
  expect_equal(length(d), 20)
  expect_equal(length(e), 5)
})

test_that("cr_r fails correctly", {
  library('httr')
  expect_error(cr_r(config=timeout(0.01)))
  expect_equal(cr_r(query = "adfaaf"), NULL)
})

test_that("cr_r 0 defaults to 20", {
  expect_equal(length(cr_r(0)), 20)
})
