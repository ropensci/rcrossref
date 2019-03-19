context("testing cr_works_")

vcr::use_cassette("cr_works_", {
  test_that("cr_works_ works", {

    a <- cr_works_(query="NSF")
    b <- cr_works_(query="renear+-ontologies")
    c <- cr_works_(query="global state", filter=c(has_orcid=TRUE), limit=3)

    # correct class
    expect_is(a, "character")
    expect_is(b, "character")
    expect_is(c, "character")

    a <- pj(a)
    b <- pj(b)
    c <- pj(c)

    expect_equal(sort(names(a)), 
      c('message', 'message-type', 'message-version', 'status'))
    expect_equal(a$status, "ok")
    expect_is(a$`message-version`, "character")
    expect_equal(a$`message-type`, "work-list")
    expect_is(a$message, "list")
    expect_equal(sort(names(a$message)), 
      c('facets', 'items', 'items-per-page', 'query', 'total-results'))

    # dimensions are correct
    expect_equal(length(a), 4)
    expect_equal(length(b), 4)
    expect_equal(length(c), 4)
  })
})

vcr::use_cassette("cr_works__fails_well", {
  test_that("cr_works_ fails correctly", {
    expect_error(cr_works_(timeout_ms = 1))
    expect_equal(
      jsonlite::fromJSON(cr_works_(query = "adfaaf"))$message$`total-results`, 
      0
    )
  })
})

vcr::use_cassette("cr_works__warns_well", {
  test_that("cr_works_ warns correctly", {
    expect_warning(cr_works_(dois = c('blblbl', '10.1038/nnano.2014.279')), 
      "Resource not found")

    res <- suppressWarnings(
      cr_works_(dois = c('blblbl', '10.1038/nnano.2014.279')))
    expect_null(res[[1]]$message)
    expect_is(res[[2]], "character")
  })
})

vcr::use_cassette("cr_works__parses_links", {
  test_that("cr_works_ - parses links data correctly", {
    aa <- pj(cr_works_(filter = c(has_full_text = FALSE), limit = 3))
    bb <- pj(cr_works_(filter = c(has_full_text = TRUE), limit = 3))

    expect_is(aa, "list")
    expect_is(bb, "list")

    expect_null(aa$message$items$link)
    expect_is(bb$message$items$link, "list")
    expect_is(bb$message$items$link[[1]], "data.frame")
    expect_match(bb$message$items$link[[1]]$URL, "http")
  })
})

vcr::use_cassette("cr_works__parses_funders", {
  test_that("cr_works_ - parses funders correctly", {

    doi <- "10.1515/crelle-2013-0024"
    aa <- cr_works_(doi)

    expect_is(aa, "character")

    aa <- pj(aa)

    expect_is(aa, "list")
    expect_is(aa$message, "list")
    expect_is(aa$message$`container-title`, "character")
    expect_equal(aa$message$facets, NULL)
    expect_is(aa$message$funder, "data.frame")
    expect_true(any(grepl("award", names(aa$message$funder))))

    doi <- "10.1186/isrctn11093872"
    bb <- pj(cr_works_(doi))
    expect_true(any(grepl("funder", names(bb$message))))
    expect_named(bb$message$funder, c("DOI", "name", "doi-asserted-by", "award"))
  })
})

test_that("cr_works_ - async", {
  skip_on_cran() # async mocking/webmockr/vcr not supported yet
  
  queries <- c("ecology", "science", "cellular", "birds", "European",
    "bears", "beets", "laughter", "hapiness", "funding")
  x <- cr_works_(query = queries, async = TRUE)
  expect_true(all( unname(vapply(x, class, "")) == "character" ))
  expect_equal(length(queries), length(x))
  expect_is(jsonlite::fromJSON(x[[1]])$message, "list")
})
