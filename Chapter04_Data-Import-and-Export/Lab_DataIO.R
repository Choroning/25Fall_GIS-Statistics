# @file    Lab_DataIO.R
# @brief   Demonstrates manual data entry and importing external data
#          from CSV and text files in R
# @author  Cheolwon Park
# @date    2025-10-14


# =============================================================================
# 1. MANUAL DATA ENTRY
# =============================================================================

# Create vectors for each variable
ID <- c(1, 2, 3, 4, 5)
ID

SEX <- c("F", "M", "F", "M", "F")
SEX

# Combine into a data frame
DATA <- data.frame(ID = ID, SEX = SEX)
View(DATA)


# =============================================================================
# 2. READING EXTERNAL DATA
# =============================================================================

# The read.table() function is the most general text file reader
help(read.table)


# =============================================================================
# 3. READING CSV FILES
# =============================================================================

# Read a CSV file (header = TRUE means first row contains column names)
# Use relative path from project root directory
ex_data <- read.csv("data/data_ex.csv", header = TRUE)
View(ex_data)

# Inspect the imported data
str(ex_data)      # Check structure and data types
summary(ex_data)  # Statistical summary
head(ex_data)     # Preview first 6 rows
dim(ex_data)      # Dimensions (rows x columns)


# =============================================================================
# 4. READING TEXT FILES
# =============================================================================

# Read tab-delimited text files
data_txt1 <- read.table("data/data_ex-1.txt", header = TRUE)
data_txt2 <- read.table("data/data_ex-2.txt", header = TRUE)
data_col  <- read.table("data/data_ex_col.txt", header = FALSE, col.names = c("ID", "SEX", "AGE", "AREA"))

# Verify imported data
str(data_txt1)
str(data_txt2)
str(data_col)
