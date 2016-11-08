context("cr_ft_text")

# out <- cr_works(
#   filter = list(has_full_text = TRUE, license_url = "http://creativecommons.org/licenses/by/4.0/"),
#   limit = 100
# )

# links <- cr_ft_links("10.7717/peerj.1282")
# xml1 <- cr_ft_text(links, 'xml')

test_that("cr_ft_text works: pdf", {
  skip_on_cran()

  links <- cr_ft_links("10.1155/mbd.1994.183", "all")
  pdf_read <- cr_ft_text(links, "pdf", read = FALSE, verbose = FALSE)
  pdf <- cr_ft_text(links, "pdf", verbose = FALSE)

  #expect_is(xml1, "xml_document")
  expect_is(pdf_read, "character")
  expect_is(pdf, "xpdf_char")

  #expect_equal(length(xml1), 2)
  expect_equal(length(pdf_read), 1)
  expect_equal(length(pdf), 2)
  expect_gt(length(pdf$meta), 5)
  expect_equal(length(pdf$data), 1)
})

# test_that("cr_ft_text gives back right values", {
#   library("xml2")
#   expect_match(xml2::xml_find_all(xml1, "//ref")[[1]], "Ake AssiL")
#   expect_match(pdf_read, "~/.crossref")
# })

test_that("cr_ft_text fails correctly", {
  skip_on_cran()

  expect_error(cr_ft_text(), 'argument "url" is missing')
  expect_error(cr_ft_text("3434"), "a character vector argument expected")

  links <- cr_ft_links("10.1155/mbd.1994.183", "all")
  expect_error(cr_ft_text(links, type = "adfasf"), "'arg' should be one of")
})

Sys.sleep(1)
