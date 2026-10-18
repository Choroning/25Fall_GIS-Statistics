# @file    Lab_DataStructures.R
# @brief   Demonstrates R data structures: vectors, matrices, arrays, lists,
#          data frames, and factors with practical examples
# @author  Cheolwon Park
# @date    2025-09-09


# =============================================================================
# 1. VARIABLES AND BASIC OPERATIONS
# =============================================================================

a <- 4
b <- 20
c <- a + b   # c = 24


# =============================================================================
# 2. DATA FRAMES
# =============================================================================

# Create a data frame from individual vectors
ID <- c(1, 2, 3, 4, 5)
GENDER <- c("F", "M", "F", "M", "M")
AGE <- c(50, 40, 28, 50, 27)
AREA <- c("Seoul", "Gyeonggi", "Jeju", "Seoul", "Seoul")

dataframe_ex <- data.frame(ID, GENDER, AGE, AREA)
dataframe_ex
str(dataframe_ex)   # Display the internal structure of the data frame


# =============================================================================
# 3. BUILT-IN FUNCTIONS AND HELP
# =============================================================================

# Calculate the mean of a numeric vector
a <- c(1, 2, 9)
mean(a)              # Returns 4

# Access help documentation
# help(mean)         -> shows mean is in the 'base' package
# help(data.frame)   -> documentation for data.frame()


# =============================================================================
# 4. VECTORS
# =============================================================================

# Create numeric and character vectors
ex_vector1 <- c(-1, 0, 1)
ex_vector2 <- c("Hello", "Hi~!")

# Check storage mode
mode(ex_vector1)     # "numeric"
mode(ex_vector2)     # "character"

# Check structure
str(ex_vector1)      # num [1:3] -1 0 1
str(ex_vector2)      # chr [1:2] "Hello" "Hi~!"

# Check length
length(ex_vector1)   # 3
length(ex_vector2)   # 2


# =============================================================================
# 5. MATRICES
# =============================================================================

# Create a matrix (default: column-major fill order)
x <- c(1, 2, 3, 4, 5, 6)
matrix(x, nrow = 2, ncol = 3)

# Compare column-fill vs row-fill
x_matrix1 <- matrix(x, nrow = 2, ncol = 3)
x_matrix2 <- matrix(x, nrow = 2, ncol = 3, byrow = TRUE)

x_matrix1
# x_matrix1 fills data by column (vertically, the default behavior)
x_matrix2
# x_matrix2 fills data by row (horizontally) due to byrow = TRUE

# Matrix indexing
a <- matrix(x, nrow = 2, ncol = 3)
a[1, 2]   # Element at row 1, column 2

# Check and convert to matrix
a1 <- 1:10
is.matrix(a1)              # FALSE (it's a vector)
a2 <- as.matrix(1:10)
is.matrix(a2)              # TRUE
is.matrix(as.matrix(1:10)) # TRUE


# =============================================================================
# 6. ARRAYS
# =============================================================================

# Create a 3D array: 2 rows x 2 columns x 3 layers
y <- c(1, 2, 3, 4, 5, 6)
array(y, dim = c(2, 2, 3))


# =============================================================================
# 7. LISTS
# =============================================================================

# Lists can hold elements of different types
list1 <- list(c(1, 2, 3), "Hello")
list1
str(list1)

# Using built-in cars dataset to create a named list
require(graphics)
pts <- list(x = cars[, 1], y = cars[, 2])

is.array(pts)   # FALSE
is.matrix(pts)  # FALSE
is.list(pts)    # TRUE

# Lists are the only structure that can bundle different types together
x <- list("a", "b", 1:10)
length(x)        # 3


# =============================================================================
# 8. FACTORS
# =============================================================================

# Create a factor with specified levels
blood.type <- factor(
  c("A", "B", "AB", "O", "O"),
  levels = c("A", "B", "AB", "O")
)
class(blood.type)   # "factor"
str(blood.type)
table(blood.type)   # Frequency table

# Case sensitivity matters: "a" and "o" won't match "A" and "O"
blood <- factor(
  c("A", "a", "B", "AB", "o", "O"),
  levels = c("A", "B", "AB", "O")
)
table(blood)        # "a" and "o" are excluded (NA)

# Factor vs character vector comparison
blood2 <- c("A", "B", "AB", "O", "O")
class(blood2)       # "character"
str(blood2)
table(blood2)

# Substring and factor example
ff <- factor(substring("statistics", 1:10, 1:10), levels = letters)
substring("statistics", 1:10, 1:10)


# =============================================================================
# 9. NUMERIC vs. FACTOR COMPARISON
# =============================================================================

var1 <- c(1, 2, 3, 1, 2)           # Numeric vector
var2 <- factor(c(1, 2, 3, 1, 2))   # Factor (categorical variable)

var1          # Prints as numbers
var2          # Prints with Levels: 1 2 3

var1 + 2      # Works: element-wise addition
# var2 + 2    # Warning: factors cannot be used in arithmetic

class(var1)   # "numeric"
class(var2)   # "factor"

levels(var1)  # NULL (numeric vectors have no levels)
levels(var2)  # "1" "2" "3"

mean(var1)    # 1.8
# mean(var2)  # NA with warning

# Convert factor to numeric (returns internal integer codes)
var2 <- as.numeric(var2)
mean(var2)    # Mean of internal codes
class(var2)   # "numeric"
levels(var2)  # NULL


# =============================================================================
# 10. COMPLEX DATA STRUCTURE EXAMPLES
# =============================================================================

# Data frame
x1 <- data.frame(
  var1 = c(1, 2, 3),
  var2 = c("a", "b", "c")
)
class(x1)        # "data.frame"

# Matrix
x2 <- matrix(c(1:12), ncol = 2)
class(x2)        # "matrix" "array"

# Array
x3 <- array(1:20, dim = c(2, 5, 2))

# Nested list containing all the above
x4 <- list(f1 = x1, f2 = x1, f3 = x2, f4 = x3)
class(x4)        # "list"

# Access list elements
x4$f1            # First element (data frame)

# Access data frame columns
x1$var1          # Numeric column
mean(x1$var1)    # Mean of var1
