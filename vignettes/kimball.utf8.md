---
title: "A Better Truncated Normal Probability Distribution for Data Science?"
author: "Brent Johnson"
date: "2018-02-05"
output: rmarkdown::html_vignette
vignette: >
  %\VignetteIndexEntry{Vignette Title}
  %\VignetteEngine{knitr::rmarkdown}
  %\VignetteEncoding{UTF-8}
---



I've created an R package called "kimball" to impliment a trunctated normal distribution that I've found very helpful in my statistics appliations. I'm going to describe it here with a couple of examples that demonstrate its usefullness. In short, the kimball distribution perfect for reflecting judgemental input about a random variable that one believes is positive and has a lower bound (i.e., is left-truncated).  But you can work with the distribution and see.  Is it an improvement over others? Did it help you answer a key data science question?  If so, please respond back and tell me your story.

There are well established algorithms and R packages for implimenting a truncated normal distribution, i.e., a bell-shaped density that's truncated (or censored) on the left and/or right. One good implimentation is in the [truncnorm](https://cran.r-project.org/web/packages/truncnorm/index.html) R package.  This post introduces the kimball distribution as an alternative formulation of the left-truncated normal distribution.  What's unique about the kimball distribution is that its two parameters are completely intuitive.  One specifies a kimball distribution using just a mean and a maximum parameter--as in the distribution's maximum likely value or the point beyond which its likelihood is neglible.  By contrast, a normal distribution (and other implimentations of a truncated normal) is specifiied by a mean and standard deviation (or variance) parameter. 

In the normal distribution, the mean parameter is straightforward. The standard deviation (or variance) paremeter is less so. Of course One learns its definition in Statitics 101. The stanard deviation is the square root of the sum the average of squared deviations between the observed values and the mean. But most students are seldom able to think about observed phenomena in such terms. Few data scientists have a good intuitive sense for the sums of squared deviations--especially when the disribution is truncated.  In fact, other than when one of the neccesary paramters is the mean, parameter interpretability isn't a common feature among a great many probability density formulas.  The parameters of most common probability distributions don't always have an easy easy real-world, behavioral interpretation. All else equal, I much prefer the ones that do.

