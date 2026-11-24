test_that("cr_abstract requires exactly one DOI", {
  dois <- c("10.1109/TASC.2010.2088091", "10.1175//2572.1")
  expect_error(cr_abstract(dois), "must contain exactly one DOI", fixed = TRUE)
})

skip_on_cran()

test_that("cr_abstract", {
  vcr::use_cassette("cr_abstract", {
    b <- cr_abstract("10.1175//2572.1")
  })

  expect_is(b, "character")
  expect_match(b, "University")
  expect_gt(nchar(b), 1000L)
})

test_that("cr_abstract not found", {
  vcr::use_cassette("cr_abstract_not_found", {
    expect_error(cr_abstract('10.5284/1011335'))
  })
})
