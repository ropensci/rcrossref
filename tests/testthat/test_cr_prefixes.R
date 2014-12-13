context("testing cr_prefixes")

test_that("cr_prefixes returns correct class", {
  a <- cr_prefixes(prefixes="10.1016")
  expect_is(a, "list")
  expect_is(a$data, "data.frame")
  expect_equal(a$facets, NULL)
})

test_that("cr_prefixes paging works correctly", {
  expect_equal(NROW(cr_works(prefixes="10.1016", filter=c(has_full_text=TRUE), limit=5)$data), 5)
  expect_equal(NCOL(cr_works(prefixes="10.1016", query='ecology', limit=4)$meta), 4)
})

test_that("cr_prefixes metadata works correctly", {
  expect_equal(cr_works(prefixes="10.1016", query='ecology', limit=4)$meta$items_per_page, 4)
})

test_that("cr_prefixes fails correctly", {
  library('httr')
  expect_error(cr_works(prefixes="10.1016", query='ecology', limit=4, config=timeout(0.001)))
})
