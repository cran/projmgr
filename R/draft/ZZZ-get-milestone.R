#' Get milestones from GitHub repository
#'
#' @inheritParams get_issues
#'
#' @return List of milestones from GitHub repository
#' @export
#'
#' @examples
#' \dontrun{
#' repo <- create_repo_reference("emilyriederer", "tidytracker")
#' tt_milestones_res <- get_milestones(tidytracker)
#' milestones <- parse_milestones(tt_milestones_res)
#' }

get_milestones <- function(ref, ...){

  req <-
    httr::GET(
      url = paste0(ref$base_url,"/milestones"),
      query = list(state = "all", per_page = 100, page = 1, ...),
      config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
      encode = "json"
    )

  res <- httr::content(req)
  res

}
