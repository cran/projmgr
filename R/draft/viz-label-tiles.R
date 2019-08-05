viz_label_tiles <- function(issues, x = label, y = title){

  x_var <- enquo(x)
  y_var <- enquo(y)

  # data prep ---

  issues <-
    tidyr::unnest(issues, !!x_var) %>%
    group_by(!!x_var) %>%
    add_count(sort = TRUE) %>%
    ungroup() %>%
    arrange(desc(n)) %>%
    mutate(!!x_var = factor(!!x_var, levels = unique(!!x_var), labels = unique(!!x_var))) %>%
    group_by(!!y_var) %>%
    add_count() %>%
    ungroup() %>%
    arrange(desc(!!x_var), desc(nn)) %>%
    mutate(!!y_var := factor(!!y_var, levels = unique(!!y_var), labels = unique(!!y_var)))

  gg_obj <- ggplot(issues, aes(x = !!x_var, y = !!y_var, fill = -1*n)) +
    geom_tile() +
    labs(
      title = "Labels by Issues",
      x = "", y = ""
    ) +
    scale_y_discrete(labels = function(x) stringr::str_wrap(x, width = 30)) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
    guides(fill = FALSE)

  gg_obj

}

dplyr <- create_repo_ref("tidyverse", "dplyr")
dplyr_issues <- get_issues(dplyr, state = "closed", milestone = 1) %>% parse_issues()

viz_label_tiles(dplyr_issues)
viz_label_tiles(dplyr_issues, y = created_by)
viz_label_tiles(dplyr_issues, y = assignee)


