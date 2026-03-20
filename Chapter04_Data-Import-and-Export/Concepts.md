# Chapter 04 — Data Import and Export

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Manual Data Entry](#1-manual-data-entry)
2. [Reading External Data](#2-reading-external-data)
3. [Reading CSV Files](#3-reading-csv-files)
4. [Reading Text Files](#4-reading-text-files)
5. [Working Directories](#5-working-directories)
6. [Data Exploration After Import](#6-data-exploration-after-import)
7. [Summary](#summary)

---

## 1. Manual Data Entry

### 1.1 Creating Data Directly in R

Before importing external data, we can create data frames manually:

```r
ID <- c(1, 2, 3, 4, 5)
SEX <- c("F", "M", "F", "M", "F")
DATA <- data.frame(ID = ID, SEX = SEX)
View(DATA)   # Open in spreadsheet viewer
```

> **Key Point:** Manual data entry is useful for small datasets or for creating test data, but for real-world analysis, data is typically imported from external files.

---

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

---

## 3. Reading CSV Files

### 3.1 Basic CSV Import

CSV (Comma-Separated Values) is the most common format for data exchange:

```r
# Read a CSV file with header row
ex_data <- read.csv("data/data_ex.csv", header = TRUE)
View(ex_data)
```

### 3.2 Important Parameters

```r
read.csv(
  file,                    # File path (absolute or relative)
  header = TRUE,           # First row is column names
  sep = ",",               # Separator (comma for CSV)
  stringsAsFactors = FALSE # Don't convert strings to factors
)
```

### 3.3 File Path Considerations

```r
# Absolute path (platform-specific)
read.csv("/Users/username/Desktop/data_ex.csv", header = TRUE)

# Relative path (relative to working directory)
read.csv("data/data_ex.csv", header = TRUE)
```

> **Key Point:** Using relative paths makes your code more portable across different computers. Set your working directory to the project root and use relative paths from there.

---

## 4. Reading Text Files

### 4.1 Reading Tab-Delimited Files

```r
# read.table() with appropriate separator
data_txt <- read.table("data/data_ex-1.txt", header = TRUE, sep = "\t")

# read.delim() is a shortcut for tab-delimited files
data_txt <- read.delim("data/data_ex-1.txt", header = TRUE)
```

### 4.2 Reading Fixed-Width Files

```r
# For column-aligned text files
data_col <- read.table("data/data_ex_col.txt", header = TRUE)
```

---

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

### 5.2 Best Practices

- Use RStudio Projects (`.Rproj` files) to manage working directories automatically
- Avoid hardcoding absolute paths in scripts
- Use the `here` package for robust path construction:
  ```r
  # install.packages("here")
  library(here)
  data <- read.csv(here("data", "data_ex.csv"))
  ```

---

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
| Encoding issues | Specify `encoding = "UTF-8"` |
| Wrong separator | Verify with `readLines(file, n = 5)` to inspect raw content |

---

## Summary

| Concept | Key Point |
|---------|-----------|
| `data.frame()` | Create data frames manually from vectors |
| `read.csv()` | Import comma-separated files; use `header = TRUE` |
| `read.table()` | General-purpose text file reader; specify `sep` |
| Working directory | Use `getwd()` / `setwd()`; prefer relative paths |
| Data inspection | Always use `str()`, `summary()`, `head()` after import |
| `View()` | Opens data in RStudio's spreadsheet viewer |
| File paths | Relative paths are more portable than absolute paths |
