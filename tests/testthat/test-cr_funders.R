context("testing cr_funders")


vcr::use_cassette("cr_funders", {
  test_that("cr_funders returns", {

    a <- suppressWarnings(cr_funders(dois=c('10.13039/100000001',
                                            '10.13039/100000015')))
    b <- suppressWarnings(cr_funders(dois='10.13039/100000001', 
                                     works=TRUE, limit=5))

    # correct clases
    expect_is(suppressWarnings(cr_funders(query="NSF", limit=1)), "list")
    expect_is(a, "list")
    expect_is(a[[1]]$data, "data.frame")
    expect_is(a[[1]]$descendants, "character")

    expect_is(b, "list")
    expect_is(b$data, "tbl_df")

    # dimensions are correct
    expect_equal(length(a), 2)
    expect_equal(length(b), 3)
  })
})

vcr::use_cassette("cr_funders_faceting", {
  test_that("cr_funders facet works", {
  
    a <- cr_funders("10.13039/100000001", works=TRUE, facet=TRUE, limit = 0)
    
    expect_is(a, "list")
    expect_is(a$data, "data.frame")
    expect_is(a$meta, "data.frame")
    expect_is(a$facets, "list")
    expect_is(a$facets$affiliation, "data.frame")
    expect_is(a$facets$published, "data.frame")
  })
})


vcr::use_cassette("cr_funders_fails_well", {
  test_that("cr_funders fails correctly", {

    expect_warning(cr_funders(dois = '10.13039/100000001afasfasdf'),
                 "Resource not found")
  })
})

vcr::use_cassette("cr_funders_email_works", {
  test_that("cr_works - email works", {
  
    Sys.setenv("crossref_email" = "name@example.com")
    expect_is(cr_funders(dois=c('10.13039/100000001')), "list")
  })
})


vcr::use_cassette("cr_funders_email_is_validated", {
  test_that("cr_funders - email is validated", {
  
    Sys.setenv("crossref_email" = "name@example")
    expect_error(cr_funders(dois=c('10.13039/100000001')))
  })
})

vcr::use_cassette("cr_funders_email_null_works", {
  test_that("cr_funders - email NULL works", {
  
    Sys.setenv("crossref_email" = "")
    expect_is(cr_funders(dois=c('10.13039/100000001')), "list")
  })
})

test_that("cr_funders cursor works with progress bar", {
  vcr::use_cassette("cr_funders_with_cursor_and_progress_bar", {
    expect_output(
      cr_funders('100000001', works = TRUE, cursor = "*",
        cursor_max = 90, limit = 30, .progress = TRUE),
      "======="
    )
  })
})
