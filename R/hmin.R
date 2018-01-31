#' Function to solve for "h" as per Kimball(1948) and Oates & Spencer(1962). Neccessary for all Kimball functions.
#'
#' @param L Mean parameter. Must be positive.
#' @param S A parameter for the maximum of the truncated normal distribution. Must be positive.
#' @return h
#' @examples
#' hmin(4, 8)
#' @export

hmin <- function(S=S, L=L) {
    hmin <- function(start=1) {
      max.as.pct.avg <- S/L
      phi.h <- dnorm(-start,0,1)
      PHI.h <- pnorm(start,0,1)
      delta <- phi.h / PHI.h
      num <- pnorm(-(max.as.pct.avg*(start+delta)-start),0,1)
      den <- pnorm(start,0,1)
      FX <-  num / den
      target <- .0001
      delta <- abs(FX - target)
      return(delta)
    }

    result <- optimize(hmin, c(0, 10))
    h <- result[[1]]
    if (h > 9) {
      warning("The max is too close to the mean. The result may not be correct")
    }
    return(h)
}

