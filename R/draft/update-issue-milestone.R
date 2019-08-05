#' Title
#'
#' @param ref
#' @param issue_num
#' @param milestone_num
#'
#' @return
#' @export
#'
#' @examples

# update_issue_milestone <- function(ref, issue_num, milestone_num) {
#
#   req <-
#     httr::PATCH(
#       paste0(ref$base,"/issues/", issue_num),
#       body = list(milestone = milestone_num),
#       config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
#       encode = "json")
#
#   return(httr::status_code(req))
#
# }
