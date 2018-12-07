context("testing cr_agency")

test_that("cr_ageny returns correct class", {
  vcr::use_cassette("cr_agency", {

    expect_is(cr_agency(dois = '10.1038/jid.2009.428'), "list")
    expect_is(cr_agency(dois = c('10.13039/100000001','10.13039/100000015')), "list")
  })
})

test_that("cr_ageny returns correct length", {
  vcr::use_cassette("cr_agency_length", {

    expect_equal(length(cr_agency(dois = c('10.13039/100000001','10.13039/100000015'))), 2)
  })
})

test_that("cr_ageny fails correctly", {
  vcr::use_cassette("cr_agency_fails_well", {

    expect_error(cr_agency(dois = cr_r(3), timeout_ms = 1))
  })
})

test_that("cr_agency - email works", {
  vcr::use_cassette("cr_agency_email_works", {
  
    Sys.setenv("crossref_email" = "name@example.com")
    expect_is(cr_agency(dois = '10.1038/jid.2009.428'), "list")
  })
})


test_that("cr_agency - email is validated", {
  vcr::use_cassette("cr_agency_email_is_validated", {
  
    Sys.setenv("crossref_email" = "name@example")
    expect_error(cr_agency(dois = '10.1038/jid.2009.428'))
  })
})

test_that("cr_agency - email NULL works", {
  vcr::use_cassette("cr_agency_null_works", {
  
    Sys.setenv("crossref_email" = "")
    expect_is(cr_agency(dois = '10.1038/jid.2009.428'), "list")
  })
})
