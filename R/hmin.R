#' Function to solve for "h" as per Kimball(1948) and Oates & Spencer(1962). Neccessary for all Kimball functions.
#'
#' @param L Mean parameter. Must be positive.
#' @param S A parameter for the maximum of the truncated normal distribution. Must be positive.
#' @return h
#' @examples
#' hmin(8, 4)
#' @export

hmin <- function(S, L) {
  ratio <- S/L
  #Parameters to Define h-Function start values
  X0 <-  9.941353
  X1 <- -7.418560
  X2 <-  2.153366
  X3 <- -0.215023
  # h-function parameter start value
  start <- ( X0 + X1 * ratio + X2 * (ratio ^ 2) + X3 * (ratio ^ 3)) ^ 2

  opt <- function(par) {
    phi.h <- dnorm(-par,0,1)
    PHI.h <- pnorm(par,0,1)
    delta <- phi.h / PHI.h
    num <- pnorm(-(ratio*(par+delta)-par),0,1)
    den <- pnorm(par,0,1)
    FX <-  num / den
    target <- .0001
    delta <- abs(FX - target)
  }

  result <- optim(par=start, opt, method="BFGS", control=list(reltol=(.Machine$double.eps)))
  h <- result[[1]]
  if (ratio < 1) {
    stop("The max is below the mean. Please check your parameters")
  }
  if (ratio > 4.88) {
    warning("The max is significantly HIGHER than the mean. Results might not be correct. Please consider another distribution.")
  }
  if (ratio < 1.22) {
    warning("The max is very close to the mean. Results might not be correct. Please consider another distribution.")
  }
  return(h)
}

