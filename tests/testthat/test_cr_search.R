context("testing cr_search")


test_that("cr_search returns correct class", {
  skip_on_cran()
  
  a <- cr_search(query = c("renear", "palmer"))
  b <- cr_search(query = c("renear", "palmer"), rows = 4)
  c <- cr_search(query = c("renear", "palmer"), rows = 40)
  d <- cr_search(query = c("renear", "palmer"), year = 2010)
  e <- cr_search(doi = c("10.1890/10-0340.1","10.1016/j.fbr.2012.01.001",
                         "10.1111/j.1469-8137.2012.04121.x"))
  
  # correct classes
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "data.frame")
  expect_is(d, "data.frame")
  expect_is(e, "data.frame")
  
  expect_is(a, "data.frame")
  expect_is(a$title, "character")
  expect_is(a$score, "numeric")
  
  # dimensions are correct
  expect_equal(NROW(b), 4)
  expect_equal(NROW(c), 40)
  expect_equal(NCOL(a), 7)
  expect_equal(NCOL(d), 7)
  expect_equal(NCOL(e), 7)
})

test_that("cr_search fails correctly", {
  skip_on_cran()
  
  library('httr')
  expect_error(cr_search(config=timeout(0.01)))
  expect_equal(cr_search("Asdfadf"), NULL)
})
