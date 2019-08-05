#' Get repositories of a given GitHub user
#'
#' @inherit get_engine return params
#' @param user
#'
#' @export
#'
#' @examples
#' \dontrun{
#' myrepo <- create_repo_ref("emilyriederer", "myrepo")
#' repo_res <- get_user_repo()
#' }
get_user_repos <- function(ref, user = "", ...){

  validate_inputs(list(...), allowed_vars = c("type"))

  get_engine(api_endpoint = paste0("/user", ifelse(user == "", "", paste0("s/", user)), "/repos"),
             ref = ref,
             ...)


}

#' Title
#'
#' @param ref
#' @param org
#' @param ...
#'
#' @return
#' @export
#'
#' @examples
get_org_repos <- function(ref, org, ...){

  args <- list(...)

  validate_inputs(args, allowed_vars = c("type"))
  if("type" %in% names(args)){
    stopifnot(
      !(args[["type"]] %in%
          c('all', 'public', 'private', 'forked', 'sources', 'member')
      ))
  }

  get_engine(api_endpoint = paste0("/orgs/", org, "/repos"),
             ref = ref,
             ...)

}
