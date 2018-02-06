#' Returns the cumulative distribution function
#'
#' @param x A positive numerical input vector requiring evaluation
#' @param min A parameter for the minimum of the truncated normal distribution. Must be positive. Default is zero.
#' @param L Mean parameter. Must be positive.
#' @param S A parameter for the maximum of the truncated normal distribution. Must be positive.
#' @return A numerical report of the cumulative probability of x
#' @importFrom stats dnorm optimize pnorm
#' @examples
#' dkimball(3, 8, 4, min=0)
#' @export


dkimball <- function(x, S, L, min=0) {
  L <- L-min # L = mean
  S <- S-min # S = max
  x <- x-min
  h <- hmin(S, L)
  phi.h <- dnorm(-h,0,1)
  PHI.h <- pnorm(h,0,1)
  w <- h + phi.h/PHI.h
  Ft <- w*dnorm(-(w*x/L-h),0,1) / (L*PHI.h)
  return(Ft)
}
