#' Returns random deviates from the Kimball distribution
#'
#' @param x A value describing the desired number of random deviates (length of a vector)
#' @param min A parameter for the minimum of the truncated normal distribution. Must be positive. Default is zero.
#' @param L Mean parameter. Must be positive.
#' @param S A parameter for the maximum of the truncated normal distribution. Must be positive.
#' @return A vector or random deviates
#' @importFrom stats dnorm optimize
#' @examples
#' rkimball(100, 8, 4, min=0)
#' @export

rkimball <- function(x, S, L, min=0) {
  result <- rep(NA, x)
  iter <- 0
  while (sum(is.na(result)) > 0) {
    iter <- iter + 1
    proposal <- runif(n, min, S)
    targetDensity <- dkimball(proposal, S, L, min)  # change this
    maxDens <- max(targetDensity, na.rm = T)
    accepted <- ifelse(runif(x,0,1) < targetDensity / maxDens, TRUE, FALSE)
    accepted[is.na(accepted)] <- FALSE
    result[accepted] <- proposal[accepted]
    if (iter > 10000) {
      warning("rkimball is taking over 10,000 sampling iterations to complete the request.")
    }
  }
  return(result)
}

