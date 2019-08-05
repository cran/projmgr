validate_milestone_level <- function(x){

  stopifnot("title" %in% names(x))
  nonissue_keys <- setdiff(names(x), "issue")
  invalid_keys <- setdiff(nonissue_keys, c("title", help_post_milestone()) )
  if(length(invalid_keys)>0){
    stop(paste("The following YAML keys are invalid for milestones:",
               paste(invalid_keys, collapse = ", ")))
  }

}

validate_issue_level <- function(x){

  stopifnot("title" %in% names(x))
  keys <- names(x)
  invalid_keys <- setdiff(keys, c("title", help_post_issue()))
  if(length(invalid_keys)>0){
    stop(paste("The following YAML keys are invalid for issues:",
               paste(invalid_keys, collapse = ", ")))
  }

}


validate_plan <- function(plan){

  sapply(plan, validate_milestone_level)
  sapply(plan, function(x) sapply(x[["issue"]], validate_issue_level))

}

validate_todo <- function(todo){

  sapply(todo, validate_issue_level)

}
