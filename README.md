
<!-- README.md is generated from README.Rmd. Please edit that file -->
kimball
=======

The kimball package makes available several functions to access [Kimball's (1947)](Kimball%20(1947)%20-%20A%20System%20of%20Life%20Tables....pdf) truncated normal distribution. As stated in Kimball's (1947) original paper and by [Oates and Spencer (1962)](Oates%20&%20Spencer%20(1962)%20-%20A%20System%20of%20Retirement%20Frequencies%20for%20Depreciable%20Assets.pdf) Kimball's contribution is a distribution with parameters that are completely intuitive. In its original specification, the user only need input a mean (e.g., the average service life of some durable) and a maximum (e.g., the maximum expected service life of some durable) to estimate the probability of failure (probability density) or the life table or likelihood of survival (1 minus the cumulative distribution function).

As opposed to most other implementations of a truncated normal distribution (e.g., the [truncnorm package](https://cran.r-project.org/web/packages/truncnorm/index.html)) the kimball distribution's parameters have a behavioral interpretation. Rather than described by a mean and standard deviation (or variance), the kimball distribution is specified by its mean and maximum value. The variance need not be specified by the user but is implied by and can be expressed as a function of the mean and maximum. (See Oats and Spencer's (1962) Equation 7.)

My implementation is largely as originally described by Kimball (1947). My one addition is to generalize Kimball's (1947) equations to incorporate an arbitrary minimum. That is, Kimball (1947) originally positioned his work as a system of [life tables](https://en.wikipedia.org/wiki/Life_table) with the assumption that the domain of interest always begin at zero on the left-hand side, i.e., it's left-censored at zero. I generalize this and allow the user to specify any arbitrary (but strictly positive) minimum as a function parameter.

The kimball package makes available several functions to access [Kimball's (1947)](Kimball%20(1947)%20-%20A%20System%20of%20Life%20Tables....pdf) truncated normal distribution. As stated in Kimball's (1947) original paper and by Oates and Spencer (1962) Kimball's contribution is a distribution with parameters that are completely intuitive. In its original specification, the user only need input a mean (e.g., the average service life of some durable) and a maximum (e.g., the maximum expected service life of some durable) to estimate the probability of failure (probability density) or the life table or likelihood of survival (1 minus the cumulative distribution function).

As opposed to most other implementations of a truncated normal distribution (e.g., the [truncnorm package](https://cran.r-project.org/web/packages/truncnorm/index.html)) the kimball distribution's parameters have a behavioral interpretation. Rather than described by a mean and standard deviation (or variance), the kimball distribution is specified by its mean and maximum value. The variance need not be specified by the user but is implied by and can be expressed as a function of the mean and maximum. (See Oats and Spencer's (1962) Equation 7.)

My implementation is largely as originally described by Kimball (1947). My one addition is to generalize Kimball's (1947) equations to incorporate an arbitrary minimum. That is, Kimball (1947) originally positioned his work as a system of [life tables](https://en.wikipedia.org/wiki/Life_table) with the assumption that the domain of interest on the left-hand side always begins at zero on. I generalize this and allow the user to specify any arbitrary (but strictly positive) minimum as a function parameter.

The kimball package makes available several functions to access [Kimball's (1947)](Kimball%20(1947)%20-%20A%20System%20of%20Life%20Tables....pdf) truncated normal distribution. As stated in Kimball's (1947) original paper and by Oates and Spencer (1962) Kimball's contribution is a distribution with parameters that are completely intuitive. In its original specification, the user only need input a mean (e.g., the average service life of some durable) and a maximum (e.g., the maximum expected service life of some durable) to estimate the probability of failure (probability density) or the life table or likelihood of survival (1 minus the cumulative distribution function).

As opposed to most other implementations of a truncated normal distribution (e.g., the [truncnorm package](https://cran.r-project.org/web/packages/truncnorm/index.html)) the kimball distribution's parameters have a behavioral interpretation. Rather than described by a mean and standard deviation (or variance), the kimball distribution is specified by its mean and maximum value. The variance need not be specified by the user but is implied by and can be expressed as a function of the mean and maximum. (See Oats and Spencer's (1962) Equation 7.)

My implementation is largely as originally described by Kimball (1947). My one addition is to generalize Kimball's (1947) equations to incorporate an arbitrary minimum. That is, Kimball (1947) originally positioned his work as a system of [life tables](https://en.wikipedia.org/wiki/Life_table) with the assumption that the domain of interest on the left-hand side always begins at zero on. I generalize this and allow the user to specify any arbitrary (but strictly positive) minimum as a function parameter.

Like the un-truncated normal or Gaussian distribution, the kimball distribution maintains the property wherein its mean, median, and mode are identical (Under most conditions). But unlike the complete normal or Gaussian distribution, the Kimball distribution is undefined for x &lt; 0.

Following the naming convention in most other probability functions in R, the main functions available in the kimball package include the following:

-   rkimball() generates random deviates.
-   dkimball() returns the probability density.
-   pkimball() returns the cumulative distribution.
-   qkimball() returns the quantile (estimated by approximation and a user-specified level of precision).

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
#> [1] 0.0511109
```

And a vector containing its probability of failure in years 0,1,2,3,4 and 5 is...

``` r
time <-c(0,1,2,3,4,5)
dkimball(time,8,3)
#> [1] 0.02734781 0.10334363 0.22688442 0.28939133 0.21445008 0.09232658
```

See the [Kimball vignette](/vignettes/kimball.Rmd) for more examples.
