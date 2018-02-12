

#Histogram
histo_plot <- ggplot(mpg, aes(displ)) +
  geom_histogram(aes(fill=class), 
                 binwidth = .1, 
                 col="black", 
                 size=.1) 

#Box plot
box_plot <- ggplot(mpg, aes(x=reorder(trans, hwy), y=hwy, fill=trans)) + 
  geom_boxplot() +
  xlab("class") +
  theme(legend.position="none")


#pie chart
pie_chart <- ggplot(mpg, aes(x="", y=hwy, fill=trans))+
  geom_bar(width = 1, stat = "identity") + 
  coord_polar("y", start=0)


#line plot
dens <- with(diamonds, tapply(price, INDEX = cut, density))
df <- data.frame(
  x = unlist(lapply(dens, "[[", "x")),
  y = unlist(lapply(dens, "[[", "y")),
  cut = rep(names(dens), each = length(dens[[1]]$x))
)

line_plot <- ggplot(df, aes(x=x, y=y, group=cut, color=cut)) + 
  geom_line(size=1)


histo_plot + theme_IPR()
box_plot + theme_IPR()
pie_chart + theme_IPR()
line_plot + theme_IPR()