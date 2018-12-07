context("testing cr_funders")


test_that("cr_funders returns", {
  vcr::use_cassette("cr_funders", {

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

test_that("cr_funders facet works", {
  vcr::use_cassette("cr_funders_faceting", {
  
    a <- cr_funders("10.13039/100000001", works=TRUE, facet=TRUE, limit = 0)
    
    expect_is(a, "list")
    expect_is(a$data, "data.frame")
    expect_is(a$meta, "data.frame")
    expect_is(a$facets, "list")
    expect_is(a$facets$affiliation, "data.frame")
    expect_is(a$facets$published, "data.frame")
  })
})


test_that("cr_funders fails correctly", {
  vcr::use_cassette("cr_funders_fails_well", {

    expect_warning(cr_funders(dois = '10.13039/100000001afasfasdf'),
                 "Resource not found")
  })
})

test_that("cr_works - email works", {
  vcr::use_cassette("cr_funders_email_works", {
  
    Sys.setenv("crossref_email" = "name@example.com")
    expect_is(cr_funders(dois=c('10.13039/100000001')), "list")
  })
})


test_that("cr_funders - email is validated", {
  vcr::use_cassette("cr_funders_email_is_validated", {
  
    Sys.setenv("crossref_email" = "name@example")
    expect_error(cr_funders(dois=c('10.13039/100000001')))
  })
})

test_that("cr_funders - email NULL works", {
  vcr::use_cassette("cr_funders_email_null_works", {
  
    Sys.setenv("crossref_email" = "")
    expect_is(cr_funders(dois=c('10.13039/100000001')), "list")
  })
})
