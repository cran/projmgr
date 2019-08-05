#' Parse milestones from \code{get_milestones}
#'
#' @inheritParams parse_issue_overview
#'
#' @return `tibble` datasets with one record / milestone
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker_ref <- create_repo_reference("emilyriederer", "tidytracker")
#' tt_milestones_res <- get_milestones(tidytracker_ref)
#' tt_milestones <- parse_milestones(tt_milestones_res)
#' }

parse_milestones <- function(res){

  purrr::map_df(1:length(res),
                ~tibble::tibble(
                  title = res[[.]]$title,
                  number = res[[.]]$number,
                  description = res[[.]]$description %||% NA,
                  creator = res[[.]]$creator$login,
                  open_issues = res[[.]]$open_issues,
                  closed_issues = res[[.]]$closed_issues,
                  state = res[[.]]$state,
                  created_at = substring(res[[.]]$created_at %||% NA, 1, 10),
                  updated_at = substring(res[[.]]$updated_at %||% NA, 1, 10),
                  due_on = substring(res[[.]]$due_on %||% NA,1,10),
                  closed_at = substring(res[[.]]$closed_at %||% NA,1,10)
                ))

}
