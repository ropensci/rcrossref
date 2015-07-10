context("testing cr_works")


test_that("cr_works returns", {
  skip_on_cran()
  
  a <- cr_works(query="NSF")
  b <- cr_works(query="renear+-ontologies")
  c <- cr_works(query="global state", filter=c(has_orcid=TRUE), limit=3)
  d <- cr_works(filter=c(has_full_text = TRUE))
  e <- cr_works(dois=c('10.1007/12080.1874-1746','10.1007/10452.1573-5125', '10.1111/(issn)1442-9993'))
  f <- cr_works(query="NSF", facet=TRUE, limit=0)
  g <- cr_works(sample=1)
  h <- cr_works(query="NSF", facet=TRUE)
  i <- suppressWarnings(cr_works(dois=c('blblbl', '10.1038/nnano.2014.279')))
  
  # correct class
  expect_is(a, "list")
  expect_is(b, "list")
  expect_is(c, "list")
  expect_is(d, "list")
  expect_is(e, "list")
  expect_is(f, "list")
  expect_is(g, "list")
  expect_is(h, "list")
  expect_is(i, "list")
  
  expect_is(a$meta, "data.frame")
  expect_is(a$data, "data.frame")
  expect_is(a$data, "tbl_df")
  expect_is(a$data$URL, "character")
  expect_equal(a$facets, NULL)

  expect_is(h, "list")
  expect_is(h$meta, "data.frame")
  expect_is(h$facets, "list")
  expect_is(h$facets$license, "data.frame")
  expect_is(h$facets$license$.id, "character")
  
  expect_equal(i$meta, NULL)
  expect_equal(i$facets, NULL)
  expect_is(i$data, "tbl_df")

  # dimensions are correct
  expect_equal(length(a), 3)
  expect_equal(length(b), 3)
  expect_equal(length(c), 3)
  expect_equal(length(d), 3)
  expect_equal(length(e), 3)
  expect_equal(length(f), 3)
  expect_equal(length(g), 3)
  expect_equal(length(h), 3)
  expect_equal(length(i), 3)
})

test_that("cr_works fails correctly", {
  skip_on_cran()
  
  library('httr')
  expect_error(cr_works(config=timeout(0.01)))
  expect_equal(NROW(cr_works(query = "adfaaf")$data), 0)
})


test_that("cr_works warns correctly", {
  skip_on_cran()
  
  expect_warning(cr_works(dois=c('blblbl', '10.1038/nnano.2014.279')), "Resource not found")
  expect_equal(NROW(suppressWarnings(cr_works(dois=c('blblbl', '10.1038/nnano.2014.279'))$data)), 1)
})
