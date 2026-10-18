# Chapter 4 — Data Import and Export

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-18
>
> 혼자 공부하는 R 데이터 분석, 강전희와 엄동란, Ch 4

> **Learning Objectives:**
> 1. Create data frames directly from vectors and import data from CSV and text files into R
> 2. Use the working directory and relative paths to write import code that runs on other computers
> 3. Inspect imported data with exploration functions and resolve common import problems

---

## Table of Contents

- [1. Manual Data Entry](#1-manual-data-entry)
  - [1.1 Creating Data Directly in R](#11-creating-data-directly-in-r)
- [2. Reading External Data](#2-reading-external-data)
  - [2.1 Overview of Import Functions](#21-overview-of-import-functions)
  - [2.2 read.table() Function](#22-readtable-function)
- [3. Reading CSV Files](#3-reading-csv-files)
  - [3.1 Basic CSV Import](#31-basic-csv-import)
  - [3.2 Important Parameters](#32-important-parameters)
  - [3.3 File Path Considerations](#33-file-path-considerations)
- [4. Reading Text Files](#4-reading-text-files)
  - [4.1 Reading Tab-Delimited Files](#41-reading-tab-delimited-files)
  - [4.2 Reading Fixed-Width Files](#42-reading-fixed-width-files)
- [5. Working Directories](#5-working-directories)
  - [5.1 Getting and Setting the Working Directory](#51-getting-and-setting-the-working-directory)
  - [5.2 Best Practices](#52-best-practices)
- [6. Data Exploration After Import](#6-data-exploration-after-import)
  - [6.1 Useful Exploration Functions](#61-useful-exploration-functions)
  - [6.2 Common Issues with Imported Data](#62-common-issues-with-imported-data)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Manual Data Entry

### 1.1 Creating Data Directly in R

Before importing external data, we can create data frames manually:

```r
ID <- c(1, 2, 3, 4, 5)
SEX <- c("F", "M", "F", "M", "F")
DATA <- data.frame(ID = ID, SEX = SEX)
View(DATA)   # Open in spreadsheet viewer
```

Combining the two vectors created with `c()` through `data.frame()` turns each vector into one column, producing a data frame with 5 rows and 2 columns. In `ID = ID`, the left side of the equals sign is the column name and the right side is the vector placed in that column.

> **Key Point:** Manual data entry is useful for small datasets or for creating test data, but for real-world analysis, data is typically imported from external files.

---

<br>

## 2. Reading External Data

### 2.1 Overview of Import Functions

R provides several functions to read external data:

| Function | File Type | Package |
|----------|-----------|---------|
| `read.csv()` | CSV (comma-separated) | base |
| `read.table()` | General delimited text | base |
| `read.delim()` | Tab-delimited text | base |
| `readxl::read_excel()` | Excel (.xlsx, .xls) | readxl |
| `readr::read_csv()` | CSV (faster, tidyverse) | readr |

*Table 1. R functions for importing external data*

Writing a call in the `package::function` form, as in `readxl::read_excel()`, calls a function of that package without loading the package with `library()`. The package must still be installed beforehand.

### 2.2 read.table() Function

`read.table()` is the most general function for reading tabular data:

```r
help(read.table)

# Key parameters:
# file      - path to the file
# header    - TRUE if first row contains column names
# sep       - field separator character
# dec       - decimal point character
```

The defaults of `read.table()` are `header = FALSE`, `sep = ""`, and `dec = "."`. `sep = ""` means that any run of one or more white-space characters, such as spaces or tabs, is treated as a separator.

---

<br>

## 3. Reading CSV Files

### 3.1 Basic CSV Import

CSV (Comma-Separated Values) is the most common format for data exchange:

```r
# Read a CSV file with header row
ex_data <- read.csv("data/data_ex.csv", header = TRUE)
View(ex_data)
```

`read.csv()` is `read.table()` with defaults suited to CSV (`header = TRUE`, `sep = ","`, and others), so `header = TRUE` in the code above states the default explicitly.

### 3.2 Important Parameters

```r
read.csv(
  file,                    # File path (absolute or relative)
  header = TRUE,           # First row is column names
  sep = ",",               # Separator (comma for CSV)
  stringsAsFactors = FALSE # Don't convert strings to factors
)
```

Since R 4.0.0, the default of `stringsAsFactors` is `FALSE`. The argument is specified to get the same result in earlier versions of R or to make the intent clear.

### 3.3 File Path Considerations

```r
# Absolute path (platform-specific)
read.csv("/Users/username/Desktop/data_ex.csv", header = TRUE)

# Relative path (relative to working directory)
read.csv("data/data_ex.csv", header = TRUE)
```

A relative path is resolved against the working directory. If the working directory is `/Users/username/Desktop/project/`, `"data/data_ex.csv"` points to the file in Figure 1.

```text
/Users/username/Desktop/project/   ← working directory (result of getwd())
└── data/
    ├── data_ex.csv                ← file that "data/data_ex.csv" points to
    ├── data_ex-1.txt
    └── data_ex_col.txt
```

*Figure 1. Resolving a relative path against the working directory*

> **Key Point:** Using relative paths makes your code more portable across different computers. Set your working directory to the project root and use relative paths from there.

---

<br>

## 4. Reading Text Files

### 4.1 Reading Tab-Delimited Files

A tab-delimited file is read with `read.table()` and `sep = "\t"`, or with `read.delim()`. The defaults of `read.delim()` are `header = TRUE` and `sep = "\t"`.

```r
# read.table() with appropriate separator
data_txt <- read.table("data/data_ex-1.txt", header = TRUE, sep = "\t")

# read.delim() is a shortcut for tab-delimited files
data_txt <- read.delim("data/data_ex-1.txt", header = TRUE)
```

### 4.2 Reading Fixed-Width Files

`data_ex_col.txt` has no column-name row, and its data starts on the first row. It is therefore read with `header = FALSE` so that every row is data, and `col.names` supplies the column names. Reading it with `header = TRUE` turns the first data row into column names and loses one row of data.

```r
# For column-aligned text files
data_col <- read.table("data/data_ex_col.txt", header = FALSE, col.names = c("ID", "SEX", "AGE", "AREA"))
```

> **Caution:** With its default `sep = ""`, `read.table()` uses white space as the separator, so it can read files whose columns are aligned with spaces or tabs between them. A true fixed-width file, which separates columns only by character position without any separator, is read with `read.fwf()`, which takes the column widths.

---

<br>

## 5. Working Directories

### 5.1 Getting and Setting the Working Directory

```r
# Check current working directory
getwd()

# Set working directory
setwd("/Users/username/Desktop/project/")

# Now you can use relative paths
data <- read.csv("data/data_ex.csv", header = TRUE)
```

After `setwd()` changes the working directory, later relative paths are resolved against the new working directory.

### 5.2 Best Practices

- Use RStudio Projects (`.Rproj` files) to manage working directories automatically.
- Avoid hardcoding absolute paths in scripts.
- Use the `here` package for robust path construction. `here()` builds paths from the project root, which it locates by markers such as an `.Rproj` file, so the paths point to the same files even if the working directory changes later:
  ```r
  # install.packages("here")
  library(here)
  data <- read.csv(here("data", "data_ex.csv"))
  ```

---

<br>

## 6. Data Exploration After Import

### 6.1 Useful Exploration Functions

After importing data, always inspect it:

```r
# Structure and summary
str(data)        # Compact display of structure
summary(data)    # Statistical summary of each column
head(data)       # First 6 rows
tail(data)       # Last 6 rows
dim(data)        # Dimensions (rows x columns)
nrow(data)       # Number of rows
ncol(data)       # Number of columns
names(data)      # Column names
class(data)      # Object class

# Visualization
View(data)       # Spreadsheet viewer in RStudio
```

### 6.2 Common Issues with Imported Data

| Issue | Solution |
|-------|----------|
| Wrong column types | Use `stringsAsFactors = FALSE` or `colClasses` |
| Missing values | Check with `sum(is.na(data))` |
| Encoding issues | Specify `encoding = "UTF-8"` (to convert the file's encoding while reading, specify something like `fileEncoding = "CP949"`) |
| Wrong separator | Verify with `readLines(file, n = 5)` to inspect raw content |

*Table 2. Common issues with imported data and their solutions*

---

<br>

## Summary

| Concept | Key Summary |
|---------|-------------|
| `data.frame()` | It creates a data frame directly from vectors. |
| `read.csv()` | It imports comma-separated files and, with `header = TRUE` (the default), reads the first row as column names. |
| `read.table()` | It is a general-purpose text file reader, and the separator is specified with `sep`. |
| Working directory | It is checked with `getwd()` and set with `setwd()`, and relative paths are preferred. |
| Data inspection | After import, the data is always checked with `str()`, `summary()`, and `head()`. |
| `View()` | It opens data in RStudio's spreadsheet viewer. |
| File paths | Relative paths are more portable than absolute paths. |

---

<br>

## Self-Check Questions

1. **Comparing defaults:** Give the default values of `header` and `sep` for `read.csv()` and for `read.table()`, and state which arguments must be specified to read a comma-separated file whose first row holds column names with `read.table()`.

   <details>
   <summary>Answer</summary>

   The defaults of `read.csv()` are `header = TRUE` and `sep = ","`, and those of `read.table()` are `header = FALSE` and `sep = ""` (white space). To read this file with `read.table()`, `header = TRUE, sep = ","` must therefore be specified.

   </details>

2. **Relative paths:** When the working directory is `/Users/username/Desktop/project/`, give the absolute path of the file that `read.csv("data/data_ex.csv")` reads, and explain why relative paths are more portable than absolute paths.

   <details>
   <summary>Answer</summary>

   The file read is `/Users/username/Desktop/project/data/data_ex.csv`. A relative path is resolved against the working directory, so even if the project folder moves to another computer or location, the code runs unchanged once the working directory is set to the project root. An absolute path does not exist on a computer with a different user name or folder structure.

   </details>

3. **A file without a column-name row:** The file `data_ex_col.txt` has 10 rows and 4 columns, and its first row starts with `1`, `F`, `50`, `서울`. Describe the result of reading it with `read.table("data/data_ex_col.txt", header = TRUE)`, and write code that reads it correctly.

   <details>
   <summary>Answer</summary>

   The first data row is used as column names, so only 9 rows remain, and the column names become `X1`, `F`, `X50`, and `서울`. R prefixes names that start with a digit with `X` to make them valid names. The correct code is `read.table("data/data_ex_col.txt", header = FALSE, col.names = c("ID", "SEX", "AGE", "AREA"))`, which produces a data frame with 10 rows and 4 columns.

   </details>

4. **Inspecting imported data:** After importing a data frame `data`, write the function calls that check (a) the numbers of rows and columns, (b) the data type of each column, and (c) the total number of missing values.

   <details>
   <summary>Answer</summary>

   (a) is `dim(data)`, and `nrow(data)` and `ncol(data)` check them separately. (b) is `str(data)`, which shows the data type and first values of each column. (c) is `sum(is.na(data))`, which counts the `TRUE` values in the logical result of `is.na()` to obtain the number of missing values.

   </details>
