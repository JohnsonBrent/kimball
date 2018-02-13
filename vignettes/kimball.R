## ----setup, include = FALSE----------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>"
)
library(kimball)
library(tidyverse)
library(gridExtra)
library(grid)
library(scales)

## ----kimball.density.examples--------------------------------------------
library(dplyr)
library(kimball)
x <- seq(from=1, to=12, by=.25)
density1 <- dkimball(x, 6, 2)
density2 <- dkimball(x, 4, 2)
density3 <- dkimball(x, 12, 6)
combined1 <- data.frame(x, density1, density2, density3)

## ----kimball.cumulative.examples-----------------------------------------
cumulative1 <- pkimball(x, 6, 2)
cumulative2 <- pkimball(x, 4, 2)
cumulative3 <- pkimball(x, 12, 6)
combined2 <- data.frame(x, cumulative1, cumulative2, cumulative3)

## ----kimball.density.plots, fig.align='center', echo=FALSE---------------
p<-ggplot(combined1, aes(x=x)) +
  geom_line(aes(y = density1, colour = "dkimball(x, 6, 2)"), size=1.5) +
  geom_line(aes(y = density2, colour = "dkimball(x, 4, 2)"), size=1.5) +
  geom_line(aes(y = density3, colour = "dkimball(x, 12, 6)"), size=1.5) +
  scale_colour_manual("", 
                      breaks = c("dkimball(x, 6, 2)", "dkimball(x, 4, 2)", "dkimball(x, 12, 6)"),
                      values = c('#bdc9e1','#74a9cf','#0570b0')) +
  labs(title="Probability densities for \n various Kimball parameters") +
  labs(fill="") +
  ylab("Density") +
   theme_bw() +
  theme(legend.position = c(0.75, 0.5), axis.text.y=element_blank())

## ----kimball.cumulative.plots, echo=FALSE--------------------------------
library(ggplot2)
q <-ggplot(combined2, aes(x=x)) +
  geom_line(aes(y = cumulative1, colour = "pkimball(x, 6, 2)"), size=1.5) +
  geom_line(aes(y = cumulative2, colour = "pkimball(x, 4, 2)"), size=1.5) +
  geom_line(aes(y = cumulative3, colour = "pkimball(x, 12, 6)"), size=1.5) +
  scale_colour_manual("", 
                      breaks = c("pkimball(x, 6, 2)", "pkimball(x, 4, 2)", "pkimball(x, 12, 6)"),
                      values = c('#bdc9e1','#74a9cf','#0570b0')) +
  labs(title="Cumulative distribution for \n various Kimball parameters") +
  labs(fill="") +
  ylab("Probability") +
  theme_bw() +
  theme(legend.position = c(0.75, 0.45), axis.text.y=element_blank())

## ----arrange.kimball, fig.width=7, fig.height=4, echo=FALSE--------------
grid.arrange(p, q, ncol = 2)

## ----kimball.density.mobilephone-----------------------------------------
time <- c(0, .5, 1, 1.5, 2, 3, 4, 5, 6)
kimball.dens <- dkimball(time,6,2) 

# group last 3 periods to match the given chart
char.time <- data.frame(time=c(0, .5, 1, 1.5, 2, 3, "4+"))
kimball.dens.sum <- c(kimball.dens[1:6],sum(kimball.dens[7:9])) 

#normalize due to irregular intervals in 'time'
kimball.dens.sum <- kimball.dens.sum / sum(kimball.dens.sum)                                 # 

## ----truncnorm.density.mobilephone, fig.width = 6, fig.align = "center"----
library(truncnorm)
truncnorm.dens <- dtruncnorm(time,a=0,b=6, 1.9, 1.1) 

# group last 3 periods to match the given chart
truncnorm.dens <- c(truncnorm.dens[1:6],sum(truncnorm.dens[7:9]))

# normalize due to irregular intervals in 'time'
truncnorm.dens <- truncnorm.dens / sum(truncnorm.dens)                              

## ----truncnorm.kimball.comparison, echo=FALSE, fig.width = 6, fig.height= 4, fig.align = "center"----
ggplot(char.time, aes(x=time, group = 1)) +
  geom_line(aes(y = kimball.dens.sum, colour = "dkimball(time, 6, 2)"), size=1.5) +
  geom_line(aes(y = truncnorm.dens, colour = "dtruncnorm(time,a=0,b=6, 1.9, 1.1"), size=1.5) +
  scale_colour_manual("", 
                      breaks = c("dkimball(time, 6, 2)", "dtruncnorm(time,a=0,b=6, 1.9, 1.1"),
                      values = c('#bdc9e1','#74a9cf')) +
  labs(title="Probability densities for the kimball and truncnorm functions fit to\n mobile phone survey data", subtitle = "The two functions produce identical results and their lines below are directly on \n top of each other.") +
  theme(plot.title = element_text(hjust = 0.5)) +
  ylab("Probability") +
  xlab("Age of mobile phone at replacement (years)") +
  theme_bw() +
  theme(legend.position = c(0.5, 0.25))

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

# apply above function and create SIX lagged shipment values (plus current period)
lagged.shipments <- f(smartphone$shipments, 6, 0, "shipments")

# define vector of replacement probabilities given avg life=2 and maxlife=6
time <- seq(0, 6)
kimball.dens <- dkimball(time,6,2)
replacement.schedule <- kimball.dens / sum(kimball.dens)

# compute estimateed replacement sales
smartphone$replacements <- rowSums(mapply(`*`, lagged.shipments, replacement.schedule))

## ----print.replacements, echo=FALSE--------------------------------------
smartphone$`replacement share` <- smartphone$replacements / smartphone$shipments
smartphone$`first-time sales` <- smartphone$shipments - smartphone$replacements
smartphone$replacements <- paste(round(smartphone$replacements,digits=2))
smartphone$`replacement share` <- percent_format()(smartphone$`replacement share`)
smartphone$`first-time sales` <- paste(round(smartphone$`first-time sales`,digits=2))

knitr::kable(smartphone, align=c(rep('c', 3)))

## ----kimball.non-zero.density, echo-TRUE---------------------------------
x <- seq(from=1, to=10, by=2)
dkimball(x, 6, 3, min=1)

x <- seq(from=100, to=1000, by=100)
pkimball(x, 1000, 300, 100)

## ----kimball.density.servers, fig.width=7--------------------------------
# specify the ranges
price.ranges <- seq(from=1500, to=4000, by=250)

# compute the densities
price.densities <- dkimball(price.ranges, 4000, 2250, 1500)
price.probabilities <- price.densities / sum(price.densities)

## ----kimball.density.servers.plot, echo=FALSE, fig.width=7---------------
# plot them
df <- data.frame(price=price.ranges, probabilties=price.probabilities)

ggplot(data=df, aes(x=price, y=probabilties)) +
  geom_bar(stat="identity", colour="black", fill="#E69F00") +
  labs(title="Server price bands") +
  ylab("Probability") +
  xlab("Server price") +
  annotate("label", x = 3500, y = .15, label = "dkimball(price.ranges, \n S=$4,000, L=$2,250, min=$1,500)") +  
  theme_bw() + 
  theme(plot.title = element_text(hjust = 0.5)) +
  scale_x_continuous(labels = dollar, breaks = c(1500, 2000, 2500, 3000, 3500, 4000))

## ----kimball.density.servers.table, echo=FALSE, fig.width=7--------------
df$probabilties <- percent_format()(df$probabilties)
df$price <- dollar_format()(df$price)
knitr::kable(df,align=c(rep('c', 3)))

