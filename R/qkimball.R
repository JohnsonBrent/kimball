#' Returns the value of x for a specified quantile
#'
#' @param p A vector of one or more probilities all lying between 0 and 1
#' @param min A parameter for the minimum of the truncated normal distribution. Must be positive. Default is zero.
#' @param L Mean parameter. Must be positive.
#' @param S A parameter for the maximum of the truncated normal distribution. Must be positive.
#' @param precision The numerical precision of the quantile. Default is accurate to within .0001
#' @return  value of x at the p quantile
#' @importFrom stats dnorm optimize pnorm
#' @examples
#' qkimball(.4, 8, 4, min=0, precision=.0001)
#' @export


qkimball <- function(p, S, L, min=0, precision=.0001) {
  L <- L-min
  S <- S-min
  x <- seq(0,S,S*precision)
  h <- hmin(S=S, L=L)
  phi.h <- dnorm(-h,0,1)
  PHI.h <- pnorm(h,0,1)
  w <- h + phi.h/PHI.h
  Ft <- pnorm(w*x/L-h,0,1) / PHI.h
  q <- x[which.min(abs(Ft-p))] + min
  return(q)
}
