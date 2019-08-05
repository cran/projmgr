# # load libraries
# library(ggplot2)
# library(dplyr)
#
# # inputs
# start_date <- '2018-10-01'
# end_date <- '2018-12-30'
#
# # prep dates dataframe
# date_chars <- seq(as.Date(start_date), as.Date(end_date), by = 1)
# dow <-
#   weekdays(date_chars) %>%
#   substring(1,3) %>%
#   factor(levels = c("Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"))
# week_num <- as.integer(strftime(date_chars, format = "%V"))
#
# dates_data <- data.frame(date_chars, dow, week_num)
# rm(dow, week_num)
#
# # prep issues dataframe
# set.seed(620)
# issues <-
# data.frame(
#   id = 1:20,
#   due_on = sample(date_chars, 20, replace = TRUE)
# )
# rm(date_chars)
#
# # append issues data
# dates_issues <-
#   dates_data %>%
#   left_join(
#     transmute(issues, id, date_chars = due_on),
#     by = "date_chars"
#   ) %>%
#   group_by(date_chars, dow, week_num) %>%
#   summarize(n = n_distinct(id)) %>%
#   ungroup() %>%
#   mutate(month = substring(months(date_chars),1,3)) %>%
#   mutate(month = factor(month, c("Jan", "Feb", "Mar",
#                                  "Apr", "May", "Jun",
#                                  "Jul", "Aug", "Sep",
#                                  "Oct", "Nov", "Dec")),
#          year = substring(date_chars,1,4) %>% as.integer()
#          ) %>%
#   group_by(month) %>%
#   mutate(week_num = week_num - min(week_num))
#
# # Plot as calendar
# ggplot(dates_issues, aes(x = dow, y = -1*week_num, fill = -1*n)) +
#   geom_tile() +
#   geom_text(aes(label = lubridate::day(date_chars)))+
#   scale_x_discrete(position = "top")+
#   scale_y_discrete(limits = rev(levels(dates_issues$week_num))) +
#   theme_bw() +
#   theme(axis.title=element_blank(),
#         axis.text.y=element_blank(),
#         axis.ticks.y=element_blank(),
#         plot.title = element_text(hjust = 0.5)) +
#   guides(fill = FALSE) +
#   labs(title = paste("Due Dates,", start_date, "-", end_date)) +
#   facet_grid(year~month)
