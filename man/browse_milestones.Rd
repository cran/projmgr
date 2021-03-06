% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/browse.R
\name{browse_milestones}
\alias{browse_milestones}
\title{Browse milestones for given GitHub repo}
\usage{
browse_milestones(repo_ref, number = "")
}
\arguments{
\item{repo_ref}{Repository reference as created by \code{create_repo_ref()}}

\item{number}{Optional argument of milestone ID, if opening page for specific milestone is desired}
}
\value{
Returns URL in non-interactive session or launches browser to docs in interactive session
}
\description{
Opens browser to GitHub milestones for a given repo. Inspired by similar \code{browse_} functions included in
the \code{usethis} package.
}
\examples{
\dontrun{
my_repo <- create_repo_ref("repo_owner", "repo")
browse_milestones(my_repo)
}
}
