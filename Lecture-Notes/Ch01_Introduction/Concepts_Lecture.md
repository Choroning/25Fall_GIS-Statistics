# Chapter 1 — Introduction to R and GIS Statistics

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-26
>
> 혼자 공부하는 R 데이터 분석, 강전희와 엄동란, Ch 1

> **Learning Objectives:**
> 1. Set up the R and RStudio environment
> 2. Understand basic R syntax and data types
> 3. Execute simple R commands and scripts

---

## Table of Contents

- [1. What is R?](#1-what-is-r)
  - [1.1 Definition and History](#11-definition-and-history)
  - [1.2 Why R for GIS Statistics?](#12-why-r-for-gis-statistics)
- [2. R and RStudio Setup](#2-r-and-rstudio-setup)
  - [2.1 Installing R](#21-installing-r)
  - [2.2 RStudio IDE](#22-rstudio-ide)
  - [2.3 Basic R Console Operations](#23-basic-r-console-operations)
  - [2.4 Getting Help](#24-getting-help)
- [3. R as a Statistical Programming Language](#3-r-as-a-statistical-programming-language)
  - [3.1 Variable Assignment](#31-variable-assignment)
  - [3.2 Assignment Operator Details](#32-assignment-operator-details)
  - [3.3 Data Types in R](#33-data-types-in-r)
- [4. GIS and Statistics](#4-gis-and-statistics)
  - [4.1 What is GIS?](#41-what-is-gis)
  - [4.2 Statistical Methods in GIS](#42-statistical-methods-in-gis)
  - [4.3 Key R Packages for GIS Statistics](#43-key-r-packages-for-gis-statistics)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. What is R?

### 1.1 Definition and History

R is a programming language and free software environment designed for statistical computing and graphics. It was created by Ross Ihaka and Robert Gentleman at the University of Auckland, New Zealand, and released as free software in 1995.

- R is an implementation of the S programming language.
- It is widely used among statisticians and data scientists for data analysis, statistical modeling, and visualization.
- R is open-source and has a vast ecosystem of packages, with more than 19,000 packages on CRAN.

### 1.2 Why R for GIS Statistics?

R provides several advantages for GIS-related statistical analysis.

- **Spatial data handling:** Packages such as `sf`, `sp`, and `terra` handle spatial data.
- **Statistical modeling:** Built-in functions support regression, time series, and classification.
- **Visualization:** `ggplot2` produces publication-quality graphics, including maps.
- **Reproducibility:** Script-based analysis supports reproducible research.
- **Integration:** R can work with shapefiles, GeoJSON, raster data, and web mapping services.

> **Key Point:** R bridges the gap between traditional GIS software and advanced statistical methods, which makes it well suited to spatial data analysis.

---

<br>

## 2. R and RStudio Setup

### 2.1 Installing R

R can be downloaded from the Comprehensive R Archive Network (CRAN).

- Website: https://cran.r-project.org/
- R is available for Windows, macOS, and Linux.

### 2.2 RStudio IDE

RStudio is the most popular integrated development environment (IDE) for R, and its default layout divides the window into four panels.

- **Console:** Executes R commands interactively.
- **Script Editor:** Writes and saves R scripts (.R files).
- **Environment Panel:** Shows the variables and data in memory.
- **Plots/Help Panel:** Shows visualizations and documentation.

```text
┌──────────────────────┬────────────────────────────┐
│ Script Editor        │ Environment / History      │
│                      │                            │
├──────────────────────┼────────────────────────────┤
│ Console              │ Files / Plots /            │
│                      │ Packages / Help            │
└──────────────────────┴────────────────────────────┘
```

*Figure 1. Default panel layout of RStudio*

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

> **Key Point:** The help page opened by `help()` shows which package a function belongs to. For example, `mean {base}` means that `mean()` is in the `base` package.

---

<br>

## 3. R as a Statistical Programming Language

### 3.1 Variable Assignment

R uses the `<-` operator (preferred) or `=` for variable assignment.

```r
a <- 4       # Assign 4 to variable a
b <- 20      # Assign 20 to variable b
c <- a + b   # c = 24
```

**Variable naming rules:**
- A name must start with a letter or a period (`.`), and a leading period cannot be followed by a digit.
- A name cannot start with a number, an underscore, or a special character.
- Names are case-sensitive (`exam` and `Exam` are different variables).
- Spaces are not allowed, so use underscores (`_`) to separate words.
- Reserved words such as `if`, `TRUE`, and `function` cannot be used as names.

| Valid Names | Invalid Names |
|-------------|---------------|
| `exam`      | `1exam`       |
| `.exam`     | `_exam`       |
| `e1axm`     | `$exam`       |
| `e_xam`     | `ex a`        |

*Table 1. Examples of valid and invalid variable names*

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

> **Key Point:** In R, `<-` is preferred over `=` for assignment. `<-` has higher operator precedence, and `=` is also used to specify function arguments, so it can be confused with assignment.

### 3.3 Data Types in R

R has several fundamental data types.

| Type | Description | Example |
|------|-------------|---------|
| `numeric` | Real numbers | `3.14`, `42` |
| `integer` | Whole numbers | `1L`, `100L` |
| `character` | Text strings | `"Hello"`, `'World'` |
| `logical` | Boolean values | `TRUE`, `FALSE` |
| `factor` | Categorical data | `factor(c("A", "B"))` |
| `complex` | Complex numbers | `3+2i` |

*Table 2. Fundamental data types in R*

```r
# Check types
class(42)           # "numeric"
class(TRUE)         # "logical"
class("Hello")      # "character"
class(factor("A"))  # "factor"

typeof(1:10)        # "integer"
```

Unlike the other five types, `factor` is a class that attaches a levels attribute to an integer vector. Therefore `class(factor("A"))` is `"factor"`, but `typeof(factor("A"))` is `"integer"`. Factors are covered in detail in Chapter 2.

---

<br>

## 4. GIS and Statistics

### 4.1 What is GIS?

A Geographic Information System (GIS) is a framework for gathering, managing, and analyzing spatial and geographic data. GIS integrates the following three elements.

- **Spatial data:** Location-based information such as coordinates and boundaries.
- **Attribute data:** Characteristics associated with spatial features.
- **Statistical methods:** Analysis techniques applied to geographic data.

### 4.2 Statistical Methods in GIS

The following statistical methods are commonly used with geographic data.

1. **Descriptive Statistics:** Summarizes the distribution of spatial data.
2. **Data Visualization:** Creates maps and charts with `ggplot2` (Chapters 5-6).
3. **Regression Analysis:** Models relationships between geographic variables (Chapter 7).
4. **Time Series Analysis:** Analyzes temporal patterns in spatial data (Chapter 8).
5. **Logistic Regression:** Classifies spatial data whose outcome is one of two categories (Chapter 9).

### 4.3 Key R Packages for GIS Statistics

| Package | Purpose |
|---------|---------|
| `ggplot2` | Data visualization and mapping |
| `dplyr` | Data manipulation and transformation |
| `sf` | Simple features for spatial data |
| `mapview` | Interactive map visualization |
| `choroplethr` | Choropleth map creation |
| `tidyverse` | Collection of data science packages |

*Table 3. Key R packages for GIS statistics*

---

<br>

## Summary

| Concept | Key Summary |
|---------|-----------|
| R Language | R is an open-source statistical programming language with a rich package ecosystem. |
| Assignment | `<-` is preferred over `=` for variable assignment. |
| Data Types | Commonly used data types are numeric, character, logical, factor, integer, and complex. |
| GIS + Statistics | R bridges geographic data handling with advanced statistical modeling. |
| RStudio | RStudio is the main IDE for R, with console, editor, environment, and plots panels. |
| Packages | Packages such as ggplot2, dplyr, sf, and tidyverse extend the functionality of R. |
| Help System | `help()` or `?` opens the documentation of a function. |

---

<br>

## Self-Check Questions

1. **Arithmetic operators:** Give the results of `17 %/% 5`, `17 %% 5`, and `2 ** 5`.

   <details>
   <summary>Answer</summary>

   `%/%` gives the quotient of integer division, so from 17 = 5 × 3 + 2, `17 %/% 5` is 3. `%%` gives the remainder, so `17 %% 5` is 2. `**` is the same exponentiation operator as `^`, so `2 ** 5` is $2^5 = 32$.

   </details>

2. **Variable names:** Among `my.data`, `2nd_value`, `_temp`, `value_2`, `.5x`, and `if`, choose the valid variable names and explain why the others are invalid.

   <details>
   <summary>Answer</summary>

   The valid names are `my.data` and `value_2`. `2nd_value` starts with a digit, and `_temp` starts with an underscore. `.5x` starts with a period, but a digit follows it, so R reads the beginning as the number 0.5. `if` is a reserved word.

   </details>

3. **Assignment and named arguments:** In a new R session, run `sum(x <- 3)` and then `sum(y = 3)`. Give the results of `exists("x")` and `exists("y")` and explain why.

   <details>
   <summary>Answer</summary>

   `exists("x")` is `TRUE` and `exists("y")` is `FALSE`. The `x <- 3` in the argument position is evaluated as an assignment expression, which creates `x` in the global environment and passes its value 3 to `sum()`. In contrast, `y = 3` is a named argument that passes 3 to an argument called `y`, so no variable `y` is created.

   </details>

4. **Data types:** Give the results of `class(5)`, `class(5L)`, `class(TRUE)`, `class("5")`, and `class(factor("5"))`.

   <details>
   <summary>Answer</summary>

   In order, they are `"numeric"`, `"integer"`, `"logical"`, `"character"`, and `"factor"`. The numeric literal 5 is a real number (numeric) by default, and it becomes an integer only with the suffix `L`. The quoted `"5"` is a string, not a number.

   </details>

5. **Components of GIS:** Name the three elements that GIS integrates, and explain what each element corresponds to in a population map by district.

   <details>
   <summary>Answer</summary>

   GIS integrates spatial data, attribute data, and statistical methods. In a population map by district, the boundary coordinates of each district are spatial data, and the population of each district is attribute data linked to that spatial feature. Summarizing the distribution of population or modeling the relationship between population and other variables with regression corresponds to statistical methods.

   </details>
