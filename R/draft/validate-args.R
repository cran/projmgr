# internal functions focused on cleaning inputs to reduce common api errors

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
        "Use the browse_docs() function or directly visit \n",
        "See https://developer.github.com/v3/ for full documentation of defined fields."
      ),
      call. = FALSE
    )
  }

}

#' @keywords internal
convert_timestamp <- function(date){

  input_date <- trimws(as.character(date))

  # for correct YYYY-MM-DDTHH:MM:SSZ formatting
  if(grepl("^\\d{4}-\\d{2}-\\d{2}T\\d{2}\\:\\d{2}\\:\\d{2}Z$", input_date)){
    return(input_date)
  }

  # for yyyy-mm-dd format
  else if(grepl("^\\d{4}-\\d{2}-\\d{2}$", input_date)){
    output_date <- paste0(input_date, "T12:59:59Z")
  }

  # for yyyymmdd format
  else if(grepl("^\\d{10}$", input_date)){
    output_date <-
      paste0( substring(input_date,1,4), "-",
             substring(input_date,5,6), "-",
             substring(input_date,7,8), "-",
             "T12:59:59Z")
  }

  # for yyyy-mm format
  else if(grepl("^\\d{4}-\\d{2}$", input_date)){
    output_date <- paste0( input_date, "-15T12:59:59Z")
  }

  # for yyyymm format
  else if(grepl("^\\d{6}$", input_date)){
    output_date <-
      paste0( substring(input_date,1,4), "-",
             substring(input_date,5,6), "-",
             "15T12:59:59Z")
  }

  else{

    stop(
      paste("Timestamp input provided", input_date, "is unparseable. \n",
            "GitHub API requires timestamp format like 2018-12-31T12:59:59Z. \n",
            "Formats of YYYY-MM-DD, YYYY-MM, YYYYMMDD, and YYYYMM are also handled internally."),
      call. = FALSE
    )

  }

  message(
    paste("Time provided,", input_date, ", was converted to", output_date, "for compatibility with GitHub API.")
  )

 return(output_date)

}

#' @keywrods internal
convert_array <- function(input){

  return( I(input) )

}
