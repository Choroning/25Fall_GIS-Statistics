# Chapter 6 — Data Visualization with ggplot2

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-11-18
>
> 혼자 공부하는 R 데이터 분석, 강전희와 엄동란, Ch 6

> **Learning Objectives:**
> 1. Explain the components of the ggplot2 grammar of graphics and draw scatter plots, line plots, bar charts, and box plots
> 2. Use aesthetic mappings and facets, and stack multiple geoms as layers to add reference lines and text annotations
> 3. Explain, in terms of the interquartile range (IQR), the rule by which a box plot marks outliers

---

## Table of Contents

- [1. Introduction to ggplot2](#1-introduction-to-ggplot2)
  - [1.1 The Grammar of Graphics](#11-the-grammar-of-graphics)
  - [1.2 Basic Syntax](#12-basic-syntax)
- [2. Basic Plot Types](#2-basic-plot-types)
  - [2.1 Scatter Plot (geom_point())](#21-scatter-plot-geom_point)
  - [2.2 Line Plot (geom_line())](#22-line-plot-geom_line)
  - [2.3 Bar Chart (geom_bar())](#23-bar-chart-geom_bar)
  - [2.4 Box Plot (geom_boxplot())](#24-box-plot-geom_boxplot)
  - [2.5 Sunburst Chart (Polar Coordinates)](#25-sunburst-chart-polar-coordinates)
- [3. Aesthetic Mappings](#3-aesthetic-mappings)
  - [3.1 Color Mapping](#31-color-mapping)
  - [3.2 Alpha (Transparency) Mapping](#32-alpha-transparency-mapping)
  - [3.3 Shape Mapping](#33-shape-mapping)
- [4. Faceting](#4-faceting)
  - [4.1 facet_wrap()](#41-facet_wrap)
- [5. Reference Lines and Annotations](#5-reference-lines-and-annotations)
  - [5.1 Adding Reference Lines](#51-adding-reference-lines)
  - [5.2 Text Annotations](#52-text-annotations)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Introduction to ggplot2

### 1.1 The Grammar of Graphics

`ggplot2` is based on the **Grammar of Graphics** concept, where every plot is composed of:

- **Data**: The dataset being plotted.
- **Aesthetics** (`aes()`): Mappings from data variables to visual properties (x, y, color, size, shape).
- **Geometries** (`geom_*`): The visual elements, such as points, lines, and bars.
- **Statistics** (`stat_*`): Summaries or transformations of the data before drawing, such as counting. `geom_bar()` counts by default.
- **Scales**: How data values map to aesthetic values.
- **Coordinates** (`coord_*`): How positions are placed on the plane. The default is the Cartesian coordinate system, and `coord_polar()` gives polar coordinates.
- **Facets**: Splitting data into subplots.
- **Themes**: Visual appearance, such as fonts, colors, and backgrounds.

### 1.2 Basic Syntax

```r
library(ggplot2)

ggplot(data, aes(x = variable1, y = variable2)) +
  geom_point()   # Add a geometry layer
```

> **Key Point:** ggplot2 builds plots layer by layer using the `+` operator. The `ggplot()` call creates the canvas, and `geom_*()` functions add visual elements.

---

<br>

## 2. Basic Plot Types

### 2.1 Scatter Plot (`geom_point()`)

`airquality` holds daily air quality measurements in New York from May to September 1973. `Day` is the day of the month (1-31) and `Temp` is the daily maximum temperature (Fahrenheit), so each day in the plots below carries points from five months.

```r
# Basic scatter plot
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point()

# Scatter plot with custom size and color
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point(size = 3, color = "red")
# Default point size is 1.5
```

### 2.2 Line Plot (`geom_line()`)

```r
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_line()
```

### 2.3 Bar Chart (`geom_bar()`)

`geom_bar()` counts the rows for each value of x and uses the counts as bar heights. Passing the numeric `cyl` of `mtcars` (Chapter 5, Section 1.2) directly as x makes the x-axis continuous, leaving empty ticks such as 5 and 7 between 4, 6, and 8; converting it to a categorical variable with `factor()` shows bars only for the actual values 4, 6, and 8. `fill = factor(gear)` splits each bar by number of gears and colors the parts.

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

### 2.4 Box Plot (`geom_boxplot()`)

Because `Day` is numeric, `group = Day` is needed to draw a separate box for each day. Without it, all the data is drawn as a single box.

```r
# Box plot with grouping
ggplot(airquality, aes(x = Day, y = Temp, group = Day)) +
  geom_boxplot()
```

> **Key Point:** A box plot marks as outliers the points that lie more than $1.5 \times \mathrm{IQR}$ below the first quartile $Q_1$ or more than $1.5 \times \mathrm{IQR}$ above the third quartile $Q_3$, that is, points below $Q_1 - 1.5 \times \mathrm{IQR}$ or above $Q_3 + 1.5 \times \mathrm{IQR}$. The interquartile range is $\mathrm{IQR} = Q_3 - Q_1$. A box plot does **not** define outliers using the mean and standard deviation. The mean and standard deviation are strongly affected by the extreme values themselves.

### 2.5 Sunburst Chart (Polar Coordinates)

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

> **Note:** **Two ways of polar conversion.** The default `theta = "x"` of `coord_polar()` maps the x categories to angle and the bar heights to radius, which gives a shape like Nightingale's rose diagram (coxcomb). `theta = "y"` maps the counts to angle and the categories to radius, which gives a donut shape with one ring per category. A sunburst chart in the strict sense shows a hierarchy with higher-level categories in the inner ring and lower-level categories in the outer rings; here the name means a similar shape.

---

<br>

## 3. Aesthetic Mappings

### 3.1 Color Mapping

```r
# Map class to color: each class gets a different color
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

### 3.2 Alpha (Transparency) Mapping

Transparency expresses a degree from low to high, so mapping it to an unordered categorical variable makes ggplot2 print a warning that this is not advised.

```r
# Map class to transparency
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
```

### 3.3 Shape Mapping

The default shape palette distinguishes at most 6 categories. When `class`, which has 7 categories, is mapped to shape, the 62 points of the seventh category `suv` are not drawn, and a warning is printed.

```r
# Map class to point shape
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
```

> **Key Point:** When an aesthetic is placed **inside** `aes()`, it maps a variable to the aesthetic. When placed **outside** `aes()`, it sets a constant value (e.g., `color = "red"` makes all points red).

---

<br>

## 4. Faceting

### 4.1 facet_wrap()

Splits data into subplots based on a categorical variable. `~ class` is a formula that asks for one subplot per value of `class`, and `nrow = 2` arranges the 7 subplots in 2 rows:

```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
```

---

<br>

## 5. Reference Lines and Annotations

### 5.1 Adding Reference Lines

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

`psavert` is the US personal savings rate (%). `geom_abline()` draws the line $y = \text{intercept} + \text{slope} \times x$ defined by `intercept` and `slope`. A date axis is stored internally as the number of days since 1970-01-01, so the slope `-0.0005444` describes a trend in which the savings rate falls by 0.0005444 percentage points per day, or about 0.2 percentage points per year. `geom_hline()` and `geom_vline()` draw horizontal and vertical lines at the given y and x values. 2005-07-01 is the month with the lowest savings rate, 2.2%.

### 5.2 Text Annotations

```r
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point() +
  geom_text(aes(label = Temp, vjust = 0, hjust = 0))
```

`label = Temp` writes each point's temperature as text. `vjust = 0` and `hjust = 0` align the bottom-left corner of the text with the point, so the text sits above and to the right of the point. Both values are constants rather than variables, so writing them outside `aes()` gives the same result.

---

<br>

## Summary

| Concept | Key Summary |
|---------|-------------|
| ggplot2 | It follows a layer-based grammar of graphics and builds plots in the form `ggplot() + geom_*()`. |
| `aes()` | It maps data variables to visual properties (x, y, color, size, shape). |
| `geom_point()` | It draws scatter plots, and the default point size is 1.5. |
| `geom_bar()` | It draws bar charts, and converting x to a categorical variable with `factor()` removes empty values from the axis. |
| `geom_boxplot()` | It draws box plots and marks points below $Q_1 - 1.5 \times \mathrm{IQR}$ or above $Q_3 + 1.5 \times \mathrm{IQR}$ as outliers. |
| `facet_wrap()` | It splits a plot into subplots by the values of a variable. |

---

<br>

## Self-Check Questions

1. **Inside and outside aes():** Explain how the results of `geom_point(aes(color = "red"))` and `geom_point(color = "red")` differ.

   <details>
   <summary>Answer</summary>

   `geom_point(color = "red")` sets a constant outside `aes()`, so every point is red. `geom_point(aes(color = "red"))` maps to color a variable whose only value is the string `"red"`, so the points take the first color of the default palette (`#F8766D`, a light red), and a legend with a single entry `red` appears.

   </details>

2. **The x-axis of a bar chart:** In `mtcars`, 11 cars have `cyl` equal to 4, 7 have 6, and 14 have 8. Compare the bar heights and x-axes of the bar charts drawn with `aes(x = cyl)` and with `aes(x = factor(cyl))`.

   <details>
   <summary>Answer</summary>

   In both charts the bar heights are 11, 7, and 14. `cyl` is numeric, so with `aes(x = cyl)` the x-axis is continuous, ticks including 5 and 7 are shown, and those positions are empty. `factor(cyl)` creates a categorical axis that shows only the three categories 4, 6, and 8 side by side.

   </details>

3. **Outlier fences:** A group has first quartile 10 and third quartile 20. Find the outlier fences of the box plot, and choose all values among -6, 34, and 36 that are marked as outliers.

   <details>
   <summary>Answer</summary>

   $\mathrm{IQR} = 20 - 10 = 10$, so the lower fence is $10 - 1.5 \times 10 = -5$ and the upper fence is $20 + 1.5 \times 10 = 35$. -6 is below -5 and 36 is above 35, so both are outliers, while 34 lies within the fences and is not an outlier.

   </details>
