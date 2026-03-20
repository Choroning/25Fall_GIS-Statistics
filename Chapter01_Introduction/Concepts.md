# Chapter 01 -- Introduction to R and GIS Statistics

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [What is R?](#1-what-is-r)
2. [R and RStudio Setup](#2-r-and-rstudio-setup)
3. [R as a Statistical Programming Language](#3-r-as-a-statistical-programming-language)
4. [GIS and Statistics](#4-gis-and-statistics)
5. [Course Overview](#5-course-overview)
6. [Summary](#summary)

---

## 1. What is R?

### 1.1 Definition and History

R is a programming language and free software environment designed for statistical computing and graphics. It was created by Ross Ihaka and Robert Gentleman at the University of Auckland, New Zealand, and first released in 1995.

- R is an implementation of the S programming language
- It is widely used among statisticians and data scientists for data analysis, statistical modeling, and visualization
- R is open-source and has a vast ecosystem of packages (CRAN has 19,000+ packages)

### 1.2 Why R for GIS Statistics?

R provides several advantages for GIS-related statistical analysis:

- **Spatial data handling**: Packages like `sf`, `sp`, `terra` for spatial data
- **Statistical modeling**: Built-in functions for regression, time series, classification
- **Visualization**: `ggplot2` provides publication-quality graphics including maps
- **Reproducibility**: Script-based analysis ensures reproducible research
- **Integration**: Can work with shapefiles, GeoJSON, raster data, and web mapping services

> **Key Point:** R bridges the gap between traditional GIS software and advanced statistical methods, making it ideal for spatial data analysis.

---

## 2. R and RStudio Setup

### 2.1 Installing R

R can be downloaded from the Comprehensive R Archive Network (CRAN):
- Website: https://cran.r-project.org/
- Available for Windows, macOS, and Linux

### 2.2 RStudio IDE

RStudio is the most popular integrated development environment (IDE) for R:

- **Console**: Execute R commands interactively
- **Script Editor**: Write and save R scripts (.R files)
- **Environment Panel**: View variables and data in memory
- **Plots/Help Panel**: View visualizations and documentation

### 2.3 Basic R Console Operations

```r
# Basic arithmetic
2 + 3          # Addition
10 - 4         # Subtraction
5 * 6          # Multiplication
20 / 4         # Division
20 %/% 7       # Integer division (quotient) -> 2
20 %% 7        # Modulo (remainder) -> 6
6 ^ 2          # Exponentiation -> 36
6 ** 2         # Exponentiation (alternative) -> 36
```

### 2.4 Getting Help

```r
help(mean)       # Open help page for mean()
?mean            # Shortcut for help()
help(data.frame) # Help for data.frame function
```

> **Key Point:** The `help()` function shows which package a function belongs to (e.g., `mean {base}` means `mean()` is in the `base` package).

---

## 3. R as a Statistical Programming Language

### 3.1 Variable Assignment

R uses the `<-` operator (preferred) or `=` for variable assignment:

```r
a <- 4       # Assign 4 to variable a
b <- 20      # Assign 20 to variable b
c <- a + b   # c = 24
```

**Variable naming rules:**
- Must start with a letter or period (`.`)
- Cannot start with a number, underscore, or special character
- Case-sensitive (`exam` and `Exam` are different variables)
- No spaces allowed; use underscores (`_`) instead

| Valid Names | Invalid Names |
|-------------|---------------|
| `exam`      | `1exam`       |
| `.exam`     | `_exam`       |
| `e1axm`     | `$exam`       |
| `e_xam`     | `ex a`        |

### 3.2 Assignment Operator Details

```r
A <- 2       # Assign using <-
B = 10       # Assign using = (works but <- is preferred)
C = D <- 5   # Both C and D become 5

# Important difference: <- has higher precedence than =
# Inside function arguments, = must be used for named parameters
sum(x <- 1)  # x is assigned 1 in the global environment
sum(y = 1)   # y is a named argument, NOT assigned globally
```

> **Key Point:** In R, `<-` is preferred over `=` for assignment because `<-` has higher operator precedence and `=` is reserved for function argument specification.

### 3.3 Data Types in R

R has several fundamental data types:

| Type | Description | Example |
|------|-------------|---------|
| `numeric` | Real numbers | `3.14`, `42` |
| `integer` | Whole numbers | `1L`, `100L` |
| `character` | Text strings | `"Hello"`, `'World'` |
| `logical` | Boolean values | `TRUE`, `FALSE` |
| `factor` | Categorical data | `factor(c("A", "B"))` |
| `complex` | Complex numbers | `3+2i` |

```r
# Check types
class(42)           # "numeric"
class(TRUE)         # "logical"
class("Hello")      # "character"
class(factor("A"))  # "factor"

typeof(1:10)        # "integer"
```

---

## 4. GIS and Statistics

### 4.1 What is GIS?

A Geographic Information System (GIS) is a framework for gathering, managing, and analyzing spatial and geographic data. GIS integrates:

- **Spatial data**: Location-based information (coordinates, boundaries)
- **Attribute data**: Characteristics associated with spatial features
- **Statistical methods**: Analysis techniques applied to geographic data

### 4.2 Statistical Methods in GIS

This course covers several statistical methods commonly used with geographic data:

1. **Descriptive Statistics**: Summarizing spatial data distributions
2. **Data Visualization**: Creating maps and charts with `ggplot2`
3. **Regression Analysis**: Modeling relationships between geographic variables
4. **Time Series Analysis**: Analyzing temporal patterns in spatial data
5. **Logistic Regression**: Classification of binary spatial outcomes

### 4.3 Key R Packages for GIS Statistics

| Package | Purpose |
|---------|---------|
| `ggplot2` | Data visualization and mapping |
| `dplyr` | Data manipulation and transformation |
| `sf` | Simple features for spatial data |
| `mapview` | Interactive map visualization |
| `choroplethr` | Choropleth map creation |
| `tidyverse` | Collection of data science packages |

---

## 5. Course Overview

### 5.1 Course Structure

| Chapter | Topic | Key Skills |
|---------|-------|------------|
| Ch.01 | Introduction | R basics, GIS concepts |
| Ch.02 | Data Structures | Vectors, matrices, data frames, lists |
| Ch.03 | Functions & Control Flow | User-defined functions, loops, conditionals |
| Ch.04 | Data Import/Export | Reading CSV, TXT, external data |
| Ch.05 | Data Visualization | ggplot2, dplyr (filter, select, mutate) |
| Ch.06 | Advanced Visualization | Grouping, faceting, specialized charts |
| Ch.07 | Regression Analysis | Linear regression, geographic data modeling |
| Ch.08 | Time Series Analysis | Temporal data, ARIMA, forecasting |
| Ch.09 | Logistic Regression | GLM, binary classification, odds ratio |

### 5.2 Textbooks and References

- **R for Data Science** by Hadley Wickham & Garrett Grolemund (https://r4ds.had.co.nz)
- **Introduction to Scientific Programming and Simulation Using R**
- **An Introduction to Statistical Learning** by James, Witten, Hastie, Tibshirani
- **Linear Models with R** by Julian J. Faraway
- **Time Series Analysis and Its Applications** by Shumway & Stoffer

---

## Summary

| Concept | Key Point |
|---------|-----------|
| R Language | Open-source statistical programming language with rich package ecosystem |
| Assignment | Use `<-` for variable assignment (preferred over `=`) |
| Data Types | numeric, character, logical, factor, integer, complex |
| GIS + Statistics | R bridges geographic data handling with advanced statistical modeling |
| RStudio | Primary IDE with console, editor, environment, and plots panels |
| Packages | Extend R functionality (ggplot2, dplyr, sf, tidyverse) |
| Help System | Use `help()` or `?` to access function documentation |
