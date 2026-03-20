# @file    FunctionsAndControlFlow.R
# @brief   Demonstrates variables, functions, output functions, packages,
#          tibbles, conditional statements, and for loops in R
# @author  Cheolwon Park
# @date    2025-09-16


# =============================================================================
# 1. VARIABLES AND ASSIGNMENT
# =============================================================================

x <- 10
x
y <- "HI"
y


# =============================================================================
# 2. BUILT-IN FUNCTIONS
# =============================================================================

# print() outputs a value to the console
print("Hello World")

# sum() calculates the sum of a numeric sequence
a <- sum(1:100)
a   # 5050

# Sys.Date() returns the current system date
Sys.Date()


# =============================================================================
# 3. USER-DEFINED FUNCTIONS
# =============================================================================

# Define a function that multiplies three numbers
multi_f <- function(x, y, z) {
  res <- x * y * z
  return(res)
}
multi_f(3, 5, 6)   # 90

a <- multi_f(3, 5, 6)
a   # 90


# =============================================================================
# 4. OUTPUT FUNCTIONS: print() vs. cat()
# =============================================================================

x <- c(1, 2, 3)
print(x)            # Formatted output: [1] 1 2 3
x                   # Same as print(x) in interactive mode

y <- "a"

# print() can only handle one object at a time
# print(x, y)       # ERROR: invalid printing digits
print(x); print(y)  # Two separate print calls work

# cat() concatenates and outputs multiple objects as plain text
cat(x, y)           # 1 2 3 a


# =============================================================================
# 5. FOR LOOPS
# =============================================================================

# Generate a sequence of odd numbers: 1, 3, 5, 7, 9
x_list <- seq(1, 9, by = 2)

# Cumulative sum using a for loop
sum_x <- 0
for (x in x_list) {
  sum_x <- sum_x + x
  cat("The current loop element is ", x, "\n")
  cat("The cumulative total is ", sum_x, "\n")
}


# =============================================================================
# 6. TIBBLES AND NORMALIZATION
# =============================================================================

# Install tibble package if not already installed
# install.packages("tibble")

# Tibble is a modern version of data.frame
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df

# Manual normalization (verbose, repetitive approach)
# This motivates the creation of a rescale function
df$a <- (df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) /
  (max(df$b, na.rm = TRUE) - min(df$b, na.rm = TRUE))
df$c <- (df$c - min(df$c, na.rm = TRUE)) /
  (max(df$c, na.rm = TRUE) - min(df$c, na.rm = TRUE))
df$d <- (df$d - min(df$d, na.rm = TRUE)) /
  (max(df$d, na.rm = TRUE) - min(df$d, na.rm = TRUE))

# NA handling: any operation with NA returns NA unless na.rm = TRUE
a2 <- c(5, 2, 100, 25, NA, 6)
min(a2, na.rm = TRUE)   # 2 (ignores NA)

help(min)


# =============================================================================
# 7. RESCALE FUNCTION (DRY PRINCIPLE)
# =============================================================================

# Create a reusable rescale function to normalize to [0, 1]
rescale <- function(x) {
  rng <- range(x, na.rm = TRUE)
  cat("The range is ", rng, "\n")
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale(c(0, 5, 10))               # 0.0 0.5 1.0
rescale(c(0, 5, 10, NA, NA))       # 0.0 0.5 1.0 NA NA


# =============================================================================
# 8. COMPARISON AND LOGICAL OPERATORS
# =============================================================================

# Relational operators
5 > 3     # TRUE
5 >= 6    # FALSE
5 < 3     # FALSE
5 <= 6    # TRUE
5 == 5    # TRUE
5 != 5    # FALSE
!5        # FALSE (non-zero values are truthy)

# Logical operators with vectors
x <- 1:3
y <- 3:1
(x > 0) & (y > 1)   # Element-wise AND
(x > 0) | (y > 1)   # Element-wise OR

# Assignment vs. comparison
a <- 5
a = 10     # Also assignment (but <- is preferred in R)
a == 4     # Comparison: FALSE
a <- c(1, 5, 10)
a > 3      # FALSE TRUE TRUE (vectorized comparison)


# =============================================================================
# 9. CONDITIONAL STATEMENTS (IF-ELSE)
# =============================================================================

# Quadratic formula solver: a2*x^2 + a1*x + a0 = 0
rm(list = ls())

# Input coefficients
a2 <- 1
a1 <- 4
a0 <- 0

# Calculate the discriminant: b^2 - 4ac
discrim <- a1^2 - 4 * a2 * a0
discrim

# Determine roots based on discriminant
if (discrim > 0) {
  # Two distinct real roots
  roots <- c(
    (-a1 + sqrt(a1^2 - 4*a2*a0)) / (2*a2),
    (-a1 - sqrt(a1^2 - 4*a2*a0)) / (2*a2)
  )
} else {
  if (discrim == 0) {
    # One repeated real root
    roots <- -a1 / (2 * a2)
  } else {
    # No real roots (complex roots)
    roots <- c()
  }
}
show(roots)


# =============================================================================
# 10. CLASS TYPE IDENTIFICATION
# =============================================================================

a1 <- c(1, 2, 3)
class(a1)           # "numeric"

a2 <- TRUE
class(a2)           # "logical"

a3 <- factor(c("A"))
class(a3)           # "factor"
