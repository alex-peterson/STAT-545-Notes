library(gapminder)

##look at the structure of the object
str(gapminder)

##look at head and tail of data.frame
head(gapminder)
tail(gapminder)
##look at random sample
gapminder[sample(nrow(gapminder),10),]

gapminder

##look at the table in a new tab
View(gapminder)

##tells you names of variable columns
names(gapminder)

##tells you number of columns
ncol(gapminder)

length(gapminder)
##can view rownames, but you shouldn't put rownames, however
##other datasets may include important info in the rownames
head(rownames(gapminder))

##number of rows x columns
dim(gapminder)

##tells you number of rows
nrow(gapminder)

##look at a statistical summary of object
summary(gapminder)

##Make a scatter plot with y ~ x, and data arg
plot(lifeExp ~ year, gapminder)

##make scatter plot, with one variable transformed:
plot(lifeExp ~ log(gdpPercap), gapminder)

##look at the start of a particular variable
head(gapminder$lifeExp)

##look at summary statistical data for a variable
summary(gapminder$lifeExp)

#create a histogram of a single variable
hist(gapminder$lifeExp)
hist(log(gapminder$gdpPercap))

table(gapminder$year)

##class tells you what type of object it is
class(gapminder$country)

##see how many levels of a categorical variable
nlevels(gapminder$country)
##see names of each level
levels(gapminder$continent)

##create a bar plot to show how many counts in each level of a factor
barplot(table(gapminder$continent))

##shows you how the factors are actually coded in the data.frame
unclass(gapminder$continent)

##look at the subset of gapminder that is just the country Uruguay
subset(gapminder, subset = country == "Uruguay")

library(ggplot2)
p <- ggplot(subset(gapminder, continent != "Oceania"),
            aes(x = gdpPercap, y = lifeExp)) # just initializes
p <- p + scale_x_log10() # log the x axis the right way
p + geom_point() # scatterplot
p + geom_point(aes(color = continent)) # map continent to color
p + geom_point(alpha = (1/3), size = 3) + geom_smooth(lwd = 3, se = FALSE)
## geom_smooth: method="auto" and size of largest group is >=1000, so using gam with formula: y ~ s(x, bs = "cs"). Use 'method = x' to change the smoothing method.
p + geom_point(alpha = (1/3), size = 3) + facet_wrap(~ continent)
