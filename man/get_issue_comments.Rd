% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get.R
\name{get_issue_comments}
\alias{get_issue_comments}
\title{Get comments for a specific issue from GitHub repository}
\usage{
get_issue_comments(ref, number, ...)
}
\arguments{
\item{ref}{Repository reference (list) created by \code{create_repo_ref()}}

\item{number}{Number of issue}

\item{...}{Additional user-defined query parameters. Use \code{browse_docs()} to learn more.}
}
\value{
Content of GET request as list
}
\description{
In addition to information returned by GitHub API, appends field "number" for the issue number
to which the returned comments correspond.
}
\examples{
\dontrun{
myrepo <- create_repo_ref('emilyriederer', 'myrepo')
comments_res <- get_issue_comments(myrepo, number = 1)
comments <- parse_issue_comments(comments_res)
}
}
\seealso{
Other issues: 
\code{\link{get_issue_events}()},
\code{\link{get_issues}()},
\code{\link{parse_issue_comments}()},
\code{\link{parse_issue_events}()},
\code{\link{parse_issues}()},
\code{\link{post_issue_update}()},
\code{\link{post_issue}()},
\code{\link{report_discussion}()},
\code{\link{report_progress}()},
\code{\link{viz_waterfall}()}

Other comments: 
\code{\link{parse_issue_comments}()},
\code{\link{report_discussion}()}
}
\concept{comments}
\concept{issues}
