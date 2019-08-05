#' Save SVG of Gantt-style chart of closed issues with links to issues
#'
#' This function creates the same plot as \code{viz_gantt_closed} then edits the
#' underlying XML so that the titles of the issues on the y-axis are linked to the
#' actual issue on GitHub
#'
#' Credit goes to this Stack Overflow answer for figuring out how to do this:
#' https://stackoverflow.com/questions/42259826/hyperlinking-text-in-a-ggplot2-visualization/42262407
#'
#' @param g ggplot2 object returned by \code{viz_gantt_closed()}
#' @param filepath Location to save resulting SVG file of ggplot2, if desired. Leave blank for
#'     function to output message precisely as needed to render in HTML RMarkdown with chunk
#'     option \code{results = 'asis'}
#'
#' @return SVG version of ggplot2 object with links to relevant GitHub issues. Either writes output
#'     to file or to console (to be captured in RMarkdown) depending on existence of \code{filepath} argument
#' @export
#'
#' @family issues
#'
#' @examples
#' \dontrun{
#' # In R, to save to file:
#' viz_gantt_closed_links(issues, "my_folder/my_file.svg")
#'
#' # In RMarkdown chunk, to print as output:
#' ```{r results = 'asis', echo = FALSE}
#' g <- viz_gantt_closed(issues)
#' viz_gantt_closed_links(g)
#' ````
#' }

viz_gantt_closed_links <- function(g, filepath){

  if (!requireNamespace("xml2", quietly = TRUE)) {
    message(
      paste0("Package \"xml2\" is needed to edit SVG.",
             "Please install \"xml2\" or use viz_gantt_closed for the non-linked version."),
      call. = FALSE)
  }

  if (!requireNamespace("stringr", quietly = TRUE)) {
    stop("Package \"stringr\" needed for this function to work. Please install it.",
         call. = FALSE)
  }

  # save current ggplot at svg
  tf <- tempfile(fileext = ".svg")
  ggsave(tf , g )

  # update svg w links
  links <- tibble::tibble(
    url = g$data$url,
    name =
      g$data$title %>%
      stringr::str_wrap(width = 30) %>%
      stringr::str_split("\\n")
  ) %>%
    tidyr::unnest() %>%
    {stats::setNames(.$url, .$name)}

  xml <- xml2::read_xml(tf)
  xml %>%
    xml2::xml_find_all(xpath="//d1:text") %>%
    purrr::keep(xml2::xml_text(.) %in% names(links)) %>%
    xml2::xml_add_parent("a", "xlink:href" = links[xml2::xml_text(.)], target = "_blank")

  if(missing(filepath)){
    xml2::write_xml(xml, tf)
    cat( readLines(tf), sep = "\n" )
  }
  else{ xml2::write_xml(xml, filepath ) }

  # clean up environment
  unlink(tf)

}

#' Save SVG of Agile-style task board of issue status with links to issues
#'
#' This function creates the same plot as \code{viz_taskboard} then edits the
#' underlying XML so that the "cards" are linked to the corresponding issues on GitHub.
#' It saves a file with the reuslting SVG, which can then be read into an RMarkdown
#' HTML document as shown in the Examples.
#'
#' Credit goes to this Stack Overflow answer for figuring out how to do this:
#' https://stackoverflow.com/questions/42259826/hyperlinking-text-in-a-ggplot2-visualization/42262407
#'
#' @inheritParams viz_gantt_closed_links
#' @inherit viz_gantt_closed_links return
#' @export
#'
#' @family issues
#'
#' @examples
#' \dontrun{
#' # In R, to save to file:
#' viz_taskboard_links(issues, "my_folder/my_file.svg")
#'
#' # In RMarkdown chunk, to print as output:
#' ```{r results = 'asis', echo = FALSE}
#' g <- viz_taskboard(issues)
#' viz_taskboard_links(g)
#' ````
#' }

viz_taskboard_links <- function(g, filepath){

  if (!requireNamespace("xml2", quietly = TRUE)) {
    message(
      paste0("Package \"xml2\" is needed to edit SVG.",
             "Please install \"xml2\" or use viz_taskboard for the non-linked version."),
      call. = FALSE)
  }

  if (!requireNamespace("stringr", quietly = TRUE)) {
    stop("Package \"stringr\" needed for this function to work. Please install it.",
         call. = FALSE)
  }

  # save current ggplot at svg
  tf <- tempfile(fileext = ".svg")
  ggsave(tf , g )

  # update svg w links
  links <- tibble::tibble(
    url = g$data$url,
    name =
      paste0("#", g$data$id, ": ", g$data$title) %>%
      stringr::str_wrap(width = 20) %>%
      stringr::str_split("\\n")
  ) %>%
    tidyr::unnest() %>%
    {stats::setNames(.$url, .$name)}

  xml <- xml2::read_xml(tf)
  xml %>%
    xml2::xml_find_all(xpath="//d1:text") %>%
    purrr::keep(xml2::xml_text(.) %in% names(links)) %>%
    xml2::xml_add_parent("a", "xlink:href" = links[xml2::xml_text(.)], target = "_blank")

  if(missing(filepath)){
    xml2::write_xml(xml, tf)
    cat(readLines(tf), sep = "\n")
  }
  else{ xml2::write_xml(xml, filepath ) }

  # clean up environment
  unlink(tf)

}
