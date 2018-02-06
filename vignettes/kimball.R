## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(kimball)
library(tidyverse)
library(ggplot2)
library(gridExtra)
library(grid)

## ----kimball.density.examples--------------------------------------------
library(dplyr)
library(kimball)
x <- seq(from=1, to=12, by=.25)
density1 <- dkimball(x, 6, 2)
density2 <- dkimball(x, 12, 2)
density3 <- dkimball(x, 12, 6)
combined1 <- data.frame(x, density1, density2, density3)

## ----kimball.density.plots, fig.align='center', echo=FALSE---------------
p<-ggplot(combined1, aes(x=x)) +
  geom_line(aes(y = density1, colour = "dkimball(x, 6, 2)"), size=1.5) +
  geom_line(aes(y = density2, colour = "dkimball(x, 12, 2)"), size=1.5) +
  geom_line(aes(y = density3, colour = "dkimball(x, 12, 6)"), size=1.5) +
  scale_colour_manual("", 
                      breaks = c("dkimball(x, 6, 2)", "dkimball(x, 12, 2)", "dkimball(x, 12, 6)"),
                      values = c('#bdc9e1','#74a9cf','#0570b0')) +
  labs(title="Probability densities for \n various Kimball parameters") +
  labs(fill="") +
  ylab("Probability") +
   theme_bw() +
  theme(legend.position = c(0.75, 0.5), axis.text.y=element_blank())

## ----kimball.cumulative.examples-----------------------------------------
cumulative1 <- pkimball(x, 6, 2)
cumulative2 <- pkimball(x, 12, 2)
cumulative3 <- pkimball(x, 12, 6)
combined2 <- data.frame(x, cumulative1, cumulative2, cumulative3)

## ----kimball.cumulative.plots, echo=FALSE--------------------------------
library(ggplot2)
q <-ggplot(combined2, aes(x=x)) +
  geom_line(aes(y = cumulative1, colour = "pkimball(x, 6, 2)"), size=1.5) +
  geom_line(aes(y = cumulative2, colour = "pkimball(x, 12, 2)"), size=1.5) +
  geom_line(aes(y = cumulative3, colour = "pkimball(x, 12, 6)"), size=1.5) +
  scale_colour_manual("", 
                      breaks = c("pkimball(x, 6, 2)", "pkimball(x, 12, 2)", "pkimball(x, 12, 6)"),
                      values = c('#bdc9e1','#74a9cf','#0570b0')) +
  labs(title="Cumulative probabilties for \n various Kimball parameters") +
  labs(fill="") +
  ylab("Probability") +
  theme_bw() +
  theme(legend.position = c(0.75, 0.45), axis.text.y=element_blank())

## ----arrange.kimball, fig.width=7, fig.height=4, echo=FALSE--------------
grid.arrange(p, q, ncol = 2)

## ----kimball.density.cellphone-------------------------------------------
time <- c(0, .5, 1, 1.5, 2, 3, 4, 5, 6)
kimball.dens <- dkimball(time,6,2) 
# group last 3 periods to match the given chart
kimball.dens <- c(kimball.dens[1:6],sum(kimball.dens[7:9])) 
#normalize due to irregular intervals in 'time'
kimball.dens <- kimball.dens / sum(kimball.dens)                                 # 

## ----truncnorm.density.cellphone, fig.width = 6, fig.align = "center"----
library(truncnorm)
truncnorm.dens <- dtruncnorm(time,a=0,b=6, 1.9, 1.1) 
# group last 3 periods to match the given chart
truncnorm.dens <- c(truncnorm.dens[1:6],sum(truncnorm.dens[7:9]))
# normalize due to irregular intervals in 'time'
truncnorm.dens <- truncnorm.dens / sum(truncnorm.dens)                              

## ----truncnorm.kimball.comparison, echo=FALSE, fig.width = 5, fig.align = "center"----
plot(kimball.dens,type="l",col="red", 
     main="Comparison of Kimball and Truncnorm densities",
     xlab="Age of phone",
     ylab="Probability of replacement",)
