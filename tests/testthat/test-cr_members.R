context("testing cr_members")


test_that("cr_members returns", {
  vcr::use_cassette("cr_members", {

    a <- cr_members(member_ids=98)
    b <- cr_members(member_ids=98, works=TRUE)
    c <- cr_members(member_ids=c(10,98,45,1,9))
    d <- cr_members(member_ids=c(10,98,45,1,9), works=TRUE)
    e <- cr_members(query='ecology')

    # correct class
    expect_is(a, "list")
    expect_null(a$meta)
    expect_is(a$data, "data.frame")
    expect_is(a$data$primary_name, "character")

    expect_is(b, "list")
    expect_is(b$meta, "data.frame")
    expect_is(b$data, "data.frame")
    expect_is(b$data, "tbl_df")
    expect_is(b$data$url, "character")

    expect_is(c, "list")
    expect_is(d, "list")
    expect_is(e, "list")
    expect_equal(e$facets, NULL)

    # dimensions are correct
    expect_equal(length(a), 3)
    expect_equal(length(b), 3)
    expect_equal(length(e), 3)
    expect_equal(length(d$facets), 0)
  })
})

test_that("cr_members fails correctly", {
  vcr::use_cassette("cr_members_fails_well", {

    expect_error(cr_members(timeout_ms = 1))
    expect_equal(NROW(cr_members(query = "adfaaf")$data), 0)

    expect_warning(
      cr_members(
        member_ids=c(323234343434, 3434343434), works=TRUE, facet=TRUE),
      "Resource not found.")
    expect_warning(
      cr_members(
        member_ids=c(323234343434,3434343434,98), works=TRUE, facet=TRUE),
      "Resource not found.")

    # fails due to facet not supported
    expect_warning(cr_members(facet = TRUE),
                 "/members - This route does not support facet")
  })
})
