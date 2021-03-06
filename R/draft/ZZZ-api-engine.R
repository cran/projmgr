#' Validate that all user-defined inputs (GET query, POST body, etc.) are valid
#'
#' @param input List of user-provided input parameters
#' @param required_vars Character vector of required variables
#' @param allowed_vars Character vector of allowed but not required variables
#'
#' @return No return. Throws errors if user-defined inputs are invalid.
#' @keywords internal

validate_inputs <- function(input, allowed_vars){

  input_vars <- names(input)

  # no disallowed vars exist
  if(!all(input_vars %in% allowed_vars)){
    stop(
      paste0(
        "The following user-inputted variables are not relevant to this API request: \n + ",
        paste(setdiff(input_vars, allowed_vars), collapse = ","), "\n",
        "Allowed variables are: \n + ",
        paste(allowed_vars, collapse = ","), "\n",
        "Please remove unallowed fields and try again.", "\n",
        "See https://developer.github.com/v3/ for full documentation of defined fields."
      ),
      call. = FALSE
    )
  }

}

#' Core code for all GET calls
#'
#' @param api_endpoint API endpoint
#' @param ref Repository reference (list) created by \code{tidytracker::create_repo_ref}
#' @param ... Additional user-defined query parameters
#'
#' @keywords internal
#' @return Content of GET request as list

get_engine <- function(api_endpoint, ref, ...){

  req <-
    httr::GET(
      paste0(ref$base_url, ref$repo_path, api_endpoint),
      query = list(...),
      config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
      encode = "json"
    )

  res <- httr::content(req)
  res

}

#' Core code for all POST calls
#'
#' @param api_endpoint API endpoint
#' @param ref Repository reference (list) created by \code{tidytracker::create_repo_ref}
#' @param ... Additional user-defined body parameters
#'
#' @keywords internal
#' @return Content of POST request as list

post_engine <- function(api_endpoint, ref, ...){

  req <-
    httr::POST(
      paste0(ref$base_url, ref$repo_path, api_endpoint),
      body = list(...),
      config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
      encode = "json")

  res <- httr::content(req)
  res

}

#' Core code for all PATCH calls
#'
#' @param api_endpoint API endpoint
#' @param ref Repository reference (list) created by \code{tidytracker::create_repo_ref}
#' @param ... Additional user-defined body parameters
#'
#' @keywords internal
#' @return Content of PATCH request as list

patch_engine <- function(api_endpoint, ref, ...){

  req <-
    httr::PATCH(
      paste0(ref$base_url, ref$repo_path, api_endpoint),
      body = list(...),
      config = httr::authenticate(Sys.getenv(ref$id), Sys.getenv(ref$pw)),
      encode = "json")

  res <- httr::content(req)
  res

}
