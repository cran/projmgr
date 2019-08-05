#' Post issue to GitHub repository
#'
#' Post issue to specified GitHub repository. This function will check that the title you have
#' specified is not already in use by a currently open issue on the repository. If so, it will
#' returns wth an error message and will not post the issue.
#'
#' @param title Issue title. Title must be unique from current open issues in specified repo.
#' @param body Issue body/text/description
#' @param ... Additional arguments passed into POST query. Often used for \code{labels} to pass
#'     character vector of labels for use on the issue
#' @inheritParams get_issues
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
#' post_issue(tidytracker,
#'   'this is my issue's title',
#'   'this is my issue's body',
#'   labels = c('priority:high', 'bug'))
#' }

post_issue <- function(ref, title, body, ...){

  # pull existing issues
  curr_issues <- get_issues(ref)

  if(length(curr_issues) > 0){

    curr_issue_titles <-
      curr_issues %>%
      parse_issue_overview() %>%
      dplyr::filter(state == "open") %>%
      dplyr::pull(title) %>%
      unique()

  }
  else{
    curr_issue_titles <- c()
  }

  # throw error and exit if issue of same name already exists
  if(title %in% curr_issue_titles){
    return(
      tibble::tibble(
        post_status = "Duplicate",
        issue_num = NA_real_
        ))
  }

  req <-
  httr::POST(
    paste0(ref$base_url,"/issues"),
    body = list(title = title, body = body, ...),
    config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
    encode = "json")

  results <- tibble::tibble(
    post_status = as.character(httr::status_code(req)),
    issue_num = ifelse(httr::status_code(req) == 201, httr::content(req)$number, NA),
    title = title
  )

  return(results)

}
