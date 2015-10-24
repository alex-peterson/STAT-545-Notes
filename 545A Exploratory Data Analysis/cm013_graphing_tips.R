##Practical Graphing Tips!

##Using Colors in R:
suppressPackageStartupMessages(library(dplyr))
library(gapminder)
#install.packages("RColorBrewer")
library(RColorBrewer)
#install.packages("viridis")
library(viridis)

##par(), from base graphics. We want default plotting symbol to be a solid circle. 
opar <- par(pch = 19)   #change plot symbol, store it, so that you can undo later

n_c <- 8
j_year <- 2007
set.seed(1903)
countries_to_keep <-
  levels(gapminder$country) %>% 
  sample(size = n_c) %>% 
  as.character()
jdat <-
  gapminder %>% 
  filter(country %in% countries_to_keep, year == j_year) %>% 
  droplevels() %>% 
  arrange(gdpPercap)

j_xlim <- c(460, 60000)
j_ylim <- c(47, 82)
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     main = "Start your engines ...")

##look at the palette:
palette()

##Can manually assign colors:
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = "red", main = 'col = "red"')
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = c("blue", "orange"), main = 'col = c("blue", "orange")')

##Here's the default palette with named colors:
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:n_c, main = paste0('col = 1:', n_c))
with(jdat, text(x = gdpPercap, y = lifeExp, pos = 1))
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = 1:n_c, main = 'the default palette()')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = palette(),
                pos = rep(c(1, 3, 1), c(5, 1, 2))))  

##Note, if you use custom colors, it's best practice to save them as an object in one place, easy access
##Here's some ugly ones:
j_colors <- c('chartreuse3', 'cornflowerblue', 'darkgoldenrod1', 'peachpuff3',
              'mediumorchid2', 'turquoise3', 'wheat4', 'slategray2')
plot(lifeExp ~ gdpPercap, jdat, log = 'x', xlim = j_xlim, ylim = j_ylim,
     col = j_colors, main = 'custom colors!')
with(jdat, text(x = gdpPercap, y = lifeExp, labels = j_colors,
                pos = rep(c(1, 3, 1), c(5, 1, 2)))) 

##RColorBrewer is a package that has some nice palettes of colors. 
display.brewer.all()  #look at all the colors

##There are three types: sequential, qualitative, diverging.
##Sequential: low-to-high, gradients, correlations, stat significance
##Qualitative: great for non-ordered categorical things. Note the "paired" palette as well
##Diverging: great for things that range from "extreme negative" to "extreme positive"
   ##Goes through "non-extreme and boring" in the middle. t-statistics, signed correlations

##View a single palette:
display.brewer.pal(n = 8, name = 'Dark2')

##viridis library is nice: it's black-and-white friendly, and color-blind friendly
##Can look up vignette for colors and how it works. 
##Can use with ggplot:
library(ggplot2)
ggplot(data.frame(x = rnorm(10000), y = rnorm(10000)), aes(x = x, y = y)) +
  geom_hex() + coord_fixed() +
  scale_fill_viridis() + theme_bw()

##Computers like RGB, humans like HCL: hue (color), chroma (purity, vivid), 
##luminance (dark/bright, etc). 

##dichromat package is good for color-blindness. (error when installing so don't see here, but look
##it up)

##Finally, this lesson is a good place for links and info. 


##Taking control of colors in ggplot!
jdat <- gapminder %>% 
  filter(continent != "Oceania") %>% 
  droplevels() %>% 
  mutate(country = reorder(country, -1 * pop)) %>% 
  arrange(year, country) 

j_year <- 2007
q <-
  jdat %>% 
  filter(year == j_year) %>% 
  ggplot(aes(x = gdpPercap, y = lifeExp)) +
  scale_x_log10(limits = c(230, 63000))
q + geom_point()

##start by checking you have basics under control, and go for dramatic:
q + geom_point(pch = 21, size = 8, fill = I("darkorchid1"))

##Make the circle area representative of population
## ggplot2 ALERT: size now means area, not radius!
q + geom_point(aes(size = pop), pch = 21)
(r <- q +
  geom_point(aes(size = pop), pch = 21, show.legend = FALSE) +
  scale_size_continuous(range=c(1,40)))

##use ase() to map a color to a factor, using default ggplot palette. 
(r <- r + facet_wrap(~ continent) + ylim(c(39, 87)))
r + aes(fill = continent)

##gapminder comes with a color palette. 
head(country_colors)
r + aes(fill = country) + scale_fill_manual(values = country_colors)
#also be aware of scale_color_manual()


##Writing figures to file!
##Use ggsave()
p <- ggplot(gapminder, aes(x = year, y = lifeExp)) + geom_jitter()
p
ggsave("fig-io-practice.png", p)

##Pay attention to raster(pixels) vs vector(scales well) formats. 
##Also pay attention to scale. Can use scale= argument, or base_size of the active theme
##scale can be used for both label size, and when saving for image size. 



