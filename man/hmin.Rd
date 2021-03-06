% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hmin.R
\name{hmin}
\alias{hmin}
\title{Function to solve for "h" as per Kimball(1948) and Oates & Spencer(1962). Neccessary for all Kimball functions.}
\usage{
hmin(S, L)
}
\arguments{
\item{S}{A parameter for the maximum of the truncated normal distribution. Must be positive.}

\item{L}{Mean parameter. Must be positive.}
}
\value{
h
}
\description{
Function to solve for "h" as per Kimball(1948) and Oates & Spencer(1962). Neccessary for all Kimball functions.
}
\examples{
hmin(8, 4)
}