legend(1, y=.24, legend=c("Kimball density", "Truncnorm density"), col=c("#bae4bc", "#2b8cbe"), lty=1, cex=0.8)
lines(truncnorm.dens,col="blue")

## ----smartphone.data, echo=FALSE-----------------------------------------
smartphone <- data.frame(year=c(2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015,
2016, 2017), shipments=c(122.36, 151.4, 173.5, 304.7, 494.6, 725.3, 1019.5, 1301.7, 1437.2, 1470.6, 1468.1))

## ----print.shipments, echo=FALSE-----------------------------------------
knitr::kable(smartphone)

## ----replacement.estimate------------------------------------------------
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

## ----print.replacements, echo=FALSE--------------------------------------
smartphone$replacement.share <- smartphone$replacements / smartphone$shipments
smartphone$replacements <- paste(round(smartphone$replacements,digits=2))
smartphone$replacement.share <- paste(round(smartphone$replacement.share*100,digits=1),"%",sep="")
knitr::kable(smartphone, align=c(rep('c', 3)))

## ----kimball.non-zero.density--------------------------------------------
library(dplyr)
library(kimball)
x <- seq(from=1, to=12, by=.25)
density1 <- dkimball(x, 6, 2)
density2 <- dkimball(x, 12, 2)
density3 <- dkimball(x, 12, 6)
combined1 <- data.frame(x, density1, density2, density3)

## ----kimball.non-density.plots, fig.align='center', echo=FALSE-----------
library(ggplot2)
p<-ggplot(combined1, aes(x=x)) +
  geom_line(aes(y = density1, colour = "dkimball(x, 6, 2)"), size=1.5) +
  geom_line(aes(y = density2, colour = "dkimball(x, 12, 2)"), size=1.5) +
  geom_line(aes(y = density3, colour = "dkimball(x, 12, 6)"), size=1.5) +
  scale_colour_manual("", 
                      breaks = c("dkimball(x, 6, 2)", "dkimball(x, 12, 2)", "dkimball(x, 12, 6)"),
                      values = c('#bdc9e1','#74a9cf','#0570b0')) +
  labs(title="Probability densities for \n various Kimball parameters") +
  labs(fill="") +
  ylab("Probability") +
   theme_bw() +
  theme(legend.position = c(0.75, 0.5), axis.text.y=element_blank())

## ----kimball.non-zero.cumulative.examples--------------------------------
cumulative1 <- pkimball(x, 6, 2)
cumulative2 <- pkimball(x, 12, 2)
cumulative3 <- pkimball(x, 12, 6)
combined2 <- data.frame(x, cumulative1, cumulative2, cumulative3)

## ----kimball.non-zero.cumulative.plots, echo=FALSE-----------------------
library(ggplot2)
q <-ggplot(combined2, aes(x=x)) +
  geom_line(aes(y = cumulative1, colour = "pkimball(x, 6, 2)"), size=1.5) +
  geom_line(aes(y = cumulative2, colour = "pkimball(x, 12, 2)"), size=1.5) +
  geom_line(aes(y = cumulative3, colour = "pkimball(x, 12, 6)"), size=1.5) +
  scale_colour_manual("", 
                      breaks = c("pkimball(x, 6, 2)", "pkimball(x, 12, 2)", "pkimball(x, 12, 6)"),
                      values = c('#bdc9e1','#74a9cf','#0570b0')) +
  labs(title="Cumulative probabilties for \n various Kimball parameters") +
  labs(fill="") +
  ylab("Probability") +
  theme_bw() +
  theme(legend.position = c(0.75, 0.45), axis.text.y=element_blank())

## ----arrange.non-zero.kimball, fig.width=7, fig.height=4, echo=FALSE-----
grid.arrange(p, q, ncol = 2)

## ----kimball.density.servers---------------------------------------------

## ---- fig.show='hold'----------------------------------------------------
plot(1:10)
plot(10:1)

## ---- echo=FALSE, results='asis'-----------------------------------------
knitr::kable(head(mtcars, 10))