Enter the kimball distribution. First articulated in 1947 by Bradford Kimball (note he didn't name the distribution after himself. I did that.) and then revisited by Oates and Spencer (1962), the kimball distribution is entirely specified by just a mean and a maximum. (In its original form, the kimball distribution also assumes a minimum of zero--something I relax in one of my later examples below, suggesting yet a third intuitive parameter for tose appliations taht need it). Like all distributions, the kimball has a variance--which one can calculate by minimizing a function determined by its mean and maximum values. (See Oates & Spencer(1962)'s equation #7 for the variance formula). But for the Kimball, the variance is a descriptive term only. It's not a direct parameter and one doesn't need  to articular a variance (or standard deviation) to specify the distribution. Ratehr, one specifies the Kimball distribution simply in terms of a mean parameter and a maximum parameter.  

## Some concrete examples

Enough talk. Here below are several examples of the kimball distribution's probability density. Note I use the `dkimball()` function inside the kimball R package to complete these. 

```r
library(dplyr)
library(kimball)
x <- seq(from=1, to=12, by=.25)
density1 <- dkimball(x, 6, 2)
density2 <- dkimball(x, 12, 2)
#> Warning in hmin(S, L): The max is significantly HIGHER than the mean.
#> Results might not be correct. Please consider another distribution.
density3 <- dkimball(x, 12, 6)
combined1 <- data.frame(x, density1, density2, density3)
```




And here are the corresponding cumulative distributions. For these above example densities. I use the `pkimball()` funtion for these.

```r
cumulative1 <- pkimball(x, 6, 2)
cumulative2 <- pkimball(x, 12, 2)
#> Warning in hmin(S, L): The max is significantly HIGHER than the mean.
#> Results might not be correct. Please consider another distribution.
cumulative3 <- pkimball(x, 12, 6)
combined2 <- data.frame(x, cumulative1, cumulative2, cumulative3)
```

(Note: I need to fix the limits on pkimball and dkimball)



![](kimball_files/figure-html/arrange.kimball-1.png)<!-- -->

Kimball (1947) as well as Oates and Spencer (1962) first developed the distribution to estimate life tables. For example, the kimball density could be descriptive of a probability of a machine part's failure as function of its age. Or it could describe the distribution of human lifespans. In this later appllication (life tables and mortality rates) the Kimball competes with the much more commonly used [Gompertz distribution](https://en.wikipedia.org/wiki/Gompertz_distribution). But again, the Gompertz distribution's two parameters, eta and b, are quite opaque.  They're inputs to a complex formula for deriving the Gompertz' mean and variance (or standard deviation) and they don't have an easy interpretation..  


## The Kimball distribution for replacement rates

The benefit of a distribution with interpretable parameters is that it lends itself to estimation via judgement or easily observed inputs. One can examine easily collecged data or judgments and use these to estimate the Kimball's parameters.  For example, per the simple, publically available survey data below, a mobile phone has a median expected life of between 1.5 to 2 years (in boht the US and in all countries) and a maxium life somewhere beyond 4 years. Looking a little more closely and mentally projecting the curve below further to the right, it appears that perhaps the expected maxkum life of a cell phone in the US is rohgly 6 years in the US and 7 years in all countries.

<center>
[![Survey data on expected mobile phone life.](mobile phone replacement curve.jpg){ width=80% }](https://www.statista.com/statistics/241036/ownership-time-length-of-current-mobile-phone-until-replacement/)
</center>

It's easy to fit a corresponding truncated normal probability density to these data above using the `dkimball` function:


```r
time <- c(0, .5, 1, 1.5, 2, 3, 4, 5, 6)
kimball.dens <- dkimball(time,6,2) 
# group last 3 periods to match the given chart
kimball.dens <- c(kimball.dens[1:6],sum(kimball.dens[7:9])) 
#normalize due to irregular intervals in 'time'
kimball.dens <- kimball.dens / sum(kimball.dens)                                 # 
```

And here's the above Kimball density overlayed with the obsreved survey data:

<center>
[![The Kimball density function estimated using survey data on expected mobile phone life.](mobile phone replacement curve (fitted).jpg){ width=80% }](https://www.statista.com/statistics/241036/ownership-time-length-of-current-mobile-phone-until-replacement/)
</center>

Note that I'm not using a least squares or maxkum likelhood algorithm to fit the kimball distribution to these survey data. I could indeed do so if I wanted to take the time. however, the parameters for the kimball distribution are already given to me in the observed statistics in the original image above. The parameters for the kimball are straightway handed to me in the way one typically describes such events. The Kimball's parameters reflect the everyday language one uses to describe cell phone life and other phenomena. 

One can comprae the Kimball density to the density from the truncnorm package--another implimentation of the truncated normal distribution. Optimizing `dtruncnorm()` to achieve the same fit as `dkimball()` yields a mean and standard deviation for dtruncnorm of 1.9 and 1.1, respectively. As seen in the image below, the two distributions mimic each other exactly. (Their lines are indistinguisable). But, again, one can estimate the Kimball version of the truncated normal distribution judgementally. For the Truncnorm version it would take maximum likelihood estimation or the generaized method of moments to esting the correct, fitted standard deviation.


```r
library(truncnorm)
truncnorm.dens <- dtruncnorm(time,a=0,b=6, 1.9, 1.1) 
# group last 3 periods to match the given chart
truncnorm.dens <- c(truncnorm.dens[1:6],sum(truncnorm.dens[7:9]))
# normalize due to irregular intervals in 'time'
truncnorm.dens <- truncnorm.dens / sum(truncnorm.dens)                              
```

<center>
<img src="kimball_files/figure-html/truncnorm.kimball.comparison-1.png" style="display: block; margin: auto;" />
</center>

To extend the mobile phone example above, I sometimes use the kimball distribution to estimate replaement sales of consumer or business durables. If one knows, say, the number of mobile phones sold in a given year, the kimball distribution (applied retrospectively) enables an estimate of the replacement sales volume. And one can also apply the Kimball distribution prospectively to easily forecast likely replacement sales in the future. For example, here below is publically [available data](https://www.statista.com/statistics/271539/worldwide-shipments-of-leading-smartphone-vendors-since-2007/) showing historic mobile phone sales.^[I'm going to assume in this example that shipments equal sales. In truth, there's a small amount of inventory in the channel and shipments in a given time period is slightly higher than actual sales in that time period.]  




 year   shipments
-----  ----------
 2007      122.36
 2008      151.40
 2009      173.50
 2010      304.70
 2011      494.60
 2012      725.30
 2013     1019.50
 2014     1301.70
 2015     1437.20
 2016     1470.60
 2017     1468.10

And here's how one might work with these data and apply the kimball distribution `dkimball()`.  The above table shows *total* smartphone sales history.  I start by defining a function that takes this historic data and creates lagged values of the sales history. I put these lagged values in separate variables/columns (called shipments1, shipments2, etc.). And I save these lagged mobile phone shipment values into a data frame called `lagged.shipments`. 

I note that the first variable insied `lagged.shipments` isn't a lagged value per se but is the current period's sales. When it comes to mobile phones, some small fraction of phones get replaced within the same year they were purchased. Hence, `dkimball()` allows one to compute a probabilily for `x=0` and you'll notice that I apply `dkimball()` on a sequence startin with zero.

I next compute replacemnet probabilities for six time periods (starting with 0, i.e., within the first year) using `dkimball()`.  When it comes to phone replacemnts, I'm assuming that just a neglible number of phones last beyond the end of the fifth year, i.e., 6 total time periods (including zero).

The `mapply` function multiplies my 6-column matrix of lagged sales history (`lagged.shipments`) to the 6 element vector of replacement probabilities (`replacement.schedule`).  


```r
# create a function to lag variable x a total of n times and name it with a prefix--keeping 
# the original variable. This function creates n lags. Hence, it returns n+1 columns (including original).
f <- function(x, n, pad, prefix="lag") {
  if(!missing(pad)) {
    X <- c(rep(pad, n), x)
  }
  y <- data.frame(embed(X, n+1))
  names(y) <- c(gsub('.*\\$', '', deparse(substitute(x))), paste(prefix, seq(1:(n)), sep=""))
  return(y)
}

# apply above function
lagged.shipments <- f(smartphone$shipments, 5, 0, "ships")

# define vector of replacement probabilities given avg life=2 and maxlife=6
replacement.schedule <- dkimball(seq(0:5),6,2)

# compute estimateed replacement sales
smartphone$replacements <- rowSums(mapply(`*`, lagged.shipments, replacement.schedule))
```

The result is an estimate of replacement mobile phone sales. Note that I show replacement sales as a percentage of total sales and that this rate is growing over time.  This suggests that fewer and fewer mobile mobile phone sales are going to first-time buyers. The market is composed of an increasing number of customers on their second, third, or fourth, etc. mobile phone. 


 year    shipments    replacements    replacement.share 
------  -----------  --------------  -------------------
 2007     122.36         33.25              27.2%       
 2008     151.40         87.27              57.6%       
 2009     173.50         132.23             76.2%       
 2010     304.70         190.31             62.5%       
 2011     494.60         299.07             60.5%       
 2012     725.30         464.98             64.1%       
 2013     1019.50        683.52              67%        
 2014     1301.70        936.41             71.9%       
 2015     1437.20        1162.4             80.9%       
 2016     1470.60       1306.76             88.9%       
 2017     1468.10       1369.03             93.3%       

In practice, I might now *forecast* the first-time sales, or sales of mobile phones to first-time users and then apply the kimball distribution recursively to forecast both first-time and subsequent replacement mobile phone sales. One woudl then have a logical forecast of total mobile phone sales--resting on the parameters of the kimball distribution as a key factor.

With ths modeling framework as a base, one can easily see extensions or ways to improve the kimball's replacement rate. Perhaps the kimball's mean and maximum life parameters are conditional on yet other phoenomena or indicators. It's quite likely that the mean replacemne trate for existing phones is a function of the features and prices of newly released phones. Newly released phones with expanded feature sets miight shorten the replacement cycle.  Or operating in the other directoin, perhaps mobile phone average life--and the mean of hte kimball--is inversely correlated with GDP growth or other economic indicators. It's reasonable to expect that during times of recession or economic uncertantinly, all else equal, users will hang onto their current phones  for longer.

The Kimball distribution allows an easy way to incorporate both judgemental AND analytic inputs about a consumer or business durable's replacement rate--all in the ocntext of easily understand parameters, the mean and maximum.

## Features and limitations

There are a few limitations and parameter domain restrictions on the Kimball-related function sin this package. The kimball functoin will generate warnings and/or fail to provide good estimates if the user violates the restrictions.  

If the mean is closer to the maximum than it is to zero (or the minimum), then perhaps a truncated normal isn't appropriate eitehr.  In this case, the Kimball is symmetric and a normal disribution becomes more appropriate.

Domain restrictions on the parameters are manifest in a key ingredient in the derivation of the kimball: the ratio between its maxium and the mean parameter. By by definition, this maximum-to-mean ratio is bounded lower end by 1 since the mean population value must lie below the maximum population value. Likewise, there's a boundary on the upper end of the ration (a maximum well in excess of the mean) and beyond which the kimball's functions become undefined.  Oates & Spencer's (1982) tables place the domain for the maxium-to-mean ratio between 1.22 and 4.88.  In other words, the populatioj maximum ought no lower than 22 percent above the population mean and no higher than nearly 5 times the mean. 

Oates & Spencer (1982) say that in most survey or engineering applications, the user is rarely likely to attept fitting a truncated normal to populations with a maxium-to-mean ratio outside this range. And these restrictions rarely pose a problem.  A Kimball disribution fit with a `maximum/mean` ratio below 2 is nearly symmetric and starts to resemble a non-truncated normal distribution. In this case, `dnorm()` (R's implimentatoin of normal or gaussian density) may be more appropriate than `dkimball`. Moreover, `dnorm()` is most certainly more efficient. 

And at the other extreme, attempting to fit a kimball disribution with a `maximum/mean` ratio above 4 results in a highly skewed distribution. In that case, a negative exponetial distribution (e.g., `dexp()`) or gamma distribution (e.g., `dgamma()`) is likely more appropriate and more efficient than `dkimball`.

My implimentation adopts yet another assumption expressed by Oates & Spencer (1962) in the expression of Kimball's (1947) formulas.  In the Kimball distribution, the maximum parameter is defined as the point beyond which it's expected that only 1 unit out of 1,000 exists in the population.  This is an intuitive assumption in practice, but it creates the condition wherein the Kimball's cumulative distribution doesnt't resolve to precisely 1.0. More specifically...

$$\int_{0}^{\infty} fx(x)~dx = 1.001$$
Whereas,
$$\int_0^{max} fx(x)~dx = 1$$
In other words, when specififying a Kimball distribution or density, there yet remains some small probality that part of the population exceeds the stated parameter for the maximum. Therefore, technically speaking, the Kimball distribution function is only an *approximate* probability distribution.

## Modifying the Kimball for a non-zero lower bound

The original Kimball distrribution also assumes a minimum population value of zero (x >= 0) and a lower bound other than zero is not permitted. This assumption goes back to Kimball's (1947) specification and application to life tables--in which a zero lower bound is a reasonable assumptin. After all, no species ever lives a *negative* number of months or years.  And in my implimentation, zero is the default minimum when specifing `dkimball()` or `pkimball()`.  But I allow an option to over-ride this zero minimum assumption.  Within the function's options, one can specify a more flexibility minimum if desired.  In these next examples, I show the Kimball probability density and cumulative distributionsfor a variety of minimums and maxium values:



```r
library(dplyr)
library(kimball)
x <- seq(from=1, to=12, by=.25)
density1 <- dkimball(x, 6, 2)
density2 <- dkimball(x, 12, 2)
#> Warning in hmin(S, L): The max is significantly HIGHER than the mean.
#> Results might not be correct. Please consider another distribution.
density3 <- dkimball(x, 12, 6)
combined1 <- data.frame(x, density1, density2, density3)
```




And here are the corresponding cumulative distributions. For these above example densities. I use the `pkimball()` funtion for these.

```r
cumulative1 <- pkimball(x, 6, 2)
cumulative2 <- pkimball(x, 12, 2)
#> Warning in hmin(S, L): The max is significantly HIGHER than the mean.
#> Results might not be correct. Please consider another distribution.
cumulative3 <- pkimball(x, 12, 6)
combined2 <- data.frame(x, cumulative1, cumulative2, cumulative3)
```

(Note: I need to fix the limits on pkimball and dkimball)



![](kimball_files/figure-html/arrange.non-zero.kimball-1.png)<!-- -->

Removing the restruction of a zero minimum makes the kiimball distribution a natural fit for yet more creative applications.

## The Kimball distribution for price-band estimation

Another task wich which I am sometimes faced is to estimate the likely price bands for some product given just a few judgemental inputs. For example, a client may provide me with research (or an assumption) telling me the average price of a computer server is roughly \$2,000, the minimum price for a stripped down version is \$1,500 and the maximum price for a richly configered workplace server--one with lots of memory and processors--is $4,000. The client shares all this information with a desire to know the share servers sold in \$500 price increments. The `dkimball()` function solves this problem rather quickly. Here's the kimball density with precisely these parameters: 



Of course its entirely possible that a big server manufacturer in this product example only sells servers in excess of \$3,000 suggesting some other distribution. But without such disproving information, a single-moded distribution, covering only a positive range of \$-values, and that has a left-leaning skew (which is most definately the case since the mean is closer to the minimum than it is to the minimum), the kimball distribution provides a natural choice.  

There are a number of other distributions that I could fit to these same price data. A weibull, gamma, lognormal, or even an alternative implimentation of a truncated normal, could all be specified with parameters such that they have a shape similar to the above. However, I don't have a complete set of observed data for all price bands. I don't even have informatin on any single price band (unless one makes the trivial assumption that the entire prie range is one single price band).  Such lack of data prevents me from using a parametric estimation approach such as maximum likelihood to fit the parameters for these other distributions.  Instead, I'm left to judge the parameters.  But none of these other distributions contain interpretable parameters that are all easily judged.  By contrast, the kimball distribution's parameters (a mean, minimum, and maxium) are easily obtained.  The very words used to describe the price band problem (expressing it in terms of a mean, min, and max) are precisely the kimball distribution's neccesary and sufficient parameters.  

## Share your story

The kimball package and distribution enables the data scientist to easily fit a wide range of data using easily observed and judgemental inputs.  I keep the kimball close at hand when I need a probability density with intuitive and interpetable parameters.

Strange that such a helpful disbrituion should remain so obscure for nearly 75 years. Perhaps putting it in an R package can help remedy that and put the knowledge into more hands. If you find the kimball package helpful, if you apply it to something new and different from the above examples, I'd sure like to hear your story. 

Have you got an applicaiton for which the Kimball distribution works particularly well?




are long form documentation commonly included in packages. Because they are part of the distribution of the package, they need to be as compact as possible. The `html_vignette` output type provides a custom style sheet (and tweaks some options) to ensure that the resulting html is as small as possible. The `html_vignette` format:

- Never uses retina figures
- Has a smaller default figure size
- Uses a custom CSS stylesheet instead of the default Twitter Bootstrap style

## Vignette Info

Note the various macros within the `vignette` section of the metadata block above. These are required in order to instruct R how to build the vignette. Note that you should change the `title` field and the `\VignetteIndexEntry` to match the title of your vignette.

## Styles

The `html_vignette` template includes a basic CSS theme. To override this theme you can specify your own CSS in the document metadata as follows:

    output: 
      rmarkdown::html_vignette:
        css: mystyles.css

## Figures

The figure sizes have been customised so that you can easily put two images side-by-side. 


```r
plot(1:10)
plot(10:1)
```

![](kimball_files/figure-html/unnamed-chunk-1-1.png)![](kimball_files/figure-html/unnamed-chunk-1-2.png)

You can enable figure captions by `fig_caption: yes` in YAML:

    output:
      rmarkdown::html_vignette:
        fig_caption: yes

Then you can use the chunk option `fig.cap = "Your figure caption."` in **knitr**.

## More Examples

You can write math expressions, e.g. $Y = X\beta + \epsilon$, footnotes^[A footnote here.], and tables, e.g. using `knitr::kable()`.


                      mpg   cyl    disp    hp   drat      wt    qsec   vs   am   gear   carb
------------------  -----  ----  ------  ----  -----  ------  ------  ---  ---  -----  -----
Mazda RX4            21.0     6   160.0   110   3.90   2.620   16.46    0    1      4      4
Mazda RX4 Wag        21.0     6   160.0   110   3.90   2.875   17.02    0    1      4      4
Datsun 710           22.8     4   108.0    93   3.85   2.320   18.61    1    1      4      1
Hornet 4 Drive       21.4     6   258.0   110   3.08   3.215   19.44    1    0      3      1
Hornet Sportabout    18.7     8   360.0   175   3.15   3.440   17.02    0    0      3      2
Valiant              18.1     6   225.0   105   2.76   3.460   20.22    1    0      3      1
Duster 360           14.3     8   360.0   245   3.21   3.570   15.84    0    0      3      4
Merc 240D            24.4     4   146.7    62   3.69   3.190   20.00    1    0      4      2
Merc 230             22.8     4   140.8    95   3.92   3.150   22.90    1    0      4      2
Merc 280             19.2     6   167.6   123   3.92   3.440   18.30    1    0      4      4

Also a quote using `>`:

> "He who gives up [code] safety for [code] speed deserves neither."
([via](https://twitter.com/hadleywickham/status/504368538874703872))
