# HW2 코드 총정리 — 고급 시각화

[레포지토리 안내](../../README.ko.md) | [English](Code-Walkthrough.md) | [한국어](Code-Walkthrough.ko.md)

> **최종 수정일:** 2026-11-27
>
> Modern Data Visualization with R, Kabacoff, Ch 5, 6, 7, 8

> **학습 목표:**
> 1. 스크립트를 실행하는 데 필요한 패키지, 작업 디렉토리, 블록 사이의 의존 관계를 설명할 수 있다
> 2. `aes()` 안의 매핑과 밖의 고정값, 레이어, 척도, 레이블, 테마로 ggplot2 그래프를 조립하는 코드를 읽을 수 있다
> 3. dplyr와 tidyr로 그래프에 맞는 모양의 자료를 만드는 코드를 설명할 수 있다
> 4. sf, mapview, choroplethr로 지도 자료를 만들고 결합하는 코드를 설명할 수 있다
> 5. Kabacoff의 원래 코드와 풀이 코드가 달라진 부분과 그 이유를 설명할 수 있다

---

## 목차

- [1. 파일 구성과 실행 방법](#1-파일-구성과-실행-방법)
  - [1.1 스크립트의 구성](#11-스크립트의-구성)
  - [1.2 필요한 패키지](#12-필요한-패키지)
  - [1.3 작업 디렉토리와 실행](#13-작업-디렉토리와-실행)
- [2. Kabacoff 5장의 코드](#2-kabacoff-5장의-코드)
  - [2.1 범주형 변수와 범주형 변수](#21-범주형-변수와-범주형-변수)
  - [2.2 양적 변수와 양적 변수](#22-양적-변수와-양적-변수)
  - [2.3 범주형 변수와 양적 변수](#23-범주형-변수와-양적-변수)
- [3. Kabacoff 6장의 코드](#3-kabacoff-6장의-코드)
  - [3.1 그룹화](#31-그룹화)
  - [3.2 패싯](#32-패싯)
- [4. Kabacoff 7장의 코드](#4-kabacoff-7장의-코드)
  - [4.1 점 밀도 지도](#41-점-밀도-지도)
  - [4.2 단계구분도](#42-단계구분도)
- [5. Kabacoff 8장의 코드](#5-kabacoff-8장의-코드)
- [6. Kabacoff의 코드와 달라진 부분](#6-kabacoff의-코드와-달라진-부분)
- [요약](#요약)
- [점검 문제](#점검-문제)

---

<br>

## 1. 파일 구성과 실행 방법

> **풀어 보기:** 이 문서는 작성한 코드 전체와 줄별 설명을 담고 있다. 먼저 [과제 안내문](Original/Assignment.ko.md)의 문제를 직접 풀어 본 뒤 읽는다.

`Solution/HW_AdvancedVisualization.R`은 372행의 R 스크립트 하나로, Kabacoff의 *Modern Data Visualization with R* 5~8장에서 고른 그림 25개의 코드를 장 순서대로 담는다. 각 블록이 재현하는 절과 그림, 실행 결과의 해석은 [HW2 과제 해설](Assignment-Explanation.ko.md)에 있고, 이 문서는 코드를 처음부터 끝까지 읽는다.

### 1.1 스크립트의 구성

```r
# @file    HW_AdvancedVisualization.R
# @brief   Advanced ggplot2 visualizations including grouped charts,
#          distribution plots, faceting, GIS maps, and time-based charts
# @author  Cheolwon Park
# @date    2025-11-11
```

1~5행은 파일 이름, 한 줄 설명, 작성자, 작성일을 적은 Doxygen 스타일 헤더이다. 그 아래에 장마다 `# ====` 줄로 감싼 구분 주석이 있고, 장 안의 블록은 `# (1) Grouped Bar Chart (side-by-side)`처럼 번호와 그림 이름을 적은 주석으로 시작한다.

| 장 구분 주석 | 행 | 블록 |
|:-----|:-----|:-----|
| `CHAPTER 5: DISTRIBUTION AND COMPARISON PLOTS` | 8\~104행 | (1)\~(7) |
| `CHAPTER 6: GROUPING AND FACETING` | 106\~195행 | (1)\~(8) |
| `CHAPTER 7: GIS VISUALIZATION` | 198\~282행 | (1)\~(5) |
| `CHAPTER 8: TIME-BASED VISUALIZATION` | 285\~372행 | (1)\~(5) |

*표 1. 스크립트의 장 구분*

블록은 대부분 자신이 쓰는 패키지와 자료를 다시 불러오므로 따로 실행할 수 있다. 다만 앞 블록이 만든 객체나 불러온 패키지를 이어 쓰는 블록이 있으므로, 위에서부터 차례로 실행하거나 블록 하나만 실행할 때는 다음을 먼저 준비한다.

| 블록 | 먼저 준비해야 하는 것 |
|:-----|:-----|
| 6장 (2)\~(7) | 6장 (1)이 불러온 ggplot2와 `Salaries` |
| 6장 (8) | ggplot2 |
| 7장 (2) | 7장 (1)이 만든 `homicide`와 불러온 sf, mapview |
| 7장 (3) | dplyr의 `%>%`, `filter()`, `rename()`, `mutate()`, `recode()` |
| 7장 (4) | 7장 (3)이 만든 `plotdata`와 불러온 choroplethr, 그리고 ggplot2 |
| 8장 (3) | dplyr의 `%>%`, `filter()`, `mutate()`와 ggplot2 |
| 8장 (4), (5) | ggplot2 |

*표 2. 앞 블록에 의존하는 블록*

### 1.2 필요한 패키지

| 패키지 | 쓰는 곳 | 설치 |
|:-----|:-----|:-----|
| ggplot2 | 모든 그래프, `mpg`와 `economics` 자료 | CRAN |
| carData, gapminder | `Salaries`, `gapminder` 자료 | CRAN |
| dplyr, tidyr | 자료의 선택, 변환, 재구성 | CRAN |
| scales | 축 레이블의 달러 형식과 날짜 형식 | CRAN |
| ggridges | 5장 (6)의 능선 그래프 | CRAN |
| ggmap | 7장 (1)의 `crime` 자료 | CRAN |
| sf, mapview | 7장의 sf 객체와 인터랙티브 지도 | CRAN |
| choroplethr, choroplethrMaps | 7장 (3), (4)의 국가별 단계구분도 | CRAN |
| tidyverse | 7장 (5)에서 ggplot2, dplyr 등을 한꺼번에 불러오기 | CRAN |
| gcookbook, forcats | 8장 (5)의 `uspopage` 자료와 팩터 수준 뒤집기 | CRAN |
| ggalt | 8장 (2)의 dumbbell chart | GitHub (`hrbrmstr/ggalt`) |
| CGPfunctions | 8장 (3)의 기울기 그래프 | GitHub (`ibecav/CGPfunctions`) |
| ggstream | 8장 (5)의 stream graph | GitHub (`davidsjoberg/ggstream`) |

*표 3. 스크립트가 쓰는 패키지*

스크립트는 블록마다 `# install.packages("...")` 주석으로 설치 명령을 남겨 두었다. 그러나 ggalt, CGPfunctions, ggstream은 CRAN에서 설치할 수 없으므로 remotes 패키지로 GitHub에서 설치한다.

```r
install.packages(c("ggplot2", "carData", "gapminder", "dplyr", "tidyr",
                   "scales", "ggridges", "ggmap", "sf", "mapview",
                   "choroplethr", "choroplethrMaps", "tidyverse",
                   "gcookbook", "forcats", "remotes"))
remotes::install_github("hrbrmstr/ggalt")
remotes::install_github("ibecav/CGPfunctions")
remotes::install_github("davidsjoberg/ggstream")
```

### 1.3 작업 디렉토리와 실행

7장 (5)는 `st_read("../data/cb_2024_us_state_5m.shp")`처럼 작업 디렉토리를 기준으로 한 상대 경로로 자료를 읽으므로, 작업 디렉토리가 `Solution/` 폴더여야 한다. RStudio에서는 스크립트를 연 뒤 Session 메뉴의 Set Working Directory, To Source File Location을 고르고, 콘솔에서는 레포지토리 루트에서 다음과 같이 실행한다.

```r
setwd("Coursework/HW02_Advanced-Visualization/Solution")
source("HW_AdvancedVisualization.R", echo = TRUE)
```

`source()`는 기본값으로 식의 값을 출력하지 않아 ggplot 객체가 그려지지 않는다. `echo = TRUE`를 주면 `print.eval`의 기본값도 `TRUE`가 되어 각 식의 값이 출력되고 그래프가 차례로 그려진다. 과제의 방식대로 블록을 하나씩 실행해 Plots 창을 확인하려면 RStudio에서 블록을 선택하고 Ctrl+Enter(macOS는 Cmd+Enter)로 실행한다. mapview 지도는 Plots 창이 아니라 Viewer 창에 열린다.

---

<br>

## 2. Kabacoff 5장의 코드

### 2.1 범주형 변수와 범주형 변수

**(1) 병렬 막대 그래프 (13\~17행).**

```r
# (1) Grouped Bar Chart (side-by-side)
library(ggplot2)

ggplot(mpg, aes(x = class, fill = drv)) +
  geom_bar(position = "dodge")
```

- `ggplot(mpg, aes(...))`는 자료와 미적 매핑을 정한다. `x = class`는 차종을 x축에, `fill = drv`는 구동 방식을 막대의 채우기 색에 매핑한다. `mpg`는 ggplot2에 들어 있는 자료이므로 따로 불러오지 않는다.
- `geom_bar()`는 y를 주지 않으면 x의 범주마다 행의 수를 세어 막대 높이로 쓴다. `fill`로 나뉜 집단은 기본값 `position = "stack"`이면 한 막대에 쌓이고, `"dodge"`이면 옆으로 나란히 놓인다.

### 2.2 양적 변수와 양적 변수

**(2) 꾸민 산점도 (20\~33행).**

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

- `data(Salaries, package = "carData")`는 패키지 전체를 불러오지 않고 자료 `Salaries`만 전역 환경에 올린다.
- `geom_point()`의 `color`, `size`, `alpha`는 `aes()` 밖에 있으므로 변수에 매핑되지 않고 모든 점에 같은 값이 적용되며, 범례도 생기지 않는다.
- `scale_y_continuous()`의 `label`은 인수 `labels`를 부분 일치로 지정한 것이다. `scales::dollar`는 숫자를 `$100,000` 형식의 문자열로 바꾸는 함수이며, `::`는 패키지를 불러오지 않고 그 패키지의 함수를 쓰는 연산자이다.
- `limits`는 축의 범위를 정하며, 범위 밖의 값은 결측값이 되어 그려지지 않는다. 이 자료는 모든 점이 범위 안에 있다. `breaks = seq(0, 60, 10)`은 x축 눈금을 0, 10, ..., 60에 둔다.
- `labs()`는 축 제목, 제목, 부제목을 지정하며, `y = ""`는 y축 제목을 비운다.

**(3) 점과 레이블을 더한 선 그래프 (36\~51행).**

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

- `filter()`는 조건이 참인 행만 남기는 dplyr의 함수로, 여기서는 미국의 12행을 고른다. 40행에서 dplyr를 불러온 뒤에 써야 같은 이름의 stats 패키지 함수가 아닌 dplyr의 함수가 불린다.
- `geom_line()`은 연한 회색의 굵은 선을, `geom_point()`는 그 위의 점을 그린다. 레이어는 더한 순서대로 그려지므로 점이 선 위에 놓인다.
- `linewidth`는 선의 굵기이다. Kabacoff의 코드는 `size = 1.5`로 썼지만, ggplot2 3.4.0부터 선의 굵기는 `linewidth`로 지정하며 `size`는 경고를 낸다.
- `labs()`의 `caption`은 그래프 오른쪽 아래에 출처를 적는다.

### 2.3 범주형 변수와 양적 변수

**(4) 그룹별 커널 밀도 그래프 (54\~61행).**

```r
# (4) Grouped Kernel Density Plots
# install.packages("carData")
data(Salaries, package = "carData")
library(ggplot2)

ggplot(Salaries, aes(x = salary, fill = rank)) +
  geom_density(alpha = 0.4) +
  labs(title = "Salary distribution by rank")
```

- `geom_density()`는 커널 밀도 추정으로 분포를 곡선 아래 넓이가 1인 매끄러운 곡선으로 그린다. `fill = rank`가 직급마다 곡선을 하나씩 나누고 색을 다르게 칠한다.
- `alpha = 0.4`는 채우기의 불투명도로, 0이면 완전히 투명하고 1이면 불투명하다. 곡선이 겹친 부분이 보이도록 낮은 값을 썼다.

**(5) 병렬 상자 그림 (64\~70행).**

```r
# (5) Side-by-Side Box Plots
data(Salaries, package = "carData")
library(ggplot2)

ggplot(Salaries, aes(x = rank, y = salary)) +
  geom_boxplot() +
  labs(title = "Salary distribution by rank")
```

- x가 범주형(`rank`)이고 y가 양적(`salary`)이면 `geom_boxplot()`은 범주마다 상자 그림을 그린다. 상자는 1사분위수부터 3사분위수까지, 가운데 선은 중앙값이며, 수염은 상자에서 사분위수 범위의 1.5배 안에 있는 가장 먼 값까지 뻗고 그 밖의 값은 이상점으로 따로 찍힌다.

**(6) 능선 그래프 (73\~83행).**

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

- ggridges의 `geom_density_ridges()`는 y의 범주마다 x의 밀도 곡선을 그리고 범주 사이에 조금씩 겹쳐 쌓는다. 실행하면 모든 곡선에 공통으로 쓴 대역폭을 알리는 `Picking joint bandwidth of 0.929` 메시지가 출력된다.
- `theme_ridges()`는 ggridges가 제공하는 완전한 테마이고, `theme(legend.position = "none")`은 범례를 지운다. 완전한 테마는 앞의 테마 설정을 모두 덮어쓰므로, 범례 설정은 테마 함수보다 뒤에 더해야 한다.
- 82행의 `labs(title = ...)`는 Kabacoff의 `labs("Highway mileage by auto class")`를 고친 것이다. `labs()`는 인수 이름(`title`, `x` 등)으로 어느 레이블인지 정하므로 이름 없는 문자열은 제목이 되지 않으며, ggplot2 4.0.1에서는 오류가 난다. x축이 도시 주행 연비 `cty`이므로 제목의 Highway도 City로 바꾸었다.

**(7) jittered strip plot (86\~103행).**

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

- `factor(rank, labels = c(...))`는 직급의 세 수준 `AsstProf`, `AssocProf`, `Prof`에 차례로 새 이름을 붙인다. `\n`은 줄바꿈 문자여서 y축의 긴 이름이 두 줄로 표시된다.
- 직급을 y축에, 급여를 x축에 두었으므로 가로 방향의 strip plot이 된다.
- `geom_jitter()`는 점마다 작은 무작위 이동을 더해 같은 범주의 점이 한 줄로 겹치지 않게 한다. 기본 이동 폭은 각 축 자료 해상도의 40%이므로, 해상도가 1달러인 급여 방향으로는 거의 움직이지 않고 범주 방향으로 퍼진다.
- 89행에서 scales를 불러왔으므로 `scale_x_continuous(label = dollar)`는 `scales::` 없이 `dollar`를 쓴다. `theme_minimal()`은 회색 배경과 테두리를 없앤 테마이다.

---

<br>

## 3. Kabacoff 6장의 코드

### 3.1 그룹화

**(1) 단순 산점도 (111\~118행).**

```r
# (1) Simple scatter plot
library(ggplot2)
data(Salaries, package = "carData")

ggplot(Salaries,
       aes(x = yrs.since.phd, y = salary)) +
  geom_point() +
  labs(title = "Academic salary by years since degree")
```

이 블록에서 불러온 ggplot2와 `Salaries`를 (2)부터 (7)까지가 이어 쓴다.

**(2) 색상 매핑 (121\~124행), (3) 색상과 모양 매핑 (127\~131행), (4) 색상과 크기 매핑 (134\~139행).**

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

- 세 블록은 `aes()`에 미적 요소를 하나씩 더한다. `aes()` 안에 넣은 요소는 변수에 매핑되어 척도와 범례가 자동으로 생기고, (3)의 `size = 3`처럼 `aes()` 밖에 둔 값은 모든 점에 같이 적용된다.
- 범주형 변수 `rank`를 `color`에 매핑하면 이산 색 척도가, 범주형 변수 `sex`를 `shape`에 매핑하면 모양 척도가 쓰인다. 양적 변수 `yrs.service`를 `size`에 매핑하면 값의 크기에 따라 점의 넓이가 커지는 연속 척도가 쓰인다.
- (4)의 `paste0()`는 문자열을 공백 없이 잇는 함수로, 긴 제목을 코드 두 줄에 나누어 쓰려고 썼다.

**(5) 성별 2차 적합선 (142\~154행).**

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

- `color = sex`가 `ggplot()`의 `aes()`에 있으므로 이 매핑은 모든 레이어에 적용되어, 점과 적합선이 모두 성별로 나뉜다.
- `geom_smooth(method = "lm", formula = y ~ poly(x, 2))`는 집단마다 x의 2차 다항식으로 회귀 곡선을 적합한다. `se = FALSE`는 신뢰 구간의 띠를 그리지 않고, `linewidth = 1.5`는 곡선을 굵게 그린다.
- `labs(color = "Sex")`는 색 범례의 제목을, `scale_color_brewer(palette = "Set1")`은 ColorBrewer의 `Set1` 팔레트를 정한다.

### 3.2 패싯

**(6) 직급별 히스토그램 (157\~161행).**

```r
# (6) Salary histograms faceted by rank
ggplot(Salaries, aes(x = salary)) +
  geom_histogram() +
  facet_wrap(~rank, ncol = 1) +
  labs(title = "Salary histograms by rank")
```

- `facet_wrap(~rank, ncol = 1)`은 `rank`의 수준마다 패널을 하나씩 만들어 한 열로 늘어놓는다. 패널은 기본값으로 x축과 y축을 공유한다.
- `geom_histogram()`은 `bins`나 `binwidth`를 주지 않으면 30개 구간을 쓰고, `` `stat_bin()` using `bins = 30`. Pick better value `binwidth`. `` 메시지를 출력한다.

**(7) 학과 유형별 패싯 산점도 (164\~179행).**

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

- `facet_wrap()`의 공식 안에 식을 쓸 수 있으므로, `factor(discipline, labels = ...)`로 수준 A와 B의 이름을 바꾸면서 바로 패널을 나눈다. 패널 제목에는 바뀐 이름이 쓰인다.
- `geom_smooth(method = "lm")`은 `formula`를 주지 않아 직선 `y ~ x`를 적합하고, `` `geom_smooth()` using formula = 'y ~ x' `` 메시지를 출력한다.
- 여기서는 `labels = scales::dollar`처럼 인수 이름을 끝까지 썼으며, 결과는 (5)의 `label`과 같다.

**(8) 아메리카 국가별 기대수명 (182\~195행).**

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

- `dplyr::filter()`는 dplyr를 불러왔는지와 상관없이 dplyr의 함수를 쓴다. 아메리카 25개국의 12개 시점, 300행이 남는다.
- `facet_wrap(~country)`는 열 수를 주지 않으면 패널 수에 맞추어 격자를 정하므로 25개 패널이 5행 5열로 놓인다.
- `theme_minimal(base_size = 9)`는 기본 글자 크기를 9포인트로 줄인다. `element_text(angle = 45, hjust = 1)`은 x축 눈금 글자를 45도 기울이고 오른쪽 끝을 눈금에 맞춘다.

---

<br>

## 4. Kabacoff 7장의 코드

### 4.1 점 밀도 지도

**(1) mapview 인터랙티브 지도 (203\~218행).**

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

- ggmap을 불러오면 Google, Stadia Maps, OpenStreetMap의 이용 약관 안내가, sf를 불러오면 GEOS, GDAL, PROJ 라이브러리의 버전이 출력된다. 이 블록은 ggmap의 지도 기능이 아니라 자료 `crime`만 쓴다.
- `%>%`는 왼쪽의 결과를 오른쪽 함수의 첫째 인수로 넘기는 파이프 연산자이다. `filter()`가 살인 157건을 고르고 `select()`가 다섯 열만 남긴다. `head(homicide, 3)`은 앞의 세 행을 출력한다.

```text
      date offense            address       lon      lat
1 1/1/2010  murder    9650 marlive ln -95.43739 29.67790
2 1/5/2010  murder   1350 greens pkwy -95.43944 29.94292
3 1/5/2010  murder 10250 bissonnet st -95.55906 29.67480
```

- `st_as_sf()`는 경도와 위도 열을 점 도형을 담은 `geometry` 열로 바꾸어 sf 객체를 만든다. `crs = 4326`은 좌표가 WGS 84 경위도 좌표계(EPSG:4326)임을 지정한다.
- `mapview()`는 sf 객체를 Leaflet 기반의 인터랙티브 지도로 그려 Viewer 창에 띄운다.

**(2) OpenStreetMap 배경의 mapview 지도 (221\~225행).**

```r
# (2) Interactive map with OpenStreetMap basemap
mymap <- st_as_sf(homicide, coords = c("lon", "lat"), crs = 4326)
mapview(mymap, color = "black", col.regions = "red",
        alpha.regions = 0.5, legend = FALSE,
        homebutton = FALSE, map.types = "OpenStreetMap")
```

- `color`는 점의 테두리 색, `col.regions`는 채우기 색, `alpha.regions`는 채우기의 불투명도이다.
- `legend = FALSE`와 `homebutton = FALSE`는 범례와 홈 단추를 지우고, `map.types`는 배경 지도를 정한다. Kabacoff는 그 밖의 배경 지도로 CartoDB.Positron, CartoDB.DarkMatter, Esri.WorldImagery, OpenTopoMap을 든다.

### 4.2 단계구분도

**(3) 국가별 기대수명 단계구분도 (228\~251행).**

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

- `data(country.map, package = "choroplethrMaps")`는 지도 자료를 전역 환경에 올린다. Kabacoff는 이 자료의 `region` 열로 지역 이름의 표기를 확인했으며, 풀이 코드는 이 객체를 다시 쓰지 않는다. 그래서 `library(choroplethr)`를 실행하면 choroplethr의 `country.map`이 전역 환경의 같은 이름 객체에 가려진다는 메시지가 출력된다.
- 파이프라인은 2007년의 142개국을 고르고(`filter()`), `rename(새 이름 = 원래 이름)`으로 `country`와 `lifeExp`를 `region`과 `value`로 바꾸며, `tolower()`로 국가 이름을 소문자 문자열로 바꾼다. `country_choropleth()`가 이 두 열 이름과 소문자 지역 이름을 요구하기 때문이다.
- `recode(region, 원래 값 = 새 값, ...)`는 표기가 다른 9개 이름을 바꾼다. 쉼표나 공백이 든 이름은 따옴표로 감싼다. Kabacoff의 코드는 `"korea, dem. rep."`(북한)를 `"south korea"`로 바꾸고 `"korea. rep."`라는 없는 이름을 `"north korea"`로 바꾸었는데, 풀이는 243\~244행에서 두 대응을 바로잡았다.
- `country_choropleth()`는 값을 개수가 비슷한 구간으로 나누어(기본값 7개) 국가마다 색을 칠하고 ggplot2 객체를 돌려준다. 실행하면 지역 이름의 유형을 자동으로 판별했다는 메시지와 지도에서 찾지 못한 지역의 목록이 출력된다.

**(4) 색 구성을 바꾼 단계구분도 (254\~260행).**

```r
# (4) Choropleth with color palette
country_choropleth(plotdata, num_colors = 9) +
  scale_fill_brewer(palette = "YlOrRd") +
  labs(title = "Life expectancy by country",
       subtitle = "Gapminder 2007 data",
       caption = "source: https://www.gapminder.org",
       fill = "Years")
```

- `num_colors = 9`는 구간을 9개로 늘린다. 반환값이 ggplot2 객체이므로 `+`로 척도와 레이블을 더할 수 있다.
- `country_choropleth()`가 이미 채우기 척도를 정해 두었으므로, `scale_fill_brewer(palette = "YlOrRd")`를 더하면 `Scale for fill is already present.`와 `Adding another scale for fill, which will replace the existing scale.` 메시지가 출력되고 새 척도가 기존 척도를 대신한다. `labs(fill = "Years")`는 범례 제목을 정한다.

**(5) 셰이프파일로 그린 미국 주별 지도 (263\~282행).**

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

- `library(tidyverse)`는 ggplot2, dplyr, tidyr, readr, purrr, tibble, stringr, forcats, lubridate를 한꺼번에 불러오고, 이름이 겹치는 함수의 목록(예: `dplyr::filter()`가 `stats::filter()`를 가림)을 출력한다.
- `st_read()`는 `.shp`와 같은 폴더의 `.shx`, `.dbf`, `.prj`, `.cpg`를 함께 읽어 지역마다 한 행인 sf 객체를 만들고, 읽은 내용을 다음과 같이 요약한다. 첫 두 줄의 경로는 실행한 컴퓨터에 따라 다르다.

```text
Reading layer `cb_2024_us_state_5m' from data source 
  `.../HW02_Advanced-Visualization/data/cb_2024_us_state_5m.shp' using driver `ESRI Shapefile'
Simple feature collection with 56 features and 9 fields
Geometry type: MULTIPOLYGON
Dimension:     XY
Bounding box:  xmin: -179.1473 ymin: -14.55255 xmax: 179.7785 ymax: 71.35256
Geodetic CRS:  NAD83
```

- 56개 지역은 50개 주, 워싱턴 D.C., 푸에르토리코를 비롯한 자치령 5곳이다. 경계 상자가 경도 -179도에서 179도에 걸치는 것은 날짜 변경선을 넘는 알래스카의 알류샨 열도와 태평양의 자치령이 들어 있기 때문이다.
- `read.csv()`는 `stateFlagCode`, `State`, `Rate`의 세 열과 52행을 읽는다. `left_join(litRates, by = c("NAME" = "State"))`는 지도의 `NAME`과 CSV의 `State`를 키로 삼아 지도의 56행을 모두 유지한 채 `Rate`를 붙이며, CSV에 짝이 없는 푸에르토리코와 나머지 자치령 4곳의 `Rate`는 `NA`가 된다. 왼쪽 자료가 sf 객체이므로 결과도 sf 객체이다.
- `filter()`는 `&`로 묶은 네 조건을 모두 만족하는 행, 곧 본토 48개 주와 워싱턴 D.C.의 49행을 남긴다.
- `aes(geometry = geometry, fill = Rate)`는 x와 y 대신 도형 열을 지정하고, `geom_sf()`가 각 행의 다각형을 그린다. `geom_sf()`가 이미 `coord_sf()`를 쓰므로 마지막 `coord_sf()`는 그림을 바꾸지 않으며, 축에는 경위도가 도 단위로 표시된다.

---

<br>

## 5. Kabacoff 8장의 코드

**(1) 날짜 축을 바꾼 시계열 (290\~302행).**

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

- `economics`의 `date` 열은 `Date` 클래스이므로 x축에 날짜 척도 `scale_x_date()`를 쓴다. `date_breaks = "5 years"`는 눈금을 5년 간격으로 두고, scales의 `date_format("%b-%y")`는 눈금을 월 약칭과 두 자리 연도로 표시한다. `%b`는 현재 로캘의 월 약칭을 쓰므로 한국어 로캘에서는 `1월-70`처럼 표시된다.
- `geom_smooth()`는 방법을 주지 않으면 자료가 1,000행 미만일 때 LOESS를 쓴다. `economics`는 574행이므로 `` `geom_smooth()` using method = 'loess' and formula = 'y ~ x' `` 메시지가 출력되고, 곡선 주위에 신뢰 구간의 띠가 함께 그려진다.
- Kabacoff의 코드는 `geom_line()`의 굵기를 `size=1`로 썼으며, 풀이는 `linewidth = 1`로 고쳤다.

**(2) dumbbell chart (305\~324행).**

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

- `year %in% c(1952, 2007)`은 `year`가 두 값 중 하나이면 참이다. 25개국의 두 시점, 50행이 긴 형태(`plotdata_long`)로 남는다.
- `pivot_wider()`는 `year`의 값을 새 열 이름으로, `lifeExp`를 그 열의 값으로 삼아 나라마다 한 행인 넓은 형태(25행)로 펼친다. 새 열 이름 `1952`, `2007`은 숫자로 시작해 코드에서 백틱 없이 쓸 수 없으므로 `names()`로 `y1952`, `y2007`로 바꾼다.
- ggalt의 `geom_dumbbell()`은 `x`에서 `xend`까지 선분을 긋고 양 끝에 점을 찍는다. ggalt는 ggplot2를 함께 불러온다. 실행하면 ggalt 내부의 `geom_segment()`가 `size`를 쓴다는 ggplot2의 경고가 출력되지만 그림에는 영향이 없다.

**(3) 기울기 그래프 (327\~344행).**

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

- `filter()`는 네 해와 7개국을 함께 만족하는 행을 고르지만, gapminder에 벨리즈가 없어 6개국의 24행이 남는다. `mutate()`는 `year`를 팩터로, `lifeExp`를 정수로 반올림해 그래프의 레이블을 짧게 만든다.
- `newggslopegraph(자료, 시점, 측정값, 집단)`은 열 이름을 따옴표 없이 받아, 시점마다 값을 세로로 늘어놓고 집단마다 선을 잇는다. 실행하면 `Converting 'year' to an ordered factor` 메시지가 출력되고, 반환값이 ggplot2 객체이므로 `+ labs()`로 제목을 더할 수 있다.
- 실행하면 CGPfunctions 내부에서 쓰는 `aes_()`, `aes_string()`과 선의 `size`가 폐지 예정이라는 ggplot2의 경고가 출력되지만 그림에는 영향이 없다.

**(4) 영역 차트 (347\~352행).**

```r
# (4) Area chart
ggplot(economics, aes(x = date, y = psavert)) +
  geom_area(fill = "lightblue", color = "black") +
  labs(title = "Personal Savings Rate",
       x = "Date",
       y = "Personal Savings Rate")
```

- `geom_area()`는 y값과 0 사이를 채운다. `fill`은 채우기 색, `color`는 영역의 윤곽선 색이다.

**(5) stream graph (355\~372행).**

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

- `uspopage`는 103개 연도와 8개 연령대의 824행이며, `Thousands / 1000`은 천 명 단위를 백만 명 단위로 바꾼다.
- `AgeGroup`의 수준은 `<5`부터 `>64`까지 나이 순서이다. `forcats::fct_rev()`가 이 순서를 뒤집어, 범례가 위에서부터 `>64`, ..., `<5`로 그래프의 층 순서와 같아진다.
- ggstream의 `geom_stream()`은 기본값으로 층을 가운데 선의 위아래로 대칭이 되게 쌓는다. `scale_fill_brewer(palette = "Set2")`는 8가지 색의 `Set2` 팔레트로 8개 연령대를 칠한다.
- `theme()`의 세 `element_blank()`는 가로 격자선과 y축 눈금 글자를 지운다. 층의 위치가 가운데 선을 기준으로 정해지므로 y축의 값이 인구를 직접 뜻하지 않기 때문이다.

---

<br>

## 6. Kabacoff의 코드와 달라진 부분

| 위치 | Kabacoff의 코드 | 풀이의 코드 | 이유 |
|:-----|:-----|:-----|:-----|
| 5장 (3) 45행, 6장 (5) 147행, 6장 (7) 167행, 8장 (1) 295행 | `size = 1.5`, `size=1` | `linewidth = 1.5`, `linewidth = 1` | ggplot2 3.4.0부터 선의 굵기는 `linewidth`로 지정하며 `size`는 경고를 낸다 |
| 5장 (6) 82행 | `labs("Highway mileage by auto class")` | `labs(title = "City mileage by auto class")` | 이름 없는 인수는 제목이 되지 않고, x축 변수가 `cty`이다 |
| 7장 (3) 243\~244행 | `"korea, dem. rep." = "south korea"`, `"korea. rep." = "north korea"` | `"korea, dem. rep." = "north korea"`, `"korea, rep." = "south korea"` | 남한과 북한의 대응이 뒤바뀌고 원래 이름에 오타가 있었다 |
| 7장 (5) 268\~269행 | `cb_2022_us_state_20m`, `USLitRates.csv` | `cb_2024_us_state_5m`, `us_literacy_rates_by_state_2025.csv` | 2024년 경계 파일과 2025년 자료를 따로 받아 썼다 |
| 7장 (5) 277행 | 없음 | `!is.na(Rate)` | 2024년 5m 파일에는 푸에르토리코 밖에도 CSV에 없는 자치령 4곳이 있어, 빼지 않으면 회색 지역으로 그려지고 지도 범위가 넓어진다 |
| 7장 (5) 282행 | 없음 | `coord_sf()` | `geom_sf()`가 이미 쓰는 좌표계를 명시한 것으로, 그림은 같다 |

*표 4. Kabacoff의 코드와 풀이 코드의 차이*

이 밖의 차이는 공백과 줄바꿈, 따옴표의 종류, 주석, `library()`와 `data()` 호출의 위치, 자료를 확인하던 일부 출력문(`head()`, `setdiff()`)의 생략뿐이며 그림에는 영향이 없다.

---

<br>

## 요약

| 개념 | 핵심 요약 |
|:-----|:-----|
| 스크립트 구성 | Doxygen 스타일 헤더 아래에 Kabacoff 5\~8장의 블록 25개가 장 순서로 있으며, 일부 블록은 앞 블록의 객체와 패키지를 이어 쓴다. |
| 실행 환경 | 작업 디렉토리를 `Solution/`으로 두어야 `../data/`의 자료를 읽으며, `source()`로 실행할 때는 `echo = TRUE`를 주어야 그래프가 그려진다. ggalt, CGPfunctions, ggstream은 GitHub에서 설치한다. |
| 그래프 조립 | `ggplot(자료, aes(...))`에 `geom_*()` 레이어, `scale_*()` 척도, `labs()` 레이블, `theme_*()`와 `theme()`을 `+`로 더한다. `aes()` 안의 요소는 변수에 매핑되고 밖의 값은 고정값이다. |
| 자료 가공 | `filter()`, `select()`, `rename()`, `mutate()`, `recode()`로 행과 열을 고르고 바꾸며, `pivot_wider()`로 긴 형태를 넓은 형태로 펼친다. |
| 지도 | `st_as_sf()`와 `st_read()`로 sf 객체를 만들고, `mapview()`는 인터랙티브 지도, `geom_sf()`는 정적 지도를 그린다. 단계구분도는 자료의 지역 이름이나 키가 지도와 맞아야 칠해진다. |
| 원래 코드와의 차이 | 풀이는 선 굵기의 `linewidth`, 이름 있는 `labs()` 인수, 남북한 이름의 대응, 결측 자치령의 제외로 Kabacoff의 코드를 고쳤다. |

---

<br>

## 점검 문제

1. **매핑과 고정값:** `geom_point(color = "cornflowerblue")`와 `ggplot(..., aes(color = rank)) + geom_point()`는 무엇이 다른가?

   <details>
   <summary>정답</summary>

   앞의 것은 `aes()` 밖의 고정값이어서 모든 점이 같은 색이고 범례가 생기지 않는다. 뒤의 것은 `rank`를 색에 매핑하므로 직급마다 다른 색이 자동으로 정해지고 색 범례가 생긴다.

   </details>

2. **테마의 순서:** 5장 (6)에서 `theme(legend.position = "none")`을 `theme_ridges()`보다 앞에 더하면 결과는 어떻게 되는가?

   <details>
   <summary>정답</summary>

   `theme_ridges()`는 완전한 테마여서 앞에서 정한 테마 설정을 모두 덮어쓰므로 범례가 다시 나타난다. 개별 설정은 완전한 테마 뒤에 더해야 한다.

   </details>

3. **source()와 그래프:** 콘솔에서 `source("HW_AdvancedVisualization.R")`만 실행하면 그래프가 하나도 그려지지 않는 이유는 무엇이며, 어떻게 고치는가?

   <details>
   <summary>정답</summary>

   ggplot 객체는 출력(`print()`)될 때 그려지는데, `source()`는 기본값으로 최상위 식의 값을 출력하지 않는다. `source(..., echo = TRUE)`나 `print.eval = TRUE`를 주면 각 식의 값이 출력되어 그래프가 그려진다.

   </details>

4. **넓은 형태의 열 이름:** 8장 (2)에서 `pivot_wider()` 뒤에 `names()`로 열 이름을 바꾸지 않았다면 `aes()`를 어떻게 써야 하는가?

   <details>
   <summary>정답</summary>

   열 이름이 숫자로 시작하는 `1952`, `2007`이므로 `` aes(y = country, x = `1952`, xend = `2007`) ``처럼 백틱으로 감싸야 한다. 백틱 없이 `x = 1952`라고 쓰면 열이 아닌 숫자 상수 1952가 매핑된다.

   </details>

5. **척도 교체 메시지:** 7장 (4)에서 `Scale for fill is already present.` 메시지가 나오는 이유는 무엇인가?

   <details>
   <summary>정답</summary>

   `country_choropleth()`가 돌려주는 ggplot2 객체에 이미 채우기 척도가 들어 있는데 `scale_fill_brewer()`로 채우기 척도를 하나 더 더했기 때문이다. ggplot2는 같은 미적 요소의 척도를 하나만 쓰므로 나중에 더한 척도가 기존 척도를 대신한다.

   </details>
