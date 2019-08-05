#' Post issue to GitHub repository based on breaches flagged by \code{tidytrends}
#'
#' Automatically add new items to your backlog, managed through GitHub issues. \code{tidytrends} output
#' must be provided in long-form, as created after running `prep_step0_pivot`. Such a dataset
#' includes variables \code{METRIC, SEGMENT, CADENCE, Val, Exp, breach}.
#'
#' Records where `breach == 1` will each generate a new issue with title
#' `METRIC out of bounds (above/below) for SEGMENT in CADENCE` and body listing out
#' the key components of the issues (the relevant metric, segment, cadence as well as numerical
#' measures of the actual, the expected, and the guardrail.)
#'
#' Additionally, each issue will have labels `metric:METRIC`, `segment:SEGMENT`, and
#' `cadence:CADENCE` (uppercase replaced my actual values) to facilitate future searchability and
#' meta-analytics around commonly out-of-bounds items.
#'
#'
#' @param tidytrends_output Long-form output from \code{tidytrends} following `prep_step0_pivot` step.
#'     See `tidytracker::tidytrends_sample` for a sample of the expected input. Most critically,
#'     there must be variables: \code{SEGMENT, CADENCE, METRIC, Val, Exp, GR}
#' @inheritParams get_issues
#'
#' @return Returns with columns \code{post_status}, \code{issue_num}, and \code{title}. See
#'     \code{tidytracker::post_issue} documentation for interpretation of these fields.
#' @export
#'
#' @examples
#' \dontrun{
#' tidytracker <- create_repo_reference('emilyriederer', 'tidytracker')
#' post_issues_tidytrends(tidytracker, tidytrends_sample)
#' }

post_issues_tidytrends <- function(ref, tidytrends_output){

  tidytrends_output %>%
    dplyr::filter(breach == 1) %>%
    dplyr::transmute(
      title = paste(METRIC, "out of bounds",
                    ifelse(Val>Exp, "(above)", "(below)"),
                    "for",SEGMENT,"in",CADENCE),
      body = paste(
        "**Cadence**:", CADENCE, "\n",
        "**Metric**:", METRIC, "\n",
        "**Segment**:", SEGMENT, "\n",
        "**Actual Value:**", Val, "\n",
        "**Expected Value:**", Exp, "\n",
        "**Guardrail:**", GR, "\n"
      ),
      label = list(c(
        paste0('metric:',METRIC),
        paste0('segment:',SEGMENT),
        paste0('cadence:',CADENCE)
      )
      )
    ) %>%
    purrr::pmap_df(
      function(title,body,label)
        post_issue(ref, title, body, label)
    )

}
