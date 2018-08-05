context("testing cr_prefixes")

test_that("cr_prefixes returns correct class", {
  skip_on_cran()

  a <- cr_prefixes(prefixes="10.1016")
  expect_is(a, "list")
  expect_is(a$data, "data.frame")
  expect_equal(a$facets, NULL)
})

test_that("cr_prefixes paging works correctly", {
  skip_on_cran()

  expect_equal(NROW(
    cr_prefixes(prefixes="10.1016", works = TRUE, 
                filter=c(has_full_text=TRUE),
                limit=5)$data
    ), 
    5
  )
  expect_equal(NCOL(cr_prefixes(prefixes="10.1016", works = TRUE,
                             query='ecology', limit=4)$meta), 5)
})

test_that("cr_prefixes metadata works correctly", {
  skip_on_cran()

  expect_equal(cr_prefixes(prefixes="10.1016", query='ecology', works = TRUE,
                        limit=4)$meta$items_per_page, 4)
})

test_that("cr_prefixes facet works correctly", {
  skip_on_cran()

  aa <- cr_prefixes(prefixes="10.1016", works=TRUE, facet=TRUE, limit = 10)

  expect_is(aa, "list")
  expect_named(aa, c('meta', 'data', 'facets'))
  expect_is(aa$facets, 'list')
  expect_is(aa$facets$affiliation, 'data.frame')
  expect_is(aa$facets$orcid, 'data.frame')
})

test_that("cr_prefixes fails correctly", {
  skip_on_cran()

  # curl timeout
  expect_error(cr_works(prefixes="10.1016", query='ecology',
                        limit=4, timeout_ms = 1))

  # prefix not found
  expect_warning(
    cr_prefixes_(prefixes = c("10.1038", "10.1684", "10.1109")),
    "/prefixes/10.1684 - Resource not found."
  )
})

Sys.sleep(2)

