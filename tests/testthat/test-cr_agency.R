context("testing cr_agency")

test_that("cr_ageny returns correct class", {
  skip_on_cran()

  expect_is(cr_agency(dois = '10.1038/jid.2009.428'), "list")
  expect_is(cr_agency(dois = c('10.13039/100000001','10.13039/100000015')), "list")
})

test_that("cr_ageny returns correct length", {
  skip_on_cran()

  expect_equal(length(cr_agency(dois = c('10.13039/100000001','10.13039/100000015'))), 2)
})

test_that("cr_ageny fails correctly", {
  skip_on_cran()

  expect_error(cr_agency(dois = cr_r(3), timeout_ms = 1))
})

test_that("cr_agency - email works", {
  skip_on_cran()
  
  Sys.setenv("crossref_email" = "name@example.com")
  expect_is(cr_agency(dois = '10.1038/jid.2009.428'), "list")
})


test_that("cr_agency - email is validated", {
  skip_on_cran()
  
  Sys.setenv("crossref_email" = "name@example")
  expect_error(cr_agency(dois = '10.1038/jid.2009.428'))
})

test_that("cr_agency - email NULL works", {
  skip_on_cran()
  
  Sys.setenv("crossref_email" = "")
  expect_is(cr_agency(dois = '10.1038/jid.2009.428'), "list")
})

Sys.sleep(2)
