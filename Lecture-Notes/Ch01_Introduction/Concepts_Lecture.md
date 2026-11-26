# Chapter 1 — Introduction to R and GIS Statistics

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-11-26
>
> 혼자 공부하는 R 데이터 분석, 강전희와 엄동란, Ch 1

> **Learning Objectives:**
> 1. Set up the R and RStudio environment
> 2. Understand basic R syntax and data types
> 3. Execute simple R commands and scripts
> 4. Read a help page and identify the arguments and return value of a function
> 5. Predict the results produced by special values (NA, NaN, Inf, NULL), floating-point comparison, and operator precedence
> 6. Explain the vector and raster models of spatial data and coordinate reference systems, and create point data with sf

---

## Table of Contents

- [1. Introduction to R](#1-introduction-to-r)
  - [1.1 Definition and History](#11-definition-and-history)
  - [1.2 Reasons to Use R for GIS Statistics](#12-reasons-to-use-r-for-gis-statistics)
  - [1.3 Big Data and Data Analysis](#13-big-data-and-data-analysis)
  - [1.4 Strengths and Limitations of R](#14-strengths-and-limitations-of-r)
  - [1.5 Structure of R: Base System and Packages](#15-structure-of-r-base-system-and-packages)
- [2. R and RStudio Setup](#2-r-and-rstudio-setup)
  - [2.1 Installing R](#21-installing-r)
  - [2.2 RStudio IDE](#22-rstudio-ide)
  - [2.3 Basic R Console Operations](#23-basic-r-console-operations)
  - [2.4 Getting Help](#24-getting-help)
  - [2.5 Tabs in RStudio](#25-tabs-in-rstudio)
  - [2.6 Running Code](#26-running-code)
  - [2.7 Reading a Help Page](#27-reading-a-help-page)
  - [2.8 RStudio Settings and Projects](#28-rstudio-settings-and-projects)
- [3. R as a Statistical Programming Language](#3-r-as-a-statistical-programming-language)
  - [3.1 Variable Assignment](#31-variable-assignment)
  - [3.2 Assignment Operator Details](#32-assignment-operator-details)
  - [3.3 Data Types in R](#33-data-types-in-r)
  - [3.4 Expressions, Autoprinting, and Comments](#34-expressions-autoprinting-and-comments)
  - [3.5 Integers and Doubles](#35-integers-and-doubles)
  - [3.6 Special Values: NA, NaN, Inf, NULL](#36-special-values-na-nan-inf-null)
  - [3.7 Floating-Point Comparison](#37-floating-point-comparison)
  - [3.8 Operator Precedence](#38-operator-precedence)
  - [3.9 Managing the Workspace](#39-managing-the-workspace)
  - [3.10 String Basics](#310-string-basics)
  - [3.11 Reading Errors, Warnings, and Messages](#311-reading-errors-warnings-and-messages)
- [4. GIS and Statistics](#4-gis-and-statistics)
  - [4.1 The Concept of GIS](#41-the-concept-of-gis)
  - [4.2 Statistical Methods in GIS](#42-statistical-methods-in-gis)
  - [4.3 Key R Packages for GIS Statistics](#43-key-r-packages-for-gis-statistics)
  - [4.4 Spatial Data Models: Vector and Raster](#44-spatial-data-models-vector-and-raster)
  - [4.5 Coordinate Reference Systems](#45-coordinate-reference-systems)
  - [4.6 Point Data with sf](#46-point-data-with-sf)
- [Concept Applications](#concept-applications)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)
- [References](#references)

---

<br>

## 1. Introduction to R

### 1.1 Definition and History

> **Definition:** **R** is a language and environment for statistical computing and graphics, and it is free software whose source code is released under the GNU GPL [1].

R was created by Ross Ihaka and Robert Gentleman at the University of Auckland, New Zealand, and released as free software in 1995.

- R is an implementation of the S programming language.
- It is widely used among statisticians and data scientists for data analysis, statistical modeling, and visualization.
- R is open-source and has a vast ecosystem of packages, with more than 25,000 packages on CRAN as of November 2026 [2].

> **Definition:** **CRAN (the Comprehensive R Archive Network)** is the network of servers around the world that distributes R and its extensions.

S, the root of R, is a language for statistical analysis developed at Bell Laboratories by John Chambers and colleagues [1]. S-PLUS was a widely used commercial implementation of S, and R was first introduced as a free alternative to S-PLUS. Ihaka and Gentleman experimentally built a small statistical environment with S-like syntax; in August 1993 they placed binary copies on StatLib and first announced it on the s-news mailing list. In June 1995, persuaded by Martin Mächler of ETH Zurich, they released the source code under the GNU General Public License (GPL), and since mid-1997 a core development group (R Core) of developers from several institutions has maintained the source code [3]. Because R started as a free implementation of the S language, much code written in S also runs unchanged in R.

### 1.2 Reasons to Use R for GIS Statistics

R provides several advantages for GIS-related statistical analysis.

- **Spatial data handling:** Packages such as `sf`, `sp`, and `terra` handle spatial data.
- **Statistical modeling:** Built-in functions support regression, time series, and classification.
- **Visualization:** `ggplot2` produces publication-quality graphics, including maps.
- **Reproducibility:** Script-based analysis supports reproducible research.
- **Integration:** R can work with shapefiles, GeoJSON, raster data, and web mapping services.

> **Key Point:** R bridges the gap between traditional GIS software and advanced statistical methods, which makes it well suited to spatial data analysis.

### 1.3 Big Data and Data Analysis

> **Definition:** **Big data** is data so large, generated so fast, or so varied in form that it is difficult to store, manage, and analyze with conventional database tools.

Big data is commonly described by three characteristics.

| Characteristic | Meaning | Example |
|:--|:--|:--|
| Volume | The amount of data to be stored is very large | Card payment records, satellite images |
| Velocity | Data is generated and must be processed quickly | Traffic sensors, real-time location data |
| Variety | Unstructured data such as text, images, and logs is mixed with structured tabular data | Social media posts, CCTV video |

*Table 1. Three characteristics used to describe big data*

Data can be divided into three kinds by structure. **Structured data** is tabular data with fixed rows and columns, such as spreadsheet tables or tables in a relational database. **Semi-structured data** has no fixed table but marks its structure with tags or keys; JSON and XML are typical examples. **Unstructured data** has no predefined structure, such as text, images, and audio. Most analyses in R covered in this course target structured data, that is, tables in the form of data frames (Chapter 2).

However much data there is, it does not become information by itself. Drawing meaningful facts from data requires descriptive statistics and inferential statistics. For example, surveying 1,000 households in a city and computing their mean income is descriptive statistics, and using that result to estimate the range in which the mean income of all households in the city lies is inferential statistics. Because R handles both tasks in the same language, the whole process of importing (Chapter 4), transforming (Chapter 5), visualizing (Chapter 6), and modeling (Chapters 10-12) the data can be kept in one script.

> **Definition:** **Descriptive statistics** organize and summarize data to show its characteristics.

> **Definition:** **Inferential statistics** draw conclusions about the whole (the population) from the part that was observed (the sample).

### 1.4 Strengths and Limitations of R

The strengths of R can be summarized in four points.

1. **There are many packages.** Packages for statistical analysis, visualization, machine learning, and spatial analysis are published on CRAN, so new analysis methods quickly become available as packages.
2. **Users actively share information.** Questions and answers, example code, and tutorials have accumulated on many websites and communities. Well-known examples include R tutorial (www.r-tutor.com), R-bloggers (www.r-bloggers.com), R-statistics (www.r-statistics.com), Quick-R (www.statmethods.net), and the Korean user group R Korea (www.facebook.com/groups/KoreaRUsers). Many learning resources are also freely available, such as the R Graph Gallery (r-graph-gallery.com), a collection of chart examples, and *R Graphics Cookbook* by Winston Chang (r-graphics.org), which can be read online for free.
3. **It is free.** Installation and use cost nothing, and because the source code is open, the computation can be inspected directly.
4. **It runs on many operating systems.** The same code runs on Windows, macOS, and Linux.

R is used not through a GUI (Graphic User Interface), where menus are chosen with a mouse, but through programming, where commands are typed on the keyboard. At first it takes effort to learn the commands, but because the analysis is recorded as code, the same analysis is easy to run again or to repeat with small changes, and advanced analyses that are not in any GUI menu become possible.

R also has limitations. First, R basically loads all the data being analyzed into the computer's main memory (RAM), so data larger than memory is hard to handle as is. Such data is first reduced in a database or a distributed processing system and then brought into R. Second, R is an interpreted language that parses and runs code one line at a time, so code that loops over each element is slower than in a compiled language such as C. Most of this problem is avoided with vector operations (Chapters 2 and 3). Third, because each package has a different author, function names and argument conventions are not uniform, and the quality of packages varies. The tidyverse packages covered in Chapters 5 and 6 are a collection built on common design principles to reduce such inconsistency.

### 1.5 Structure of R: Base System and Packages

Installing R also installs the **base system (base R)**. The base system contains packages such as `base`, `stats`, `graphics`, `utils`, and `datasets`, so functions such as `mean()`, `lm()`, `plot()`, and `read.csv()` and practice data such as `mtcars` and `iris` can be used without installing anything else. Other functionality is added with packages.

> **Definition:** A **package** is the unit of distributed R code that bundles functions, data, and help documentation.

Using a package takes two steps. First it is **installed** on the computer once with `install.packages("name")`, and then it is **loaded** into the current session with `library(name)` each time R starts. Installing is like shelving a book, and loading is like opening that book on the desk. Package management is covered in detail in Section 4 of Chapter 3.

---

<br>

## 2. R and RStudio Setup

### 2.1 Installing R

R can be downloaded from CRAN.

- Website: https://cran.r-project.org/
- R is available for Windows, macOS, and Linux.

CRAN operates as a system of **mirrors** that copy the same files to servers around the world, so R is installed by downloading the installer for your operating system from a nearby mirror (on Windows, R x.y.z under the base item, where x.y.z is the version number) and running it with the default options. Older Windows installers asked users to choose between 64-bit and 32-bit files, but from R 4.2.0 R for Windows no longer supports 32-bit builds, so recent versions install only the 64-bit version [4].

The version number of R has the form `major.minor.patch`. The version of the running R can be checked as below, and all results in this document were obtained with R 4.5.1.

```r
R.version.string
#> [1] "R version 4.5.1 (2025-06-13)"
```

### 2.2 RStudio IDE

> **Definition:** An **integrated development environment (IDE)** is software that brings writing and running a program, checking and saving its results, and debugging together in one window.

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

R works without RStudio, but RStudio lets you work while seeing the script, the results, the list of variables, and the graphs at a glance. RStudio is not a replacement for R but a program that calls R, so **R must be installed before RStudio.** RStudio Desktop can be downloaded from https://posit.co/download/rstudio-desktop/.

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

### 2.5 Tabs in RStudio

Each panel of RStudio consists of several tabs. Their arrangement can be changed in the settings, but their names and roles stay the same.

| Tab | Role |
|:--|:--|
| Script | An editor that makes R programming convenient |
| Console | Runs R functions or installs packages by typing code directly. Results and error messages of code run from the Script tab also appear here |
| Terminal | Opens the operating system's command line (shell) inside RStudio |
| Jobs | Runs long scripts in the background, separately from the console |
| Environment | Shows the data and variables created |
| History | Shows the code run in RStudio and the working process |
| Connections | Manages connections to external data sources such as databases |
| Tutorial | Runs interactive learning materials |
| Files | Shows folders and files, similar to the Windows file explorer |
| Plots | Shows the graphs produced. Graphs can be enlarged with the Zoom function and exported as image or PDF files |
| Packages | Installs and manages packages. The list of installed packages can be checked and updated |
| Help | Shows help pages |
| Viewer | Shows the result of R code rendered for a web browser |

*Table 2. Tabs of RStudio and their roles*

As the Packages tab shows, a package is a bundle of many functions, and using a package requires both installing and loading it (Section 1.5).

### 2.6 Running Code

Write code in the script pane, put the cursor on the line to run, and press Ctrl + Enter on Windows or Cmd + Enter on macOS; that line is sent to the console and run. Dragging over several lines and pressing the same keys runs the selected lines in order, and Ctrl + Shift + Enter (Cmd + Shift + Enter on macOS) runs the whole script. A script is saved as a text file with the `.R` extension, and a saved script can be run as a whole with `source("file name.R")`.

The following script enters the ID, sex, age, and area of residence of five people as vectors, combines them into a data frame, and checks its structure.

```r
ID <- c(1, 2, 3, 4, 5)
SEX <- c("F", "M", "F", "M", "M")
AGE <- c(50, 40, 28, 50, 27)
AREA <- c("Seoul", "Gyeonggi", "Jeju", "Seoul", "Seoul")
dataframe_ex <- data.frame(ID, SEX, AGE, AREA)
dataframe_ex
#>   ID SEX AGE     AREA
#> 1  1   F  50    Seoul
#> 2  2   M  40 Gyeonggi
#> 3  3   F  28     Jeju
#> 4  4   M  50    Seoul
#> 5  5   M  27    Seoul
str(dataframe_ex)
#> 'data.frame':	5 obs. of  4 variables:
#>  $ ID  : num  1 2 3 4 5
#>  $ SEX : chr  "F" "M" "F" "M" ...
#>  $ AGE : num  50 40 28 50 27
#>  $ AREA: chr  "Seoul" "Gyeonggi" "Jeju" "Seoul" ...
```

In the code blocks of this document, lines starting with `#>` are the output that appears in the console when the command just above is run. In a real console, only the output appears, without `#>`. The first four lines create four vectors with `c()`, and the fifth line binds them as columns into the data frame `dataframe_ex`. An assignment prints nothing, so the table is printed only on the sixth line, where just the name `dataframe_ex` is entered. `str()` summarizes the structure of an object, and `5 obs. of  4 variables` means it consists of 5 observations (rows) and 4 variables (columns). The `num` before each column means numeric and `chr` means character; when there are many values, only the first few are shown and the rest is abbreviated as `...`. Data frames and `str()` are covered in detail in Chapter 2.

The symbols of the console are also worth knowing. The `>` shown while the console waits for a command is called the **prompt**. If Enter is pressed while a parenthesis or a quotation mark is still open, R considers the command unfinished and shows `+` while waiting for the next line. If `+` keeps appearing unintentionally, press Esc to cancel the input. The `[1]` in front of the output is an index telling which element of the result vector the first value on that line is.

```r
seq(10, 300, by = 10)
#>  [1]  10  20  30  40  50  60  70  80  90 100 110 120 130 140 150 160 170 180 190
#> [20] 200 210 220 230 240 250 260 270 280 290 300
```

`seq(10, 300, by = 10)` creates 30 elements increasing by 10 from 10 to 300. Since 19 values were printed on one line, the first value 200 on the second line is the 20th element, and that line begins with `[20]`. The index depends on the screen width and is not part of the values.

### 2.7 Reading a Help Page

Running `help(print)` or `?print` opens a document titled `print {base}` in the Help tab. The `base` in braces is the package to which the function belongs. Every help page in R has sections in the same order, so knowing the role of each section makes it possible to grasp an unfamiliar function quickly.

| Section | Content |
|:--|:--|
| Description | A short description of what the function does |
| Usage | How to call the function and the default values of the arguments |
| Arguments | The meaning and allowed values of each argument |
| Details | Details of the behavior and points to note |
| Value | The form of the object the function returns |
| See Also | Related functions |
| Examples | Example code that can be run right away |

*Table 3. Sections of an R help page*

The Description of `print` says that `print` prints its argument and returns it invisibly, and that it is a **generic function**. A generic function is one whose actually executed method depends on the class of its argument, which is why the Usage section lists separate forms per class, such as `## S3 method for class 'factor'`. The help page of a function whose name is a symbol, such as an operator, is opened by quoting the name, as in `help("+")`.

To see only the argument list without opening the help page, use `args()`, and to find a function whose name is only partly remembered, use `apropos()`. `??regression` or `help.search("regression")` searches all documents of the installed packages for a word.

```r
args(round)
#> function (x, digits = 0, ...) 
#> NULL
round(3.14159, digits = 2)
#> [1] 3.14
round(3.14159, 2)
#> [1] 3.14
apropos("^read\\.")
#>  [1] "read.csv"     "read.csv2"    "read.dcf"     "read.delim"   "read.delim2" 
#>  [6] "read.DIF"     "read.fortran" "read.ftable"  "read.fwf"     "read.socket" 
#> [11] "read.table"
```

In the result of `args(round)`, `digits = 0` means that 0 is used when the `digits` argument is omitted. Therefore `round(3.14159)` is 3, and giving `digits = 2` rounds at the second decimal place to 3.14. An argument can be passed by name as `digits = 2` or without a name in the order given in Usage, as in `round(3.14159, 2)`. The `"^read\\."` in `apropos("^read\\.")` is a regular expression matching names that start with "read.", and the result includes `read.csv()`, `read.table()`, `read.delim()`, and `read.fwf()`, which are covered in Chapter 4.

### 2.8 RStudio Settings and Projects

RStudio settings are changed in Global Options under the Tools menu. After the first installation, it is good to check the following two settings.

- **Character encoding:** Set the default text encoding of scripts to UTF-8. This reduces the problem of broken characters when a script containing Korean comments or strings is opened on another operating system.
- **Saving the workspace:** Set RStudio not to restore `.RData` at startup and never to save it on exit. If variables are saved to an `.RData` file every time R closes and restored automatically next time, variables that are not in the script remain, and the same script can behave differently on another computer. The record of an analysis must be kept in the script, not in the workspace.

> **Definition:** The **workspace** is where the variables and objects created during an R session are stored; more precisely, it is the global environment.

A **project** is an RStudio feature that gathers the scripts, data, and outputs of one analysis in one folder. Creating a project with New Project in the File menu creates an `.Rproj` file in the folder, and opening RStudio with this file automatically sets the working directory to the project folder. Files can then be read with relative paths, so the same code works on other computers (Section 5 of Chapter 4).

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

*Table 4. Examples of valid and invalid variable names*

A variable name should reveal what its value is. Names that carry meaning, such as `age` and `mean_income`, make code easier to read than `x1` or `temp2`. For names made of several words, joining them with underscores as in `mean_income` (snake case) is recommended in the tidyverse documentation, and one style should be used consistently within a script. Names already used for functions, such as `c`, `t`, and `mean`, can be used for variables but invite confusion and are best avoided.

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

The difference in precedence shows up in an expression such as `G <- E = 10`. Because `<-` binds before `=`, R reads this expression as `(G <- E) = 10`, that is, as an instruction to assign 10 again to the assignment `G <- E`. Such an assignment is not defined, so R raises an error whose message depends on the situation. If `G` does not exist yet, the message is `object 'G' not found`; if `G` already exists, R fails to find the assignment function `<-<-` and raises the error `could not find function "<-<-"`. Conversely, `C = D <- 5` is read as `C = (D <- 5)`, which puts 5 into D and then that value into C. To avoid such confusion, it is safest to always use `<-` for assignment and `=` only for function arguments.

> **Definition:** **Operator precedence** is the rule that decides which operator is computed first when one command contains several operators.

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

*Table 5. Fundamental data types in R*

```r
# Check types
class(42)           # "numeric"
class(TRUE)         # "logical"
class("Hello")      # "character"
class(factor("A"))  # "factor"

typeof(1:10)        # "integer"
```

Unlike the other five types, `factor` is a class that attaches a levels attribute to an integer vector. Therefore `class(factor("A"))` is `"factor"`, but `typeof(factor("A"))` is `"integer"`. Factors are covered in detail in Chapter 2.

`class()` and `typeof()` answer different questions. `typeof()` tells the basic form in which R stores the value in memory, and its result is the name of a storage type such as `"double"`, `"integer"`, `"character"`, `"logical"`, or `"complex"`. `class()` tells what kind of object functions treat it as; it returns `"numeric"` for a numeric vector and `"factor"` or `"data.frame"` for objects with a class attribute, such as factors and data frames. That is why `class(42)` is `"numeric"` but `typeof(42)` is `"double"`.

### 3.4 Expressions, Autoprinting, and Comments

> **Definition:** An **expression** is the unit of command that R evaluates to compute a value; each command in R is an expression.

When an expression is entered in the console, R computes its value and, unless the expression is an assignment, prints the result automatically. An assignment does not print its value, so to see the result while assigning, wrap the whole expression in parentheses.

```r
x <- 3 * 4
x
#> [1] 12
(y <- x / 5)
#> [1] 2.4
```

The first line only puts 12 into `x` and prints nothing. Entering just a name, as in the second line, prints its value. The third line puts `x / 5` = 12 / 5 = 2.4 into `y` and prints that value because of the parentheses.

Text after `#` is a **comment**, which R does not run. A comment should explain why the code does something rather than what it does. To write several expressions on one line, separate them with semicolons (`;`), and if a line breaks while a parenthesis is open, R treats the expression as continuing.

```r
x <- c(4, 8, 15)
mean(x); sum(x)
#> [1] 9
#> [1] 27
y <- c(1, 2,
       3)
y
#> [1] 1 2 3
```

`mean(x)` is (4 + 8 + 15) / 3 = 27 / 3 = 9, and `sum(x)` is 27. The third expression is read as one expression over two lines because the `c(` parenthesis is not closed on the first line.

### 3.5 Integers and Doubles

> **Definition:** A **double-precision real number (double)** is the 64-bit floating-point format in which R stores numeric data by default; even a number written without a decimal point is stored this way.

To store an integer, add `L` after the number or create a sequence with the colon operator, as in `1:10`.

```r
typeof(5)
#> [1] "double"
typeof(5L)
#> [1] "integer"
5L / 2L
#> [1] 2.5
typeof(5L / 2L)
#> [1] "double"
5L %/% 2L
#> [1] 2
typeof(5L %/% 2L)
#> [1] "integer"
.Machine$integer.max
#> [1] 2147483647
.Machine$integer.max + 1L
#> Warning in .Machine$integer.max + 1L: NAs produced by integer overflow
#> [1] NA
```

Even when two integers are divided, the result of `/` is a double, because a quotient may not be an integer, as in 5 / 2 = 2.5. In contrast, `%/%` computes only the quotient, so its result is an integer when both operands are integers. R stores integers in 32 bits, so the largest representable value is $`2^{31} - 1`$ = 2,147,483,647, and exceeding it gives `NA` with a warning. Doubles represent values up to about $`1.8 \times 10^{308}`$, so doubles are fine for everyday computation, and the integer type is used mainly to reduce data size or to represent counts such as the number of iterations.

### 3.6 Special Values: NA, NaN, Inf, NULL

R has four special values that represent situations ordinary values cannot express.

| Special Value | Meaning | Example of How It Arises | Test Function |
|:--|:--|:--|:--|
| `NA` | A missing value that should exist but is unknown (Not Available) | Survey nonresponse, failed measurement | `is.na()` |
| `NaN` | The result of a mathematically undefined computation (Not a Number) | `0 / 0`, `sqrt(-1)` | `is.nan()` |
| `Inf`, `-Inf` | Positive and negative infinity | `1 / 0`, `-1 / 0` | `is.infinite()` |
| `NULL` | No value at all, an object of length 0 | Extracting an element that does not exist | `is.null()` |

*Table 6. Special values in R*

> **Definition:** A **missing value** is a value that should exist but is unknown; R represents it as `NA` (Not Available).

```r
1 / 0
#> [1] Inf
-1 / 0
#> [1] -Inf
0 / 0
#> [1] NaN
sqrt(-1)
#> Warning in sqrt(-1): NaNs produced
#> [1] NaN
NA + 1
#> [1] NA
NA > 3
#> [1] NA
c(length(NA), length(NULL))
#> [1] 1 0
is.na(NaN)
#> [1] TRUE
is.nan(NA)
#> [1] FALSE
```

Most computations involving `NA` give `NA`, because an unknown value plus 1 is also unknown, and whether an unknown value is greater than 3 is also unknown. `NA` and `NULL` differ in that `NA` is a value of length 1 while `NULL` has length 0. `NA` means "the place for a value is empty," and `NULL` means "the place itself does not exist." `is.na()` returns `TRUE` for `NaN` as well, but `is.nan()` returns `FALSE` for `NA`, so `NaN` is treated as a kind of `NA`. Ways to handle missing values are covered in Section 5 of Chapter 3 and Section 4 of Chapter 5.

> **Caution:** Do not use `x == NA` to check whether a value is `NA`. Any comparison with `NA` is always `NA`, so this expression returns `NA` regardless of the value of `x`. Always test for missingness with `is.na(x)`.

### 3.7 Floating-Point Comparison

Computers store real numbers in binary, so a decimal fraction such as 0.1 cannot be represented exactly, and the nearest binary approximation is stored instead. Because of this small error, two values that are mathematically equal can be judged different by `==`.

```r
0.1 + 0.2 == 0.3
#> [1] FALSE
print(0.1 + 0.2, digits = 17)
#> [1] 0.30000000000000004
all.equal(0.1 + 0.2, 0.3)
#> [1] TRUE
isTRUE(all.equal(0.1 + 0.2, 0.3))
#> [1] TRUE
abs((0.1 + 0.2) - 0.3) < 1e-9
#> [1] TRUE
```

R usually prints only 7 significant digits, so `0.1 + 0.2` appears as 0.3 on the screen, but printing 17 digits shows that the value actually stored is 0.30000000000000004. To decide whether doubles are equal, use a function that compares within a small tolerance, such as `all.equal()`, or check directly whether the absolute difference of the two values is small enough. When the values differ, `all.equal()` returns a string describing the difference instead of `FALSE`, so wrap it in `isTRUE()` when it is used as the condition of an `if` statement.

### 3.8 Operator Precedence

R's main operators, from highest to lowest operator precedence (Section 3.2), are as follows.

| Rank | Operator | Meaning |
|:--|:--|:--|
| 1 | `^` | Exponentiation (groups from the right) |
| 2 | `-x`, `+x` | Unary sign |
| 3 | `:` | Sequence |
| 4 | `%/%`, `%%`, `%in%`, etc. | Special operators |
| 5 | `*`, `/` | Multiplication, division |
| 6 | `+`, `-` | Addition, subtraction |
| 7 | `<`, `>`, `<=`, `>=`, `==`, `!=` | Comparison |
| 8 | `!` | Logical negation |
| 9 | `&`, `&&` | Logical AND |
| 10 | `\|`, `\|\|` | Logical OR |
| 11 | `<-` | Assignment |
| 12 | `=` | Assignment |

*Table 7. Precedence of the main operators (higher rows first)*

```r
-2^2
#> [1] -4
(-2)^2
#> [1] 4
2^3^2
#> [1] 512
1:3 * 2
#> [1] 2 4 6
1:(3 * 2)
#> [1] 1 2 3 4 5 6
-7 %/% 2
#> [1] -4
-7 %% 2
#> [1] 1
7 %% -3
#> [1] -2
```

Because `^` takes precedence over the unary sign, `-2^2` is $`-(2^2) = -4`$, and squaring the sign as well requires parentheses, as in `(-2)^2`. `^` groups from the right, so `2^3^2` is $`2^{(3^2)} = 2^9 = 512`$. `:` takes precedence over `*`, so `1:3 * 2` multiplies each element of (1, 2, 3) by 2 to give 2, 4, 6, while `1:(3 * 2)` is the sequence from 1 to 6.

Quotients and remainders of negative numbers need care. R's `%/%` does not drop the fractional part of the quotient; it takes as the quotient the largest integer less than or equal to it, that is, the floor. Since -7 / 2 = -3.5, the quotient is -4, not -3. The remainder is always chosen to satisfy $`a = b \times q + r`$, so from -7 = 2 × (-4) + 1, `-7 %% 2` is 1. By the same principle, the quotient of 7 / (-3) ≈ -2.33 is -3, and since 7 = (-3) × (-3) + (-2), `7 %% -3` is -2. As a result, a nonzero remainder in R always has the same sign as the divisor.

### 3.9 Managing the Workspace

Variables created while R runs are stored in the workspace (Section 2.8). The list shown in the Environment tab of RStudio is exactly this. In the console, the workspace is managed with the following functions.

```r
a <- 1; b <- "text"; d <- TRUE
ls()
#> [1] "a" "b" "d"
rm(b)
ls()
#> [1] "a" "d"
exists("b")
#> [1] FALSE
rm(list = ls())
ls()
#> character(0)
```

After the three variables are created in a new session, `ls()` lists their names in alphabetical order. `rm(b)` removes `b`, after which `exists("b")` is `FALSE`. `rm(list = ls())` removes every name returned by `ls()`, so the workspace becomes empty, and `ls()` then returns `character(0)`, a character vector of length 0. The quadratic-equation example in Section 7 of Chapter 3 runs `rm(list = ls())` on its first line so that variables left from earlier computations do not mix into the result. However, `rm(list = ls())` removes only variables and leaves loaded packages in place, so to start completely fresh, use Restart R in the Session menu.

### 3.10 String Basics

Strings are enclosed in double or single quotation marks, and both forms create the same value. A few basic functions for strings are as follows.

```r
nchar("Hello")
#> [1] 5
toupper("gis")
#> [1] "GIS"
paste("R", "4.5", sep = "-")
#> [1] "R-4.5"
'single' == "single"
#> [1] TRUE
```

`nchar()` returns the number of characters, and `toupper()` and `tolower()` return the string converted to upper and lower case. `paste()` joins several strings into one, inserting the separator given by `sep`, and joins them with a single space when `sep` is omitted. A string that looks like a number, such as `"123"`, is not a number, so `"123" + 1` raises an error. To turn a string into a number, a type conversion such as `as.numeric("123")` is needed (Section 7 of Chapter 2).

### 3.11 Reading Errors, Warnings, and Messages

R leaves three kinds of notices in the console. An **error** appears when an expression cannot be computed to the end; execution of that expression stops and no result is produced. A **warning** says that the computation finished but the result may differ from what was intended. A **message** only conveys information, such as notes printed when a package is loaded. Warnings do not stop execution and are easy to ignore, but they often explain why `NA` appears in a result, so they must always be read.

```r
mean(scores)
#> Error: object 'scores' not found
Mean(c(1, 2, 3))
#> Error in Mean(c(1, 2, 3)): could not find function "Mean"
as.numeric(c("1", "2", "three"))
#> Warning: NAs introduced by coercion
#> [1]  1  2 NA
x <- 5
x + "1"
#> Error in x + "1": non-numeric argument to binary operator
```

The first error, `object 'scores' not found`, means that a variable that was never created was used; a typo in the name or not running the line that creates the variable is a common cause. The second error, `could not find function "Mean"`, means that no function has that name. R is case-sensitive, so writing `mean` as `Mean` gives a different name, and calling a package function before loading the package gives the same error. The third line is a warning, not an error. `"three"` cannot be turned into a number and became `NA`, but the other elements were converted and a result was produced. The fourth error, `non-numeric argument to binary operator`, means that values that cannot be used in arithmetic, such as a number and a string, were given to a binary operator such as `+`. Copying an unfamiliar error message as is into a search engine quickly finds cases of the same problem.

---

<br>

## 4. GIS and Statistics

### 4.1 The Concept of GIS

> **Definition:** A **Geographic Information System (GIS)** is a framework for gathering, managing, and analyzing spatial and geographic data.

GIS integrates the following three elements.

- **Spatial data:** Location-based information such as coordinates and boundaries.
- **Attribute data:** Characteristics associated with spatial features.
- **Statistical methods:** Analysis techniques applied to geographic data.

### 4.2 Statistical Methods in GIS

The following statistical methods are commonly used with geographic data.

1. **Descriptive Statistics:** Summarizes the distribution of spatial data.
2. **Data Visualization:** Creates maps and charts with `ggplot2` (Chapters 6 and 9).
3. **Regression Analysis:** Models relationships between geographic variables (Chapter 10).
4. **Time Series Analysis:** Analyzes temporal patterns in spatial data (Chapter 11).
5. **Logistic Regression:** Classifies spatial data whose outcome is one of two categories (Chapter 12).

### 4.3 Key R Packages for GIS Statistics

| Package | Purpose |
|---------|---------|
| `ggplot2` | Data visualization and mapping |
| `dplyr` | Data manipulation and transformation |
| `sf` | Simple features for spatial data |
| `mapview` | Interactive map visualization |
| `choroplethr` | Choropleth map creation |
| `tidyverse` | Collection of data science packages |

*Table 8. Key R packages for GIS statistics*

### 4.4 Spatial Data Models: Vector and Raster

GIS represents geographic phenomena in the real world in two ways.

> **Definition:** The **vector model** is a spatial data model that represents geographic features as points, lines, and polygons defined by coordinates.

In the vector model, a **point** gives a location with one pair of coordinates and is used for features whose size can be ignored, such as bus stops or hospitals. A **line** connects points in order and represents roads or rivers, and a **polygon** is a closed line whose first and last points coincide and represents the boundaries of administrative districts or lakes. Each feature is linked to attribute data such as name, population, and area as one row of a table. A population map by district is vector data made of about 250 polygons and their attribute table.

> **Definition:** The **raster model** is a spatial data model that divides space into grid cells of equal size and stores one value per cell.

The raster model suits phenomena that spread continuously over space, such as temperature, elevation, and precipitation. Satellite images and digital elevation models are typical raster data. The smaller the cell size, that is, the **resolution**, the finer the detail, but the more cells must be stored. Covering a region 30 km on a side with cells 30 m on a side requires 1,000 × 1,000 = one million cells.

```text
Vector model                     Raster model
                                 ┌──┬──┬──┬──┬──┐
  ●  bus stop (point)            │12│13│15│16│18│
                                 ├──┼──┼──┼──┼──┤
  ●───●───●  road (line)         │11│12│14│17│19│
                                 ├──┼──┼──┼──┼──┤
  ┌───────┐                      │10│11│13│15│17│
  │ zone  │  district (polygon)  └──┴──┴──┴──┴──┘
  └───────┘                        one value per cell (e.g., temperature)
```

*Figure 2. Points, lines, and polygons of the vector model and the grid of the raster model*

In R, vector data is handled mainly with the `sf` package and raster data mainly with the `terra` package. The choropleth maps in Chapter 9 are maps that color polygon vector data by attribute values.

### 4.5 Coordinate Reference Systems

> **Definition:** A **coordinate reference system (CRS)** is the reference that fixes which location on the Earth a coordinate means.

The coordinates of spatial data are meaningful only when it is known by what reference, that is, by what coordinate reference system, they were measured. Coordinate reference systems fall into two broad kinds.

> **Definition:** A **geographic coordinate system** is a coordinate reference system that treats the Earth as an ellipsoid and gives positions as angles of longitude and latitude; the most widely used is WGS 84, used by GPS. Its unit is the degree, so differences in coordinates cannot be read directly as distances: one degree of longitude spans about 111 km at the equator but shrinks as latitude increases.

> **Definition:** A **projected coordinate system** is a coordinate reference system that flattens (projects) the curved Earth onto a plane and gives positions as x and y coordinates in length units such as meters. It makes distance and area computations over small regions convenient, but no projection preserves distance, area, shape, and direction over a large region at the same time.

To overlay two datasets with different CRSs, one must be transformed into the CRS of the other. If data with different CRSs is overlaid as is, the same place is drawn at different positions on the map.

> **Definition:** An **EPSG code** is the number assigned to a coordinate reference system in the database begun by the European Petroleum Survey Group (EPSG); for example, 4326 is WGS 84 longitude and latitude.

### 4.6 Point Data with sf

The `sf` (simple features) package stores vector data as one column (the geometry column) of a data frame. Spatial data can therefore be filtered by rows and extended with columns like an ordinary data frame. The following code creates two points from the longitude and latitude near Seoul City Hall and Busan City Hall and computes the distance between them.

```r
library(sf)
```

```r
pts <- st_sfc(st_point(c(126.978, 37.5665)),
              st_point(c(129.0756, 35.1796)), crs = 4326)
pts
#> Geometry set for 2 features 
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 126.978 ymin: 35.1796 xmax: 129.0756 ymax: 37.5665
#> Geodetic CRS:  WGS 84
#> POINT (126.978 37.5665)
#> POINT (129.0756 35.1796)
st_distance(pts)
#> Units: [m]
#>          [,1]     [,2]
#> [1,]      0.0 325111.8
#> [2,] 325111.8      0.0
st_crs(pts)$epsg
#> [1] 4326
```

`st_point(c(longitude, latitude))` creates one point; note that the order is (x, y) = (longitude, latitude), not (latitude, longitude). `st_sfc()` bundles the points into one geometry column, and `crs = 4326` records that the coordinates are WGS 84 longitude and latitude. The Bounding box in the output is the extent of the smallest rectangle containing all the points. `st_distance()` returns the distances between all pairs of points as a matrix; for longitude and latitude, under the default setting (using the s2 spherical geometry library), it treats the Earth as a sphere and computes the length of the shortest path (great circle) between two points in meters. The result of 325,111.8 m, about 325 km, is the shortest distance between the two places on a sphere with a radius of about 6,371 km, which differs from the road distance.

```r
cities <- st_sf(name = c("Seoul", "Busan"), geometry = pts)
cities
#> Simple feature collection with 2 features and 1 field
#> Geometry type: POINT
#> Dimension:     XY
#> Bounding box:  xmin: 126.978 ymin: 35.1796 xmax: 129.0756 ymax: 37.5665
#> Geodetic CRS:  WGS 84
#>    name                 geometry
#> 1 Seoul  POINT (126.978 37.5665)
#> 2 Busan POINT (129.0756 35.1796)
```

`st_sf()` binds the attribute column `name` and the geometry column `geometry` into an sf object. The `2 features and 1 field` in the output means 2 features (rows) and 1 attribute column. This table holds two of the three elements of Section 4.1, spatial data (the geometry column) and attribute data (the name column), in one structure, and the data transformation of Chapter 5 and the visualization of Chapters 6 and 9 apply to it directly.

`st_distance()` computed the distance between the two points directly on the sphere. Moving the same points into a projected coordinate system gives x and y coordinates on a plane and a Euclidean distance. EPSG 5179 is a coordinate system that projects the whole Korean peninsula onto one plane, and its unit is the meter.

```r
st_crs(5179)$Name
#> [1] "KGD2002 / Unified CS"
pts_tm <- st_transform(pts, 5179)
st_coordinates(pts_tm)
#>              X       Y
#> [1,]  953901.2 1952032
#> [2,] 1143467.4 1688282
st_distance(pts_tm)
#> Units: [m]
#>          1        2
#> 1      0.0 324806.8
#> 2 324806.8      0.0
```

`st_transform()` converts coordinates to another CRS. The coordinate differences of the two transformed points are 1,143,467.4 - 953,901.2 = 189,566.2 m in the x direction and 1,688,282 - 1,952,032 = -263,750 m in the y direction, so the Pythagorean theorem gives $`\sqrt{189566.2^2 + 263750^2} \approx 324{,}807`$ m. This value equals the 324,806.8 m of `st_distance(pts_tm)` and is about 305 m (0.09%) shorter than the 325,111.8 m computed on the sphere. Not all of this difference comes from the projection, however. The geodesic distance computed on the WGS 84 ellipsoid is about 324,915 m, so the spherical distance is about 196 m longer because it approximates the Earth by a sphere, and the projected distance is about 108 m (0.03%) shorter because of the distortion caused by flattening the curved surface onto a plane. If the `lwgeom` package is installed and spherical computation is turned off with `sf_use_s2(FALSE)`, `st_distance(pts)` returns this distance on the ellipsoid. The distortion due to projection is small over a narrow region such as the Korean peninsula but grows over a continent.

---

<br>

## Concept Applications

**True/False Check:**

| Statement | Judgment and Reason |
|:--|:--|
| Installing RStudio also installs R, so R does not need to be installed separately. | **F.** RStudio is an integrated development environment that calls an installed R, so R must be installed first. |
| `x == NA` returns `TRUE` when `x` is a missing value. | **F.** Any comparison with `NA` is `NA`, so missingness is tested with `is.na(x)`. |
| The result of `0.1 + 0.2 == 0.3` is `FALSE`. | **T.** 0.1 and 0.2 are stored as binary approximations and their sum is 0.30000000000000004, so the comparison must use `all.equal()`, which allows a tolerance. |
| The value of `-3^2` is 9. | **F.** `^` is computed before the unary sign, so the value is $`-(3^2) = -9`$. |
| `typeof(5)` is `"integer"`. | **F.** A number written without a decimal point is still stored as a double, so it is `"double"`; write `5L` for an integer. |
| `st_point(c(37.57, 126.98))` creates a point near Seoul City Hall. | **F.** `st_point()` takes (x, y) = (longitude, latitude), so longitude 126.98 and latitude 37.57 must be written as `c(126.98, 37.57)`. |
| Saving the workspace as `.RData` makes an analysis easier to reproduce. | **F.** Variables that are not in the script remain in the workspace, so results can differ in another environment; keep the record of an analysis in scripts. |

---

<br>

## Summary

| Concept | Key Summary |
|---------|-----------|
| R Language | R is an open-source statistical programming language with a rich package ecosystem. |
| History | R was built by Ihaka and Gentleman on the basis of the S language of Bell Laboratories, first announced in 1993, and its source was released under the GPL in 1995. |
| Assignment | `<-` is preferred over `=` for variable assignment. |
| Data Types | Commonly used data types are numeric, character, logical, factor, integer, and complex. |
| GIS + Statistics | R bridges geographic data handling with advanced statistical modeling. |
| RStudio | RStudio is the main IDE for R, with console, editor, environment, and plots panels. |
| Packages | Packages such as ggplot2, dplyr, sf, and tidyverse extend the functionality of R. |
| Help System | `help()` or `?` opens the documentation of a function. |
| Structure of a Help Page | A help page has Description, Usage, Arguments, Details, Value, and Examples in that order, and `args()` shows only the arguments. |
| Special Values | `NA` is a missing value, `NaN` an undefined computation result, `Inf` infinity, and `NULL` an empty object of length 0. |
| Floating Point | Doubles are stored as binary approximations, so equality is judged with `all.equal()` instead of `==`. |
| Operator Precedence | `^` is computed before the unary sign and groups from the right, and `:` is computed before `*`. |
| Spatial Data Models | The vector model represents space with points, lines, and polygons, and the raster model with grid cells of equal size. |
| Coordinate Reference System | It is the reference for coordinates, and WGS 84 longitude and latitude (EPSG 4326) are angles, so distance computations need care. |

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

6. **Special values:** Give the results of `c(1, NA, 3) + 1`, `length(c(1, NULL, 3))`, `is.na(0 / 0)`, and `-5 / 0`, and explain each.

   <details>
   <summary>Answer</summary>

   `c(1, NA, 3) + 1` is 2, `NA`, 4. 1 is added to each element, and an unknown value plus 1 is also unknown. `length(c(1, NULL, 3))` is 2. `NULL` is an object of length 0, so it adds no element when combined with `c()`. `0 / 0` is `NaN`, and `is.na()` returns `TRUE` for `NaN`, so the result is `TRUE`. `-5 / 0` is negative infinity, `-Inf`.

   </details>

7. **Precedence and negative remainders:** Compute `-3^2 + 2^2^3`, `-9 %/% 4`, and `-9 %% 4`.

   <details>
   <summary>Answer</summary>

   `-3^2` is $`-(3^2) = -9`$, and `2^2^3` groups from the right to give $`2^{(2^3)} = 2^8 = 256`$, so the first expression is -9 + 256 = 247. -9 / 4 = -2.25, and R's quotient is the largest integer less than or equal to it, so `-9 %/% 4` is -3. The remainder must satisfy -9 = 4 × (-3) + r, so r = 3 and `-9 %% 4` is 3.

   </details>

8. **Coordinate reference systems:** Explain why the distance between two points in longitude and latitude (EPSG 4326) must not be computed by putting their differences in longitude and latitude into the Pythagorean theorem.

   <details>
   <summary>Answer</summary>

   Longitude and latitude are angles, not lengths, and the real distance of one degree depends on the location. One degree of latitude is about 111 km everywhere, but one degree of longitude is about 111 km at the equator and shrinks as latitude increases, becoming 0 at the poles. Treating angle differences as planar lengths therefore distorts distances; use `st_distance()`, which computes spherical distances, or transform to a projected coordinate system in meters before computing.

   </details>

---

<br>

## References

1. The R Foundation, "What is R?" [Online]. Available: https://www.r-project.org/about.html
2. CRAN, "Contributed packages." [Online]. Available: https://cran.r-project.org/web/packages/
3. R. Ihaka, "R: Past and future history," presented at Interface '98, 1998. [Online]. Available: https://cran.r-project.org/doc/html/interface98-paper/paper.html
4. R Core Team, "R news." [Online]. Available: https://cran.r-project.org/doc/manuals/r-release/NEWS.html
