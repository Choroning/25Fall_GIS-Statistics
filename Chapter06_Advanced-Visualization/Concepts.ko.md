# Chapter 06 — 고급 시각화

> **최종 수정일:** 2026-03-21

---

## 목차

1. [그룹화된 막대 그래프](#1-그룹화된-막대-그래프)
2. [고급 미학 요소를 활용한 산점도](#2-고급-미학-요소를-활용한-산점도)
3. [선 그래프](#3-선-그래프)
4. [분포 그래프](#4-분포-그래프)
5. [그룹화 및 다변량 시각화](#5-그룹화-및-다변량-시각화)
6. [패싯을 활용한 다중 패널 그래프](#6-패싯을-활용한-다중-패널-그래프)
7. [GIS 시각화](#7-gis-시각화)
8. [시간 기반 시각화](#8-시간-기반-시각화)
9. [요약](#요약)

---

## 1. 그룹화된 막대 그래프

### 1.1 병렬 막대 그래프

`position = "dodge"`를 사용하면 막대를 쌓지 않고 나란히 배치할 수 있다:

```r
library(ggplot2)

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "dodge")
```

이 그래프는 각 차량 유형 내에서 구동 방식(전륜, 후륜, 4WD)의 분포를 보여준다.

---

## 2. 고급 미학 요소를 활용한 산점도

### 2.1 커스터마이징된 산점도

```r
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

### 2.2 주요 미학 매개변수

| 매개변수 | 설명 | 예시 |
|----------|------|------|
| `color` | 점/선 색상 | `"cornflowerblue"` |
| `size` | 점 크기 | `2` (기본값: 1.5) |
| `alpha` | 투명도 (0-1) | `0.8` |
| `shape` | 점 모양 | `16` (채워진 원) |

---

## 3. 선 그래프

### 3.1 시계열 선 그래프

```r
data(gapminder, package = "gapminder")
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

> **핵심 포인트:** `geom_line()`과 `geom_point()`를 결합하면 추세와 개별 데이터 포인트를 모두 보여주는 효과적인 시각화를 만들 수 있다.

---

## 4. 분포 그래프

### 4.1 그룹별 커널 밀도 그래프

```r
data(Salaries, package = "carData")

ggplot(Salaries, aes(x = salary, fill = rank)) +
  geom_density(alpha = 0.4) +
  labs(title = "Salary distribution by rank")
```

### 4.2 병렬 상자 그림

```r
ggplot(Salaries, aes(x = rank, y = salary)) +
  geom_boxplot() +
  labs(title = "Salary distribution by rank")
```

### 4.3 능선 그래프(Ridgeline Plot)

```r
library(ggridges)

ggplot(mpg, aes(x = cty, y = class, fill = class)) +
  geom_density_ridges() +
  theme_ridges() +
  labs(title = "Highway mileage by auto class") +
  theme(legend.position = "none")
```

### 4.4 스트립 그래프(지터링)

```r
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

---

## 5. 그룹화 및 다변량 시각화

### 5.1 그룹별 색상 매핑

```r
ggplot(Salaries, aes(x = yrs.since.phd, y = salary, color = rank)) +
  geom_point() +
  labs(title = "Academic salary by rank and years since degree")
```

### 5.2 색상 + 모양 매핑

```r
ggplot(Salaries, aes(x = yrs.since.phd, y = salary,
                     color = rank, shape = sex)) +
  geom_point(size = 3, alpha = 0.6) +
  labs(title = "Academic salary by rank, sex, and years since degree")
```

### 5.3 색상 + 크기 매핑

```r
ggplot(Salaries, aes(x = yrs.since.phd, y = salary,
                     color = rank, size = yrs.service)) +
  geom_point(alpha = 0.6) +
  labs(title = "Academic salary by rank, years of service, and years since degree")
```

### 5.4 적합선이 포함된 산점도

```r
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

---

## 6. 패싯을 활용한 다중 패널 그래프

### 6.1 그룹별 히스토그램

```r
ggplot(Salaries, aes(x = salary)) +
  geom_histogram() +
  facet_wrap(~rank, ncol = 1) +
  labs(title = "Salary histograms by rank")
```

### 6.2 적합선이 포함된 패싯 산점도

```r
ggplot(Salaries, aes(x = yrs.since.phd, y = salary, color = sex)) +
  geom_point(size = 2, alpha = 0.5) +
  geom_smooth(method = "lm", se = FALSE, linewidth = 1.5) +
  facet_wrap(~factor(discipline,
                     labels = c("Theoretical", "Applied")),
             ncol = 1) +
  scale_y_continuous(labels = scales::dollar) +
  theme_minimal() +
  scale_color_brewer(palette = "Set1") +
  labs(title = "Relationship of salary and years since degree by sex and discipline",
       subtitle = "9-month salary for 2008-2009",
       color = "Gender",
       x = "Years since Ph.D.",
       y = "Academic Salary")
```

### 6.3 다국가 기대수명

```r
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

---

## 7. GIS 시각화

### 7.1 mapview를 활용한 인터랙티브 지도

```r
library(ggmap)
library(dplyr)
library(mapview)
library(sf)

homicide <- filter(crime, offense == "murder") %>%
  select(date, offense, address, lon, lat)

mymap <- st_as_sf(homicide, coords = c("lon", "lat"), crs = 4326)
mapview(mymap)
```

### 7.2 국가별 단계구분도(Choropleth Map)

```r
library(choroplethr)
data(gapminder, package = "gapminder")

plotdata <- gapminder %>%
  filter(year == 2007) %>%
  rename(region = country, value = lifeExp) %>%
  mutate(region = tolower(region))

country_choropleth(plotdata, num_colors = 9) +
  scale_fill_brewer(palette = "YlOrRd") +
  labs(title = "Life expectancy by country",
       subtitle = "Gapminder 2007 data",
       fill = "Years")
```

### 7.3 Shapefile을 활용한 미국 주별 단계구분도

```r
library(tidyverse)
library(sf)

USMap <- st_read("data/cb_2024_us_state_5m.shp")
litRates <- read.csv("data/us_literacy_rates_by_state_2025.csv")

continentalUS <- USMap %>%
  left_join(litRates, by = c("NAME" = "State")) %>%
  filter(NAME != "Hawaii" & NAME != "Alaska" &
         NAME != "Puerto Rico" & !is.na(Rate))

ggplot(continentalUS, aes(geometry = geometry, fill = Rate)) +
  geom_sf() +
  coord_sf()
```

---

## 8. 시간 기반 시각화

### 8.1 평활화를 적용한 시계열

```r
library(scales)

ggplot(economics, aes(x = date, y = psavert)) +
  geom_line(color = "indianred3", linewidth = 1) +
  geom_smooth() +
  scale_x_date(date_breaks = "5 years", labels = date_format("%b-%y")) +
  labs(title = "Personal Savings Rate",
       subtitle = "1967 to 2015",
       x = "", y = "Personal Savings Rate") +
  theme_minimal()
```

### 8.2 덤벨 차트

```r
library(ggalt)
library(tidyr)

plotdata_long <- filter(gapminder,
  continent == "Americas" & year %in% c(1952, 2007)) %>%
  select(country, year, lifeExp)

plotdata_wide <- pivot_wider(plotdata_long,
  names_from = year, values_from = lifeExp)
names(plotdata_wide) <- c("country", "y1952", "y2007")

ggplot(plotdata_wide, aes(y = country, x = y1952, xend = y2007)) +
  geom_dumbbell()
```

### 8.3 기울기 그래프(Slope Graph)

```r
library(CGPfunctions)

df <- gapminder %>%
  filter(year %in% c(1992, 1997, 2002, 2007) &
         country %in% c("Panama", "Costa Rica", "Nicaragua",
                         "Honduras", "El Salvador", "Guatemala", "Belize")) %>%
  mutate(year = factor(year), lifeExp = round(lifeExp))

newggslopegraph(df, year, lifeExp, country) +
  labs(title = "Life Expectancy by Country",
       subtitle = "Central America",
       caption = "source: gapminder")
```

### 8.4 영역 차트 및 스트림 그래프

```r
# 영역 차트
ggplot(economics, aes(x = date, y = psavert)) +
  geom_area(fill = "lightblue", color = "black") +
  labs(title = "Personal Savings Rate", x = "Date", y = "Personal Savings Rate")

# 스트림 그래프
library(ggstream)
data(uspopage, package = "gcookbook")

ggplot(uspopage, aes(x = Year, y = Thousands/1000,
                     fill = forcats::fct_rev(AgeGroup))) +
  geom_stream() +
  labs(title = "US Population by age", subtitle = "1900 to 2002",
       x = "Year", y = "", fill = "Age Group") +
  scale_fill_brewer(palette = "Set2") +
  theme_minimal()
```

---

## 요약

| 개념 | 핵심 포인트 |
|------|-------------|
| 그룹화된 막대 그래프 | `position = "dodge"`로 병렬 막대 생성 |
| 다변량 미학 요소 | 변수를 color, shape, size, alpha에 동시 매핑 가능 |
| 패싯(Faceting) | `facet_wrap()`으로 범주형 변수에 따른 하위 그래프 생성 |
| 분포 그래프 | 밀도, 상자 그림, 능선, 스트립/지터 그래프 |
| `geom_smooth()` | 적합선 추가 (선형, 다항, LOESS) |
| GIS 지도 | `sf` + `mapview`로 인터랙티브 지도; `geom_sf()`로 정적 지도 |
| 단계구분도(Choropleth) | 데이터 변수에 따라 지리적 영역을 색으로 채움 |
| 시간 시각화 | 덤벨, 기울기 그래프, 영역 차트, 스트림 그래프 |
| `theme_minimal()` | 출판 품질의 깔끔하고 간결한 테마 |
