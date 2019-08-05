#' Visualize Agile-style task board of item status
#'
#' Produces three column task board showing any relevant objects (typically issues or milestones)
#' as "Not Started", "In Progress", or "Done".
#'
#' The following logic is used to determine the status of each issue:
#' \itemize{
#'   \item{Not Started:}{ \code{closed_at} is NA and no \code{in-progress} label}
#'   \item{In Progress:}{ \code{closed_at} is NA but \code{in-progress} label exists}
#'   \item{Done:}{ \code{closed_at} is not NA}
#' }
#'
#' @inheritParams viz_gantt
#' @param data Dataset, such as those representing issues or milestones (i.e. from \code{parse_issues()}).
#'     Must have \code{state} variable.
#'
#' @return ggplot object
#' @export
#' @seealso viz_linked
#'
#' @import ggplot2
#'
#' @examples
#' \dontrun{
#' issues <- get_issues(myrepo, milestone = 1) %>% parse_issues()
#' viz_task_board(issues)
#' }

viz_taskboard <- function(data, str_wrap_width = 20){

  # create status classification ----
  statuses <- c("Not Started", "In Progress", "Done")
  data$board_group <- statuses[1]
  data$board_group[purrr::map_lgl(data$labels_name, ~"in-progress" %in% .)] <- statuses[2]
  data$board_group[data$state == "closed"] <- statuses[3]
  data$board_group <- factor(data$board_group, levels = statuses)

  # create helper aesthetics for size, position, text fmt ----
  data$board_pos <- stats::ave(data$number, data$board_group, FUN = seq_along)
  text_components <-
    purrr::map2(data$number, data$title,
                ~strwrap(paste0("#", .x, ": ", .y), width = str_wrap_width))
  data$taskboard_text <- purrr::map_chr(text_components, ~paste(., collapse = "\n"))
  #data$height <- max( purrr::map_int(label_components, length) ) * 2
  height <- max( purrr::map_int(text_components, length) ) * 2

  # create ggplot object of task board ----
  g <-
    ggplot(data, aes(x = 0, y = 0)) +
    geom_rect(aes(fill = board_group), xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
    geom_text(aes(label = taskboard_text)) +
    geom_point(data = data.frame(y = c(-5*height, 5*height), x = c(0,0)), col = NA) +
    facet_grid(board_pos ~ board_group) +
    scale_y_continuous(limits = c(round(-1 * height / 1.75), round(height / 1.75))) +
    scale_fill_manual(values = c("Not Started" = "#F0E442",
                                   "In Progress" = "#56B4E9",
                                   "Done" = "#009E73")) +
    theme(
      panel.grid = element_blank(),
      axis.title = element_blank(),
      axis.text = element_blank(),
      axis.ticks = element_blank(),
      strip.background.y = element_blank(),
      strip.text.y = element_blank(),
      #panel.spacing.y = unit(0, "lines"),
      legend.position = 'none'
    )

  # add metadata to be used with viz_linked ----
  class(g) <- c(class(g), "taskboard")
  g[['str_wrap_width']] <- str_wrap_width

  return(g)

}
