context("testing cr_cn")

# a <- cr_cn(dois="10.1126/science.169.3946.635")
b <- cr_cn(dois="10.1126/science.169.3946.635", format="citeproc-json")
c <- cr_cn("10.1126/science.169.3946.635", "rdf-xml")
d <- cr_cn("10.1126/science.169.3946.635", "crossref-xml")
e <- cr_cn("10.1126/science.169.3946.635", "bibentry")
f <- cr_cn("10.1126/science.169.3946.635", "text", "apa")
# g <- cr_cn("10.1126/science.169.3946.635", "text", "oikos")

test_that("cr_cn returns correct class", {
  # expect_is(a, "character")
  expect_is(b, "list")
  expect_is(c, "XMLInternalDocument")
  expect_is(d, "XMLInternalDocument")
  expect_is(e, "bibentry")
  expect_is(f, "character")
  # expect_is(g, "character")
})

test_that("cr_cn gives correct value", {
  expect_match(b$subject[[1]], "General")
  expect_match(unclass(e)[[1]]$year, "1970")
})

test_that("cr_cn fails correctly", {
  library('httr')
  expect_error(cr_cn(dois="10.1126/science.169.3946.635", config=timeout(0.01)))
})
