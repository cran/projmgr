#' Get comments from GitHub repository
#'
#' @inheritParams get_issues
#'
#' @return List of all comments from GitHub repo
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker <- create_repo_reference('emilyriederer', 'tidytracker')
#' tt_comments_res <- get_comments(tidytracker)
#' tt_comments <- parse_comments(tt_comments_res)
#' }

get_comments <- function(ref, ...){

  req <-
    httr::GET(
      url = paste0(ref$base_url,"/issues/comments"),
      query = list(state = "all", per_page = 100, page = 1, ...),
      config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
      encode = "json"
    )

  res <- httr::content(req)
  res

}
