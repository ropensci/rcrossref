context("testing cr_r")

test_that("cr_r returns", {
  vcr::use_cassette("cr_r", {
    a <- cr_r(1)
    b <- cr_r(5)
    c <- cr_r(20)
    d <- cr_r(20, query = "ecology")
    e <- cr_r(5, filter = c(award.funder = '501100001659'))

    # correct classe
    expect_is(a, "character")
    expect_is(b, "character")
    expect_is(c, "character")
    expect_is(d, "character")
    expect_is(e, "character")

    # dimensions are correct
    expect_equal(length(a), 1)
    expect_equal(length(b), 5)
    expect_equal(length(c), 20)
    expect_equal(length(d), 20)
    expect_equal(length(e), 5)
  })
})

test_that("cr_r fails correctly", {
  vcr::use_cassette("cr_r_fails_well", {
    expect_error(cr_r(timeout_ms = 1))
    expect_equal(cr_r(query = "adfaaf"), NULL)
  })
})

test_that("cr_r 0 defaults to 20", {
  vcr::use_cassette("cr_r_limit_default", {
    expect_equal(length(cr_r(0)), 20)
  })
})
