test_that("field queries: flq", {
  expect_is(flq_set, "character")
  expect_true(all(grepl('query\\.', flq_set)))
})

test_that("field queries: field_query_handler", {
  expect_is(field_query_handler, "function")
  expect_null(field_query_handler(NULL))
  expect_error(field_query_handler(list(query.foobar = "foobar")))
  expect_is(field_query_handler(list(query.author = "foobar")), "list")
})

test_that("field queries: cr_works errors as expected", {
  expect_error(
    cr_works(query = "ecology", flq = c(query.title = 'cell'))
  )
})
