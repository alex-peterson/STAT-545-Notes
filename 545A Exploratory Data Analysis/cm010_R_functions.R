library(gapminder)


##We want to create a function that finds the difference between the max and min
##of a numeric vector. First, let's see what that might look like in lifeExp.
max(gapminder$lifeExp)
min(gapminder$lifeExp)
range <- max(gapminder$lifeExp) - min(gapminder$lifeExp)
range

##Now we can start writing the function
max_minus_min <- function(x) max(x) - min(x) 
#Does it work for our example?
max_minus_min(gapminder$lifeExp)
#Yes!

##Testing
test <- 7:17
max_minus_min(test)  #works
max_minus_min(gapminder$year) #works
max_minus_min(runif(100))  #generates random number [0,1], works

max_minus_min(as.character(1:10)) #error
max_minus_min(gapminder) #error
max_minus_min(gapminder$country) #error
max_minus_min(gapminder[c('lifeExp', 'gdpPercap', 'pop')])
    #this one works: it takes the biggest number and smallest, even though it
    #doesn't really make sense

##Make the function a li'l fancier, make it throw error in wrong context
mmm <- function(x) {
  stopifnot(is.numeric(x))
  max(x) - min(x)
}

mmm(as.character(1:10)) #get a better error
mmm(gapminder)

##Let's make an even better error
mmm2 <- function(x) {
  if (!is.numeric(x)) { #! means 'not'
    stop("I am so sorry, but this function only works for numeric input\n", 
         "You have provided an object of class: ", class(x))
  }
  max(x) - min(x)
}

mmm2(gapminder) 
mmm2(gapminder$country)


##Let's go back to our simple function, and try to generalize this function
##Let's try to add some functionality around quantiles
#First, learn about quantile function
quantile(gapminder$lifeExp)
quantile(gapminder$lifeExp, 0.15)
quantile(gapminder$lifeExp, 0.75)
?quantile
quantile(gapminder$lifeExp, probs=c(0.25, 0.75))
quantile(gapminder$lifeExp, probs=c(0.15,0.9))
boxplot(gapminder$lifeExp)$stats

the_probs <- c(0.25, 0.75)
the_quantiles <- quantile(gapminder$lifeExp, probs = the_probs)
max(the_quantiles) - min(the_quantiles)
IQR(gapminder$lifeExp)

##Now we make the function
qdiff_1 <- function(x, prob) {
  stopifnot(is.numeric(x))
  abs(quantile(x, prob[1]) - quantile(x, prob[2]))
}

##Better version from prof:
qdiff_2 <- function(x, probs) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs = probs)
  max(the_quantiles) - min(the_quantiles)
}


qdiff_2(gapminder$lifeExp, c(.25, 0.75))

##Change output, it just returns the last line, even though it did previous steps
qdiff_99 <- function(x, probs) {
  stopifnot(is.numeric(x))
  the_quantiles <- quantile(x, probs = probs)
  y <- max(the_quantiles) - min(the_quantiles)   #assigns variable, doesn't return nething
}

#Can also use return() function, but generally only use return() if you are
#returning early, rather than at the expected end of the function

##But how do we set default values for our arguments?
qdiff4 <- function(x, probs = c(0,1)) {   #here, default is max and min
  stopifnot(is.numeric(x), is.numeric(probs), length(probs) == 2, 
            min(probs) >= 0, max(probs) <= 1)
  the_quantiles <- quantile(x, probs)
  return(max(the_quantiles) - min(the_quantiles))
}
#Now, test without specifying quantiles
qdiff4(gapminder$lifeExp)
qdiff4(gapminder$lifeExp, probs = c('a', 'b'))   #get an error b/c probs is not numeric
qdiff4(gapminder$lifeExp, probs = c(0, 1, 0.5))  #get an error b/c gave more than 2 probs
qdiff4(gapminder$lifeExp, probs = c(0.1, 1.5))   #get an error b/c probs out of range

