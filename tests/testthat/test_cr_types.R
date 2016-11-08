context("testing cr_types")

test_that("cr_types returns correct class", {
  skip_on_cran()

  aa <- cr_types()
  expect_is(aa, "list")
  expect_is(aa$data, "data.frame")
  expect_gt(NROW(aa$data), 10)
  expect_equal(aa$facets, NULL) # there is no facets slot

  bb <- cr_types("monograph")
  expect_is(bb, "list")
  expect_is(bb$data, "data.frame")
  expect_equal(NROW(bb$data), 1)
})

test_that("cr_types paging works correctly", {
  skip_on_cran()

  # doens't work when works=FALSE
  aa <- cr_types(limit = 3)
  expect_is(aa, "list")
  expect_gt(NROW(aa$data), 3)

  # works when works=TRUE
  bb <- cr_types("monograph", works=TRUE, limit = 3)
  expect_is(bb, "list")
  expect_equal(NROW(bb$data), 3)
})

test_that("cr_types metadata works correctly", {
  skip_on_cran()

  expect_gt(cr_types()$meta$count, 10)
  expect_equal(cr_types("monograph", works=TRUE, limit = 3)$meta$items_per_page, 3)
})

test_that("cr_types facet works correctly", {
  skip_on_cran()

  aa <- cr_types("monograph", works=TRUE, facet=TRUE, limit = 0)

  expect_is(aa, "list")
  expect_named(aa, c('meta', 'data', 'facets'))
  expect_is(aa$facets, 'list')
  expect_is(aa$facets$affiliation, 'data.frame')
  expect_is(aa$facets$orcid, 'data.frame')
})

test_that("cr_types fails correctly", {
  skip_on_cran()

  library('httr')
  expect_error(cr_types(types="monograph", config=timeout(0.001)))
})

Sys.sleep(1)
