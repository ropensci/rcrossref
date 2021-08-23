context("testing id_converter")

test_that("id_converter returns", {
  vcr::use_cassette("id_converter", {
    doi <- "10.1038/ng.590"
    a <- id_converter(doi)

    expect_is(a, "list")
    expect_named(a, c("status", "responseDate", "request", "records"))
    expect_equal(a$status, "ok")
    expect_is(a$responseDate, "character")
    expect_is(a$request, "character")
    expect_is(a$records, "data.frame")
    expect_equal(a$records$doi, doi)
    expect_is(a$records$pmcid, "character")
    expect_is(a$records$pmid, "character")
    expect_is(a$records$versions[[1]], "data.frame")
  })
})

test_that("id_converter fails correctly", {
    expect_error(id_converter("", timeout_ms = 1))

  skip_on_cran()
  expect_error(id_converter(), "argument \"x\" is missing")
  expect_error(id_converter(matrix()), "x must be of class")
  expect_error(id_converter(rep("foobar", 201)), "200 ids or less please")

  vcr::use_cassette("id_converter_fails_type_param_bad", {
    expect_error(id_converter("28371833", "doi"),
      "ID type 'doi' mismatch for '28371833'")
  })
})
