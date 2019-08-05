#' Parse issues overview from \code{get_issues}
#'
#' @param res R list returned by corresponding \code{get_} function
#'
#' @return \code{tibble} datasets with one record / issue
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker <- create_repo_reference('emilyriederer', 'tidytracker')
#' tt_issues_res <- get_issues(tidytracker)
#' tt_issues <- parse_issues(tt_issues_res)
#' }

parse_issue_overview <- function(res){

  purrr::map_df(1:length(res),
                ~tibble::tibble(
                  title = res[[.]]$title,
                  body = res[[.]]$body %||% NA,
                  state = res[[.]]$state,
                  created_at = res[[.]]$created_at %>% substring(1,10),
                  closed_at = substring(res[[.]]$closed_at %||% NA, 1,10),
                  created_by = res[[.]]$user$login,
                  n_comments = res[[.]]$comments,
                  url = res[[.]]$html_url,
                  id = res[[.]]$number,
                  milestone_title = res[[.]]$milestone$title %||% NA,
                  milestone_id = res[[.]]$milestone$id %||% NA,
                  milestone_state = res[[.]]$milestone$state %||% NA,
                  due_on = substring(res[[.]]$milestone$due_on %||% NA,1,10),
                  point_of_contact = res[[.]]$assignee$login %||% NA,
                  assignee = list(res[[.]]$assignees %>% purrr::map_chr('login')),
                  label = list(res[[.]]$labels %>% purrr::map_chr('name'))
                ))

}

#' Parse issue assignees from \code{get_issues}
#'
#' @inheritParams parse_issue_overview
#'
#' @return `tibble` datasets with one record / issue-assignee
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker <- create_repo_reference('emilyriederer', 'tidytracker')
#' tt_issues_res <- get_issues(tidytracker)
#' tt_issue_assignees <- parse_issue_assignees(tt_issues_res)
#' }

parse_issue_assignees <- function(res){

  purrr::map_df(1:length(res),
                ~tibble::tibble(
                  id = res[[.]]$number,
                  assignee = list(res[[.]]$assignees %>% purrr::map_chr('login'))
                )) %>%
    tidyr::unnest()

}

#' Parse issue labels from \code{get_issues}
#'
#' @inheritParams parse_issue_overview
#'
#' @return `tibble` datasets with one record / issue-labels
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker <- create_repo_reference('emilyriederer', 'tidytracker')
#' tt_issues_res <- get_issues(tidytracker)
#' tt_issue_labels <- parse_issue_labels(tt_issues_res)
#' }

parse_issue_labels <- function(res){

  purrr::map_df(1:length(res),
                ~tibble::tibble(
                  id = res[[.]]$number,
                  label = list(res[[.]]$labels %>% purrr::map_chr('name'))
                )) %>%
    tidyr::unnest() %>%
    tidyr::separate(label, into = c("super", "sub"), sep = ":", remove = FALSE)

}

#' Parse issues comments from \code{get_issues}
#'
#' @inheritParams parse_issue_overview
#'
#' @return \code{tibble} datasets with one record / issue-comment
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker <- create_repo_reference('emilyriederer', 'tidytracker')
#' tt_issues_res <- get_issues(tidytracker)
#' tt_issue_comments <- parse_issue_comments(tt_issues_res)
#' }

parse_issue_comments <- function(res){

  purrr::map_df(1:length(res),
                ~tibble::tibble(
                  user = res[[.]]$user$login,
                  created_at = res[[.]]$created_at %>% substring(1,10),
                  body = res[[.]]$body,
                  url = res[[.]]$html_url
                )
  )
}

