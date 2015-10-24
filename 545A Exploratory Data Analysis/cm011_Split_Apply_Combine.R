##Split Apply Combine, aka Data Aggregation

##Pay attention to: 1) how you specify the pieces, 2) how they get put back together
##In base R: use apply functions. We will use dplyr (for data.frames) and plyr and purrr. 

##plyr functions all take form "ddply" meaning d=data.frame in, d=data.frame out, and ply. 
##also aaply, daply, etc. 

##Guided Practice using linear regression
library(gapminder)
library(ggplot2)
suppressPackageStartupMessages(library(dplyr))
library(magrittr)

##Extract data for one country to develop code
j_country <- "France"
(j_dat <- gapminder %>% 
  filter(country == j_country))
##Plot the data to see what it looks like
p <- ggplot(j_dat, aes(x = year, y = lifeExp))
p + geom_point() + geom_smooth(method = "lm", se = FALSE)
##Fit a linear regression line
j_fit <- lm(lifeExp ~ I(year - 1952), j_dat) #this model makes reference point 1952, not 0 for intercept
coef(j_fit)  #look at estimated coefficients

##Now we can create a working function for any country
le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat) 
  coef(the_fit)
  setNames(coef(the_fit), c("Intercept", "Slope"))
}
le_lin_fit(j_dat)

##Now let's test this function on Zimbabwe
j_country <- "Zimbabwe"
(j_dat <- gapminder %>% filter(country == j_country)) #object for just Zimbabwe

p <- ggplot(j_dat, aes(x = year, y = lifeExp))
p + geom_point() + geom_smooth(method = "lm", se = FALSE) #look at the graph

le_lin_fit(j_dat)  #the results appear to match

##Try calling the function directly
le_lin_fit(gapminder %>% filter(country == "Zimbabwe"))


##Using dplyr::do
gapminder %>% 
  group_by(continent) %>% 
  summarize(ave_lifeExp = mean(lifeExp))

##Go back to our function from before:
qdiff <- function(x, probs = c(0, 1), na.rm = TRUE) {
  the_quantiles <- quantile(x = x, probs = probs, na.rm = na.rm)
  return(max(the_quantiles) - min(the_quantiles))
}
qdiff(gapminder$lifeExp)

##Apply this function to each continent
gapminder %>% 
  group_by(continent) %>% 
  summarize(qdiff = qdiff(lifeExp))

##What if you want to return something other than a single number from each group?
##Use do() 
gapminder %>%
  filter(year == 2007) %>%   #only look at 2007 
  group_by(continent) %>%    #group by continent
  do(head(., 2))             #only look at first two observations using the head() function

##What's the deal with the '.'? It is a placeholder, used frequently in do() statements. 

##Let's use do() to find the 10th most populous country in 2002 for each continent
gapminder %>% 
  filter(year == 2002) %>% 
  group_by(continent) %>% 
  arrange(desc(pop)) %>% 
  do(slice(.,10))         #slice() selects a row by position
#or
gapminder %>% 
  filter(year == 2002) %>% 
  group_by(continent) %>% 
  filter(min_rank(desc(pop)) == 10)
##Note that Oceania has gone missing (b/c it has less than 10 countries) 
##And that the results produce rows in different order

##DO NOT NAME THINGS IN DO()!
weird_df <- gapminder %>% 
  group_by(continent) %>% 
  do(range = range(.$lifeExp))

weird_df[4, ]
weird_df[[4, 'range']]  #ask for the values from the list at location 4


##Look at correlations between year and life expectancy
(ov_cor <- gapminder %$%
  cor(year, lifeExp))


##Let's return to le_lin_fit function, but ensure it returns a dataframe
le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(data.frame(t(coef(the_fit))), c("Intercept", "Slope"))
}
le_lin_fit(gapminder %>% filter(country == "Canada"))

##Now we can place this function inside a do() call to perform for every country
gfits_me <- gapminder %>% 
  group_by(country) %>% 
  do(le_lin_fit(.))
gfits_me

##Now we learn about the BROOM package!
#install.packages("broom")
library(broom)
##Get fitted model results
gfits_broom <- gapminder %>% 
  group_by(country, continent) %>% 
  do(tidy(lm(lifeExp ~ I(year - 1952), data=.)))
gfits_broom

##We can store the linear models for each country as a value in a column
##we call "fit":
fits <- gapminder %>% 
  group_by(country, continent) %>% 
  do(fit = lm(lifeExp ~ I(year - 1952), .))
fits

##Now that we have one linear model per country, we can use broom to 
##examine the data
fits %>% 
  tidy(fit)

fits %>% 
  augment(fit)   #takes a statistical model and converts the info into columns of your data.frame

