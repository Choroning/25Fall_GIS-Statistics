# 6장 — ggplot2를 활용한 데이터 시각화

[레포지토리 안내](../../README.ko.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **최종 수정일:** 2026-11-18
>
> 혼자 공부하는 R 데이터 분석, 강전희와 엄동란, Ch 6

> **학습 목표:**
> 1. ggplot2 그래픽 문법의 구성 요소를 설명하고 산점도, 선 그래프, 막대 그래프, 상자 그림을 그릴 수 있다
> 2. 미적 매핑과 패싯을 사용하고, 여러 geom을 레이어로 쌓아 기준선과 텍스트 주석을 더할 수 있다
> 3. 상자 그림이 이상치를 표시하는 기준을 사분위수 범위(IQR)로 설명할 수 있다

---

## 목차

- [1. ggplot2 소개](#1-ggplot2-소개)
  - [1.1 그래픽 문법](#11-그래픽-문법)
  - [1.2 기본 문법](#12-기본-문법)
- [2. 기본 그래프 유형](#2-기본-그래프-유형)
  - [2.1 산점도 (geom_point())](#21-산점도-geom_point)
  - [2.2 선 그래프 (geom_line())](#22-선-그래프-geom_line)
  - [2.3 막대 그래프 (geom_bar())](#23-막대-그래프-geom_bar)
  - [2.4 상자 그림 (geom_boxplot())](#24-상자-그림-geom_boxplot)
  - [2.5 선버스트 차트 (극좌표)](#25-선버스트-차트-극좌표)
- [3. 미적 매핑](#3-미적-매핑)
  - [3.1 색상 매핑](#31-색상-매핑)
  - [3.2 알파(투명도) 매핑](#32-알파투명도-매핑)
  - [3.3 모양 매핑](#33-모양-매핑)
- [4. 패싯](#4-패싯)
  - [4.1 facet_wrap()](#41-facet_wrap)
- [5. 기준선과 주석](#5-기준선과-주석)
  - [5.1 기준선 추가](#51-기준선-추가)
  - [5.2 텍스트 주석](#52-텍스트-주석)
- [요약](#요약)
- [점검 문제](#점검-문제)

---

<br>

## 1. ggplot2 소개

### 1.1 그래픽 문법

`ggplot2`는 **그래픽 문법(Grammar of Graphics)** 개념에 기반하며, 모든 그래프는 다음으로 구성된다:

- **데이터(Data)**: 시각화할 데이터셋이다.
- **미적 요소(Aesthetics)** (`aes()`): 데이터 변수를 시각적 속성(x, y, 색상, 크기, 모양)에 매핑한다.
- **기하 객체(Geometries)** (`geom_*`): 점, 선, 막대 같은 시각적 요소이다.
- **통계 변환(Statistics)** (`stat_*`): 개수 세기처럼 그리기 전에 데이터를 요약하거나 변환한다. `geom_bar()`는 기본으로 개수를 센다.
- **척도(Scales)**: 데이터 값이 미적 요소 값에 매핑되는 방식이다.
- **좌표계(Coordinates)** (`coord_*`): 위치를 평면에 배치하는 방식이다. 기본은 직교 좌표계이고, `coord_polar()`는 극좌표계이다.
- **패싯(Facets)**: 데이터를 하위 그래프로 분할한다.
- **테마(Themes)**: 글꼴, 색상, 배경 같은 시각적 외관이다.

### 1.2 기본 문법

```r
library(ggplot2)

ggplot(data, aes(x = variable1, y = variable2)) +
  geom_point()   # 기하 레이어 추가
```

> **핵심:** ggplot2는 `+` 연산자를 사용하여 레이어별로 그래프를 구축한다. `ggplot()` 호출이 캔버스를 생성하고, `geom_*()` 함수가 시각적 요소를 추가한다.

---

<br>

## 2. 기본 그래프 유형

### 2.1 산점도 (`geom_point()`)

`airquality`는 1973년 5\~9월 뉴욕의 일별 대기 질 측정값이다. `Day`는 그 달의 날짜(1\~31)이고 `Temp`는 일 최고 기온(화씨)이므로, 아래 그래프에서 각 날짜에는 다섯 달의 점이 함께 찍힌다.

```r
# 기본 산점도
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point()

# 크기와 색상을 사용자 정의한 산점도
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point(size = 3, color = "red")
# 기본 점 크기는 1.5
```

### 2.2 선 그래프 (`geom_line()`)

```r
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_line()
```

### 2.3 막대 그래프 (`geom_bar()`)

`geom_bar()`는 x의 값마다 행의 수를 세어 막대 높이로 쓴다. `mtcars`(5장 1.2절)의 숫자형 `cyl`을 그대로 x에 주면 x축이 연속형이 되어 4, 6, 8 사이에 5와 7 같은 빈 눈금이 생기고, `factor()`로 범주형으로 바꾸면 실제 값 4, 6, 8만 막대로 나타난다. `fill = factor(gear)`는 막대를 기어 수별로 나누어 색을 칠한다.

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

### 2.4 상자 그림 (`geom_boxplot()`)

`Day`가 숫자형이므로 `group = Day`를 지정해야 날짜마다 따로 상자가 그려진다. 지정하지 않으면 모든 자료가 하나의 상자로 그려진다.

```r
# 그룹화된 상자 그림
ggplot(airquality, aes(x = Day, y = Temp, group = Day)) +
  geom_boxplot()
```

> **핵심:** 상자 그림은 1사분위수 $Q_1$보다 $1.5 \times \mathrm{IQR}$ 넘게 작거나 3사분위수 $Q_3$보다 $1.5 \times \mathrm{IQR}$ 넘게 큰 점, 곧 $Q_1 - 1.5 \times \mathrm{IQR}$보다 작거나 $Q_3 + 1.5 \times \mathrm{IQR}$보다 큰 점을 이상치(outlier)로 표시한다. 사분위수 범위는 $\mathrm{IQR} = Q_3 - Q_1$이다. 상자 그림은 이상치를 평균과 표준편차로 정의하지 **않는다**. 평균과 표준편차는 극단값 자체의 영향을 크게 받기 때문이다.

### 2.5 선버스트 차트 (극좌표)

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

> **참고:** **극좌표 변환의 두 방식.** `coord_polar()`의 기본값 `theta = "x"`는 x의 범주를 각도에, 막대 높이를 반지름에 대응시키므로 Nightingale의 장미 도표(coxcomb)와 같은 모양이 된다. `theta = "y"`는 개수를 각도에, 범주를 반지름에 대응시키므로 범주마다 고리가 하나씩 생기는 도넛 모양이 된다. 엄밀한 의미의 선버스트 차트는 계층 구조의 상위 범주를 안쪽 고리에, 하위 범주를 바깥 고리에 나누어 보이는 차트이며, 여기서는 그와 비슷한 모양이라는 뜻으로 부른다.

---

<br>

## 3. 미적 매핑

### 3.1 색상 매핑

```r
# class를 색상에 매핑: 각 class가 다른 색상을 갖는다
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class))
```

### 3.2 알파(투명도) 매핑

투명도는 정도의 크고 작음을 나타내는 속성이므로, 순서가 없는 범주형 변수에 매핑하면 ggplot2가 권장하지 않는다는 경고를 출력한다.

```r
# class를 투명도에 매핑
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))
```

### 3.3 모양 매핑

기본 모양 팔레트는 범주를 최대 6개까지만 구분한다. 범주가 7개인 `class`를 모양에 매핑하면 일곱 번째 범주인 `suv`의 점 62개는 경고와 함께 그려지지 않는다.

```r
# class를 점 모양에 매핑
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class))
```

> **핵심:** 미적 요소가 `aes()` **안에** 배치되면 변수를 미적 요소에 매핑한다. `aes()` **밖에** 배치되면 고정된 값을 설정한다 (예: `color = "red"`는 모든 점을 빨간색으로 만든다).

---

<br>

## 4. 패싯

### 4.1 facet_wrap()

범주형 변수에 따라 데이터를 하위 그래프로 분할한다. `~ class`는 `class`의 값마다 하위 그래프를 하나씩 만들라는 공식이고, `nrow = 2`는 하위 그래프 7개를 2행으로 배치한다:

```r
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
```

---

<br>

## 5. 기준선과 주석

### 5.1 기준선 추가

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

`psavert`는 미국의 개인 저축률(%)이다. `geom_abline()`은 절편 `intercept`와 기울기 `slope`로 정해지는 직선 $y = \text{intercept} + \text{slope} \times x$를 그린다. 날짜 축은 내부적으로 1970-01-01부터의 일수로 저장되므로, 기울기 `-0.0005444`는 저축률이 하루에 0.0005444%p, 1년에 약 0.2%p씩 줄어드는 추세를 뜻한다. `geom_hline()`과 `geom_vline()`은 지정한 y 값과 x 값의 위치에 수평선과 수직선을 긋는다. 2005-07-01은 저축률이 2.2%로 가장 낮은 달이다.

### 5.2 텍스트 주석

```r
ggplot(airquality, aes(x = Day, y = Temp)) +
  geom_point() +
  geom_text(aes(label = Temp, vjust = 0, hjust = 0))
```

`label = Temp`는 각 점에 기온 값을 글자로 표시한다. `vjust = 0`과 `hjust = 0`은 글자의 왼쪽 아래 모서리를 점의 위치에 맞추므로 글자가 점의 오른쪽 위에 놓인다. 두 값은 변수가 아닌 상수이므로 `aes()` 밖에 써도 결과가 같다.

---

<br>

## 요약

| 개념 | 핵심 요약 |
|------|-----------|
| ggplot2 | 레이어 기반 그래픽 문법을 따르며, `ggplot() + geom_*()` 형태로 그래프를 만든다. |
| `aes()` | 데이터 변수를 시각적 속성(x, y, color, size, shape)에 매핑한다. |
| `geom_point()` | 산점도를 그리며, 기본 점 크기는 1.5이다. |
| `geom_bar()` | 막대 그래프를 그리며, `factor()`로 x를 범주형으로 바꾸면 비어 있는 값이 축에서 빠진다. |
| `geom_boxplot()` | 상자 그림을 그리며, $Q_1 - 1.5 \times \mathrm{IQR}$보다 작거나 $Q_3 + 1.5 \times \mathrm{IQR}$보다 큰 점을 이상치로 표시한다. |
| `facet_wrap()` | 변수의 값에 따라 그래프를 하위 그래프로 분할한다. |

---

<br>

## 점검 문제

1. **aes() 안과 밖:** `geom_point(aes(color = "red"))`와 `geom_point(color = "red")`의 결과가 어떻게 다른지 설명하라.

   <details>
   <summary>정답</summary>

   `geom_point(color = "red")`는 `aes()` 밖에서 고정값을 지정하므로 모든 점이 빨간색이 된다. `geom_point(aes(color = "red"))`는 문자열 `"red"` 하나만 값으로 가진 변수를 색상에 매핑하므로, 점은 기본 팔레트의 첫 번째 색(`#F8766D`, 연한 붉은색)으로 칠해지고 `red`라는 항목 하나만 있는 범례가 생긴다.

   </details>

2. **막대 그래프의 x축:** `mtcars`에서 `cyl`이 4, 6, 8인 자동차는 각각 11대, 7대, 14대이다. `aes(x = cyl)`로 그린 막대 그래프와 `aes(x = factor(cyl))`로 그린 막대 그래프의 막대 높이와 x축을 비교하라.

   <details>
   <summary>정답</summary>

   두 그래프 모두 막대 높이는 11, 7, 14이다. `cyl`은 숫자형이므로 `aes(x = cyl)`에서는 x축이 연속형이 되어 5와 7을 포함한 눈금이 표시되고 그 위치는 비어 있다. `factor(cyl)`은 범주형 축을 만들어 4, 6, 8 세 범주만 나란히 표시한다.

   </details>

3. **이상치 경계:** 어떤 그룹의 1사분위수가 10, 3사분위수가 20일 때 상자 그림의 이상치 경계를 구하고, 값 -6, 34, 36 가운데 이상치로 표시되는 값을 모두 고르라.

   <details>
   <summary>정답</summary>

   $\mathrm{IQR} = 20 - 10 = 10$이므로 아래 경계는 $10 - 1.5 \times 10 = -5$, 위 경계는 $20 + 1.5 \times 10 = 35$이다. -6은 -5보다 작고 36은 35보다 크므로 이상치이며, 34는 경계 안에 있으므로 이상치가 아니다.

   </details>
