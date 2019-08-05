names(my_plan)

# any milestone must have a title
purrr::map(my_plan, names) %>%
  purrr::map_lgl(~length(intersect(., "title")) == 1) %>%
  all()

# any issues must have titles
purrr::map(my_plan, "issue") %>%
  purrr::modify_depth(2, "title") %>%
  purrr::map_dbl(~sum(is.na(.)))
