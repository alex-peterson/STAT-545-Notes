##R Objects and Data Structures

#Types of R objects:
#Simple view: character, logical, numeric, factor
#For factors: mode is numeric, class is factor, and typeof is integer

#Everything is a vector in R, scalars are just vectors of length 1. This means
#it is easy to add stuff to the end of the object. 
x <- 3 * 4
x
is.vector(x)
length(x)
x[2] <- 100     #assign 100 to the second element, which you create
x
x[5] <- 4       #assign 4 to 5th element, the rest filled with NA
x

#Exploiting this fact
x <- 1:4
#square each element, without using a loop
y <- x^2

#Here, when creating a random variable, but you can use a vector for the 
#values in the mean
set.seed(1999)
rnorm(5, mean = 10^(1:5))

#R recycles vectors if they are not the necessary length. 
(y <- 1:3)
(z <- 3:7)
y+z        #the two vectors are different lengths, in this case we get a 
#warning. However, in some instances, they may not tell you, and it will 
#just continue adding by restarting at the beginning.
(y <- 1:10)
(z <- 3:7)
y + z      #here it doesn't warn you, because they are even multiples of 
#each other. 


##Using concatenate. Make sure it's all the same type (char, int, etc), if
##not, it will try to make it all the same, typically char. 
str(c("hello", "world"))

##Make some random vectors
n <- 8
set.seed(1)
(w <- round(rnorm(n), 2))  #floating point
(x <- 1:n) #integer
(y <- LETTERS[1:n]) #character
(z <- runif(n) > 0.3) #logical


##Using Indexing
names(w) <- letters[seq_along(w)]
w
which(w < 0)   #find which elements are less than 0
w[seq(from = 1, to = length(w), by = 2)]  #get every other element
w[-c(2,5)]    #get everything except 2 and 5


##Lists. 
##Lists are like vectors, but without the requirement that each element
##be of the same type. 
(a <- list("cabbage", pi, TRUE, 4.3))
#Note, first element is a length 1 character vector, 2nd is vector also, etc.

names(a)   #look at the names
names(a) <- c("veg", "dessert", "myAim", "number")   #add some names
a

##Indexing into a list. When you are looking for a single element, do you want
##a list of length 1 with just that element, or do you want that actual element?
(a <- list(veg = c("cabbage", "eggplant"),
           tNum = c(pi, exp(1), sqrt(2)),
           myAim = TRUE,
           joeNum = 2:6))
str(a)

##Retrieving elements:
a[[2]]   #unpackaged
a$myAim
#if you want two elements, use single brackets
a[c("veg", "tNum")]


##Arrays: Arrays are just multi-dimensional vectors. Matrices are the special
##case with 2 dimensions.