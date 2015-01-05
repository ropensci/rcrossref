# # context("testing cr_ft_text")
# 
# links <- cr_ft_links("10.3897/phytokeys.42.7604", "all")
# xml1 <- cr_ft_text(links, 'xml')
# pdf_read <- cr_ft_text(links, "pdf", read=FALSE, verbose = FALSE)
# pdf <- cr_ft_text(links, "pdf", verbose = FALSE)
# 
# test_that("cr_ft_text returns correct class", {
#   expect_is(xml1, "XMLInternalDocument")
#   expect_is(pdf_read, "character")
#   expect_is(pdf, "xpdf_char")
# })
# 
# test_that("cr_ft_text dimensions are correct", {
#   expect_equal(length(xml1), 1)
#   expect_equal(length(pdf_read), 1)
#   expect_equal(length(pdf), 2)
#   expect_equal(length(pdf$meta), 14)
#   expect_equal(length(pdf$data), 1)
# })
# 
# test_that("cr_ft_text gives back right values", {
#   library("XML")
#   expect_match(xpathApply(xml1, "//ref", xmlValue)[[1]], "Ake AssiL")
#   expect_match(pdf_read, "~/.crossref")
#   
# #   nms <- c('Title','Author','Creator','Producer','CreationDate','ModDate','Tagged','Form',
# #            'Pages','Encrypted','Page size','File size','Optimized','PDF version')
# #   expect_named(pdf$meta, nms)
# })
# 
# test_that("cr_ft_text fails correctly", {
#   expect_error(cr_ft_text(), 'argument "url" is missing')
#   expect_error(cr_ft_text("3434"), "Chosen type value not available in links")
#   expect_error(cr_ft_text(links, type = "adfasf"), "'arg' should be one of")
# })
