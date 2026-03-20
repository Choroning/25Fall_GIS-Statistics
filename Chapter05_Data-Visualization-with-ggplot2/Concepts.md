# Chapter 05 — Data Visualization with ggplot2

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Introduction to ggplot2](#1-introduction-to-ggplot2)
2. [Data Manipulation with dplyr](#2-data-manipulation-with-dplyr)
3. [Basic Plot Types](#3-basic-plot-types)
4. [Aesthetic Mappings](#4-aesthetic-mappings)
5. [Faceting](#5-faceting)
6. [Reference Lines and Annotations](#6-reference-lines-and-annotations)
7. [Joining Data](#7-joining-data)
8. [Summary](#summary)

---

## 1. Introduction to ggplot2

### 1.1 The Grammar of Graphics

`ggplot2` is based on the "Grammar of Graphics" concept, where every plot is composed of:

- **Data**: The dataset being plotted
- **Aesthetics** (`aes()`): Mappings from data variables to visual properties (x, y, color, size, shape)
- **Geometries** (`geom_*`): The visual elements (points, lines, bars)
- **Scales**: How data values map to aesthetic values
- **Facets**: Splitting data into subplots
- **Themes**: Visual appearance (fonts, colors, backgrounds)

### 1.2 Basic Syntax

```r
library(ggplot2)

ggplot(data, aes(x = variable1, y = variable2)) +
  geom_point()   # Add a geometry layer
```

> **Key Point:** ggplot2 builds plots layer by layer using the `+` operator. The `ggplot()` call creates the canvas, and `geom_*()` functions add visual elements.

---

## 2. Data Manipulation with dplyr

### 2.1 Core dplyr Verbs

The `dplyr` package provides five core functions for data manipulation:

| Function | Purpose | Example |
|----------|---------|---------|
| `filter()` | Select rows by condition | `filter(flights, month == 1)` |
| `arrange()` | Sort rows | `arrange(flights, dep_delay)` |
| `select()` | Choose columns | `select(flights, year, month, day)` |
| `mutate()` | Create new columns | `mutate(data, speed = distance/time)` |
| `summarise()` | Aggregate data | `summarise(data, avg = mean(x))` |

### 2.2 filter() — Row Selection

```r
library(tidyverse)
library(nycflights13)

# Filter flights on January 1st
filter(flights, month == 1, day == 1)

# Assign result to variable
jan1 <- filter(flights, month == 1, day == 1)

# Filter and print in one step (wrapping with parentheses)
(dec25 <- filter(flights, month == 12, day == 25))

# Filter with multiple conditions
filter(mtcars, cyl == 4)
filter(mtcars, cyl >= 6 & mpg > 20)
```

### 2.3 arrange() — Sorting

```r
arrange(flights, year, month, day)         # Ascending order
arrange(flights, desc(dep_delay))          # Descending order

head(arrange(mtcars, wt))                  # Sort by weight (ascending)
head(arrange(mtcars, mpg, desc(wt)))       # Sort by mpg, then desc weight
```

### 2.4 select() — Column Selection

```r
select(flights, year, month, day)          # Select specific columns
select(flights, year:day)                  # Select range of columns
select(flights, -(year:day))               # Exclude range of columns

# Helper functions
select(flights, ends_with("delay"))        # Columns ending with "delay"
```

### 2.5 mutate() — Create New Columns

```r
flights_sml <- select(flights,
  year:day, ends_with("delay"), distance, air_time
)

mutate(flights_sml,
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60
)

# New columns can reference other new columns
mutate(flights_sml,
  gain = dep_delay - arr_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)
```

### 2.6 summarise() and group_by()

```r
# Simple summary
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# Grouped summary
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# Using pipe operator (%>%)
group_by(mtcars, cyl) %>% summarise(n())

# Multiple summary statistics
summarise(mtcars,
  cyl_mean = mean(cyl),
  cyl_min = min(cyl),
  cyl_max = max(cyl)
)
```

> **Key Point:** The pipe operator `%>%` passes the result of the left expression as the first argument to the right function. It makes chains of operations readable: `data %>% filter() %>% summarise()`.

---

## 3. Basic Plot Types

### 3.1 Scatter Plot (`geom_point()`)

```r
# Basic scatter plot
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point()

# Scatter plot with custom size and color
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point(size = 3, color = "red")
# Default point size is 1.5
```

### 3.2 Line Plot (`geom_line()`)

```r
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_line()
```

### 3.3 Bar Chart (`geom_bar()`)

```r
# Simple bar chart (only x-axis needed; y counts automatically)
ggplot(mtcars, aes(x = cyl)) +
  geom_bar(width = 0.5)

# Use factor() to exclude empty categories (e.g., 5 and 7 cylinders)
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(width = 0.5)

# Stacked bar chart with fill color
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(aes(fill = factor(gear)))
```

### 3.4 Box Plot (`geom_boxplot()`)

```r
# Box plot with grouping
ggplot(airquality, aes(x = Day, y = Temp, group = Day)) +
  geom_boxplot()
```

> **Key Point:** In box plots, outliers are points that fall beyond 1.5 times the interquartile range (IQR). In statistics, outliers are **not** defined using mean and standard deviation.

### 3.5 Sunburst Chart (Polar Coordinates)

```r
# Stacked bar chart converted to sunburst using coord_polar()
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(aes(fill = factor(gear))) +
  coord_polar()

# Donut-shaped sunburst chart
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(aes(fill = factor(gear))) +
  coord_polar(theta = "y")
```

---

## 4. Aesthetic Mappings

### 4.1 Color Mapping

```r
# Map class to color: each class gets a different color
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

### 4.2 Alpha (Transparency) Mapping

```r
# Map class to transparency
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
```

### 4.3 Shape Mapping

```r
# Map class to point shape
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
```

> **Key Point:** When an aesthetic is placed **inside** `aes()`, it maps a variable to the aesthetic. When placed **outside** `aes()`, it sets a constant value (e.g., `color = "red"` makes all points red).

---

## 5. Faceting

### 5.1 facet_wrap()

Splits data into subplots based on a categorical variable:

```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
```

---

## 6. Reference Lines and Annotations

### 6.1 Adding Reference Lines

```r
library(ggplot2)

# Diagonal line with intercept and slope
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_abline(intercept = 12.18671, slope = -0.0005444)

# Horizontal reference line at the mean
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_hline(yintercept = mean(economics$psavert))

# Vertical reference line at a specific date
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2005-07-01"))
```

### 6.2 Text Annotations

```r
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point() +
  geom_text(aes(label = Temp, vjust = 0, hjust = 0))
```

---

## 7. Joining Data

### 7.1 left_join()

```r
library(nycflights13)

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")
```

### 7.2 Counting and Filtering Duplicates

```r
planes %>%
  count(tailnum) %>%
  filter(n > 1)

weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)
```

---

## Summary

| Concept | Key Point |
|---------|-----------|
| ggplot2 | Layer-based grammar of graphics; `ggplot() + geom_*()` |
| `aes()` | Maps data variables to visual properties (x, y, color, size, shape) |
| `geom_point()` | Scatter plots; default size is 1.5 |
| `geom_bar()` | Bar charts; use `factor()` to exclude empty categories |
| `geom_boxplot()` | Box plots; outliers beyond 1.5 * IQR |
| `facet_wrap()` | Split plot into subplots by a variable |
| dplyr verbs | `filter()`, `arrange()`, `select()`, `mutate()`, `summarise()` |
| `%>%` pipe | Chains operations: passes left result as first argument to right |
| `group_by()` | Groups data for aggregation with `summarise()` |
| `left_join()` | Merges data frames by a common key column |
