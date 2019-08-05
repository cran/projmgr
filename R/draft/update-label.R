#' Title
#'
#' @param ref
#' @param issue_num
#' @param old_label
#' @param new_label
#'
#' @return
#' @export
#'
#' @examples
#
# update_label <- function(ref, issue_num, old_label, new_label){
#
#   # establish path
#   uri <- paste0(ref$base_url,"/issues/", issue_number, "/labels")
#
#   # delete old label
#   del_req <-
#     httr::DELETE(
#       paste0(uri,"/",old_label),
#       httr::authenticate(eid, pw),
#       encode = "json")
#
#   # throw error if problem with delete call
#   if(httr::status_code(del_req) != 200){
#     stop(
#       paste("No change was made. Removal of original label failed with status code:",
#             httr::status_code(del_req))
#       )
#   }
#
#   # input new label
#   post_req <-
#     httr::POST(
#       uri,
#       body = list(new_label),
#       httr::authenticate(eid, pw),
#       encode = "json")
#
#   return(httr::status_code(post_req))
#
# }
