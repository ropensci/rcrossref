# context("testing pmd2doi")

# a <- doi2pmid("10.1016/0006-2944(75)90147-7")
# b <- doi2pmid("10.1016/0006-2944(75)90147-7", TRUE)
# c <- doi2pmid(c("10.1016/0006-2944(75)90147-7","10.1186/gb-2008-9-5-r89"))
# d <- pmid2doi(18507872)
# e <- pmid2doi(18507872, TRUE)
# f <- pmid2doi(c(1,2,3))

# test_that("pmd2doi returns correct class", {
#   expect_is(a, "data.frame")
#   expect_is(b, "integer")
#   expect_is(c, "data.frame")
#   expect_is(d, "data.frame")
#   expect_is(e, "character")
#   expect_is(f, "data.frame")

#   expect_is(a$doi, "character")
# })

# test_that("pmd2doi dimensions are correct", {
#   expect_equal(NCOL(a), 2)
#   expect_equal(length(b), 1)
#   expect_equal(NCOL(c), 2)
#   expect_equal(NCOL(d), 2)
#   expect_equal(length(e), 1)
#   expect_equal(NCOL(f), 2)
# })

# test_that("pmd2doi fails correctly", {
#   library('httr')
#   expect_error(pmid2doi())
#   expect_error(pmid2doi(18507872, config=timeout(0.01)))
# })
