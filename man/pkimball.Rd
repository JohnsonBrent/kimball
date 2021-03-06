% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/pkimball.R
\name{pkimball}
\alias{pkimball}
\title{Returns the probability density function}
\usage{
pkimball(x, S, L, min = 0)
}
\arguments{
\item{x}{A positive numerical input vector requiring evaluation}

\item{S}{A parameter for the maximum of the truncated normal distribution. Must be positive.}

\item{L}{Mean parameter. Must be positive.}

\item{min}{A parameter for the minimum of the truncated normal distribution. Must be positive. Default is zero.}
}
\value{
A numerical result of length x.
}
\description{
Returns the probability density function
}
\examples{
pkimball(3, 8, 4, min=0)
}
