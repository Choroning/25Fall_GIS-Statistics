# Chapter 2 — Data Structures in R

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-18
>
> 혼자 공부하는 R 데이터 분석, 강전희와 엄동란, Ch 2

> **Learning Objectives:**
> 1. Create and manipulate vectors, lists, and data frames
> 2. Apply indexing and subsetting operations
> 3. Convert between different R data structures

---

## Table of Contents

- [1. Vectors](#1-vectors)
  - [1.1 Creating Vectors](#11-creating-vectors)
  - [1.2 Vector Properties](#12-vector-properties)
  - [1.3 Vector Operations](#13-vector-operations)
- [2. Matrices](#2-matrices)
  - [2.1 Creating Matrices](#21-creating-matrices)
  - [2.2 Matrix Indexing](#22-matrix-indexing)
  - [2.3 Checking and Converting to Matrix](#23-checking-and-converting-to-matrix)
- [3. Arrays](#3-arrays)
  - [3.1 Creating Arrays](#31-creating-arrays)
  - [3.2 Array vs. Matrix](#32-array-vs-matrix)
- [4. Lists](#4-lists)
  - [4.1 Creating Lists](#41-creating-lists)
  - [4.2 Named Lists](#42-named-lists)
  - [4.3 Mixed-Type Storage](#43-mixed-type-storage)
  - [4.4 Nested Lists](#44-nested-lists)
- [5. Data Frames](#5-data-frames)
  - [5.1 Creating Data Frames](#51-creating-data-frames)
  - [5.2 Inspecting Data Frames](#52-inspecting-data-frames)
  - [5.3 Accessing Columns](#53-accessing-columns)
  - [5.4 Alternative: data.frame() Inline Construction](#54-alternative-dataframe-inline-construction)
- [6. Factors](#6-factors)
  - [6.1 What are Factors?](#61-what-are-factors)
  - [6.2 Factors vs. Character Vectors](#62-factors-vs-character-vectors)
  - [6.3 Factor Behavior with Arithmetic](#63-factor-behavior-with-arithmetic)
  - [6.4 Case Sensitivity in Factors](#64-case-sensitivity-in-factors)
- [7. Type Checking and Conversion](#7-type-checking-and-conversion)
  - [7.1 Checking Types](#71-checking-types)
  - [7.2 Type Conversion Functions](#72-type-conversion-functions)
  - [7.3 Built-in Datasets](#73-built-in-datasets)
- [8. Comparison of Data Structures](#8-comparison-of-data-structures)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

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

> **Key Point:** R operations on vectors are **vectorized**, so they automatically apply to each element without needing explicit loops.

---

<br>

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

> **Key Point:** By default, R fills matrices column by column (column-major order). Use `byrow = TRUE` to fill row by row.

---

<br>

## 3. Arrays

### 3.1 Creating Arrays

Arrays generalize matrices to any number of dimensions, and a two-dimensional array is a matrix.

```r
y <- c(1, 2, 3, 4, 5, 6)

# Create a 3D array: 2 rows x 2 cols x 3 layers
array(y, dim = c(2, 2, 3))
```

The `dim` argument specifies the dimensions.
- The first value is the number of rows.
- The second value is the number of columns.
- The third value is the number of layers (depth).

The array above has 2 × 2 × 3 = 12 cells, but `y` has only 6 elements, so R reuses `y` from the beginning to fill the remaining cells. This is called **recycling**. Each layer is filled in column-major order, like a matrix.

```text
          Layer 1        Layer 2        Layer 3
         col1 col2      col1 col2      col1 col2
        ┌────┬────┐    ┌────┬────┐    ┌────┬────┐
 row 1  │  1 │  3 │    │  5 │  1 │    │  3 │  5 │
        ├────┼────┤    ├────┼────┤    ├────┼────┤
 row 2  │  2 │  4 │    │  6 │  2 │    │  4 │  6 │
        └────┴────┘    └────┴────┘    └────┴────┘
```

*Figure 1. Three layers of a 2 × 2 × 3 array filled by recycling six elements*

### 3.2 Array vs. Matrix

```r
# Arrays are multi-dimensional; matrices are 2D arrays
is.array(matrix(1:6, 2, 3))  # TRUE (matrices are 2D arrays)
is.matrix(array(1:6, c(2,3))) # TRUE (2D arrays are matrices)
```

---

<br>

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

`cars` is a data frame built into R (Section 7.3), and `cars[,1]` and `cars[,2]` are its speed (`speed`) and stopping distance (`dist`) columns.

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

<br>

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

> **Key Point:** Data frames are the workhorse of data analysis in R. Each column is a variable and each row is an observation, which matches the standard tidy data format.

---

<br>

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

Values that are not in the list of levels become `NA`, and `table()` does not count `NA` by default, so they are left out of the frequency table.

> **Key Point:** Factors store data internally as integer codes with associated level labels. They cannot be used in arithmetic operations directly, so they must first be converted to numeric. Here `as.numeric()` returns the internal integer codes rather than the level labels, so use `as.numeric(as.character(x))` when the numbers that the labels represent are needed. In the example of Section 6.3, the levels are 1, 2, and 3, so the two results coincide.

---

<br>

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

*Table 1. Type conversion functions and their target types*

### 7.3 Built-in Datasets

R includes many built-in datasets for practice.

```r
data()         # List all available datasets
cars           # Speed and stopping distance of cars
mtcars         # Motor car data (32 cars, 11 variables)
airquality     # Air quality measurements in New York
economics      # US economic time series data
```

> **Caution:** `economics` is not part of base R but a dataset in the `ggplot2` package, so it is available only after the package is loaded with `library(ggplot2)`.

---

<br>

## 8. Comparison of Data Structures

Table 2 compares the six data structures covered above by dimensions, allowed types, and key function.

| Data Structure | Dimensions | Types Allowed | Key Function |
|---------------|------------|---------------|--------------|
| Vector | 1D | Same type only | `c()` |
| Matrix | 2D | Same type only | `matrix()` |
| Array | nD | Same type only | `array()` |
| List | 1D (nested) | Different types | `list()` |
| Data Frame | 2D | Different types per column | `data.frame()` |
| Factor | 1D | Categorical levels | `factor()` |

*Table 2. Dimensions, allowed types, and key functions of R data structures*

---

<br>

## Summary

| Concept | Key Summary |
|---------|-----------|
| Vectors | A vector is the fundamental 1D structure of R, and all of its elements have the same type. |
| Matrices | A matrix is a 2D structure that is filled in column-major order by default and in row-major order with `byrow = TRUE`. |
| Lists | A list is the only structure that can hold elements of mixed types and lengths together. |
| Data Frames | A data frame holds tabular data in which rows are observations and columns are variables. |
| Factors | A factor holds categorical data with fixed levels and cannot be used directly in arithmetic. |
| `$` Operator | The `$` operator accesses named elements in data frames and lists. |

---

<br>

## Self-Check Questions

1. **Matrix fill order:** Give the elements of row 2 of `matrix(1:6, nrow = 3)` and of `matrix(1:6, nrow = 3, byrow = TRUE)`.

   <details>
   <summary>Answer</summary>

   Filling in column-major order makes the first column of the 3 × 2 matrix 1, 2, 3 and the second column 4, 5, 6, so row 2 is 2, 5. With `byrow = TRUE`, the rows are filled with (1, 2), (3, 4), and (5, 6), so row 2 is 3, 4.

   </details>

2. **Array elements:** Find the value of element `[1, 2, 2]` of `array(1:6, dim = c(2, 2, 3))`.

   <details>
   <summary>Answer</summary>

   Layer 1 receives 1, 2, 3, 4 in column-major order, and layer 2 receives 5, 6 followed by 1, 2 recycled from the beginning. The cells of layer 2 are filled in the order [1, 1], [2, 1], [1, 2], [2, 2], so `[1, 2, 2]` is the third value of that layer, 1 (Figure 1).

   </details>

3. **Converting a factor to numbers:** For `f <- factor(c(10, 20, 10, 30))`, find the results of `mean(as.numeric(f))` and `mean(as.numeric(as.character(f)))`.

   <details>
   <summary>Answer</summary>

   The levels are `"10"`, `"20"`, and `"30"`, and the internal codes are 1, 2, 1, 3. `as.numeric(f)` returns the codes, so the mean is (1 + 2 + 1 + 3) / 4 = 1.75. `as.character(f)` returns the labels `"10"`, `"20"`, `"10"`, `"30"`, which become 10, 20, 10, 30 as numbers, so the mean is 70 / 4 = 17.5.

   </details>

4. **Data frame access:** For `dataframe_ex` in Section 5.1, give the results of `dataframe_ex[2, 3]`, `mean(dataframe_ex$AGE)`, and `nrow(dataframe_ex)`.

   <details>
   <summary>Answer</summary>

   Column 3 is AGE, so `dataframe_ex[2, 3]` is the age in the second row, 40. AGE is 50, 40, 28, 50, 27 with a sum of 195, so the mean is 195 / 5 = 39. There are five rows, so `nrow()` is 5.

   </details>

5. **Choosing a structure:** Which data structure should be used to hold a numeric vector of length 3 and a character vector of length 5 in one object? Explain why a data frame cannot be used, and give the `length()` of the object.

   <details>
   <summary>Answer</summary>

   A list should be used. A data frame allows a different type in each column, but all columns must have the same length, so `data.frame(1:3, c("a", "b", "c", "d", "e"))` raises an error because the numbers of rows, 3 and 5, differ. The `length()` of `list(1:3, c("a", "b", "c", "d", "e"))` is the number of elements, 2.

   </details>
