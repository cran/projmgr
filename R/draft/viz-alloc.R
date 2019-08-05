set.seed(620)

labels <-
  data.frame(
    id = 1:20,
    label = sample(c("priority:high", "priority:med", "priority:low"), 20, replace = TRUE),
    stringsAsFactors = FALSE
  ) %>%
  tidyr::separate(label, into = c("super", "sub"), sep = ":", remove = FALSE)

assignees <-
  data.frame(
    id = 1:20,
    assignee = sample(c("Person1", "Person2", "Person3"), 20, replace = TRUE),
    stringsAsFactors = FALSE
  )

viz_assignees_priority <- function(assignees, labels){

assignee_labels <-
  left_join(assignees,
            filter(labels, super == 'priority'),
            by = "id") %>%
  group_by(assignee, sub) %>%
  count() %>%
  ungroup() %>%
  mutate(sub = factor(sub,
                      levels = c("low", "med", "high"),
                      labels = c("Low", "Med", "High")))

ggplot(
  assignee_labels,
    aes(
    x = sub,
    y = assignee,
    fill = -1*n,
    label = n
    )
  ) +
  geom_tile() +
  geom_text() +
  theme_bw() +
  theme(axis.title = element_blank()) +
  labs(title = "Backlog Items by Association and Priority") +
  guides(fill = FALSE)

}

viz_backlog_counts <- function(labels){

  labels %>%
    filter(super == "priority") %>%
    mutate(sub = factor(sub,
                        levels = c("low", "med", "high"),
                        labels = c("Low", "Med", "High"))) %>%
    ggplot(aes(x = sub, fill = sub)) + geom_bar() +
    scale_fill_manual(
      values = c("Low" = "darkgreen", "Med" = "goldenrod", "High" = "darkred")
    ) +
    theme_bw() +
    theme(axis.title = element_blank()) +
    guides(fill = FALSE) +
    labs(title = "Outstanding Backlog Items by Criticality",
         subtitle = "Status as of YYYY-MM-DD")

}



viz_assignees_priority(assignees, labels)
viz_backlog_counts(labels)
