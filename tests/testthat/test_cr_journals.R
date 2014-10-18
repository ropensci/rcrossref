context("testing cr_journals")

test_that("cr_journals returns correct class", {
  a <- cr_journals()
  expect_is(a, "list")
  expect_is(a$data, "tbl_df")
  expect_is(a$data, "data.frame")
})

test_that("cr_journals paging works correctly", {
  expect_equal(NROW(cr_journals(query="ecology", works = TRUE, limit=5)$data), 5)
})

test_that("cr_journals metadata works correctly", {
  expect_equal(cr_journals(query="peerj", limit=4)$meta$items_per_page, 4)
})

test_that("cr_journals fails correctly", {
  library('httr')
  expect_error(cr_journals(query="peerj", limit=4, config=timeout(0.001)))
})
