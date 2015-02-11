context("testing cr_fundref")

a <- cr_fundref(dois=c('10.13039/100000001','10.13039/100000015'))
b <- cr_fundref(dois='10.13039/100000001', works=TRUE, limit=5)

test_that("cr_fundref returns correct class", {
  expect_is(cr_fundref(query="NSF", limit=1), "list")
  expect_is(a, "list")
  expect_is(a[[1]]$data, "data.frame")
  expect_is(a[[1]]$descendants, "character")
  
  expect_is(b, "list")
  expect_is(b$data, "tbl_df")
})

test_that("cr_fundref dimensions are correct", {
  expect_equal(length(a), 2)
  expect_equal(length(b), 2)
})

test_that("cr_fundref fails correctly", {
  library('httr')
  expect_warning(cr_fundref(dois='10.13039/100000001afasfasdf'))
})
