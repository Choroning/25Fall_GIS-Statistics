# @file    AdvancedVisualization.R
# @brief   Advanced ggplot2 visualizations including grouped charts,
#          distribution plots, faceting, GIS maps, and time-based charts
# @author  Cheolwon Park
# @date    2025-11-11


# =============================================================================
# CHAPTER 5: DISTRIBUTION AND COMPARISON PLOTS
# =============================================================================


# (1) Grouped Bar Chart (side-by-side)
library(ggplot2)

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "dodge")


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


# (4) Grouped Kernel Density Plots
# install.packages("carData")
data(Salaries, package = "carData")
library(ggplot2)

ggplot(Salaries, aes(x = salary, fill = rank)) +
  geom_density(alpha = 0.4) +
  labs(title = "Salary distribution by rank")


# (5) Side-by-Side Box Plots
data(Salaries, package = "carData")
library(ggplot2)

ggplot(Salaries, aes(x = rank, y = salary)) +
  geom_boxplot() +
  labs(title = "Salary distribution by rank")


# (6) Ridgeline Plots
# install.packages("ggridges")
library(ggplot2)
library(ggridges)

ggplot(mpg,
       aes(x = cty, y = class, fill = class)) +
  geom_density_ridges() +
  theme_ridges() +
  labs(title = "Highway mileage by auto class") +
  theme(legend.position = "none")


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


# =============================================================================
# CHAPTER 6: GROUPING AND FACETING
# =============================================================================


# (1) Simple scatter plot
library(ggplot2)
data(Salaries, package = "carData")

ggplot(Salaries,
       aes(x = yrs.since.phd, y = salary)) +
  geom_point() +
  labs(title = "Academic salary by years since degree")


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


# (6) Salary histograms faceted by rank
ggplot(Salaries, aes(x = salary)) +
  geom_histogram() +
  facet_wrap(~rank, ncol = 1) +
  labs(title = "Salary histograms by rank")


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


# =============================================================================
# CHAPTER 7: GIS VISUALIZATION
# =============================================================================


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


# (2) Interactive map with OpenStreetMap basemap
mymap <- st_as_sf(homicide, coords = c("lon", "lat"), crs = 4326)
mapview(mymap, color = "black", col.regions = "red",
        alpha.regions = 0.5, legend = FALSE,
        homebutton = FALSE, map.types = "OpenStreetMap")


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


# (4) Choropleth with color palette
country_choropleth(plotdata, num_colors = 9) +
  scale_fill_brewer(palette = "YlOrRd") +
  labs(title = "Life expectancy by country",
       subtitle = "Gapminder 2007 data",
       caption = "source: https://www.gapminder.org",
       fill = "Years")


# (5) US State map with shapefile data
library(tidyverse)
library(sf)
library(ggplot2)

USMap <- st_read("data/cb_2024_us_state_5m.shp")
litRates <- read.csv("data/us_literacy_rates_by_state_2025.csv")

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


# =============================================================================
# CHAPTER 8: TIME-BASED VISUALIZATION
# =============================================================================


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


# (4) Area chart
ggplot(economics, aes(x = date, y = psavert)) +
  geom_area(fill = "lightblue", color = "black") +
  labs(title = "Personal Savings Rate",
       x = "Date",
       y = "Personal Savings Rate")


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
