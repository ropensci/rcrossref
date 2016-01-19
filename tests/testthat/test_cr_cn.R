context("testing cr_cn")

test_that("cr_cn returns", {
  skip_on_cran()
  
  b <- cr_cn(dois = "10.1126/science.169.3946.635", format = "citeproc-json")
  c <- cr_cn("10.1126/science.169.3946.635", "rdf-xml")
  d <- cr_cn("10.1126/science.169.3946.635", "crossref-xml")
  e <- cr_cn("10.1126/science.169.3946.635", "bibentry")
  f <- cr_cn("10.1126/science.169.3946.635", "text", "apa")
  g <- cr_cn("10.5604/20831862.1134311", "crossref-tdm")
  h <- cr_cn("10.3233/ISU-150780", "onix-xml")
  
  # correct classes
  expect_is(b, "list")
  expect_is(c, "XMLInternalDocument")
  expect_is(d, "XMLInternalDocument")
  expect_is(e, "bibentry")
  expect_is(f, "character")
  expect_is(g, "XMLInternalDocument")
  expect_is(h, "XMLInternalDocument")
  
  # correct values
  expect_match(b$`container-title`, "Science")
  expect_match(unclass(e)[[1]]$year, "1970")
})

test_that("cr_cn fails correctly", {
  skip_on_cran()
  
  library('httr')
  expect_error(cr_cn(dois="10.1126/science.169.3946.635", config=timeout(0.01)))
})

test_that("cr_cn checks if doi agency supports format", {
  skip_on_cran()
  
  expect_error(cr_cn("10.3233/ISU-150780", "crossref-tdm"))
  expect_error(cr_cn("10.4225/55/5568087BB3A88", "citeproc-json"))
  expect_error(cr_cn("10.1126/science.169.3946.635", "onix-xml"))
})
