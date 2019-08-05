viz_gantt_closed_plotly <- function(issues, x = created_at, y = closed_at){

  x_var <- enquo(x)
  y_var <- enquo(y)

  data_prep <-
    issues %>%
    dplyr::filter(state == "closed") %>%
    dplyr::mutate(id_label = factor(id, levels = id, labels = title))

  gg_object <-
  ggplot(data_prep,
         aes(
           x = !!x_var, xend = !!y_var,
           y = id_label, yend = id_label,
           col = -1*as.integer(difftime(!!y_var, !!x_var, "days")),
           `Start Date` = !!x_var,
           `End Date` = !!y_var,
           `Days Outstanding` = as.integer(difftime(!!y_var, !!x_var, "days")),
           `Created by` = created_by
         )) +
    geom_segment(size = 8) +
    geom_point(aes(x = !!x_var), size = 2) +
    geom_point(aes(x = !!y_var), size = 2) +
    labs(
      title = "Closed Issues",
      x = "", y = ""
    ) +
    scale_y_discrete(labels = function(x) stringr::str_wrap(x, width = 30)) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    guides(col = FALSE)

  ggplotly(gg_object,
           tooltip = c("Start Date", "End Date", "Days Outstanding", "Created by"))


}

# dplyr <- create_repo_ref("tidyverse", "dplyr")
# dplyr_issues <- get_issues(dplyr, state = "closed", milestone = 1) %>% parse_issues()

dplyr_issues %>%
  mutate_at(vars(created_at, closed_at), lubridate::as_date) %>%
  viz_gantt_closed(created_at, closed_at)

dplyr_issues %>%
  mutate_at(vars(created_at, closed_at), lubridate::as_date) %>%
  viz_gantt_closed()

dplyr_issues %>%
  mutate_at(vars(created_at, closed_at), lubridate::as_date) %>%
  viz_gantt_closed_plotly(created_at, closed_at)
