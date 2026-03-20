# @file    Lab_Visualization.R
# @brief   Data visualization with ggplot2 and data manipulation with dplyr
#          using nycflights13 and mtcars datasets
# @author  Cheolwon Park
# @date    2025-10-28


# =============================================================================
# 0. PACKAGE SETUP
# =============================================================================

# install.packages("tidyverse")
# install.packages("nycflights13")
library(tidyverse)       # Includes ggplot2, dplyr, tidyr, etc.
library(nycflights13)    # NYC flights dataset


# =============================================================================
# 1. DATA MANIPULATION WITH dplyr
# =============================================================================

# --- 1.1 filter(): Select rows by condition ---

flights
filter(flights, month == 1, day == 1)

jan1 <- filter(flights, month == 1, day == 1)
(dec25 <- filter(flights, month == 12, day == 25))


# --- 1.2 arrange(): Sort rows ---

arrange(flights, year, month, day)
arrange(flights, desc(dep_delay))

a <- data.frame(math = c(100, 40, 70), eng = c(20, 50, 90))
a


# --- 1.3 select(): Choose columns ---

select(flights, year, month, day)
select(flights, year:day)
select(flights, -(year:day))

flights_sml <- select(flights,
  year:day,
  ends_with("delay"),
  distance,
  air_time
)


# --- 1.4 mutate(): Create new columns ---

mutate(flights_sml,
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60
)

mutate(flights_sml,
  gain = dep_delay - arr_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)


# --- 1.5 summarise() and group_by(): Aggregate data ---

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# Using mtcars dataset
nrow(mtcars)
str(mtcars)

filter(mtcars, cyl == 4)
filter(mtcars, cyl >= 6 & mpg > 20)

head(select(mtcars, am, gear))
head(arrange(mtcars, wt))
head(arrange(mtcars, mpg, desc(wt)))
head(mutate(mtcars, years = "1974"))
head(mutate(mtcars, mpg_rank = rank(mpg)))

# Summary statistics for cylinder count
summarise(mtcars, cyl_mean = mean(cyl), cyl_min = min(cyl), cyl_max = max(cyl))

# Group by cylinder and count
gr_cyl <- group_by(mtcars, cyl)
summarise(gr_cyl, n())

# Same operation using pipe operator
group_by(mtcars, cyl) %>% summarise(n())


# =============================================================================
# 2. DATA JOINING
# =============================================================================

# Check for duplicate tail numbers in planes table
planes %>%
  count(tailnum) %>%
  filter(n > 1)

# Check for duplicate weather observations
weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)

# Select subset of flights and join with airlines
flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")


# =============================================================================
# 3. BASIC ggplot2 VISUALIZATIONS
# =============================================================================

library(ggplot2)

# --- 3.1 Bar Charts ---

help(mtcars)
str(mtcars)

# Bar chart of cylinder counts (numeric x-axis includes empty categories)
ggplot(mtcars, aes(x = cyl)) + geom_bar(width = 0.5)

# Use factor() to treat cylinder as categorical
ggplot(mtcars, aes(x = factor(cyl))) + geom_bar()

# Stacked bar chart: fill by gear type
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(aes(fill = factor(gear)))


# --- 3.2 Box Plots ---

# Boxplot of daily temperatures (group by Day)
ggplot(airquality, aes(x = Day, y = Temp, group = Day)) +
  geom_boxplot()
# Note: In statistics, outliers are NOT defined using mean/std deviation


# --- 3.3 Scatter Plots with Aesthetic Mappings ---

# Color mapping by vehicle class
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Transparency mapping by vehicle class
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

# Shape mapping by vehicle class
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))


# --- 3.4 Faceting ---

# Split scatter plot into subplots by vehicle class
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)


# =============================================================================
# 4. REFERENCE LINES AND ANNOTATIONS
# =============================================================================

# --- 4.1 Time Series with Reference Lines ---

str(economics)

# Line plot with a regression line overlay
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_abline(intercept = 12.18671, slope = -0.0005444)

# Horizontal reference line at the mean personal savings rate
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_hline(yintercept = mean(economics$psavert))

# Vertical reference line at a specific date
library(dplyr)
x_inter <- filter(economics, psavert == min(economics$psavert))$date
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2005-07-01"))


# --- 4.2 Text Annotations ---

# Add temperature labels to scatter plot
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point() +
  geom_text(aes(label = Temp, vjust = 0, hjust = 0))
