#' Get issues from GitHub repository
#'
#' @param ref Repository reference (list) created by \code{tidytracker::create_repo_reference}
#' @param ... Additional arguments passed to the GET query
#'
#' @return List of issues from GitHub repository
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker <- create_repo_reference('emilyriederer', 'tidytracker')
#' tt_issues_res <- get_issues(tidytracker)
#' tt_issues <- parse_issues(tt_issues_res)
#' }

get_issues <- function(ref, ...){

  req <-
    httr::GET(
      url = paste0(ref$base_url,"/issues"),
      query = list(state = "all", per_page = 100, page = 1, ...),
      config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
      encode = "json"
    )

  res <- httr::content(req)
  res

}
