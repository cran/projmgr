#' Core code for all API calls
#'
#' @param api_endpoint API endpoint
#' @param method Type of API call (e.g. GET, POST, PATCH)
#' @param ref Repository reference (list) created by \code{create_repo_ref()}
#' @param limit Number or records to return
#' @param ... Additional user-defined body parameters
#'
#' @keywords internal
#' @return Content of PATCH request as list

api_engine <- function(api_endpoint,
                       method = c('GET', 'POST', 'PATCH', 'DELETE'),
                       limit = Inf,
                       ref, ...){

  gh::gh(
    endpoint = paste0(ref$base_url, ref$repo_path, api_endpoint),
    ...,
    .token = Sys.getenv(ref$id),
    .method = method,
    .limit = limit,
    .send_headers = c("User-Agent" = "https://github.com/emilyriederer/tidytracker")
  )

}
