
<!-- README.md is generated from README.Rmd. Please edit that file -->
kimball
=======

The kimball package makes available several functions to access Kimball's (1947) truncated normal distribution. As stated in Kimball's (1947) original paper and by Oates and Spencer (1962) the distribution's parameters are entirely intuitive. In its original specification, the user only need input a mean (e.g., the average service life of some durable) and a maximum (e.g., the maximum expected service life of some durable) to estimate the probability of failure (probability density) or the life table or likelihood of survival (1 minus the cumulative distribution function).

As opposed to most other implementations of a truncated normal distribution (e.g., the [truncnorm package](https://cran.r-project.org/web/packages/truncnorm/index.html)) the kimball distribution's parameters are entirely intuitive. Rather than specification by a mean and standard deviation (or variance) the kimball distribution is specified by a mean and maximum. The variance is implied and is expressed as a function of the mean and maximum. (See Oats and Spencer's (1962) equation's 7.)

My implementation is largely as originally described by Kimball (1947). My one addition is to generalize Kimball's (1947) equations to incorporate an arbitrary minimum. That is, Kimball (1947) originally positioned his work as a system of [life tables](https://en.wikipedia.org/wiki/Life_table) with the assumption that the domain of interest always begins at zero. I generalize this and allow the user to specify an arbitrary minimum as a function parameter.

Like the un-truncated normal or Gaussian distribution, the kimball distribution maintains the property wherein its mean, median, and mode are identical (Under most conditions).

Following the naming convention in most other probability functions in R, the main functions available in the kimball package include the following:

-   dkimball() returns the probability density.
-   pkimball() returns the cumulative distribution.
-   qkimball() returns the quantile (estimated by approximation and a user-specified level of precision).

In this version of the package, I have not implemented a function for returning random deviates, e.g., rkimball().

Installation
------------

You can install kimball from github with:

``` r
# install.packages("devtools")
devtools::install_github("JohnsonBrent/kimball")
```

Example
-------

Suppose for example, one has obtained estimates that a particular machine part or durable has an average service life of 3 years and a maximum service life of 8 years. The probability that the part or durable survives beyond 5 years is...

``` r
1 - pkimball(5,8,3)
#> [1] 0.05111129
```

And a vector containing its probability of failure in years 0,1,2,3,4 and 5 is...

``` r
time <-c(0,1,2,3,4,5)
dkimball(time,8,3)
#> [1] 0.02734840 0.10334433 0.22688392 0.28938969 0.21444933 0.09232698
```

See the vignette for more examples.