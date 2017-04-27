library("devtools")

res <- revdep_check(threads = 4)
revdep_check_save_summary()
revdep_check_print_problems()
#revdep_email(date = "April 27", only_problems = FALSE, draft = TRUE)
