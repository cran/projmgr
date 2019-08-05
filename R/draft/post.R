#' Post issue to GitHub repository
#'
#' @inherit post_engine params
#' @param title Issue title (required)
#' @param distinct Logical value to denote whether issues with the same title
#'     as a current open issue should be allowed
#' @export
#' @family post
#' @family issues
#'
#' @return Number (identifier) of posted issue
#'
#' @examples
#' \dontrun{
#' myrepo <- create_repo_ref('emilyriederer', 'myrepo')
#' post_issue(myrepo,
#'   title = 'this is my issue's title',
#'   body = 'this is my issue's body',
#'   labels = c('priority:high', 'bug'))
#' }
#' \dontrun{
#' # can be used in conjunction with reprex pkg
#' # example assumes code for reprex is on clipboard
#' reprex::reprex(venue = "gh")
#' post_issue(myrepo,
#'             title = "something is broken",
#'             body = paste( clipr::read_clip(), collapse = "\n") )
#' }

post_issue <- function(ref, title, ..., distinct = TRUE){

  # check for unique title if desired ----
  if(distinct){

    issue_titles <- purrr::map_chr( get_issues(ref, state = 'open') , "title" )

    if(any(title == issue_titles)){ # when title not distinct
      stop(
        paste("New title is not distinct with current open issues. \n",
              "Please change title or set distinct = FALSE."),
             call. = FALSE
              )
      }
  }

  # check that rest of inputs are valid per github api ----
  args <- list(...)

  validate_inputs(args,
                  allowed_vars = c("body", "milestone",
                                   "labels", "assignees"))

  # clean inputs ----
  if(any(names(args) == "due_on")){
    args[['due_on']] <- convert_timestamp(args[['due_on']])
  }
  if(any(names(args) == 'assignees')){
    args[['assignees']] <- convert_array(args[['assignees']])
  }
  if(any(names(args) == 'labels')){
    args[['labels']] <- convert_array(args[['labels']])
  }



  # post results ----
  api_fx <-
    function(...){
            api_engine(
             api_endpoint = "/issues",
             method = "POST",
             ref = ref,
             title = title,
             ...)
    }

  res <- do.call(api_fx, args)

  return( res[['number']] )

}
