##install.packages("dplyr")
suppressPackageStartupMessages(library(dplyr))   #so you don't have to see messages on startup everytime
library(gapminder)

str(gapminder)
head(gapminder)

##convert the gapminder object using the tbl_df function from dplyr. 
##tbl looks a lot nicer when you print it, tells you type of variable, etc.
gtbl <- tbl_df(gapminder)
gtbl
glimpse(gtbl)   #a lot like str, but a little cleaner.

##It is not necessary to convert a data.frame into a tbl in order to use dplyr.
##dplyr works perfectly fine with data.frames, but tbl just looks a little nicer on printing. 
##tbl_df is a special case of a tbl, which is a special case of data.frame.

##Regarding snippets of data: try not to make a bunch of little objects. Maybe okay to make an object
##for initial testing, but think about how are you going to scale up. Instead of subset, consider dplyr's
##filter:

filter(gtbl, lifeExp < 29)
filter(gtbl, country == "Rwanda")
filter(gtbl, country %in% c("Rwanda", "Canada"))
filter(gtbl, year > 1990, continent == "Asia")

##The pipe operator. %>% "then". Takes the left-hand side, and pipes it into the function that comes
##next. For example, it takes head(gapminder) to gapminder %>% head. Why do this? Because then the
##function can take arguments, so it makes it easier to do more sophisticated things. ctrl+shift+M
gapminder %>% head
gapminder %>% head(3)    #this is equivalent to head(gapminder, 3)

##select:  filter is used for rows, select is used for variables. 
select(gtbl, year, lifeExp)

##Example using pipe. This takes the tbl, selects columns, then displays 6 rows.
gtbl %>% 
  select(year, lifeExp) %>%
  head(6)

##Another example:
gtbl %>%
  select(continent, year, pop) %>% 
  head(50)

##can use pipeline directly with ggplot to make a plot without creating an intermediary object
gtbl %>% filter(country =="Canada") %>% ggplot(aes(x = year, y= lifeExp)) + geom_point()

##mutate() to create new variables from old variables. Create TOTAL gdp, by multiplying 
##gdpPercap by population. And store this new variable within the original gtbl object. 
gtbl <- gtbl %>% 
  mutate(gdp = gdpPercap*pop)
gtbl %>% glimpse

##use arrange() to order by row, and can sort by ascending or descending order.
##this example creates a really boring bar chart of the 10 countries with highest
##life expectancy. 
gtbl %>% 
  filter(year == 2007) %>%
  arrange(desc(lifeExp)) %>% 
  head(10) %>% 
  ggplot(aes(x = country, y = lifeExp)) + geom_bar(stat = "identity")

##rename() to rename variables. Here we take "pop" and change it to "population".
gtbl <- gtbl %>% 
  rename(population = pop)
gtbl   ##now when we print this, we see that the variable name has changed to "population." 


##group_by() allows you to group your data into chunks that you can then take a look at. 
##here, we can group by a variable, and see how many observations per continent:
gtbl %>% 
  group_by(continent) %>% 
  summarize(n_obs = n())

##alternatively, we can use tally to produce the same results.
gtbl %>% 
  group_by(continent) %>% 
  tally

##We can also find out how many distinct countries there are per continent:
gtbl %>% 
  group_by(continent) %>% 
  summarize(n_obs = n(), n_countries = n_distinct(country))

##This also allows us to produce more complicated statistical summaries:
gtbl %>% 
  filter(year %in% c(1952, 2007)) %>% 
  group_by(continent, year) %>% 
  summarise_each(funs(mean, median), lifeExp, gdpPercap)

##Example using just Asia:
gtbl %>% 
  filter(continent == "Asia") %>% 
  group_by(year) %>% 
  summarize(min_lifeExp = min(lifeExp), max_lifeExp = max(lifeExp))

##or:
gtbl %>% 
  filter(continent == "Asia") %>% 
  group_by(year) %>% 
  summarize_each(funs(max, min), lifeExp, gdpPercap)

##however, we don't know which countries are contributing these extreme values. That's where we 
##use windows functions. 
gtbl %>% 
  filter(continent == "Asia") %>% 
  select(year, country, lifeExp) %>% 
  arrange(year) %>% 
  group_by(year) %>% 
  filter(min_rank(desc(lifeExp)) < 2 | min_rank(lifeExp) < 2)
