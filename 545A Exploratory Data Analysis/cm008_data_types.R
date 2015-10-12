##Continuing dplyr and introduction to R Data Structures

##Load/initialize stuff
suppressPackageStartupMessages(library(dplyr))
library(gapminder)
library(ggplot2)
gtbl <- gapminder %>% 
  tbl_df
gtbl %>% 
  glimpse

##Look at GDP relative to Canada
just_canada <- gtbl %>% 
  filter(country == "Canada")
##Note: this is extremely dangerous: assumes each country has exactly 12 years of data, and those years
##are exactly the same as the 12 observed for Canada. 
gtbl <- gtbl %>% 
  mutate(canada = rep(just_canada$gdpPercap, nlevels(country)), 
         gdpPercapRel = gdpPercap / canada)
gtbl %>% 
  select(country, year, gdpPercap, canada, gdpPercapRel)
gtbl %>% 
  select(gdpPercapRel) %>% 
  summary

##Use arrange() to put stuff in a logical order for when you look at it. However, try not
##to make your analysis depend on arrange(). 
gtbl %>% 
  filter(year == 2007) %>% 
  arrange(desc(pop))

##Using group_by(). It adds extra structure to your dataset. Then when you run functions, its
##performed group-wise rather then reassembled, making analysis easier. 
##summarise() takes something with n observations -> 1 number. 
##window functions take n observations -> dataset with n observations. 
gtbl %>% 
  group_by(continent) %>% 
  summarise(n_countries = n_distinct(country))     #creates new variable called n_countries, 
                                                   #and use n_distinct() function to count unique ones.

gtbl %>% 
  filter(year %in% c(1952, 2007)) %>% 
  group_by(continent, year) %>% 
  summarise(med_lifeExp = median(lifeExp))

##Window functions: We are interested in the highest and lowest life expectancies
##in Asia, but want to know which country it belongs to. 
gtbl %>% 
  filter(continent == "Asia") %>% 
  select(year, country, lifeExp) %>% 
  arrange(year) %>% 
  group_by(year) %>% 
  #here we filter and look at those with lifeExp rank less than 2 (that is #1), for both ascending
  #and descending order 
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2)  

##Let's create an object "Asia" that stores this information, and then store the ranks as two new
##variables within this object: "le_top" "le_bottom".
asia <- gtbl %>% 
  filter(continent == "Asia") %>% 
  select(year, country, lifeExp) %>% 
  group_by(year) %>% 
  arrange(year)

#now the new variables
asia <- asia %>% 
  mutate(le_top = min_rank(lifeExp), le_bottom = min_rank(desc(lifeExp)))
asia

##Now we can answer the question "which country experienced the highest drop in 
##five year life expectancy...by continent"
gtbl %>% 
  group_by(continent, country) %>% 
  select(country, year, continent, lifeExp) %>%  #select the variables of interest
  mutate(le_delta = lifeExp - lag(lifeExp)) %>%  #create a new variable for change in LE using lag() function
  #which allows you to compare to the previous value 
  summarise(worst_le_delta = min(le_delta, na.rm = TRUE)) %>% 
  filter(min_rank(worst_le_delta) < 2) %>% 
  arrange(worst_le_delta)
