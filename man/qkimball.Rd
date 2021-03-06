% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/qkimball.R
\name{qkimball}
\alias{qkimball}
\title{Returns the value of x for a specified quantile}
\usage{
qkimball(p, S, L, min = 0, precision = 1e-04)
}
\arguments{
\item{p}{A vector of one or more probilities all lying between 0 and 1}

\item{S}{A parameter for the maximum of the truncated normal distribution. Must be positive.}

\item{L}{Mean parameter. Must be positive.}

\item{min}{A parameter for the minimum of the truncated normal distribution. Must be positive. Default is zero.}

\item{precision}{The numerical precision of the quantile. Default is accurate to within .0001}
}
\value{
value of x at the p quantile
}
\description{
Returns the value of x for a specified quantile
}
\examples{
qkimball(.4, 8, 4, min=0, precision=.0001)
}
