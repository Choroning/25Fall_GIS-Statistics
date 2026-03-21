# Chapter 05 — ggplot2를 활용한 데이터 시각화

> **최종 수정일:** 2026-03-21

---

## 목차

1. [ggplot2 소개](#1-ggplot2-소개)
2. [dplyr을 활용한 데이터 조작](#2-dplyr을-활용한-데이터-조작)
3. [기본 그래프 유형](#3-기본-그래프-유형)
4. [미적 매핑](#4-미적-매핑)
5. [패싯](#5-패싯)
6. [기준선과 주석](#6-기준선과-주석)
7. [데이터 결합](#7-데이터-결합)
8. [요약](#요약)

---

## 1. ggplot2 소개

### 1.1 그래픽 문법

`ggplot2`는 "그래픽 문법(Grammar of Graphics)" 개념에 기반하며, 모든 그래프는 다음으로 구성된다:

- **데이터(Data)**: 시각화할 데이터셋
- **미적 요소(Aesthetics)** (`aes()`): 데이터 변수를 시각적 속성(x, y, 색상, 크기, 모양)에 매핑
- **기하 객체(Geometries)** (`geom_*`): 시각적 요소 (점, 선, 막대)
- **척도(Scales)**: 데이터 값이 미적 요소 값에 매핑되는 방식
- **패싯(Facets)**: 데이터를 하위 그래프로 분할
- **테마(Themes)**: 시각적 외관 (글꼴, 색상, 배경)

### 1.2 기본 문법

```r
library(ggplot2)

ggplot(data, aes(x = variable1, y = variable2)) +
  geom_point()   # 기하 레이어 추가
```

> **핵심 요점:** ggplot2는 `+` 연산자를 사용하여 레이어별로 그래프를 구축한다. `ggplot()` 호출이 캔버스를 생성하고, `geom_*()` 함수가 시각적 요소를 추가한다.

---

## 2. dplyr을 활용한 데이터 조작

### 2.1 dplyr 핵심 동사

`dplyr` 패키지는 데이터 조작을 위한 다섯 가지 핵심 함수를 제공한다:

| 함수 | 용도 | 예시 |
|------|------|------|
| `filter()` | 조건에 따른 행 선택 | `filter(flights, month == 1)` |
| `arrange()` | 행 정렬 | `arrange(flights, dep_delay)` |
| `select()` | 열 선택 | `select(flights, year, month, day)` |
| `mutate()` | 새로운 열 생성 | `mutate(data, speed = distance/time)` |
| `summarise()` | 데이터 집계 | `summarise(data, avg = mean(x))` |

### 2.2 filter() — 행 선택

```r
library(tidyverse)
library(nycflights13)

# 1월 1일 항공편 필터링
filter(flights, month == 1, day == 1)

# 결과를 변수에 할당
jan1 <- filter(flights, month == 1, day == 1)

# 괄호로 감싸서 필터링과 출력을 동시에 수행
(dec25 <- filter(flights, month == 12, day == 25))

# 복수 조건으로 필터링
filter(mtcars, cyl == 4)
filter(mtcars, cyl >= 6 & mpg > 20)
```

### 2.3 arrange() — 정렬

```r
arrange(flights, year, month, day)         # 오름차순 정렬
arrange(flights, desc(dep_delay))          # 내림차순 정렬

head(arrange(mtcars, wt))                  # 무게(wt) 기준 오름차순 정렬
head(arrange(mtcars, mpg, desc(wt)))       # mpg 기준 정렬 후 무게 내림차순
```

### 2.4 select() — 열 선택

```r
select(flights, year, month, day)          # 특정 열 선택
select(flights, year:day)                  # 열 범위 선택
select(flights, -(year:day))               # 열 범위 제외

# 도우미 함수
select(flights, ends_with("delay"))        # "delay"로 끝나는 열
```

### 2.5 mutate() — 새로운 열 생성

```r
flights_sml <- select(flights,
  year:day, ends_with("delay"), distance, air_time
)

mutate(flights_sml,
  gain = dep_delay - arr_delay,
  speed = distance / air_time * 60
)

# 새 열은 다른 새 열을 참조할 수 있다
mutate(flights_sml,
  gain = dep_delay - arr_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)
```

### 2.6 summarise()와 group_by()

```r
# 단순 요약
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# 그룹별 요약
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay = mean(dep_delay, na.rm = TRUE))

# 파이프 연산자 (%>%) 사용
group_by(mtcars, cyl) %>% summarise(n())

# 다중 요약 통계
summarise(mtcars,
  cyl_mean = mean(cyl),
  cyl_min = min(cyl),
  cyl_max = max(cyl)
)
```

> **핵심 요점:** 파이프 연산자 `%>%`는 왼쪽 표현식의 결과를 오른쪽 함수의 첫 번째 인수로 전달한다. 이를 통해 연산 체인이 읽기 쉬워진다: `data %>% filter() %>% summarise()`.

---

## 3. 기본 그래프 유형

### 3.1 산점도 (`geom_point()`)

```r
# 기본 산점도
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point()

# 크기와 색상을 사용자 정의한 산점도
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point(size = 3, color = "red")
# 기본 점 크기는 1.5
```

### 3.2 선 그래프 (`geom_line()`)

```r
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_line()
```

### 3.3 막대 그래프 (`geom_bar()`)

```r
# 단순 막대 그래프 (x축만 필요; y축은 자동으로 개수를 셈)
ggplot(mtcars, aes(x = cyl)) +
  geom_bar(width = 0.5)

# factor()를 사용하여 비어 있는 범주 제외 (예: 5, 7 실린더)
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(width = 0.5)

# 채움 색상이 있는 누적 막대 그래프
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(aes(fill = factor(gear)))
```

### 3.4 상자 그림 (`geom_boxplot()`)

```r
# 그룹화된 상자 그림
ggplot(airquality, aes(x = Day, y = Temp, group = Day)) +
  geom_boxplot()
```

> **핵심 요점:** 상자 그림에서 이상치(outlier)는 사분위수 범위(IQR)의 1.5배를 넘어서는 점으로 정의된다. 통계학에서 이상치는 평균과 표준편차를 사용하여 정의하지 **않는다**.

### 3.5 선버스트 차트 (극좌표)

```r
# 누적 막대 그래프를 coord_polar()로 선버스트 차트로 변환
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(aes(fill = factor(gear))) +
  coord_polar()

# 도넛 형태의 선버스트 차트
ggplot(mtcars, aes(x = factor(cyl))) +
  geom_bar(aes(fill = factor(gear))) +
  coord_polar(theta = "y")
```

---

## 4. 미적 매핑

### 4.1 색상 매핑

```r
# class를 색상에 매핑: 각 class가 다른 색상을 갖는다
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

### 4.2 알파(투명도) 매핑

```r
# class를 투명도에 매핑
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
```

### 4.3 모양 매핑

```r
# class를 점 모양에 매핑
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
```

> **핵심 요점:** 미적 요소가 `aes()` **안에** 배치되면 변수를 미적 요소에 매핑한다. `aes()` **밖에** 배치되면 고정된 값을 설정한다 (예: `color = "red"`는 모든 점을 빨간색으로 만든다).

---

## 5. 패싯

### 5.1 facet_wrap()

범주형 변수에 따라 데이터를 하위 그래프로 분할한다:

```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
```

---

## 6. 기준선과 주석

### 6.1 기준선 추가

```r
library(ggplot2)

# 절편과 기울기를 가진 대각선
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_abline(intercept = 12.18671, slope = -0.0005444)

# 평균값에 수평 기준선
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_hline(yintercept = mean(economics$psavert))

# 특정 날짜에 수직 기준선
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line() +
  geom_vline(xintercept = as.Date("2005-07-01"))
```

### 6.2 텍스트 주석

```r
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point() +
  geom_text(aes(label = Temp, vjust = 0, hjust = 0))
```

---

## 7. 데이터 결합

### 7.1 left_join()

```r
library(nycflights13)

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)

flights2 %>%
  select(-origin, -dest) %>%
  left_join(airlines, by = "carrier")
```

### 7.2 중복 카운트 및 필터링

```r
planes %>%
  count(tailnum) %>%
  filter(n > 1)

weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)
```

---

## 요약

| 개념 | 핵심 요점 |
|------|-----------|
| ggplot2 | 레이어 기반 그래픽 문법; `ggplot() + geom_*()` |
| `aes()` | 데이터 변수를 시각적 속성(x, y, color, size, shape)에 매핑 |
| `geom_point()` | 산점도; 기본 크기 1.5 |
| `geom_bar()` | 막대 그래프; `factor()`로 비어 있는 범주 제외 |
| `geom_boxplot()` | 상자 그림; 이상치는 1.5 * IQR 초과 |
| `facet_wrap()` | 변수에 따라 그래프를 하위 그래프로 분할 |
| dplyr 동사 | `filter()`, `arrange()`, `select()`, `mutate()`, `summarise()` |
| `%>%` 파이프 | 연산 체인: 왼쪽 결과를 오른쪽 함수의 첫 번째 인수로 전달 |
| `group_by()` | `summarise()`와 함께 사용하여 데이터를 그룹별로 집계 |
| `left_join()` | 공통 키 열을 기준으로 데이터 프레임 병합 |
