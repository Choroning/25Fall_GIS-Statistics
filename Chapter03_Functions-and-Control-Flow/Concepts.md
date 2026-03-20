# Chapter 03 — Functions and Control Flow

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Variables and Functions](#1-variables-and-functions)
2. [Output Functions](#2-output-functions)
3. [User-Defined Functions](#3-user-defined-functions)
4. [Packages](#4-packages)
5. [Tibbles](#5-tibbles)
6. [Operators](#6-operators)
7. [Conditional Statements](#7-conditional-statements)
8. [Loops](#8-loops)
9. [Summary](#summary)

---

## 1. Variables and Functions

### 1.1 Basic Variable Assignment

```r
x <- 10        # Assign numeric value
y <- "HI"      # Assign character value
```

### 1.2 Built-in Functions

R provides many built-in functions for common operations:

```r
print("Hello World")   # Output a value to the console
sum(1:100)              # Sum of integers from 1 to 100 -> 5050
Sys.Date()              # Get current system date
```

> **Key Point:** Functions like `sum()`, `mean()`, `min()`, `max()` are part of R's `base` package and are always available without loading additional libraries.

---

## 2. Output Functions

### 2.1 print() vs. cat()

| Function | Behavior |
|----------|----------|
| `print()` | Outputs one object at a time, includes type formatting |
| `cat()` | Concatenates and outputs multiple objects, plain text |

```r
x <- c(1, 2, 3)
y <- "a"

# print() can only handle one object at a time
print(x)              # [1] 1 2 3
# print(x, y)         # ERROR: invalid printing digits
print(x); print(y)    # Works: prints separately

# cat() concatenates multiple objects
cat(x, y)             # 1 2 3 a (plain text, no formatting)
cat("Value:", x, "\n") # Supports newline characters
```

> **Key Point:** Use `print()` for formatted output of single objects. Use `cat()` when you need to combine multiple values or include custom formatting with `\n` (newline).

---

## 3. User-Defined Functions

### 3.1 Function Syntax

A user-defined function has four components:

1. **Function name**: stored in R environment, used to call the function
2. **Parameters**: input variables passed when the function is called
3. **Function body**: the code that implements the function's logic
4. **Return value**: the result produced by the function

```r
# General syntax
function_name <- function(param1, param2, ...) {
  # Function body
  ...
  return(result)
}
```

### 3.2 Example: Multiplication Function

```r
multi_f <- function(x, y, z) {
  res <- x * y * z
  return(res)
}

multi_f(3, 5, 6)   # Returns 90

a <- multi_f(3, 5, 6)
a                    # 90
```

### 3.3 Example: Rescale Function

A practical example that normalizes values to the [0, 1] range:

```r
rescale <- function(x) {
  rng <- range(x, na.rm = TRUE)
  cat("The range is ", rng, "\n")
  (x - rng[1]) / (rng[2] - rng[1])
}

rescale(c(0, 5, 10))               # 0.0 0.5 1.0
rescale(c(0, 5, 10, NA, NA))       # 0.0 0.5 1.0 NA NA
```

### 3.4 When to Write a Function

According to the "Rule of Three" (from *R for Data Science*):

> You should consider writing a function whenever you've copied and pasted a block of code more than twice.

Three key steps to creating a function:
1. Pick a descriptive **name** for the function
2. List the **arguments** (inputs) inside `function()`
3. Place the working code in the **body** (the `{ }` block)

> **Key Point:** It is easier to start with working code and then turn it into a function, rather than creating a function first and then trying to make it work.

---

## 4. Packages

### 4.1 Installing and Loading Packages

```r
# Install a package from CRAN
install.packages("tibble")

# Load a package into the current session
library(tibble)

# Alternative: use require() (returns FALSE instead of error if not found)
require(graphics)
```

### 4.2 Common Packages Used in This Course

| Package | Purpose |
|---------|---------|
| `tibble` | Modern data frames |
| `tidyverse` | Meta-package (includes ggplot2, dplyr, tidyr, etc.) |
| `ggplot2` | Data visualization |
| `dplyr` | Data manipulation |
| `nycflights13` | Practice dataset (NYC flights) |

---

## 5. Tibbles

### 5.1 Tibble vs. Data Frame

Tibbles are a modern reimagining of data frames from the `tibble` package. They are part of the `tidyverse` ecosystem.

```r
# Create a tibble with random normal data
df <- tibble::tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df
```

### 5.2 Manual Normalization (Without Functions)

Repetitive code that motivates the need for functions:

```r
# Normalize each column to [0, 1] range (verbose approach)
df$a <- (df$a - min(df$a, na.rm = TRUE)) /
  (max(df$a, na.rm = TRUE) - min(df$a, na.rm = TRUE))
df$b <- (df$b - min(df$b, na.rm = TRUE)) /
  (max(df$b, na.rm = TRUE) - min(df$b, na.rm = TRUE))
# ... repeated for each column
```

This repetitive pattern is exactly why we should create a `rescale()` function.

### 5.3 Handling NA Values

```r
# NA represents missing values in R
a2 <- c(5, 2, 100, 25, NA, 6)
min(a2)                   # NA (any operation with NA returns NA)
min(a2, na.rm = TRUE)     # 2 (na.rm = TRUE ignores NA values)
```

> **Key Point:** Always use `na.rm = TRUE` when calculating summary statistics on data that may contain missing values (`NA`).

---

## 6. Operators

### 6.1 Arithmetic Operators

| Operator | Operation | Example |
|----------|-----------|---------|
| `+` | Addition | `5 + 3` -> `8` |
| `-` | Subtraction | `10 - 4` -> `6` |
| `*` | Multiplication | `5 * 6` -> `30` |
| `/` | Division | `20 / 4` -> `5` |
| `%/%` | Integer division | `20 %/% 7` -> `2` |
| `%%` | Modulo (remainder) | `20 %% 7` -> `6` |
| `^` or `**` | Exponentiation | `6 ^ 2` -> `36` |

### 6.2 Relational (Comparison) Operators

| Operator | Meaning | Example | Result |
|----------|---------|---------|--------|
| `>` | Greater than | `5 > 3` | `TRUE` |
| `>=` | Greater or equal | `5 >= 6` | `FALSE` |
| `<` | Less than | `5 < 3` | `FALSE` |
| `<=` | Less or equal | `5 <= 6` | `TRUE` |
| `==` | Equal to | `5 == 5` | `TRUE` |
| `!=` | Not equal to | `5 != 5` | `FALSE` |
| `!` | Logical NOT | `!5` | `FALSE` |

### 6.3 Logical Operators

```r
x <- 1:3
y <- 3:1

(x > 0) & (y > 1)   # Element-wise AND: TRUE TRUE FALSE
(x > 0) | (y > 1)   # Element-wise OR:  TRUE TRUE TRUE
```

### 6.4 Vectorized Comparisons

```r
a <- c(1, 5, 10)
a > 3    # FALSE TRUE TRUE (element-wise comparison)
```

---

## 7. Conditional Statements

### 7.1 if-else Syntax

```r
if (condition) {
  # Code executed when condition is TRUE
} else {
  # Code executed when condition is FALSE
}
```

### 7.2 Example: Quadratic Formula Solver

```r
# Find the zeros of a2*x^2 + a1*x + a0 = 0
rm(list = ls())

# Input coefficients
a2 <- 1
a1 <- 4
a0 <- 0

# Calculate the discriminant
discrim <- a1^2 - 4 * a2 * a0

# Calculate roots based on discriminant value
if (discrim > 0) {
  roots <- c(
    (-a1 + sqrt(a1^2 - 4*a2*a0)) / (2*a2),
    (-a1 - sqrt(a1^2 - 4*a2*a0)) / (2*a2)
  )
} else if (discrim == 0) {
  roots <- -a1 / (2 * a2)
} else {
  roots <- c()   # No real roots
}
show(roots)
```

> **Key Point:** In R, the opening brace `{` must be on the same line as the `if`/`else` keyword. The `else` must also be on the same line as the closing brace `}` of the previous block.

---

## 8. Loops

### 8.1 For Loop

```r
x_list <- seq(1, 9, by = 2)   # 1, 3, 5, 7, 9

sum_x <- 0
for (x in x_list) {
  sum_x <- sum_x + x
  cat("The current loop element is ", x, "\n")
  cat("The cumulative total is ", sum_x, "\n")
}
```

**Output:**
```
The current loop element is  1
The cumulative total is  1
The current loop element is  3
The cumulative total is  4
...
The current loop element is  9
The cumulative total is  25
```

### 8.2 While Loop

```r
counter <- 1
while (counter <= 5) {
  cat("Counter:", counter, "\n")
  counter <- counter + 1
}
```

---

## Summary

| Concept | Key Point |
|---------|-----------|
| `print()` vs `cat()` | `print()` for single formatted objects; `cat()` for concatenated plain text |
| User-defined functions | Name + parameters + body + return value; write when code is repeated 3+ times |
| Packages | `install.packages()` to install; `library()` to load |
| Tibbles | Modern data frames; part of tidyverse |
| NA handling | Use `na.rm = TRUE` in summary functions |
| Operators | Arithmetic (`+`, `%%`), relational (`>`, `==`), logical (`&`, `\|`) |
| if-else | Conditional execution; brace placement matters |
| for loop | Iterate over elements of a vector or list |
| `rescale()` | Example of DRY principle: write functions to avoid repetitive code |
