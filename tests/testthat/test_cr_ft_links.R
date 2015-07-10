context("testing cr_ft_links")


test_that("cr_ft_links returns correct class", {
  skip_on_cran()
  
  a <- cr_ft_links(doi = "10.5555/515151", "pdf")
  out <- cr_works(filter = c(has_full_text = TRUE), limit = 50)
  dois <- out$data$DOI
  b <- cr_ft_links("10.7554/elife.04389", "pdf")
  d <- cr_ft_links("10.1016/s0016-5085(03)02155-3", "all")
  
  expect_is(a, "tdmurl")
  expect_is(a[[1]], "character")

  expect_is(b, "tdmurl")
  expect_is(attr(b, "type"), "character")

  expect_is(d, "list")
  expect_is(d[[1]], "tdmurl")
  expect_is(attr(d[[2]], "type"), "character")

  # dimensions are correct
  expect_equal(length(a), 1)
  expect_equal(length(b), 1)
  expect_equal(length(d), 2)
  expect_equal(length(d[[1]]), 1)

  # gives back right values
  
  expect_equal(attr(a, "type"), "pdf")
  expect_equal(attr(b, "type"), "pdf")
  expect_equal(attr(d[[2]], "type"), "plain")

  expect_null(cr_ft_links("10.1007/978-1-4302-1089-4"))
})

test_that("cr_ft_links fails correctly", {
  skip_on_cran()
  
  expect_error(cr_ft_links(), 'argument "doi" is missing')
  expect_null(suppressWarnings(cr_ft_links(doi = "3434")))
})
