#' Set up skeleton file structure
#'
#' If some of folders attempting to create already exist, will not override. Call this
#' function after opening a fresh R Project for your new project.
#'
#' Within the current working directory (hopefully, an R project), this function will create the
#' following folders: data, analysis, output, src, ext, as well as a README.md file. Should such
#' folders/files already exists, they will not be overwritten.
#'
#' data - to contain "raw" (non-R generated data), i.e. pulled from database
#' analysis - to contain RMarkdown files and other R scripts
#' output - to contain manipulated data files generated during analysis
#' src - to contain scripts outside of the RMarkdown workflow (e.g. SQL, python utilities)
#' ext - to contain other files used for analysis (e.g. a legacy-format cashflow)
#'
#' @return No return
#' @export
#'
#' @examples
#' use_file_structure()

use_file_structure <- function(){

  check_and_create <- function(subpath){

    if(!dir.exists(subpath)){
      dir.create(subpath)
    }
    else{
      error_message <- paste(subpath, "already exists. Directory not updated.")
      message(error_message)
    }

  }

  dirs <- c("./data",
            "./analysis",
            "./output",
            "./src",
            "./ext",
            "./doc")

  for(d in dirs){
    check_and_create(d)
  }

  if(!file.exists("README.md")){
    writeLines("#WRITE PROJECT DESCRIPTION", con = "README.md")
  }
  else{
    message("README.md already exists. File not updated.")
  }

}
