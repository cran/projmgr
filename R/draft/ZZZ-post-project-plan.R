
# post_project_plan <- function(ref, project_plan){
#
#   # post milestones to repo and capture identifiers ----
#   posted_milestones <-
#     purrr::map_df(
#       unique(project_plan$milestone),
#       ~post_milestone(ref, .x)
#     )
#
#   # append milestone identifiers to project plan ----
#   project_plan <-
#     dplyr::left_join(
#       project_plan,
#       posted_milestones,
#       by = c("milestone" = "title")) %>%
#     tidyr::unnest()
#
#   # post issues with link to milestone ----
#   posted_issues <-
#     project_plan %>%
#     dplyr::transmute(
#       title = issue,
#       body = details,
#       milestone = milestone_num
#     ) %>%
#     purrr::pmap_df(
#       function(title, body, milestone)
#         post_issue(ref, title, body, milestone = milestone)
#     )
#
#   # return posted issues to signify success ----
#   return(posted_issues)
#
# }
