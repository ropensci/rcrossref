context("testing cr_licenses")

test_that("cr_licenses returns", {
  vcr::use_cassette("cr_licenses", {

    a <- cr_licenses()
    b <- cr_licenses(query = 'elsevier')

    # correct classes
    expect_is(a, "list")
    expect_is(a$meta, "data.frame")
    expect_is(a$data, "data.frame")
    expect_is(a$data$URL, "character")

    expect_is(b, "list")
    expect_is(b$meta, "data.frame")
    expect_is(b$data, "data.frame")
    expect_is(b$data, "tbl_df")
    expect_is(b$data$URL, "character")

    # dimensions are correct
    expect_equal(length(a), 2)
    expect_equal(NCOL(a$data), 2)
    expect_equal(length(b), 2)
    expect_equal(NCOL(b$data), 2)
  })
})

test_that("cr_licenses fails correctly", {
  vcr::use_cassette("cr_licenses_fails_well", {

    expect_error(cr_licenses(timeout_ms = 1))
    expect_equal(NROW(cr_licenses(query = "adfaaf")$data), 0)
    expect_error(cr_licenses(filter=''))
  })
})
