context("testing cr_search_free")

a <- cr_search_free(query = "Piwowar Sharing Detailed Research Data Is Associated with Increased Citation Rate PLOS one 2007")
b <- cr_search_free(query="Renear 2012")
c <- doi <- cr_search_free(query="Piwowar sharing data PLOS one")$doi
d <- cr_search(doi = doi)
queries <- c("Piwowar sharing data PLOS one", "Priem Scientometrics 2.0 social web",
  "William Gunn A Crosstalk Between Myeloma Cells", 
  "karthik ram Metapopulation dynamics override local limits")
e <- cr_search_free(queries)

test_that("cr_search_free returns correct class", {
  expect_is(a, "data.frame")
  expect_is(b, "data.frame")
  expect_is(c, "character")
  expect_is(d, "data.frame")
  expect_is(e, "data.frame")

  expect_is(a$score, "numeric")
  expect_is(a$match, "logical")
})

test_that("cr_search_free dimensions are correct", {
  expect_equal(NCOL(a), 5)
  expect_equal(NCOL(b), 3)
  expect_equal(length(c), 1)
  expect_equal(NCOL(d), 7)
  expect_equal(NCOL(e), 5)
})

test_that("cr_search_free fails correctly", {
  library('httr')
  expect_error(cr_search_free(config=timeout(0.01)))
  expect_match(cr_search_free("Asdfadf")$reason, "Too few terms")
})
