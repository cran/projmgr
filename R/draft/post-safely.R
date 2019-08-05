post_issue <- function(ref, title, ..., distinct = TRUE){

  # check for unique title if desired
  if(distinct){

    issue_titles <- purrr::map_chr( get_issues(ref, state = 'open') , "title" )

    if(any(title == issue_titles)){ # when title not distinct
      return("Duplicate")
    }
  }

  # check that rest of inputs are valid per github api
  validate_inputs(list(...),
                  allowed_vars = c("body", "milestone",
                                   "labels", "assignees"))

  # post issue and capture result or error
  post_engine_safely <- purrr::safely(post_engine)
  post_res <- post_engine_safely(api_endpoint = "/issues",
                                 ref = ref,
                                 title = title,
                                 ...)

  if(!is.null(post_res$result)){
    return("Success")
  }
  else{
    error_msg <-
      post_res$error %>%
      {regmatches(as.character(.), regexpr("\\([0-9]{3}\\)", as.character(.)))} %>%
      substr(2, 4 ) %>%
      as.numeric() %>%
      httr:::http_status() %>%
      .[['message']]

    return(error_msg)
  }

}
