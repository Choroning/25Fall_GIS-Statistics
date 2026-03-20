# Chapter 02 — Data Structures in R

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Vectors](#1-vectors)
2. [Matrices](#2-matrices)
3. [Arrays](#3-arrays)
4. [Lists](#4-lists)
5. [Data Frames](#5-data-frames)
6. [Factors](#6-factors)
7. [Type Checking and Conversion](#7-type-checking-and-conversion)
8. [Summary](#summary)

---

## 1. Vectors

### 1.1 Creating Vectors

Vectors are the most fundamental data structure in R. They are one-dimensional, ordered collections of elements of the **same type**.

```r
# Create vectors using c() function
ex_vector1 <- c(-1, 0, 1)          # Numeric vector
ex_vector2 <- c("Hello", "Hi~!")   # Character vector
a <- c(1, 2, 9)                    # Numeric vector

# Sequence generation
1:10                               # Integer sequence 1 to 10
seq(1, 9, by = 2)                  # Sequence: 1, 3, 5, 7, 9
```

### 1.2 Vector Properties

```r
mode(ex_vector1)    # "numeric"   - storage mode
mode(ex_vector2)    # "character" - storage mode

str(ex_vector1)     # num [1:3] -1 0 1
str(ex_vector2)     # chr [1:2] "Hello" "Hi~!"

length(ex_vector1)  # 3
length(ex_vector2)  # 2
```

### 1.3 Vector Operations

```r
a <- c(1, 2, 9)
mean(a)             # 4 (arithmetic mean)

# Vectorized operations
x <- c(1, 2, 3)
x + 2               # 3, 4, 5 (element-wise addition)
x * 3               # 3, 6, 9 (element-wise multiplication)
```

> **Key Point:** R operations on vectors are **vectorized** -- they automatically apply to each element without needing explicit loops.

---

## 2. Matrices

### 2.1 Creating Matrices

Matrices are two-dimensional data structures where all elements must be of the same type.

```r
x <- c(1, 2, 3, 4, 5, 6)

# Default: fills by column (column-major order)
matrix(x, nrow = 2, ncol = 3)
#      [,1] [,2] [,3]
# [1,]    1    3    5
# [2,]    2    4    6

# Fill by row
matrix(x, nrow = 2, ncol = 3, byrow = TRUE)
#      [,1] [,2] [,3]
# [1,]    1    2    3
# [2,]    4    5    6
```

### 2.2 Matrix Indexing

```r
a <- matrix(c(1,2,3,4,5,6), nrow = 2, ncol = 3)
a[1, 2]     # Element at row 1, column 2 -> 3
a[1, ]      # Entire first row
a[, 2]      # Entire second column
```

### 2.3 Checking and Converting to Matrix

```r
a1 <- 1:10
is.matrix(a1)              # FALSE (it's a vector)

a2 <- as.matrix(1:10)
is.matrix(a2)              # TRUE

is.matrix(as.matrix(1:10)) # TRUE
```

> **Key Point:** By default, R fills matrices column-by-column (column-major order). Use `byrow = TRUE` to fill row-by-row.

---

## 3. Arrays

### 3.1 Creating Arrays

Arrays extend matrices to more than two dimensions.

```r
y <- c(1, 2, 3, 4, 5, 6)

# Create a 3D array: 2 rows x 2 cols x 3 layers
array(y, dim = c(2, 2, 3))
```

The `dim` argument specifies the dimensions:
- First value: number of rows
- Second value: number of columns
- Third value: number of layers (depth)

### 3.2 Array vs. Matrix

```r
# Arrays are multi-dimensional; matrices are 2D arrays
is.array(matrix(1:6, 2, 3))  # TRUE (matrices are 2D arrays)
is.matrix(array(1:6, c(2,3))) # TRUE (2D arrays are matrices)
```

---

## 4. Lists

### 4.1 Creating Lists

Lists are the most flexible data structure in R. Unlike vectors and matrices, lists can contain elements of **different types and different sizes**.

```r
list1 <- list(c(1, 2, 3), "Hello")
list1
# [[1]]
# [1] 1 2 3
#
# [[2]]
# [1] "Hello"

str(list1)
# List of 2
#  $ : num [1:3] 1 2 3
#  $ : chr "Hello"
```

### 4.2 Named Lists

```r
pts <- list(x = cars[,1], y = cars[,2])
is.list(pts)    # TRUE
is.matrix(pts)  # FALSE
is.array(pts)   # FALSE
```

### 4.3 Mixed-Type Storage

```r
# Only lists can bundle data of different types and lengths
x <- list("a", "b", 1:10)
length(x)  # 3 (three elements in the list)
```

> **Key Point:** Lists are the **only** data structure in R that can hold elements of different types and different lengths. This makes them essential for storing complex, heterogeneous data.

### 4.4 Nested Lists

```r
x1 <- data.frame(var1 = c(1, 2, 3), var2 = c("a", "b", "c"))
x2 <- matrix(1:12, ncol = 2)
x3 <- array(1:20, dim = c(2, 5, 2))

x4 <- list(f1 = x1, f2 = x1, f3 = x2, f4 = x3)
class(x4)   # "list"
x4$f1       # Access the first element by name
```

---

## 5. Data Frames

### 5.1 Creating Data Frames

Data frames are the primary structure for tabular data in R. They are essentially lists of vectors of equal length, where each column can have a different type.

```r
ID <- c(1, 2, 3, 4, 5)
GENDER <- c("F", "M", "F", "M", "M")
AGE <- c(50, 40, 28, 50, 27)
AREA <- c("Seoul", "Gyeonggi", "Jeju", "Seoul", "Seoul")

dataframe_ex <- data.frame(ID, GENDER, AGE, AREA)
```

### 5.2 Inspecting Data Frames

```r
dataframe_ex            # Print the data frame
str(dataframe_ex)       # Structure: types, dimensions
View(dataframe_ex)      # Open in spreadsheet viewer
nrow(dataframe_ex)      # Number of rows
ncol(dataframe_ex)      # Number of columns
```

### 5.3 Accessing Columns

```r
# Using $ operator
dataframe_ex$AGE        # Returns the AGE column as a vector
mean(dataframe_ex$AGE)  # Calculate mean of AGE column

# Using bracket notation
dataframe_ex[, 3]       # Third column (AGE)
dataframe_ex[1, ]       # First row
dataframe_ex[2, 3]      # Element at row 2, column 3
```

### 5.4 Alternative: data.frame() Inline Construction

```r
x1 <- data.frame(
  var1 = c(1, 2, 3),
  var2 = c("a", "b", "c")
)
class(x1)  # "data.frame"
```

> **Key Point:** Data frames are the workhorse of data analysis in R. Each column is a variable, each row is an observation -- matching the standard tidy data format.

---

## 6. Factors

### 6.1 What are Factors?

Factors represent categorical (qualitative) data with a fixed set of possible values called **levels**.

```r
blood.type <- factor(
  c("A", "B", "AB", "O", "O"),
  levels = c("A", "B", "AB", "O")
)
class(blood.type)  # "factor"
str(blood.type)    # Factor w/ 4 levels "A","B","AB","O": 1 2 3 4 4
table(blood.type)  # Frequency table
# A  B AB  O
# 1  1  1  2
```

### 6.2 Factors vs. Character Vectors

```r
blood2 <- c("A", "B", "AB", "O", "O")
class(blood2)   # "character"
table(blood2)   # Also creates frequency table, but no fixed levels
```

### 6.3 Factor Behavior with Arithmetic

```r
var1 <- c(1, 2, 3, 1, 2)
var2 <- factor(c(1, 2, 3, 1, 2))

var1 + 2    # Works: 3, 4, 5, 3, 4
var2 + 2    # Warning! Factors are NOT numeric

mean(var1)  # 1.8
mean(var2)  # NA with warning

# Convert factor to numeric
var2_num <- as.numeric(var2)
mean(var2_num)   # Gives mean of internal codes (1, 2, 3, 1, 2)
```

### 6.4 Case Sensitivity in Factors

```r
blood <- factor(
  c("A", "a", "B", "AB", "o", "O"),
  levels = c("A", "B", "AB", "O")
)
table(blood)
# A  B AB  O
# 1  1  1  1
# Note: "a" and "o" are excluded because they don't match any level
```

> **Key Point:** Factors store data internally as integers with associated level labels. They cannot be used in arithmetic operations directly -- you must convert them to numeric first with `as.numeric()`.

---

## 7. Type Checking and Conversion

### 7.1 Checking Types

```r
is.vector(c(1, 2, 3))     # TRUE
is.matrix(matrix(1:4, 2))  # TRUE
is.list(list(1, "a"))      # TRUE
is.data.frame(mtcars)      # TRUE
is.factor(factor("A"))     # TRUE

class(c(1, 2, 3))          # "numeric"
class(TRUE)                # "logical"
class(factor("A"))         # "factor"
```

### 7.2 Type Conversion Functions

| Function | Converts to |
|----------|------------|
| `as.numeric()` | Numeric |
| `as.character()` | Character |
| `as.logical()` | Logical |
| `as.factor()` | Factor |
| `as.matrix()` | Matrix |
| `as.data.frame()` | Data frame |

### 7.3 Built-in Datasets

R includes many built-in datasets for practice:

```r
data()         # List all available datasets
cars           # Speed and stopping distance of cars
mtcars         # Motor car data (32 cars, 11 variables)
airquality     # Air quality measurements in New York
economics      # US economic time series data
```

---

## Summary

| Data Structure | Dimensions | Types Allowed | Key Function |
|---------------|------------|---------------|--------------|
| Vector | 1D | Same type only | `c()` |
| Matrix | 2D | Same type only | `matrix()` |
| Array | nD | Same type only | `array()` |
| List | 1D (nested) | Different types | `list()` |
| Data Frame | 2D | Different types per column | `data.frame()` |
| Factor | 1D | Categorical levels | `factor()` |

| Concept | Key Point |
|---------|-----------|
| Vectors | Fundamental 1D structure; all elements same type |
| Matrices | 2D; default fill is column-major (use `byrow = TRUE` for row-major) |
| Lists | Only structure that can hold mixed types and lengths |
| Data Frames | Tabular data (rows = observations, columns = variables) |
| Factors | Categorical data with fixed levels; not directly usable in arithmetic |
| `$` Operator | Access named elements in data frames and lists |
