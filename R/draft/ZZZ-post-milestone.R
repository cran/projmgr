#' Post milestone to GitHub repository
#'
#' This function creates a new milestone in the speciied GitHub repository.
#'
#' @inheritParams get_issues
#' @param title Milestone title
#' @param description Milestone description
#' @param ... Additional milestone fields such as \code{due_on} or \code{state}
#'
#' @return Single-row \code{tibble} with columns \code{post_status} (API status code),
#'     \code{issue_num} (issue ID number), \code{title} (user-supplied). \code{post_status} value of
#'     201 denotes success. Other numbers denote failure. In case of duplicate titles,
#'     \code{post_status} takes value of "Duplicate" to signify API call was not attempted.
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker <- create_repo_reference('emilyriederer', 'tidytracker')
#' post_milestone(tidytracker,
#'     title = "my milestone title",
#'     description = "my milestone description",
#'     state = "open",
#'     due_on = "2020-12-31T12:59:59Z")
#' }

post_milestone <- function(ref, title, description = "", ...) {

  req <-
    httr::POST(
      paste0(ref$base_url, "/milestones"),
      body = list(title = title,
                  description = description,
                  ...),
      config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
      encode = "json")

  results <- tibble::tibble(
    post_status = as.character(httr::status_code(req)),
    milestone_num = ifelse(httr::status_code(req) == 201, httr::content(req)$number, NA),
    title = title
  )

  return(results)

}
