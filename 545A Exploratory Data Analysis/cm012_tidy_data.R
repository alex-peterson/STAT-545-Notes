##install.packages("devtools")
library(devtools)
#install_github("rstudio/EDAWR")
library(EDAWR)
#install.packages("tidyr")
library(tidyr)
library(ggplot2)
library(gapminder)
library(dplyr)
#install.packages("plyr")
library(plyr)

View(storms)  #tidy!
View(cases)   #good format for human eyeballs, not a good format for computing
View(pollution)

##Concepts of Tidy Data
#Each variable gets its own column
#Each observation gets its own row
#Each "type" of observation is stored in a single table

##tidyr: Two IMPORTANT functions:  gather() and spread()
##Wouldn't cases be nice, if it had three columns: country, year, n
##gather() takes a "key" variable that takes the values that used to be the column names: year
##Then it also takes a "value" variable that is the names for the values themselves: n
gather(cases, "year", "n", 2:4)  #here, the variables to stack are columns 2, 3, and 4 (each year)
  #The columns not specified just get repeated

##Let's try using this to reorganize pollution, with the variables: city, large, small. 
##This will make the table smaller. Taking long data and make it short and fat.
##For spread, identify the key variable (rather than make it) and identify where the values
##will be found. 
spread(pollution, size, amount)
    #the values of size become variable names, the amounts get entered into cells under 
    #these columns

##Moving on to unite() and separate(). 
##For separate(), it takes one variable and can split it up into multiple variables.
##For example, take date of the form 01/02/1999 to month, day, and year variables. 
##Can also be used to separate units (as char) from numeric value. E.g. 10 kilos to
##10 and kilos under different variables. unite() does the opposite. 


##FACTORS: reorder()
##reorder() takes three arguments, the factor, the variable on which you want to organize
##and an optional third argument that tells you what function on the organizing variable you
##want, default is the mean. 
reorder(country, slope)   #for if you have an object with countries and slope
droplevels() #drop unused levels, but once you nuke them they're gone from that object, 
     #unless you use them within like ggplot, for example. Then its temporary. 



##Be the Boss of Factors
le_lin_fit <- function(dat, offset = 1952) {
  the_fit <- lm(lifeExp ~ I(year - offset), dat)
  setNames(data.frame(t(coef(the_fit))), c("intercept", "slope"))
}

gcoefs <- gapminder %>%
  group_by(country, continent) %>% 
  do(le_lin_fit(.)) %>% 
  ungroup()
gcoefs

##reorder() takes the arguments of factor variable, quant variable, and function done to 
##quant variable on which to reorder. For example, can sort on mean, max, min, etc. 

##What is difference between each of these objects?
post_arrange <- gcoefs %>% arrange(slope)    #arranges by slope, low to high
post_reorder <- gcoefs %>%
  mutate(country = reorder(country, slope, mean))  #arranges by mean slope in each country?
post_both <- gcoefs %>%
  mutate(country = reorder(country, slope, mean)) %>%
  arrange(country)                          #arranges by mean slope (n=1), then sorts by magnitude


##Use droplevels() to get rid of unused levels of a factor
h_countries <- c("Egypt", "Haiti", "Romania", "Thailand", "Venezuela")
hDat <- gapminder %>%
  filter(country %in% h_countries)
hDat %>% str()
  #Note, it has 142 levels in country, because the 137 not used are still hanging out

iDat  <- hDat %>% droplevels()
iDat %>% str()
  #Now: there's only 5 levels, the rest have been dropped. 


##revalue() function allows you to rename your factors. For example, change Korea, Dem. Rep.
##to North Korea. 
k_countries <- c("Australia", "Korea, Dem. Rep.", "Korea, Rep.")
kDat <- gapminder %>%
  filter(country %in% k_countries, year > 2000) %>%
  droplevels()
kDat
kDat <- kDat %>%
  mutate(new_country = revalue(country,
                               c("Australia" = "Oz",
                                 "Korea, Dem. Rep." = "North Korea",
                                 "Korea, Rep." = "South Korea")))
data_frame(levels(kDat$country), levels(kDat$new_country))
kDat
##As you can see, this doesn't actually change the value in the "Country" column, it just 
##changes the names of the factor levels. 


##You can also create a factor from scratch, from a character vector:
gapminder$continent <- as.character(gapminder$continent)
str(gapminder)
  #See! It's just a "chr" not a factor!
gapminder$continent <- factor(gapminder$continent)
str(gapminder)
  #Now it's gone back to being a factor with 5 levels!
