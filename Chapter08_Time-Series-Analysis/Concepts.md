# Chapter 08 — Time Series Analysis

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Introduction to Time Series](#1-introduction-to-time-series)
2. [Characteristics of Time Series Data](#2-characteristics-of-time-series-data)
3. [Date and Time Objects in R](#3-date-and-time-objects-in-r)
4. [Time Series Objects in R](#4-time-series-objects-in-r)
5. [Descriptive Techniques](#5-descriptive-techniques)
6. [Decomposition](#6-decomposition)
7. [ARIMA Models](#7-arima-models)
8. [Forecasting](#8-forecasting)
9. [Summary](#summary)

---

## 1. Introduction to Time Series

### 1.1 Definition

A **time series** is a sequence of data points collected or recorded at successive, equally spaced points in time. Time series analysis involves methods for analyzing time-ordered data to extract meaningful statistics, identify patterns, and make forecasts.

### 1.2 Real-World Examples

| Example | Data Description |
|---------|------------------|
| Johnson & Johnson Earnings | Quarterly earnings per share, 1960-1980 |
| Global Warming | Mean land-ocean temperature index, 1880-2015 |
| Speech Data | Audio signal sampled at 10,000 points/second |
| DJIA Returns | Daily returns of Dow Jones Industrial Average |
| El Nino & Fish Population | Monthly SOI and Recruitment series, 1950-1987 |
| Earthquake vs. Explosion | Seismic waveform classification |

### 1.3 Key Concepts

- **Trend**: Long-term increase or decrease in the data
- **Seasonality**: Regular periodic fluctuations (e.g., annual cycles)
- **Cyclic variation**: Oscillations without a fixed period (e.g., business cycles)
- **Noise/Irregularity**: Random, unpredictable fluctuations

> **Key Point:** "All models are wrong, but some are useful." -- George E.P. Box. This aphorism is particularly relevant in time series analysis, where models approximate reality but can still provide valuable forecasts.

---

## 2. Characteristics of Time Series Data

### 2.1 Types of Variation

#### Seasonal Variation
- Fixed periodic patterns (annual, quarterly, monthly, weekly)
- Example: Unemployment is typically higher in winter
- Can be estimated and removed (deseasonalization)

#### Cyclic Variation
- Oscillations without a fixed period
- Business cycles vary from 3-4 years to 10+ years
- Less predictable than seasonal patterns

#### Trend
- Long-term upward or downward movement
- Can be linear or non-linear
- Example: Increasing global temperatures

#### Random/Irregular
- Unpredictable fluctuations
- Residual after removing trend, seasonal, and cyclic components

### 2.2 Stationarity

A time series is **stationary** if its statistical properties (mean, variance, autocorrelation) do not change over time.

- **Strict stationarity**: The entire joint distribution is time-invariant
- **Weak stationarity**: Only mean and autocovariance are time-invariant

Most time series models require stationarity. Non-stationary series can be made stationary through **differencing**.

---

## 3. Date and Time Objects in R

### 3.1 Date Classes

R provides several classes for handling dates and times:

| Class | Description | Origin Point |
|-------|-------------|-------------|
| `Date` | Calendar date only | 1970-01-01 |
| `POSIXct` | Date + time as seconds since origin | 1970-01-01 00:00:00 UTC |
| `POSIXlt` | Date + time as a named list | 1970-01-01 00:00:00 UTC |

```r
# Get current date and time
date <- Sys.Date()
date                    # "2025-12-02"
class(date)             # "Date"

time_ct <- Sys.time()
time_ct                 # "2025-12-02 14:30:00 KST"
class(time_ct)          # "POSIXct" "POSIXt"

# Convert POSIXct to POSIXlt
time_lt <- as.POSIXlt(time_ct)
class(time_lt)          # "POSIXlt" "POSIXt"
```

### 3.2 POSIXct vs. POSIXlt

```r
# POSIXct: stored as a single numeric value (seconds since origin)
unclass(time_ct)        # e.g., 1663317362

# POSIXlt: stored as a named list
unclass(time_lt)$sec    # seconds
unclass(time_lt)$hour   # hour
unclass(time_lt)$mday   # day of month
unclass(time_lt)$mon    # month (0-11)
unclass(time_lt)$year   # years since 1900
unclass(time_lt)$yday   # day of year (0-365)
```

### 3.3 Creating Date Objects

```r
# String to Date conversion
d1 <- "2022-09-21"
class(d1)               # "character"

d2 <- as.Date("2022-09-21")
class(d2)               # "Date"

# Creating POSIXct and POSIXlt with timezone
time_ct <- as.POSIXct("2022-09-21 20:05:35", tz = "EST")
time_lt <- as.POSIXlt("2022-09-21 20:05:35", tz = "EST")
```

### 3.4 Date Format Conversion

Different date formats require format specifications:

| Format Code | Meaning | Example |
|-------------|---------|---------|
| `%Y` | 4-digit year | 2022 |
| `%m` | 2-digit month | 09 |
| `%d` | 2-digit day | 21 |
| `%H` | Hour (24h) | 20 |
| `%M` | Minute | 05 |
| `%S` | Second | 35 |

```r
# ISO 8601 format (default): YYYY-MM-DD
as.Date("2017-01-20")

# US format: MM/DD/YYYY
as.Date("1/20/2017", format = "%m/%d/%Y")

# NZ format: DD/MM/YYYY
as.Date("20/01/2017", format = "%d/%m/%Y")
```

### 3.5 Origin Points Across Software

| Software | Origin Point |
|----------|-------------|
| R | January 1, 1970 |
| SAS | January 1, 1960 |
| Excel | January 1, 1900 |

> **Key Point:** When importing date data from other software, verify the origin point matches. Use the `origin` parameter in `as.Date()` if converting from numeric date values.

---

## 4. Time Series Objects in R

### 4.1 Creating ts Objects

```r
# Create a time series object
ts_data <- ts(data_vector, start = c(1960, 1), frequency = 4)
# start: starting time (year, period)
# frequency: observations per unit time (4 = quarterly, 12 = monthly)
```

### 4.2 Common Time Series Datasets

```r
# Johnson & Johnson quarterly earnings
data(JohnsonJohnson)
plot(JohnsonJohnson)

# AirPassengers: monthly airline passengers
data(AirPassengers)
plot(AirPassengers)

# US economic data
library(ggplot2)
data(economics)
str(economics)
```

---

## 5. Descriptive Techniques

### 5.1 Time Series Plotting

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

### 5.2 Autocorrelation Function (ACF)

The ACF measures the correlation between a time series and its lagged values:

$$\rho(h) = \frac{Cov(X_t, X_{t+h})}{Var(X_t)}$$

```r
acf(ts_data)         # Plot ACF
acf(ts_data, plot = FALSE)  # Get numeric values
```

### 5.3 Partial Autocorrelation Function (PACF)

PACF measures the correlation between $X_t$ and $X_{t+h}$ after removing the effect of intermediate lags:

```r
pacf(ts_data)        # Plot PACF
```

> **Key Point:** ACF and PACF plots are essential diagnostic tools for identifying the appropriate ARIMA model order. ACF helps identify the MA order, while PACF helps identify the AR order.

---

## 6. Decomposition

### 6.1 Additive vs. Multiplicative

A time series can be decomposed into components:

- **Additive**: $Y_t = T_t + S_t + R_t$ (constant seasonal amplitude)
- **Multiplicative**: $Y_t = T_t \times S_t \times R_t$ (seasonal amplitude proportional to trend)

Where $T_t$ is trend, $S_t$ is seasonal, and $R_t$ is residual.

```r
# Decompose a time series
decomp <- decompose(AirPassengers, type = "multiplicative")
plot(decomp)

# STL decomposition (more robust)
stl_result <- stl(AirPassengers, s.window = "periodic")
plot(stl_result)
```

---

## 7. ARIMA Models

### 7.1 AR, MA, and ARIMA

| Model | Name | Formula |
|-------|------|---------|
| AR(p) | Autoregressive | $X_t = \phi_1 X_{t-1} + \cdots + \phi_p X_{t-p} + w_t$ |
| MA(q) | Moving Average | $X_t = w_t + \theta_1 w_{t-1} + \cdots + \theta_q w_{t-q}$ |
| ARMA(p,q) | Autoregressive Moving Average | Combination of AR and MA |
| ARIMA(p,d,q) | Autoregressive Integrated Moving Average | ARMA with differencing |

Parameters:
- **p**: Order of autoregressive (AR) component
- **d**: Degree of differencing (for stationarity)
- **q**: Order of moving average (MA) component

### 7.2 Box-Jenkins Method

The classical approach to building ARIMA models:

1. **Identification**: Determine p, d, q using ACF/PACF plots
2. **Estimation**: Estimate model parameters
3. **Diagnostic checking**: Verify residuals are white noise
4. **Forecasting**: Generate predictions

### 7.3 Implementation in R

```r
library(forecast)

# Automatic ARIMA model selection
auto_model <- auto.arima(ts_data)
summary(auto_model)

# Manual ARIMA specification
manual_model <- arima(ts_data, order = c(1, 1, 1))

# Check residuals
checkresiduals(auto_model)
```

---

## 8. Forecasting

### 8.1 Making Forecasts

```r
library(forecast)

# Forecast future values
fc <- forecast(auto_model, h = 12)  # 12 periods ahead
plot(fc)

# Autoplot (ggplot2 style)
autoplot(fc) +
  labs(title = "Time Series Forecast",
       x = "Time", y = "Value")
```

### 8.2 Forecast Accuracy

```r
# Train/test split for evaluation
train <- window(ts_data, end = c(2010, 12))
test <- window(ts_data, start = c(2011, 1))

model <- auto.arima(train)
fc <- forecast(model, h = length(test))
accuracy(fc, test)
```

### 8.3 Recommended References

| Book | Author | Focus |
|------|--------|-------|
| *Time Series Analysis and Its Applications* | Shumway & Stoffer | Comprehensive theory with R |
| *Forecasting: Principles and Practice* | Hyndman & Athanasopoulos | Practical forecasting (https://otexts.com/fpp3/) |
| *Hands-On Time Series Analysis with R* | Rami Krispin | Practical R implementation |
| *Analysis of Financial Time Series* | Ruey S. Tsay | Financial applications |

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Time series | Ordered sequence of data points at regular time intervals |
| Components | Trend, seasonality, cyclic variation, random noise |
| Stationarity | Statistical properties constant over time; required for most models |
| Date classes | `Date`, `POSIXct` (numeric seconds), `POSIXlt` (list) |
| Date formats | Use `%Y`, `%m`, `%d` with `as.Date(x, format = ...)` |
| ACF/PACF | Diagnostic tools for identifying ARIMA model order |
| Decomposition | Additive ($Y = T + S + R$) vs. Multiplicative ($Y = T \times S \times R$) |
| ARIMA(p,d,q) | p = AR order, d = differencing, q = MA order |
| Box-Jenkins | Identify -> Estimate -> Diagnose -> Forecast |
| `auto.arima()` | Automatic ARIMA model selection in R |
| `forecast()` | Generate future predictions with confidence intervals |
