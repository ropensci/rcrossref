context("testing cr_ft_text")

out <- cr_members(2258, filter=c(has_full_text = TRUE), works = TRUE)
links <- cr_ft_links(out$data$DOI[1], "all")
xml1 <- cr_ft_text(links, 'xml')
pdf_read <- cr_ft_text(links, "pdf", read=FALSE)
pdf <- cr_ft_text(links, "pdf")

test_that("cr_ft_text returns correct class", {
  expect_is(a, "tdmurl")
  expect_is(a[[1]], "character")

  expect_is(b, "tdmurl")
  expect_is(attr(b, "type"), "character")

  expect_is(d, "list")
  expect_is(d[[1]], "tdmurl")
  expect_is(attr(d[[2]], "type"), "character")
})

test_that("cr_ft_text dimensions are correct", {
  expect_equal(length(a), 1)
  expect_equal(length(b), 1)
  expect_equal(length(c), 1)
  expect_equal(length(d), 2)
  expect_equal(length(d[[1]]), 1)
})

test_that("cr_ft_text gives back right values", {
  expect_equal(attr(a, "type"), "pdf")
  expect_equal(attr(b, "type"), "xml")
  expect_equal(attr(d[[2]], "type"), "plain")

  expect_null(cr_ft_text(cr_r(1)))
})

test_that("cr_ft_text fails correctly", {
  expect_error(cr_ft_text(), 'argument "doi" is missing')
  expect_error(cr_ft_text("3434"), "is not TRUE")
})
