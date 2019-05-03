context("testing cr_cn")

test_that("cr_cn returns", {
  vcr::use_cassette("cr_cn_citeproc_json", {
    b <- cr_cn(dois = "10.1126/science.169.3946.635", format = "citeproc-json")
    expect_is(b, "list")
    expect_match(b$`container-title`, "Science")
  })

  vcr::use_cassette("cr_cn_bibentry", {
    e <- cr_cn("10.1126/science.169.3946.635", "bibentry")
    expect_is(e, "list")
    expect_match(e$year, "1970")
  })

  vcr::use_cassette("cr_cn_xml_types", {
    c <- cr_cn("10.1126/science.169.3946.635", "rdf-xml")
    expect_is(c, "xml_document")

    d <- cr_cn("10.1126/science.169.3946.635", "crossref-xml")
    expect_is(d, "xml_document")

    h <- cr_cn("10.3233/ISU-150780", "onix-xml")
    expect_is(h, "xml_document")
  }, preserve_exact_body_bytes = TRUE)
})

test_that("cr_cn fails correctly", {
  vcr::use_cassette("cr_cn_fails_well", {

    expect_error(cr_cn(dois="10.1126/science.169.3946.635", timeout_ms = 1))
  })
})

test_that("DOIs with no agency found still work, at least some do", {
  vcr::use_cassette("cr_cn_no_agency_still_work", {

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
})

test_that("cr_cn checks if doi agency supports format", {
  vcr::use_cassette("cr_cn_doi_agency_check", {

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
})

test_that("cr_cn works with different URLs", {
  vcr::use_cassette("cr_cn_different_base_urls", {

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
  }, preserve_exact_body_bytes = TRUE)
})
