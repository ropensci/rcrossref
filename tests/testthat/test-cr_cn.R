context("testing cr_cn")

test_that("cr_cn returns", {
  skip_on_cran()

  b <- cr_cn(dois = "10.1126/science.169.3946.635", format = "citeproc-json")
  c <- cr_cn("10.1126/science.169.3946.635", "rdf-xml")
  d <- cr_cn("10.1126/science.169.3946.635", "crossref-xml")
  e <- cr_cn("10.1126/science.169.3946.635", "bibentry")
  #f <- cr_cn(dois = "10.1126/science.169.3946.635", format = "text", style = "apa")
  # g <- cr_cn("10.5604/20831862.1134311", "crossref-tdm")
  h <- cr_cn("10.3233/ISU-150780", "onix-xml")

  # correct classes
  expect_is(b, "list")
  expect_is(c, "xml_document")
  expect_is(d, "xml_document")
  expect_is(e, "list")
  #expect_is(f, "character")
  # expect_is(g, "xml_document")
  expect_is(h, "xml_document")

  # correct values
  expect_match(b$`container-title`, "Science")
  expect_match(e$year, "1970")
})

test_that("cr_cn fails correctly", {
  skip_on_cran()

  expect_error(cr_cn(dois="10.1126/science.169.3946.635", timeout_ms = 1))
})

test_that("DOIs with no agency found still work, at least some do", {
  skip_on_cran()

  # throws warning
  # no warning thrown any longer
  # expect_warning(
  #   cr_cn("10.1890/0012-9615(1999)069[0569:EDILSA]2.0.CO;2"),
  #   "agency not found - proceeding with 'crossref'"
  # )

  # but it is successful
  expect_is(
    suppressWarnings(cr_cn("10.1890/0012-9615(1999)069[0569:EDILSA]2.0.CO;2")),
    "character"
  )
})

test_that("cr_cn checks if doi agency supports format", {
  skip_on_cran()

  expect_error(
    cr_cn(dois = "10.3233/ISU-150780", format = "crossref-tdm"),
    "not supported by the DOI registration agency: 'medra'"
  )
  # expect_error(
  #   cr_cn("10.4225/55/5568087BB3A88", "citeproc-json"),
  #   "not supported by the DOI registration agency: 'datacite'"
  # )
  expect_error(
    cr_cn("10.1126/science.169.3946.635", "onix-xml"),
    "not supported by the DOI registration agency: 'crossref'"
  )
})

test_that("cr_cn works with different URLs", {
  skip_on_cran()

  expect_match(
    cr_cn("10.1126/science.169.3946.635", "text", url = "https://data.datacite.org"),
    "Frank"
  )
  expect_match(
    cr_cn("10.1126/science.169.3946.635", "text", url = "http://dx.doi.org"),
    "Frank"
  )
  expect_match(
    cr_cn("10.5284/1011335", url = "https://citation.crosscite.org/format"),
    "Archaeology"
  )
})

Sys.sleep(2)

