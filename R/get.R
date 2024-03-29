#' Get issues from GitHub repository
#'
#' A single issue can be obtained by identification number of `number` is passed through `...`s.
#' In this case, all other query parameters will be ignored.
#'
#' @inherit get_engine return params
#' @param limit Number of records to return, passed directly to `gh` documentation. Defaults to
#'     1000 and provides message if number of records returned equals the limit
#'
#' @export
#' @family issues
#'
#' @examples
#' \dontrun{
#' myrepo <- create_repo_ref('emilyriederer', 'myrepo')
#' issues_res <- get_issues(myrepo)
#' issues <- parse_issues(issues_res)
#' }

get_issues <- function(ref, limit = 1000, ...){

  args <- list(...)

  if("number" %in% names(args)){

    message("'number' parameter supercedes all other options passed to get_issues")
    res <- get_engine(api_endpoint = paste("/issues/", args$number), ref = ref)
    return(res)

  }

  validate_inputs(args, help_get_issues())

  res <- get_engine(api_endpoint = "/issues",
                    ref = ref,
                    limit = limit,
                    ...)

  # notify user if seem to be hitting record limit
  if(length(res) == limit){
    message(
      paste("Number of results equals max number allowed by limit argument.",
            "Additional relevant records may be getting excluded.",
            "Consider making your query more specific or increasing the limit."),
      sep = "/n")
  }

  return(res)

}

#' Get events for a specific issue from GitHub repository
#'
#' In addition to information returned by GitHub API, appends field "number" for the issue number
#' to which the returned events correspond.
#'
#' @inherit get_engine return params
#'
#' @inheritParams get_issues
#' @param dummy_events Logical for whether or not to create a 'dummy' event to denote the
#'     existence of issues which have no events. Defaults to TRUE (to allow creation). Default
#'     behavior makes the process of mapping over multiple issues simpler.
#' @param number Number of issue
#'
#' @export
#'
#' @family issues
#' @family events
#'
#' @examples
#' \dontrun{
#' myrepo <- create_repo_ref('emilyriederer', 'myrepo')
#'
#' # single issue workflow
#' events_res <- get_issue_events(myrepo, number = 1)
#' events <- parse_issue_events(events_res)
#'
#' # multi-issue workflow
#' issue_res <- get_issues(my_repo, state = 'open')
#' issues <- parse_issues(issues_res)
#' events <- purrr::map_df(issues$number, ~get_issue_events(myrepo, .x) %>% parse_issue_events())
#' }

get_issue_events <- function(ref, number, dummy_events = TRUE){

  res <- get_engine(api_endpoint = paste0("/issues/", number, "/events"),
                    ref = ref)

  # append the relevant issue number to each element
  if (res != "") {
    res <- lapply(res,
                  FUN = function(x){
                    x[["number"]] = number
                    return(x)
                  })
  }
  else if(dummy_events) {# when there were no results, create mock result for easy mapping
    res <- list(list(
        id = -9999,
        number = number,
        event = "exists"
    ))
  }
  res

}

#' Get comments for a specific issue from GitHub repository
#'
#' In addition to information returned by GitHub API, appends field "number" for the issue number
#' to which the returned comments correspond.
#'
#' @inherit get_engine return params
#' @param number Number of issue
#' @export
#'
#' @family issues
#' @family comments
#'
#' @examples
#' \dontrun{
#' myrepo <- create_repo_ref('emilyriederer', 'myrepo')
#' comments_res <- get_issue_comments(myrepo, number = 1)
#' comments <- parse_issue_comments(comments_res)
#' }

get_issue_comments <- function(ref, number, ...){

  validate_inputs(list(...), help_get_issue_comments())

  res <- get_engine(api_endpoint = paste0("/issues/", number, "/comments"),
                    ref = ref)

  # append the relevant issue number to each element
  if( res != "" ){
    res <- lapply(res,
                  FUN = function(x){
                    x[["number"]] = number
                    return(x)
                  })
  }
  res

}

#' Get milestones from GitHub repository
#'
#' A single milestone can be obtained by identification number of `number` is passed through `...`s.
#' In this case, all other query parameters will be ignored.
#'
#' @inherit get_engine return params
#' @export
#'
#' @family milestones
#'
#' @examples
#' \dontrun{
#' myrepo <- create_repo_ref("emilyriederer", "myrepo")
#' milestones_res <- get_milestones(myrepo)
#' milestones <- parse_milestones(milestones_res)
#' }

get_milestones <- function(ref, ...){

  args <- list(...)

  if ("number" %in% names(args)) {
    message("'number' parameter supercedes all other options passed to get_milestones")
    res <- get_engine(api_endpoint = paste("/milestones/", args$number), ref = ref)
    return(res)
  }

  validate_inputs(list(...), allowed_vars = help_get_milestones())

  get_engine(api_endpoint = "/milestones",
             ref = ref,
             ...)

}


#' Get all labels for a repository
#'
#' @inherit get_engine return params
#' @export
#'
#' @family labels
#'
#' @examples
#' \dontrun{
#' labels_res <- get_repo_labels(my_repo)
#' labels <- parse_repo_labels(labels_res)
#' }

get_repo_labels <- function(ref) {

  get_engine(api_endpoint = "/labels", ref = ref)

}

