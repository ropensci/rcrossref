context("Testing crossref")

random_list <- cr_r()

test_that("Random crossref search returns correct result type", {
	 expect_is(random_list, "character")
})

# entry1 <- cr_cn("10.6084/m9.figshare.97218", "bibentry")
# entry2 <- cr_cn("10.1126/science.169.3946.635", "text", "apa")
# 
# test_that("We can parse fighshare DOIs into bibentry type", {
#   expect_is(entry, "bibentry")
# })
