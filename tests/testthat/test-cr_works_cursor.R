context("testing cr_works - cursor")

test_that("cr_works cursor basic functionality works", {
  vcr::use_cassette("cr_works_with_cursor", {

    aa <- cr_works(query="NSF", cursor = "*", cursor_max = 300, limit = 100)
    bb <- cr_works(query="NSF", limit = 100)

    expect_is(aa, "list")
    expect_is(aa$meta, "data.frame")
    expect_is(aa$data, "data.frame")
    expect_is(aa$facets, "list")

    expect_equal(NROW(aa$data), 300)
    expect_equal(NROW(bb$data), 100)
  })
})

test_that("cr_works cursor fails correctly", {
  vcr::use_cassette("cr_works_with_cursor_fails_well", {

    expect_warning(cr_works(cursor = 5))
    expect_error(cr_works(cursor_max = 3.4),
                 "cursor_max must be an integer")
  })
})

test_that("cr_works cursor works with progress bar", {
  vcr::use_cassette("cr_works_with_cursor_and_progress_bar", {
    expect_output(
      cr_works(query="ecology", cursor = "*", cursor_max = 90,
        limit = 30, .progress = TRUE),
      "======="
    )
  })
})
