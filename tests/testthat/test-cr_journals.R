context("testing cr_journals")

test_that("cr_journals returns correct class", {
  vcr::use_cassette("cr_journals", {

    a <- cr_journals()
    expect_is(a, "list")
    expect_is(a$data, "tbl_df")
    expect_is(a$data, "data.frame")
  })
})

test_that("cr_journals paging works correctly", {
  vcr::use_cassette("cr_journals_pagination", {

    expect_equal(NROW(cr_journals(issn = '1803-2427', works = TRUE, limit=5)$data), 5)
  })
})

test_that("cr_journals metadata works correctly", {
  vcr::use_cassette("cr_journals_metadata", {

    expect_equal(cr_journals(query="peerj", limit=4)$meta$items_per_page, 4)
  })
})

test_that("cr_journals fails correctly", {
    expect_error(cr_journals(query="peerj", limit=4, timeout_ms = 1))
})

# test_that("cr_journals facet works", {
#   vcr::use_cassette("cr_journals_faceting", {
  
#     a <- cr_journals('1803-2427', works=TRUE, facet=TRUE, limit = 0)
    
#     expect_is(a, "list")
#     expect_is(a$data, "data.frame")
#     expect_null(a$meta)
#     expect_is(a$facets, "list")
#     expect_is(a$facets$affiliation, "data.frame")
#     expect_is(a$facets$published, "data.frame")
#   })
# })


test_that("cr_journals warns correctly", {
  vcr::use_cassette("cr_journals_warns_well", {

    expect_warning(cr_journals(issn = c('blblbl', '1932-6203')),
                   regexp = "Resource not found")
    expect_equal(NROW(suppressWarnings(cr_journals(issn = c('blblbl', '1932-6203')))$data), 1)
    expect_is(suppressWarnings(cr_journals(issn = c('blblbl', '1932-6203'))), "list")
  })
})

test_that("ISSNs that used to fail badly - should fail better now", {
  vcr::use_cassette("cr_journals_issn_behavior", {

    expect_warning(cr_journals("0413-6597"), "Resource not found")
    expect_warning(cr_journals(c('1932-6203', '1803-2427', "0413-6597")), 
      "Resource not found")
    expect_equal(
      NROW(
        suppressMessages(
          suppressWarnings(
            cr_journals(c('1932-6203', '1803-2427', "0413-6597"))))$data), 2)
  })
})

test_that("ISSNs that fail, and works=TRUE", {
  vcr::use_cassette("cr_journals_issn_workstrue_behavior", {

    expect_warning(cr_journals("0074-7742", works = TRUE), 
      "Resource not found")
    expect_warning(cr_journals(c("0074-7742", "1574-6941"), works = TRUE), 
      "Resource not found")
  })
})

test_that("cr_journals cursor works with progress bar", {
  vcr::use_cassette("cr_journals_with_cursor_and_progress_bar", {
    expect_output(
      cr_journals(issn='1932-6203', works = TRUE, cursor = "*",
        cursor_max = 90, limit = 30, .progress = TRUE),
      "======="
    )
  })
})
