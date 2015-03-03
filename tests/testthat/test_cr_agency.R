context("testing cr_agency")

test_that("cr_ageny returns correct class", {
	 expect_is(cr_agency(dois = '10.1038/jid.2009.428'), "list")
   expect_is(cr_agency(dois = c('10.13039/100000001','10.13039/100000015')), "list")
})

test_that("cr_ageny returns correct length", {
  expect_equal(length(cr_agency(dois = c('10.13039/100000001','10.13039/100000015'))), 2)
})

test_that("cr_ageny fails correctly", {
  library('httr')
  expect_error(cr_agency(dois = cr_r(3), config=timeout(0.01)))
})
