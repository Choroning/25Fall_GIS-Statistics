# Chapter 08 — 시계열 분석

> **최종 수정일:** 2026-03-21

---

## 목차

1. [시계열 개요](#1-시계열-개요)
2. [시계열 데이터의 특성](#2-시계열-데이터의-특성)
3. [R에서의 날짜 및 시간 객체](#3-r에서의-날짜-및-시간-객체)
4. [R에서의 시계열 객체](#4-r에서의-시계열-객체)
5. [기술적 기법](#5-기술적-기법)
6. [분해](#6-분해)
7. [ARIMA 모형](#7-arima-모형)
8. [예측](#8-예측)
9. [요약](#요약)

---

## 1. 시계열 개요

### 1.1 정의

**시계열(Time Series)**이란 연속적으로 동일한 간격을 두고 수집되거나 기록된 데이터 포인트의 순서열이다. 시계열 분석은 시간 순서로 정렬된 데이터를 분석하여 의미 있는 통계량을 추출하고, 패턴을 식별하며, 예측을 수행하는 방법론이다.

### 1.2 실제 사례

| 사례 | 데이터 설명 |
|------|-------------|
| Johnson & Johnson 수익 | 분기별 주당 순이익, 1960-1980 |
| 지구 온난화 | 평균 지표-해양 온도 지수, 1880-2015 |
| 음성 데이터 | 초당 10,000 포인트로 샘플링된 오디오 신호 |
| DJIA 수익률 | 다우존스 산업평균지수 일별 수익률 |
| 엘니뇨와 어류 개체수 | 월별 SOI 및 Recruitment 계열, 1950-1987 |
| 지진 vs. 폭발 | 지진파 파형 분류 |

### 1.3 핵심 개념

- **추세(Trend)**: 데이터의 장기적인 증가 또는 감소
- **계절성(Seasonality)**: 규칙적인 주기적 변동(예: 연간 순환)
- **순환 변동(Cyclic Variation)**: 고정된 주기가 없는 진동(예: 경기 순환)
- **불규칙 변동(Noise/Irregularity)**: 무작위적이고 예측 불가능한 변동

> **핵심 포인트:** "모든 모형은 틀리지만, 일부는 유용하다." — George E.P. Box. 이 격언은 시계열 분석에서 특히 적절한데, 모형은 현실을 근사하지만 여전히 가치 있는 예측을 제공할 수 있기 때문이다.

---

## 2. 시계열 데이터의 특성

### 2.1 변동의 유형

#### 계절 변동

- 고정된 주기적 패턴(연간, 분기별, 월별, 주별)
- 예: 실업률은 일반적으로 겨울에 높음
- 추정하여 제거할 수 있음(탈계절화)

#### 순환 변동

- 고정된 주기가 없는 진동
- 경기 순환은 3-4년에서 10년 이상까지 다양
- 계절 패턴보다 예측이 어려움

#### 추세

- 장기적인 상승 또는 하강 움직임
- 선형 또는 비선형일 수 있음
- 예: 증가하는 지구 온도

#### 불규칙/무작위 변동

- 예측 불가능한 변동
- 추세, 계절, 순환 성분을 제거한 후의 잔차

### 2.2 정상성

시계열의 통계적 특성(평균, 분산, 자기상관)이 시간에 따라 변하지 않으면 **정상성(Stationarity)**을 갖는다고 한다.

- **엄격한 정상성**: 전체 결합 분포가 시불변
- **약한 정상성**: 평균과 자기공분산만 시불변

대부분의 시계열 모형은 정상성을 요구한다. 비정상 시계열은 **차분(differencing)**을 통해 정상 시계열로 변환할 수 있다.

---

## 3. R에서의 날짜 및 시간 객체

### 3.1 날짜 클래스

R은 날짜와 시간을 다루기 위한 여러 클래스를 제공한다:

| 클래스 | 설명 | 기준점 |
|--------|------|--------|
| `Date` | 날짜만 표현 | 1970-01-01 |
| `POSIXct` | 기준점 이후 초 단위로 날짜+시간 표현 | 1970-01-01 00:00:00 UTC |
| `POSIXlt` | 이름 있는 리스트로 날짜+시간 표현 | 1970-01-01 00:00:00 UTC |

```r
# 현재 날짜 및 시간 가져오기
date <- Sys.Date()
date                    # "2025-12-02"
class(date)             # "Date"

time_ct <- Sys.time()
time_ct                 # "2025-12-02 14:30:00 KST"
class(time_ct)          # "POSIXct" "POSIXt"

# POSIXct를 POSIXlt로 변환
time_lt <- as.POSIXlt(time_ct)
class(time_lt)          # "POSIXlt" "POSIXt"
```

### 3.2 POSIXct vs. POSIXlt

```r
# POSIXct: 단일 숫자 값으로 저장 (기준점 이후 초)
unclass(time_ct)        # 예: 1663317362

# POSIXlt: 이름 있는 리스트로 저장
unclass(time_lt)$sec    # 초
unclass(time_lt)$hour   # 시
unclass(time_lt)$mday   # 일
unclass(time_lt)$mon    # 월 (0-11)
unclass(time_lt)$year   # 1900년 이후 연수
unclass(time_lt)$yday   # 연중 일수 (0-365)
```

### 3.3 날짜 객체 생성

```r
# 문자열을 Date로 변환
d1 <- "2022-09-21"
class(d1)               # "character"

d2 <- as.Date("2022-09-21")
class(d2)               # "Date"

# 시간대를 지정하여 POSIXct와 POSIXlt 생성
time_ct <- as.POSIXct("2022-09-21 20:05:35", tz = "EST")
time_lt <- as.POSIXlt("2022-09-21 20:05:35", tz = "EST")
```

### 3.4 날짜 형식 변환

다양한 날짜 형식에는 형식 지정자가 필요하다:

| 형식 코드 | 의미 | 예시 |
|-----------|------|------|
| `%Y` | 4자리 연도 | 2022 |
| `%m` | 2자리 월 | 09 |
| `%d` | 2자리 일 | 21 |
| `%H` | 시(24시간제) | 20 |
| `%M` | 분 | 05 |
| `%S` | 초 | 35 |

```r
# ISO 8601 형식 (기본): YYYY-MM-DD
as.Date("2017-01-20")

# 미국 형식: MM/DD/YYYY
as.Date("1/20/2017", format = "%m/%d/%Y")

# 뉴질랜드 형식: DD/MM/YYYY
as.Date("20/01/2017", format = "%d/%m/%Y")
```

### 3.5 소프트웨어별 기준점

| 소프트웨어 | 기준점 |
|------------|--------|
| R | 1970년 1월 1일 |
| SAS | 1960년 1월 1일 |
| Excel | 1900년 1월 1일 |

> **핵심 포인트:** 다른 소프트웨어에서 날짜 데이터를 가져올 때는 기준점이 일치하는지 확인해야 한다. 숫자형 날짜 값을 변환할 때는 `as.Date()`의 `origin` 매개변수를 사용한다.

---

## 4. R에서의 시계열 객체

### 4.1 ts 객체 생성

```r
# 시계열 객체 생성
ts_data <- ts(data_vector, start = c(1960, 1), frequency = 4)
# start: 시작 시점 (연도, 기간)
# frequency: 단위 시간당 관측 수 (4 = 분기별, 12 = 월별)
```

### 4.2 자주 사용되는 시계열 데이터셋

```r
# Johnson & Johnson 분기별 수익
data(JohnsonJohnson)
plot(JohnsonJohnson)

# AirPassengers: 월별 항공기 승객 수
data(AirPassengers)
plot(AirPassengers)

# 미국 경제 데이터
library(ggplot2)
data(economics)
str(economics)
```

---

## 5. 기술적 기법

### 5.1 시계열 그래프

```r
library(ggplot2)
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

### 5.2 자기상관 함수(ACF)

ACF는 시계열과 그 시차값 사이의 상관관계를 측정한다:

$$\rho(h) = \frac{Cov(X_t, X_{t+h})}{Var(X_t)}$$

```r
acf(ts_data)         # ACF 그래프
acf(ts_data, plot = FALSE)  # 수치값 확인
```

### 5.3 편자기상관 함수(PACF)

PACF는 중간 시차의 효과를 제거한 후 $X_t$와 $X_{t+h}$ 사이의 상관관계를 측정한다:

```r
pacf(ts_data)        # PACF 그래프
```

> **핵심 포인트:** ACF와 PACF 그래프는 적절한 ARIMA 모형 차수를 식별하기 위한 필수적인 진단 도구이다. ACF는 MA 차수 식별에, PACF는 AR 차수 식별에 도움이 된다.

---

## 6. 분해

### 6.1 가법 분해 vs. 승법 분해

시계열은 여러 성분으로 분해할 수 있다:

- **가법(Additive)**: $Y_t = T_t + S_t + R_t$ (계절 진폭이 일정)
- **승법(Multiplicative)**: $Y_t = T_t \times S_t \times R_t$ (계절 진폭이 추세에 비례)

여기서 $T_t$는 추세, $S_t$는 계절 성분, $R_t$는 잔차이다.

```r
# 시계열 분해
decomp <- decompose(AirPassengers, type = "multiplicative")
plot(decomp)

# STL 분해 (더 강건함)
stl_result <- stl(AirPassengers, s.window = "periodic")
plot(stl_result)
```

---

## 7. ARIMA 모형

### 7.1 AR, MA 및 ARIMA

| 모형 | 이름 | 수식 |
|------|------|------|
| AR(p) | 자기회귀 | $X_t = \phi_1 X_{t-1} + \cdots + \phi_p X_{t-p} + w_t$ |
| MA(q) | 이동 평균 | $X_t = w_t + \theta_1 w_{t-1} + \cdots + \theta_q w_{t-q}$ |
| ARMA(p,q) | 자기회귀 이동 평균 | AR과 MA의 조합 |
| ARIMA(p,d,q) | 자기회귀 누적 이동 평균 | 차분이 포함된 ARMA |

매개변수:
- **p**: 자기회귀(AR) 성분의 차수
- **d**: 차분의 차수(정상성을 위함)
- **q**: 이동 평균(MA) 성분의 차수

### 7.2 Box-Jenkins 방법론

ARIMA 모형 구축을 위한 고전적 접근법:

1. **식별(Identification)**: ACF/PACF 그래프를 사용하여 p, d, q 결정
2. **추정(Estimation)**: 모형 매개변수 추정
3. **진단 검사(Diagnostic Checking)**: 잔차가 백색 잡음인지 확인
4. **예측(Forecasting)**: 예측값 생성

### 7.3 R에서의 구현

```r
library(forecast)

# 자동 ARIMA 모형 선택
auto_model <- auto.arima(ts_data)
summary(auto_model)

# 수동 ARIMA 지정
manual_model <- arima(ts_data, order = c(1, 1, 1))

# 잔차 검사
checkresiduals(auto_model)
```

---

## 8. 예측

### 8.1 예측 수행

```r
library(forecast)

# 미래 값 예측
fc <- forecast(auto_model, h = 12)  # 12기간 선행 예측
plot(fc)

# Autoplot (ggplot2 스타일)
autoplot(fc) +
  labs(title = "Time Series Forecast",
       x = "Time", y = "Value")
```

### 8.2 예측 정확도

```r
# 평가를 위한 훈련/검정 분할
train <- window(ts_data, end = c(2010, 12))
test <- window(ts_data, start = c(2011, 1))

model <- auto.arima(train)
fc <- forecast(model, h = length(test))
accuracy(fc, test)
```

### 8.3 추천 참고문헌

| 도서 | 저자 | 주요 내용 |
|------|------|-----------|
| *Time Series Analysis and Its Applications* | Shumway & Stoffer | R을 활용한 종합적 이론 |
| *Forecasting: Principles and Practice* | Hyndman & Athanasopoulos | 실용적 예측(https://otexts.com/fpp3/) |
| *Hands-On Time Series Analysis with R* | Rami Krispin | 실용적 R 구현 |
| *Analysis of Financial Time Series* | Ruey S. Tsay | 금융 응용 |

---

## 요약

| 개념 | 핵심 포인트 |
|------|-------------|
| 시계열 | 규칙적인 시간 간격으로 정렬된 데이터 포인트의 순서열 |
| 구성 요소 | 추세, 계절성, 순환 변동, 불규칙 변동 |
| 정상성 | 통계적 특성이 시간에 따라 일정; 대부분의 모형에서 필요 |
| 날짜 클래스 | `Date`, `POSIXct`(숫자형 초), `POSIXlt`(리스트형) |
| 날짜 형식 | `as.Date(x, format = ...)`에서 `%Y`, `%m`, `%d` 사용 |
| ACF/PACF | ARIMA 모형 차수 식별을 위한 진단 도구 |
| 분해 | 가법($Y = T + S + R$) vs. 승법($Y = T \times S \times R$) |
| ARIMA(p,d,q) | p = AR 차수, d = 차분, q = MA 차수 |
| Box-Jenkins | 식별 -> 추정 -> 진단 -> 예측 |
| `auto.arima()` | R에서의 자동 ARIMA 모형 선택 |
| `forecast()` | 신뢰 구간과 함께 미래 예측값 생성 |
