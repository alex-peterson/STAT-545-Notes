##install.packages("ggplot2", dependencies = TRUE)
library(ggplot2)
library(gapminder)

##For tutorials, see https://github.com/jennybc/ggplot2-tutorial

##Scatter Plots

str(gapminder)

ggplot(gapminder, aes(x = gdpPercap, y = lifeExp))  #not yet anything to plot

p <- ggplot(gapminder, aes(x = gdpPercap, y = lifeExp)) #initializes and creates object
p + geom_point()  #scatterplot

#need to transform the x-axis (gdpPercap)
ggplot(gapminder, aes(x = log10(gdpPercap), y= lifeExp)) + geom_point()
#however, the label for these axes isn't great.

#Better way to log transform
p + geom_point() +scale_x_log10()
#Note the gdpPercap as the axis label, and units are the actual units

#can make the change stick:
p <- p + scale_x_log10()
#this is a common workflow process, start with basics, see the change,
#and then re-define the object to keep these changes. 

#to manually change an axis label:
p + geom_point() + scale_x_log10() + xlab("GDP Percapita (Log 10)")

#change color of dots, based on continent
#Note that while we are specifying aes here, we could also have included the color
#information in the original ggplot command, under the aes() part.
p + geom_point(aes(color = continent)) + scale_x_log10()

#Can set transparency, so that when points are overlapping, they
#don't get covered up.
p + geom_point(alpha = (1/3), size = 3)

#add a smooth, fitted curve through the data
#Can adjust width with lwd, and whether it includes a shaded area of se. 
p + geom_point() + geom_smooth(lwd = 3, se = FALSE)

#you can also adjust the type of fit, for example by making it a linear reg:
p + geom_point() + geom_smooth(lwd = 2, se = FALSE, method = "lm")

#In fact, you can again sort color by continent, and add different fitted
#lines for each continent:
p + aes(color = continent) + geom_point() + geom_smooth(lwd = 2, se = FALSE, method = "lm")
#or all wiggildy, and with transparency to make the lines show up:
p + aes(color = continent) + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 2, se = FALSE)

#FACETTING:

#The following will split the graph into several graphs, divided according
#to continent
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent)

#to add a fitted line to each graph:
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent) + geom_smooth(lwd = 2, se = FALSE)
#can also use things like facet_grid, to line the plots up. 

