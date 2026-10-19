# @file    Lab_TimeSeriesAnalysis.R
# @brief   Introduction to time series analysis in R, including date/time
#          objects, ts objects, decomposition, ARIMA modeling, and forecasting
# @author  Cheolwon Park
# @date    2025-12-02


# =============================================================================
# 1. DATE AND TIME OBJECTS IN R
# =============================================================================

# --- 1.1 System Date and Time ---

# Get current date (Date class)
date <- Sys.Date()
date
class(date)             # "Date"

# Get current date and time (POSIXct class)
time_ct <- Sys.time()
time_ct
class(time_ct)          # "POSIXct" "POSIXt"

# Convert POSIXct to POSIXlt
time_lt <- as.POSIXlt(time_ct)
time_lt
class(time_lt)          # "POSIXlt" "POSIXt"


# --- 1.2 Internal Representation ---

# POSIXct: single numeric value (seconds since 1970-01-01)
unclass(time_ct)

# POSIXlt: named list of components
unclass(time_lt)

# Access individual components of POSIXlt
unclass(time_lt)$sec    # Seconds
unclass(time_lt)$hour   # Hour
unclass(time_lt)$mday   # Day of month
unclass(time_lt)$yday   # Day of year (0-365)


# --- 1.3 Creating Date and Time Objects ---

# String is NOT automatically a Date
d1 <- "2022-09-21"
class(d1)               # "character"

# Convert string to Date
d2 <- as.Date("2022-09-21")
d2
class(d2)               # "Date"

# Create POSIXct and POSIXlt with timezone
time_ct <- as.POSIXct("2022-09-21 20:05:35", tz = "EST")
time_ct
class(time_ct)

time_lt <- as.POSIXlt("2022-09-21 20:05:35", tz = "EST")
time_lt
class(time_lt)


# --- 1.4 String vs. Date Object Comparison ---

time_str <- "2022-09-17 23:59:59"
class(time_str)          # "character"

time_posix_ct1 <- as.POSIXct(time_str)
class(time_posix_ct1)    # "POSIXct" "POSIXt"

# They look similar but are different types
time_str
time_posix_ct1

# Verify they are NOT identical
identical(time_str, time_posix_ct1)  # FALSE


# --- 1.5 Date Format Conversion ---

# Different regions use different date formats
# ISO 8601 format (YYYY-MM-DD) - R's default
as.Date("2017-01-20")

# US format (MM/DD/YYYY)
as.Date("1/20/2017", format = "%m/%d/%Y")

# NZ format (DD/MM/YYYY)
as.Date("20/01/2017", format = "%d/%m/%Y")

# Origin points differ across software:
# R:     1970-01-01
# SAS:   1960-01-01
# Excel: 1900-01-01


# =============================================================================
# 2. TIME SERIES OBJECTS
# =============================================================================

# --- 2.1 Built-in Time Series Datasets ---

# Johnson & Johnson quarterly earnings (1960-1980)
data(JohnsonJohnson)
JohnsonJohnson
class(JohnsonJohnson)   # "ts"
plot(JohnsonJohnson,
     main = "Johnson & Johnson Quarterly Earnings",
     ylab = "Earnings per Share")

# Monthly airline passengers (1949-1960)
data(AirPassengers)
AirPassengers
plot(AirPassengers,
     main = "Monthly Airline Passengers",
     ylab = "Number of Passengers")


# --- 2.2 Creating a Time Series Object ---

# Create a simple ts object
sample_data <- c(120, 132, 141, 118, 130, 145, 152, 160, 155, 148, 165, 170)
ts_monthly <- ts(sample_data, start = c(2024, 1), frequency = 12)
ts_monthly
plot(ts_monthly, main = "Sample Monthly Time Series", ylab = "Value")


# =============================================================================
# 3. TIME SERIES VISUALIZATION WITH ggplot2
# =============================================================================

library(ggplot2)
library(scales)

# Personal savings rate time series with smoothing
ggplot(economics, aes(x = date, y = psavert)) +
  geom_line(color = "indianred3", linewidth = 1) +
  geom_smooth() +
  scale_x_date(date_breaks = "5 years", labels = date_format("%b-%y")) +
  labs(title = "Personal Savings Rate",
       subtitle = "1967 to 2015",
       x = "",
       y = "Personal Savings Rate") +
  theme_minimal()


# =============================================================================
# 4. TIME SERIES DECOMPOSITION
# =============================================================================

# --- 4.1 Decompose AirPassengers (multiplicative) ---
decomp_mult <- decompose(AirPassengers, type = "multiplicative")
plot(decomp_mult, xlab = "Year")

# --- 4.2 Decompose AirPassengers (additive) ---
decomp_add <- decompose(AirPassengers, type = "additive")
plot(decomp_add, xlab = "Year")

# --- 4.3 STL Decomposition (robust alternative) ---
stl_result <- stl(AirPassengers, s.window = "periodic")
plot(stl_result, main = "STL Decomposition of AirPassengers")


# =============================================================================
# 5. AUTOCORRELATION ANALYSIS
# =============================================================================

# --- 5.1 ACF (Autocorrelation Function) ---
# Measures correlation between a series and its lagged values
acf(AirPassengers, main = "ACF of AirPassengers")

# --- 5.2 PACF (Partial Autocorrelation Function) ---
# Measures correlation after removing intermediate lag effects
pacf(AirPassengers, main = "PACF of AirPassengers")

# ACF helps identify MA order (q)
# PACF helps identify AR order (p)


# =============================================================================
# 6. ARIMA MODELING
# =============================================================================

# install.packages("forecast")
library(forecast)

# --- 6.1 Automatic ARIMA model selection ---
auto_model <- auto.arima(AirPassengers)
summary(auto_model)

# --- 6.2 Diagnostic checking: residuals should be white noise ---
checkresiduals(auto_model)

# --- 6.3 Manual ARIMA specification ---
# ARIMA(p, d, q) where:
#   p = autoregressive order
#   d = degree of differencing
#   q = moving average order
manual_model <- arima(AirPassengers, order = c(1, 1, 1),
                      seasonal = list(order = c(1, 1, 1), period = 12))
summary(manual_model)


# =============================================================================
# 7. FORECASTING
# =============================================================================

# --- 7.1 Generate 24-month forecast ---
fc <- forecast(auto_model, h = 24)
plot(fc,
     main = "AirPassengers Forecast (24 Months)",
     xlab = "Year", ylab = "Passengers")

# --- 7.2 ggplot2-style forecast plot ---
autoplot(fc) +
  labs(title = "AirPassengers: ARIMA Forecast",
       x = "Year",
       y = "Number of Passengers") +
  theme_minimal()


# --- 7.3 Forecast accuracy evaluation ---

# Split into training and test sets
train <- window(AirPassengers, end = c(1958, 12))
test <- window(AirPassengers, start = c(1959, 1))

# Fit model on training data
train_model <- auto.arima(train)

# Forecast and evaluate
fc_test <- forecast(train_model, h = length(test))
accuracy(fc_test, test)

# Visualize forecast vs. actual
autoplot(fc_test) +
  autolayer(test, series = "Actual", color = "red") +
  labs(title = "Forecast vs. Actual: AirPassengers",
       x = "Year", y = "Passengers") +
  theme_minimal()
