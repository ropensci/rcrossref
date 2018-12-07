context("testing cr_members - cursor")

test_that("cr_members cursor basic functionality works", {
  vcr::use_cassette("cr_members_with_cursor", {

    aa <- cr_members(member_ids=98, works = TRUE, cursor = "*", cursor_max = 300, limit = 100)
    bb <- cr_members(member_ids=c(10, 98), works = TRUE, cursor = "*", cursor_max = 200, limit = 100)

    expect_is(aa, "list")
    expect_is(aa$meta, "data.frame")
    expect_is(aa$data, "data.frame")
    expect_is(aa$facets, "list")

    expect_equal(NROW(aa$data), 300)
    expect_equal(NROW(bb$data), 400)
  })
})

test_that("cr_members cursor fails correctly", {
  vcr::use_cassette("cr_members_with_cursor_fails_well", {

    expect_warning(cr_members(cursor = 5),
                 "This route does not support cursor")
    expect_error(cr_works(cursor_max = 3.4),
                 "cursor_max must be an integer")
  })
})
