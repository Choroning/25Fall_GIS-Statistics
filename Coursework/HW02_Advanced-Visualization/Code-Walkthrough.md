# HW2 Code Walkthrough — Advanced Visualization

[Repository Guide](../../README.md) | [English](Code-Walkthrough.md) | [한국어](Code-Walkthrough.ko.md)

> **Last Updated:** 2026-11-16
>
> Modern Data Visualization with R, Kabacoff, Ch 5, 6, 7, 8

> **Learning Objectives:**
> 1. Explain the packages, working directory, and dependencies between blocks needed to run the script
> 2. Read code that assembles a ggplot2 graph from mappings inside `aes()`, fixed values outside it, layers, scales, labels, and themes
> 3. Explain code that reshapes data into the form a graph needs with dplyr and tidyr
> 4. Explain code that builds and joins map data with sf, mapview, and choroplethr
> 5. Explain where the solution code differs from Kabacoff's original code and why

---

## Table of Contents

- [1. File Structure and How to Run](#1-file-structure-and-how-to-run)
  - [1.1 Structure of the Script](#11-structure-of-the-script)
  - [1.2 Required Packages](#12-required-packages)
  - [1.3 Working Directory and Running](#13-working-directory-and-running)
- [2. Code for Kabacoff Chapter 5](#2-code-for-kabacoff-chapter-5)
  - [2.1 Categorical vs. Categorical](#21-categorical-vs-categorical)
  - [2.2 Quantitative vs. Quantitative](#22-quantitative-vs-quantitative)
  - [2.3 Categorical vs. Quantitative](#23-categorical-vs-quantitative)
- [3. Code for Kabacoff Chapter 6](#3-code-for-kabacoff-chapter-6)
  - [3.1 Grouping](#31-grouping)
  - [3.2 Faceting](#32-faceting)
- [4. Code for Kabacoff Chapter 7](#4-code-for-kabacoff-chapter-7)
  - [4.1 Dot Density Maps](#41-dot-density-maps)
  - [4.2 Choropleth Maps](#42-choropleth-maps)
- [5. Code for Kabacoff Chapter 8](#5-code-for-kabacoff-chapter-8)
- [6. Differences from Kabacoff's Code](#6-differences-from-kabacoffs-code)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. File Structure and How to Run

> **Try It First:** This document contains the complete code and line-by-line explanations. Solve the problems in the [assignment handout](Original/Assignment.md) yourself before reading on.

`Solution/HW_AdvancedVisualization.R` is a single R script of 372 lines that holds, in chapter order, the code of the 25 figures chosen from Chapters 5-8 of Kabacoff's *Modern Data Visualization with R*. The section and figure each block reproduces and the interpretation of the results are in the [HW2 assignment explanation](Assignment-Explanation.md), and this document reads the code from start to finish.

### 1.1 Structure of the Script

```r
# @file    HW_AdvancedVisualization.R
# @brief   Advanced ggplot2 visualizations including grouped charts,
#          distribution plots, faceting, GIS maps, and time-based charts
# @author  Cheolwon Park
# @date    2025-11-11
```

Lines 1-5 are a Doxygen-style header with the file name, a one-line description, the author, and the date. Below it, each chapter has a divider comment framed by `# ====` lines, and each block within a chapter starts with a comment giving its number and figure name, as in `# (1) Grouped Bar Chart (side-by-side)`.

| Chapter Divider Comment | Lines | Blocks |
|:-----|:-----|:-----|
| `CHAPTER 5: DISTRIBUTION AND COMPARISON PLOTS` | Lines 8-104 | (1)-(7) |
| `CHAPTER 6: GROUPING AND FACETING` | Lines 106-195 | (1)-(8) |
| `CHAPTER 7: GIS VISUALIZATION` | Lines 198-282 | (1)-(5) |
| `CHAPTER 8: TIME-BASED VISUALIZATION` | Lines 285-372 | (1)-(5) |

*Table 1. Chapter divisions of the script*

Most blocks load the packages and data they use again, so they can run on their own. Some blocks, however, reuse objects created or packages loaded by an earlier block, so either run the script from the top in order or, when running a single block, prepare the following first.

| Block | What Must Be Prepared First |
|:-----|:-----|
| Chapter 6 (2)-(7) | ggplot2 and `Salaries` loaded by Chapter 6 (1) |
| Chapter 6 (8) | ggplot2 |
| Chapter 7 (2) | `homicide` created by Chapter 7 (1) and sf and mapview loaded by it |
| Chapter 7 (3) | `%>%`, `filter()`, `rename()`, `mutate()`, and `recode()` from dplyr |
| Chapter 7 (4) | `plotdata` created by Chapter 7 (3), choroplethr loaded by it, and ggplot2 |
| Chapter 8 (3) | `%>%`, `filter()`, and `mutate()` from dplyr, and ggplot2 |
| Chapter 8 (4), (5) | ggplot2 |

*Table 2. Blocks that depend on earlier blocks*

### 1.2 Required Packages

| Package | Used For | Installation |
|:-----|:-----|:-----|
| ggplot2 | All graphs and the `mpg` and `economics` data | CRAN |
| carData, gapminder | The `Salaries` and `gapminder` data | CRAN |
| dplyr, tidyr | Selecting, transforming, and reshaping data | CRAN |
| scales | Dollar and date formats for axis labels | CRAN |
| ggridges | The ridgeline plot of Chapter 5 (6) | CRAN |
| ggmap | The `crime` data of Chapter 7 (1) | CRAN |
| sf, mapview | The sf objects and interactive maps of Chapter 7 | CRAN |
| choroplethr, choroplethrMaps | The country choropleth maps of Chapter 7 (3) and (4) | CRAN |
| tidyverse | Loading ggplot2, dplyr, and others at once in Chapter 7 (5) | CRAN |
| gcookbook, forcats | The `uspopage` data and reversing factor levels in Chapter 8 (5) | CRAN |
| ggalt | The dumbbell chart of Chapter 8 (2) | GitHub (`hrbrmstr/ggalt`) |
| CGPfunctions | The slope graph of Chapter 8 (3) | GitHub (`ibecav/CGPfunctions`) |
| ggstream | The stream graph of Chapter 8 (5) | GitHub (`davidsjoberg/ggstream`) |

*Table 3. Packages used by the script*

The script leaves the installation command of each block as a `# install.packages("...")` comment. However, ggalt, CGPfunctions, and ggstream cannot be installed from CRAN, so install them from GitHub with the remotes package.

```r
install.packages(c("ggplot2", "carData", "gapminder", "dplyr", "tidyr",
                   "scales", "ggridges", "ggmap", "sf", "mapview",
                   "choroplethr", "choroplethrMaps", "tidyverse",
                   "gcookbook", "forcats", "remotes"))
remotes::install_github("hrbrmstr/ggalt")
remotes::install_github("ibecav/CGPfunctions")
remotes::install_github("davidsjoberg/ggstream")
```

### 1.3 Working Directory and Running

Chapter 7 (5) reads its data with paths relative to the working directory, such as `st_read("../data/cb_2024_us_state_5m.shp")`, so the working directory must be the `Solution/` folder. In RStudio, open the script and choose Set Working Directory, To Source File Location from the Session menu; in the console, run the following from the repository root.

```r
setwd("Coursework/HW02_Advanced-Visualization/Solution")
source("HW_AdvancedVisualization.R", echo = TRUE)
```

By default, `source()` does not print the values of expressions, so ggplot objects are not drawn. With `echo = TRUE`, the default of `print.eval` also becomes `TRUE`, so the value of each expression is printed and the graphs are drawn one after another. To run the blocks one at a time and check the plot pane as the assignment describes, select a block in RStudio and run it with Ctrl+Enter (Cmd+Enter on macOS). The mapview maps open in the Viewer pane, not the Plots pane.

---

<br>

## 2. Code for Kabacoff Chapter 5

### 2.1 Categorical vs. Categorical

**(1) Side-by-side bar chart (lines 13-17).**

```r
# (1) Grouped Bar Chart (side-by-side)
library(ggplot2)

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "dodge")
```

- `ggplot(mpg, aes(...))` sets the data and the aesthetic mappings. `x = class` maps the car class to the x axis, and `fill = drv` maps the drive type to the fill color of the bars. `mpg` comes with ggplot2, so it is not loaded separately.
- Without a y, `geom_bar()` counts the rows in each category of x and uses the counts as bar heights. Groups split by `fill` are stacked in one bar with the default `position = "stack"` and placed side by side with `"dodge"`.

### 2.2 Quantitative vs. Quantitative

**(2) Customized scatterplot (lines 20-33).**

```r
# (2) Scatter Plot with custom styling and axis formatting
# install.packages("carData")
library(ggplot2)
data(Salaries, package = "carData")

ggplot(Salaries,
       aes(x = yrs.since.phd, y = salary)) +
  geom_point(color = "cornflowerblue", size = 2, alpha = 0.8) +
  scale_y_continuous(label = scales::dollar, limits = c(50000, 250000)) +
  scale_x_continuous(breaks = seq(0, 60, 10), limits = c(0, 60)) +
  labs(x = "Years Since PhD",
       y = "",
       title = "Experience vs. Salary",
       subtitle = "9-month salary for 2008-2009")
```

- `data(Salaries, package = "carData")` places only the data `Salaries` in the global environment without loading the whole package.
- `color`, `size`, and `alpha` in `geom_point()` are outside `aes()`, so they are not mapped to variables; the same values apply to all points, and no legend is created.
- `label` in `scale_y_continuous()` specifies the argument `labels` by partial matching. `scales::dollar` is a function that turns numbers into strings in the `$100,000` format, and `::` is the operator that uses a function of a package without loading the package.
- `limits` sets the axis range, and values outside the range become missing and are not drawn. In these data, all points lie within the range. `breaks = seq(0, 60, 10)` places the x ticks at 0, 10, ..., 60.
- `labs()` sets the axis titles, title, and subtitle, and `y = ""` empties the y axis title.

**(3) Line plot with points and labels (lines 36-51).**

```r
# (3) Line Plot with points and labels
# install.packages("gapminder")
data(gapminder, package = "gapminder")
library(ggplot2)
library(dplyr)

plotdata <- filter(gapminder, country == "United States")

ggplot(plotdata, aes(x = year, y = lifeExp)) +
  geom_line(linewidth = 1.5, color = "lightgrey") +
  geom_point(size = 3, color = "steelblue") +
  labs(y = "Life Expectancy (years)",
       x = "Year",
       title = "Life expectancy changes over time",
       subtitle = "United States (1952-2007)",
       caption = "Source: http://www.gapminder.org/data/")
```

- `filter()` is a dplyr function that keeps only the rows for which the condition is true; here it selects the 12 rows of the United States. It must be called after dplyr is loaded on line 40 so that the dplyr function, not the stats function of the same name, is called.
- `geom_line()` draws a thick light grey line, and `geom_point()` draws points on top of it. Layers are drawn in the order they are added, so the points sit on the line.
- `linewidth` is the line width. Kabacoff's code writes `size = 1.5`, but since ggplot2 3.4.0 the line width is set with `linewidth`, and `size` raises a warning.
- `caption` in `labs()` writes the source at the lower right of the graph.

### 2.3 Categorical vs. Quantitative

**(4) Grouped kernel density plots (lines 54-61).**

```r
# (4) Grouped Kernel Density Plots
# install.packages("carData")
data(Salaries, package = "carData")
library(ggplot2)

ggplot(Salaries, aes(x = salary, fill = rank)) +
  geom_density(alpha = 0.4) +
  labs(title = "Salary distribution by rank")
```

- `geom_density()` draws a distribution as a smooth curve with area 1 under it by kernel density estimation. `fill = rank` splits one curve per rank and fills each with a different color.
- `alpha = 0.4` is the opacity of the fill, fully transparent at 0 and opaque at 1. A low value is used so that the overlapping parts of the curves remain visible.

**(5) Side-by-side boxplots (lines 64-70).**

```r
# (5) Side-by-Side Box Plots
data(Salaries, package = "carData")
library(ggplot2)

ggplot(Salaries, aes(x = rank, y = salary)) +
  geom_boxplot() +
  labs(title = "Salary distribution by rank")
```

- When x is categorical (`rank`) and y is quantitative (`salary`), `geom_boxplot()` draws a boxplot for each category. The box runs from the first to the third quartile, the middle line is the median, the whiskers extend to the farthest values within 1.5 times the interquartile range from the box, and values beyond them are plotted separately as outliers.

**(6) Ridgeline plot (lines 73-83).**

```r
# (6) Ridgeline Plots
# install.packages("ggridges")
library(ggplot2)
library(ggridges)

ggplot(mpg,
       aes(x = cty, y = class, fill = class)) +
  geom_density_ridges() +
  theme_ridges() +
  labs(title = "City mileage by auto class") +
  theme(legend.position = "none")
```

- `geom_density_ridges()` from ggridges draws the density curve of x for each category of y and stacks them with slight overlaps between categories. Running it prints the message `Picking joint bandwidth of 0.929`, which reports the bandwidth shared by all curves.
- `theme_ridges()` is a complete theme provided by ggridges, and `theme(legend.position = "none")` removes the legend. A complete theme overwrites all earlier theme settings, so the legend setting must be added after the theme function.
- `labs(title = ...)` on line 82 corrects Kabacoff's `labs("Highway mileage by auto class")`. `labs()` decides which label to set by the argument name (`title`, `x`, and so on), so an unnamed string does not become the title, and ggplot2 4.0.1 raises an error. The x axis is the city mileage `cty`, so Highway in the title is also changed to City.

**(7) Jittered strip plot (lines 86-103).**

```r
# (7) Fancy Jittered Strip Plot
data(Salaries, package = "carData")
library(ggplot2)
library(scales)

ggplot(Salaries,
       aes(y = factor(rank,
                      labels = c("Assistant\nProfessor",
                                 "Associate\nProfessor",
                                 "Full\nProfessor")),
           x = salary, color = rank)) +
  geom_jitter(alpha = 0.7) +
  scale_x_continuous(label = dollar) +
  labs(title = "Academic Salary by Rank",
       subtitle = "9-month salary for 2008-2009",
       x = "", y = "") +
  theme_minimal() +
  theme(legend.position = "none")
```

- `factor(rank, labels = c(...))` gives new names, in order, to the three rank levels `AsstProf`, `AssocProf`, and `Prof`. `\n` is the newline character, so the long names on the y axis appear on two lines.
- The rank is on the y axis and the salary on the x axis, so the result is a horizontal strip plot.
- `geom_jitter()` adds a small random shift to each point so that points of the same category do not overlap on one line. The default shift is 40% of the resolution of the data on each axis, so the points barely move along the salary, whose resolution is 1 dollar, and spread along the category direction.
- scales is loaded on line 89, so `scale_x_continuous(label = dollar)` uses `dollar` without `scales::`. `theme_minimal()` is a theme without the grey background and borders.

---

<br>

## 3. Code for Kabacoff Chapter 6

### 3.1 Grouping

**(1) Simple scatterplot (lines 111-118).**

```r
# (1) Simple scatter plot
library(ggplot2)
data(Salaries, package = "carData")

ggplot(Salaries,
       aes(x = yrs.since.phd, y = salary)) +
  geom_point() +
  labs(title = "Academic salary by years since degree")
```

Blocks (2) through (7) reuse the ggplot2 and `Salaries` loaded by this block.

**(2) Color mapping (lines 121-124), (3) color and shape mapping (lines 127-131), and (4) color and size mapping (lines 134-139).**

```r
# (2) Scatter plot with color mapping by rank
ggplot(Salaries, aes(x = yrs.since.phd, y = salary, color = rank)) +
  geom_point() +
  labs(title = "Academic salary by rank and years since degree")


# (3) Scatter plot with color and shape mapping
ggplot(Salaries, aes(x = yrs.since.phd, y = salary,
                     color = rank, shape = sex)) +
  geom_point(size = 3, alpha = 0.6) +
  labs(title = "Academic salary by rank, sex, and years since degree")


# (4) Scatter plot with size and color mapping
ggplot(Salaries, aes(x = yrs.since.phd, y = salary,
                     color = rank, size = yrs.service)) +
  geom_point(alpha = 0.6) +
  labs(title = paste0("Academic salary by rank, years of service, ",
                      "and years since degree"))
```

- The three blocks add one aesthetic at a time to `aes()`. An aesthetic inside `aes()` is mapped to a variable, and a scale and a legend are created automatically, while a value outside `aes()`, such as `size = 3` in (3), applies equally to all points.
- Mapping the categorical variable `rank` to `color` uses a discrete color scale, and mapping the categorical variable `sex` to `shape` uses a shape scale. Mapping the quantitative variable `yrs.service` to `size` uses a continuous scale in which the point area grows with the value.
- `paste0()` in (4) joins strings without spaces and is used to split a long title over two lines of code.

**(5) Quadratic fit lines by sex (lines 142-154).**

```r
# (5) Scatter plot with quadratic fit lines by sex
ggplot(Salaries,
       aes(x = yrs.since.phd, y = salary, color = sex)) +
  geom_point(alpha = 0.4, size = 3) +
  geom_smooth(se = FALSE, method = "lm",
              formula = y ~ poly(x, 2), linewidth = 1.5) +
  labs(x = "Years Since Ph.D.",
       title = "Academic Salary by Sex and Years Experience",
       subtitle = "9-month salary for 2008-2009",
       y = "", color = "Sex") +
  scale_y_continuous(label = scales::dollar) +
  scale_color_brewer(palette = "Set1") +
  theme_minimal()
```

- `color = sex` is in the `aes()` of `ggplot()`, so the mapping applies to every layer, and both the points and the fit lines are split by sex.
- `geom_smooth(method = "lm", formula = y ~ poly(x, 2))` fits a regression curve with a second-degree polynomial of x for each group. `se = FALSE` omits the confidence band, and `linewidth = 1.5` draws thick curves.
- `labs(color = "Sex")` sets the title of the color legend, and `scale_color_brewer(palette = "Set1")` sets the ColorBrewer `Set1` palette.

### 3.2 Faceting

**(6) Histograms by rank (lines 157-161).**

```r
# (6) Salary histograms faceted by rank
ggplot(Salaries, aes(x = salary)) +
  geom_histogram() +
  facet_wrap(~rank, ncol = 1) +
  labs(title = "Salary histograms by rank")
```

- `facet_wrap(~rank, ncol = 1)` makes one panel for each level of `rank` and arranges them in one column. By default, the panels share the x and y axes.
- Without `bins` or `binwidth`, `geom_histogram()` uses 30 bins and prints the message `` `stat_bin()` using `bins = 30`. Pick better value `binwidth`. ``.

**(7) Faceted scatterplot by discipline (lines 164-179).**

```r
# (7) Faceted scatter plot by discipline with fit lines
ggplot(Salaries, aes(x = yrs.since.phd, y = salary, color = sex)) +
  geom_point(size = 2, alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.5) +
  facet_wrap(~factor(discipline,
                     labels = c("Theoretical", "Applied")),
             ncol = 1) +
  scale_y_continuous(labels = scales::dollar) +
  theme_minimal() +
  scale_color_brewer(palette = "Set1") +
  labs(title = paste0("Relationship of salary and years ",
                      "since degree by sex and discipline"),
       subtitle = "9-month salary for 2008-2009",
       color = "Gender",
       x = "Years since Ph.D.",
       y = "Academic Salary")
```

- The formula of `facet_wrap()` can contain an expression, so `factor(discipline, labels = ...)` renames the levels A and B and splits the panels at the same time. The panel titles use the new names.
- `geom_smooth(method = "lm")` is given no `formula`, so it fits the straight line `y ~ x` and prints the message `` `geom_smooth()` using formula = 'y ~ x' ``.
- Here the argument name is written in full, as `labels = scales::dollar`, and the result is the same as `label` in (5).

**(8) Life expectancy by country in the Americas (lines 182-195).**

```r
# (8) Life expectancy changes by country (Americas)
data(gapminder, package = "gapminder")

plotdata <- dplyr::filter(gapminder, continent == "Americas")

ggplot(plotdata, aes(x = year, y = lifeExp)) +
  geom_line(color = "grey") +
  geom_point(color = "blue") +
  facet_wrap(~country) +
  theme_minimal(base_size = 9) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  labs(title = "Changes in Life Expectancy",
       x = "Year",
       y = "Life Expectancy")
```

- `dplyr::filter()` uses the dplyr function whether or not dplyr is loaded. The 300 rows of 25 countries in the Americas at 12 time points remain.
- Without a number of columns, `facet_wrap(~country)` chooses the grid from the number of panels, so the 25 panels are laid out in 5 rows and 5 columns.
- `theme_minimal(base_size = 9)` reduces the base font size to 9 points. `element_text(angle = 45, hjust = 1)` tilts the x tick labels 45 degrees and aligns their right ends with the ticks.

---

<br>

## 4. Code for Kabacoff Chapter 7

### 4.1 Dot Density Maps

**(1) Interactive mapview map (lines 203-218).**

```r
# (1) Interactive maps with mapview
# install.packages("ggmap")
# install.packages("mapview")
# install.packages("sf")
library(ggmap)
library(dplyr)
library(mapview)
library(sf)

homicide <- filter(crime, offense == "murder") %>%
  select(date, offense, address, lon, lat)

head(homicide, 3)

mymap <- st_as_sf(homicide, coords = c("lon", "lat"), crs = 4326)
mapview(mymap)
```

- Loading ggmap prints notices about the terms of service of Google, Stadia Maps, and OpenStreetMap, and loading sf prints the versions of the GEOS, GDAL, and PROJ libraries. This block uses only the `crime` data of ggmap, not its mapping functions.
- `%>%` is the pipe operator that passes the result on its left as the first argument of the function on its right. `filter()` selects the 157 murders, and `select()` keeps five columns. `head(homicide, 3)` prints the first three rows.

```text
      date offense            address       lon      lat
1 1/1/2010  murder    9650 marlive ln -95.43739 29.67790
2 1/5/2010  murder   1350 greens pkwy -95.43944 29.94292
3 1/5/2010  murder 10250 bissonnet st -95.55906 29.67480
```

- `st_as_sf()` turns the longitude and latitude columns into a `geometry` column of point shapes and creates an sf object. `crs = 4326` specifies that the coordinates are in the WGS 84 longitude-latitude system (EPSG:4326).
- `mapview()` draws the sf object as an interactive Leaflet-based map in the Viewer pane.

**(2) mapview map on an OpenStreetMap basemap (lines 221-225).**

```r
# (2) Interactive map with OpenStreetMap basemap
mymap <- st_as_sf(homicide, coords = c("lon", "lat"), crs = 4326)
mapview(mymap, color = "black", col.regions = "red",
        alpha.regions = 0.5, legend = FALSE,
        homebutton = FALSE, map.types = "OpenStreetMap")
```

- `color` is the outline color of the points, `col.regions` the fill color, and `alpha.regions` the opacity of the fill.
- `legend = FALSE` and `homebutton = FALSE` remove the legend and the home button, and `map.types` sets the basemap. Kabacoff lists CartoDB.Positron, CartoDB.DarkMatter, Esri.WorldImagery, and OpenTopoMap as other basemaps.

### 4.2 Choropleth Maps

**(3) Choropleth map of life expectancy by country (lines 228-251).**

```r
# (3) Choropleth map: Life expectancy by country
# install.packages("choroplethr")
# install.packages("choroplethrMaps")
data(country.map, package = "choroplethrMaps")
data(gapminder, package = "gapminder")

plotdata <- gapminder %>%
  filter(year == 2007) %>%
  rename(region = country, value = lifeExp) %>%
  mutate(region = tolower(region)) %>%
  mutate(region =
           recode(region,
                  "united states"    = "united states of america",
                  "congo, dem. rep." = "democratic republic of the congo",
                  "congo, rep."      = "republic of congo",
                  "korea, dem. rep." = "north korea",
                  "korea, rep."      = "south korea",
                  "tanzania"         = "united republic of tanzania",
                  "serbia"           = "republic of serbia",
                  "slovak republic"  = "slovakia",
                  "yemen, rep."      = "yemen"))

library(choroplethr)
country_choropleth(plotdata)
```

- `data(country.map, package = "choroplethrMaps")` places the map data in the global environment. Kabacoff used the `region` column of these data to check how region names are spelled, and the solution code does not use this object again. As a result, running `library(choroplethr)` prints a message that choroplethr's `country.map` is masked by the object of the same name in the global environment.
- The pipeline selects the 142 countries of 2007 (`filter()`), renames `country` and `lifeExp` to `region` and `value` with `rename(new_name = old_name)`, and turns the country names into lowercase strings with `tolower()`. This is because `country_choropleth()` requires these two column names and lowercase region names.
- `recode(region, old_value = new_value, ...)` changes the 9 names that are spelled differently. Names containing commas or spaces are wrapped in quotes. Kabacoff's code changes `"korea, dem. rep."` (North Korea) to `"south korea"` and changes a nonexistent name `"korea. rep."` to `"north korea"`, and the solution corrects both mappings on lines 243-244.
- `country_choropleth()` divides the values into intervals with similar counts (7 by default), colors each country, and returns a ggplot2 object. Running it prints a message that the type of the region names was detected automatically and a list of regions not found on the map.

**(4) Choropleth map with a new color scheme (lines 254-260).**

```r
# (4) Choropleth with color palette
country_choropleth(plotdata, num_colors = 9) +
  scale_fill_brewer(palette = "YlOrRd") +
  labs(title = "Life expectancy by country",
       subtitle = "Gapminder 2007 data",
       caption = "source: https://www.gapminder.org",
       fill = "Years")
```

- `num_colors = 9` increases the intervals to 9. The return value is a ggplot2 object, so scales and labels can be added with `+`.
- `country_choropleth()` has already set a fill scale, so adding `scale_fill_brewer(palette = "YlOrRd")` prints the messages `Scale for fill is already present.` and `Adding another scale for fill, which will replace the existing scale.`, and the new scale replaces the existing one. `labs(fill = "Years")` sets the legend title.

**(5) US state map drawn from a shapefile (lines 263-282).**

```r
# (5) US State map with shapefile data
library(tidyverse)
library(sf)
library(ggplot2)

USMap <- st_read("../data/cb_2024_us_state_5m.shp")
litRates <- read.csv("../data/us_literacy_rates_by_state_2025.csv")

continentalUS <- USMap %>%
  left_join(litRates, by = c("NAME" = "State")) %>%
  filter(
    NAME != "Hawaii" &
      NAME != "Alaska" &
      NAME != "Puerto Rico" &
      !is.na(Rate)
  )

ggplot(continentalUS, aes(geometry = geometry, fill = Rate)) +
  geom_sf() +
  coord_sf()
```

- `library(tidyverse)` loads ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats, and lubridate at once and prints a list of functions with clashing names (for example, `dplyr::filter()` masks `stats::filter()`).
- `st_read()` reads the `.shp` file together with the `.shx`, `.dbf`, `.prj`, and `.cpg` files in the same folder, creates an sf object with one row per region, and summarizes what it read as follows. The path in the first two lines depends on the computer.

```text
Reading layer `cb_2024_us_state_5m' from data source 
  `.../HW02_Advanced-Visualization/data/cb_2024_us_state_5m.shp' using driver `ESRI Shapefile'
Simple feature collection with 56 features and 9 fields
Geometry type: MULTIPOLYGON
Dimension:     XY
Bounding box:  xmin: -179.1473 ymin: -14.55255 xmax: 179.7785 ymax: 71.35256
Geodetic CRS:  NAD83
```

- The 56 regions are the 50 states, Washington, D.C., and 5 territories including Puerto Rico. The bounding box spans longitudes from -179 to 179 degrees because it includes the Aleutian Islands of Alaska, which cross the date line, and the Pacific territories.
- `read.csv()` reads three columns, `stateFlagCode`, `State`, and `Rate`, and 52 rows. `left_join(litRates, by = c("NAME" = "State"))` uses `NAME` of the map and `State` of the CSV as keys and attaches `Rate` while keeping all 56 rows of the map, and `Rate` becomes `NA` for Puerto Rico and the other 4 territories, which have no match in the CSV. The left data are an sf object, so the result is also an sf object.
- `filter()` keeps the rows that satisfy all four conditions joined by `&`, that is, the 49 rows of the 48 contiguous states and Washington, D.C.
- `aes(geometry = geometry, fill = Rate)` specifies the geometry column instead of x and y, and `geom_sf()` draws the polygon of each row. `geom_sf()` already uses `coord_sf()`, so the final `coord_sf()` does not change the figure, and the axes show longitude and latitude in degrees.

---

<br>

## 5. Code for Kabacoff Chapter 8

**(1) Time series with a modified date axis (lines 290-302).**

```r
# (1) Time series with date axis formatting and smoothing
library(ggplot2)
library(scales)

ggplot(economics, aes(x = date, y = psavert)) +
  geom_line(color = "indianred3", linewidth = 1) +
  geom_smooth() +
  scale_x_date(date_breaks = "5 years", labels = date_format("%b-%y")) +
  labs(title = "Personal Savings Rate",
       subtitle = "1967 to 2015",
       x = "",
       y = "Personal Savings Rate") +
  theme_minimal()
```

- The `date` column of `economics` has the `Date` class, so the date scale `scale_x_date()` is used for the x axis. `date_breaks = "5 years"` places ticks every 5 years, and `date_format("%b-%y")` from scales shows the ticks as a month abbreviation and a two-digit year. `%b` uses the month abbreviation of the current locale, so a Korean locale shows ticks like `1월-70`.
- Without a method, `geom_smooth()` uses LOESS when the data have fewer than 1,000 rows. `economics` has 574 rows, so the message `` `geom_smooth()` using method = 'loess' and formula = 'y ~ x' `` is printed, and a confidence band is drawn around the curve.
- Kabacoff's code sets the width of `geom_line()` with `size=1`, and the solution changes it to `linewidth = 1`.

**(2) Dumbbell chart (lines 305-324).**

```r
# (2) Dumbbell chart: Life expectancy change 1952 to 2007
# install.packages("ggalt")
library(ggalt)
library(tidyr)
library(dplyr)

data(gapminder, package = "gapminder")

plotdata_long <- filter(gapminder,
                        continent == "Americas" &
                          year %in% c(1952, 2007)) %>%
  select(country, year, lifeExp)

plotdata_wide <- pivot_wider(plotdata_long,
                             names_from = year,
                             values_from = lifeExp)
names(plotdata_wide) <- c("country", "y1952", "y2007")

ggplot(plotdata_wide, aes(y = country, x = y1952, xend = y2007)) +
  geom_dumbbell()
```

- `year %in% c(1952, 2007)` is true when `year` is one of the two values. The 50 rows of 25 countries at two time points remain in long form (`plotdata_long`).
- `pivot_wider()` uses the values of `year` as new column names and `lifeExp` as their values, spreading the data into wide form with one row per country (25 rows). The new column names `1952` and `2007` start with digits and cannot be written in code without backticks, so `names()` changes them to `y1952` and `y2007`.
- `geom_dumbbell()` from ggalt draws a segment from `x` to `xend` with a point at each end. ggalt loads ggplot2 along with it. Running it prints a ggplot2 warning that `geom_segment()` inside ggalt uses `size`, but the figure is not affected.

**(3) Slope graph (lines 327-344).**

```r
# (3) Slope graph: Central American life expectancy
# install.packages("CGPfunctions")
library(CGPfunctions)
data(gapminder, package = "gapminder")

df <- gapminder %>%
  filter(year %in% c(1992, 1997, 2002, 2007) &
           country %in% c("Panama", "Costa Rica",
                          "Nicaragua", "Honduras",
                          "El Salvador", "Guatemala",
                          "Belize")) %>%
  mutate(year = factor(year),
         lifeExp = round(lifeExp))

newggslopegraph(df, year, lifeExp, country) +
  labs(title = "Life Expectancy by Country",
       subtitle = "Central America",
       caption = "source: gapminder")
```

- `filter()` selects the rows that satisfy both the four years and the 7 countries, but gapminder has no data for Belize, so 24 rows of 6 countries remain. `mutate()` turns `year` into a factor and rounds `lifeExp` to integers to keep the graph labels short.
- `newggslopegraph(data, Times, Measurement, Grouping)` takes column names without quotes, lines up the values vertically at each time point, and connects them with a line per group. Running it prints the message `Converting 'year' to an ordered factor`, and the return value is a ggplot2 object, so `+ labs()` adds the titles.
- Running it also prints ggplot2 warnings that `aes_()`, `aes_string()`, and `size` for lines, which CGPfunctions uses internally, are deprecated, but the figure is not affected.

**(4) Area chart (lines 347-352).**

```r
# (4) Area chart
ggplot(economics, aes(x = date, y = psavert)) +
  geom_area(fill = "lightblue", color = "black") +
  labs(title = "Personal Savings Rate",
       x = "Date",
       y = "Personal Savings Rate")
```

- `geom_area()` fills the area between the y values and 0. `fill` is the fill color, and `color` is the color of the outline of the area.

**(5) Stream graph (lines 355-372).**

```r
# (5) Stream graph: US population by age group
# install.packages("ggstream")
data(uspopage, package = "gcookbook")
library(ggstream)

ggplot(uspopage, aes(x = Year, y = Thousands / 1000,
                     fill = forcats::fct_rev(AgeGroup))) +
  geom_stream() +
  labs(title = "US Population by age",
       subtitle = "1900 to 2002",
       caption = "source: U.S. Census Bureau, 2003, HS-3",
       x = "Year", y = "",
       fill = "Age Group") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal() +
  theme(panel.grid.major.y = element_blank(),
        panel.grid.minor.y = element_blank(),
        axis.text.y = element_blank())
```

- `uspopage` has 824 rows for 103 years and 8 age groups, and `Thousands / 1000` converts thousands into millions.
- The levels of `AgeGroup` are in age order from `<5` to `>64`. `forcats::fct_rev()` reverses this order so that the legend reads `>64`, ..., `<5` from the top, matching the order of the layers in the graph.
- By default, `geom_stream()` from ggstream stacks the layers symmetrically above and below a center line. `scale_fill_brewer(palette = "Set2")` colors the 8 age groups with the 8-color `Set2` palette.
- The three `element_blank()` calls in `theme()` remove the horizontal grid lines and the y tick labels. This is because the positions of the layers are set relative to the center line, so the y values do not directly mean population.

---

<br>

## 6. Differences from Kabacoff's Code

| Location | Kabacoff's Code | Solution Code | Reason |
|:-----|:-----|:-----|:-----|
| Chapter 5 (3) line 45, Chapter 6 (5) line 147, Chapter 6 (7) line 167, Chapter 8 (1) line 295 | `size = 1.5`, `size=1` | `linewidth = 1.5`, `linewidth = 1` | Since ggplot2 3.4.0 the line width is set with `linewidth`, and `size` raises a warning |
| Chapter 5 (6) line 82 | `labs("Highway mileage by auto class")` | `labs(title = "City mileage by auto class")` | An unnamed argument does not become the title, and the x variable is `cty` |
| Chapter 7 (3) lines 243-244 | `"korea, dem. rep." = "south korea"`, `"korea. rep." = "north korea"` | `"korea, dem. rep." = "north korea"`, `"korea, rep." = "south korea"` | The mappings of South and North Korea were swapped, and the original name had a typo |
| Chapter 7 (5) lines 268-269 | `cb_2022_us_state_20m`, `USLitRates.csv` | `cb_2024_us_state_5m`, `us_literacy_rates_by_state_2025.csv` | The 2024 boundary file and 2025 data were downloaded separately and used |
| Chapter 7 (5) line 277 | None | `!is.na(Rate)` | Besides Puerto Rico, the 2024 5m file has 4 territories missing from the CSV, which would otherwise be drawn as grey regions and widen the map extent |
| Chapter 7 (5) line 282 | None | `coord_sf()` | It states the coordinate system that `geom_sf()` already uses, so the figure is the same |

*Table 4. Differences between Kabacoff's code and the solution code*

The other differences are only spacing and line breaks, the kind of quotes, comments, the placement of `library()` and `data()` calls, and the omission of some statements that printed data for checking (`head()`, `setdiff()`), and they do not affect the figures.

---

<br>

## Summary

| Concept | Key Summary |
|:-----|:-----|
| Script structure | Below a Doxygen-style header, 25 blocks for Kabacoff Chapters 5-8 appear in chapter order, and some blocks reuse objects and packages from earlier blocks. |
| Running environment | The working directory must be `Solution/` to read the data in `../data/`, and running with `source()` needs `echo = TRUE` for the graphs to be drawn. ggalt, CGPfunctions, and ggstream are installed from GitHub. |
| Assembling graphs | `geom_*()` layers, `scale_*()` scales, `labs()` labels, and `theme_*()` and `theme()` are added with `+` to `ggplot(data, aes(...))`. Aesthetics inside `aes()` are mapped to variables, and values outside it are fixed values. |
| Reshaping data | `filter()`, `select()`, `rename()`, `mutate()`, and `recode()` select and change rows and columns, and `pivot_wider()` spreads long data into wide form. |
| Maps | `st_as_sf()` and `st_read()` create sf objects, `mapview()` draws interactive maps, and `geom_sf()` draws static maps. A choropleth map colors a region only when the region name or key in the data matches the map. |
| Differences from the original code | The solution corrects Kabacoff's code with `linewidth` for line widths, a named `labs()` argument, the mapping of the Korean names, and the exclusion of territories with missing values. |

---

<br>

## Self-Check Questions

1. **Mapping and fixed values:** What is the difference between `geom_point(color = "cornflowerblue")` and `ggplot(..., aes(color = rank)) + geom_point()`?

   <details>
   <summary>Answer</summary>

   The first is a fixed value outside `aes()`, so all points have the same color and no legend is created. The second maps `rank` to color, so a different color is chosen automatically for each rank, and a color legend is created.

   </details>

2. **Order of themes:** In Chapter 5 (6), what happens if `theme(legend.position = "none")` is added before `theme_ridges()`?

   <details>
   <summary>Answer</summary>

   `theme_ridges()` is a complete theme that overwrites all earlier theme settings, so the legend reappears. Individual settings must be added after the complete theme.

   </details>

3. **source() and graphs:** Why does running only `source("HW_AdvancedVisualization.R")` in the console draw no graphs at all, and how can this be fixed?

   <details>
   <summary>Answer</summary>

   A ggplot object is drawn when it is printed (`print()`), but by default `source()` does not print the values of top-level expressions. Passing `source(..., echo = TRUE)` or `print.eval = TRUE` prints the value of each expression, and the graphs are drawn.

   </details>

4. **Column names in wide form:** In Chapter 8 (2), how would `aes()` have to be written if `names()` had not renamed the columns after `pivot_wider()`?

   <details>
   <summary>Answer</summary>

   The column names `1952` and `2007` start with digits, so they must be wrapped in backticks, as in `` aes(y = country, x = `1952`, xend = `2007`) ``. Writing `x = 1952` without backticks maps the numeric constant 1952, not the column.

   </details>

5. **Scale replacement message:** Why does Chapter 7 (4) print the message `Scale for fill is already present.`?

   <details>
   <summary>Answer</summary>

   The ggplot2 object returned by `country_choropleth()` already contains a fill scale, and `scale_fill_brewer()` adds another fill scale. ggplot2 uses only one scale per aesthetic, so the scale added later replaces the existing one.

   </details>
