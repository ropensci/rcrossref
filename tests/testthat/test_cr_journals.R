context("testing cr_journals")

test_that("cr_journals returns correct class", {
  skip_on_cran()
  
  a <- cr_journals()
  expect_is(a, "list")
  expect_is(a$data, "tbl_df")
  expect_is(a$data, "data.frame")
})

test_that("cr_journals paging works correctly", {
  skip_on_cran()
  
  expect_equal(NROW(cr_journals(issn = '1803-2427', works = TRUE, limit=5)$data), 5)
})

test_that("cr_journals metadata works correctly", {
  skip_on_cran()
  
  expect_equal(cr_journals(query="peerj", limit=4)$meta$items_per_page, 4)
})

test_that("cr_journals fails correctly", {
  skip_on_cran()
  
  library('httr')
  expect_error(cr_journals(query="peerj", limit=4, config=timeout(0.001)))
})


test_that("cr_journals warns correctly", {
  skip_on_cran()
  
  expect_warning(cr_journals(issn=c('blblbl', '1932-6203')), 
                 regexp = "Resource not found", all = TRUE)
  expect_equal(NROW(suppressWarnings(cr_journals(issn=c('blblbl', '1932-6203')))), 1)
  expect_is(suppressWarnings(cr_journals(issn=c('blblbl', '1932-6203'))), "tbl_df")
})

test_that("ISSNs that used to fail badly - should fail better now", {
  expect_warning(cr_journals("0413-6597"), "Resource not found")
  expect_warning(cr_journals(c('1932-6203', '1803-2427', "0413-6597")), "Resource not found")
  expect_equal(NROW(suppressMessages(suppressWarnings(cr_journals(c('1932-6203', '1803-2427', "0413-6597"))))), 2)
})
