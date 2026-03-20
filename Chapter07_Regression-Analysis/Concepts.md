# Chapter 07 — Regression Analysis

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Introduction to Regression](#1-introduction-to-regression)
2. [Simple Linear Regression](#2-simple-linear-regression)
3. [Multiple Linear Regression](#3-multiple-linear-regression)
4. [Estimating the Regression Equation](#4-estimating-the-regression-equation)
5. [Model Evaluation Metrics](#5-model-evaluation-metrics)
6. [Variable Selection](#6-variable-selection)
7. [Regression with Geographic Data in R](#7-regression-with-geographic-data-in-r)
8. [Summary](#summary)

---

## 1. Introduction to Regression

### 1.1 What is Regression?

Regression analysis is a statistical method for modeling the relationship between a **dependent variable** (response, outcome) and one or more **independent variables** (predictors, features).

The goal is to:
- **Explanatory modeling**: Understand how predictors influence the response
- **Predictive modeling**: Forecast future values of the response

### 1.2 Types of Regression

| Type | Response Variable | Predictors | Example |
|------|-------------------|-----------|---------|
| Simple Linear | Continuous | One continuous | Sales ~ TV advertising |
| Multiple Linear | Continuous | Multiple | Price ~ Age + Mileage + HP |
| Logistic | Binary (0/1) | One or more | Disease ~ Risk factors |
| Polynomial | Continuous | Non-linear terms | Growth ~ Time + Time^2 |

---

## 2. Simple Linear Regression

### 2.1 The Model

Simple linear regression assumes a linear relationship between $X$ and $Y$:

$$Y \approx \beta_0 + \beta_1 X$$

Where:
- $\beta_0$ is the **intercept** (expected value of $Y$ when $X = 0$)
- $\beta_1$ is the **slope** (average change in $Y$ per one-unit increase in $X$)
- $\epsilon$ is the **error term** (captures noise and unmodeled effects)

The full statistical model is:

$$Y = \beta_0 + \beta_1 X + \epsilon$$

### 2.2 Estimating Coefficients (Least Squares)

The least squares method finds $\hat{\beta}_0$ and $\hat{\beta}_1$ that minimize the **Residual Sum of Squares (RSS)**:

$$RSS = \sum_{i=1}^{n} e_i^2 = \sum_{i=1}^{n} (y_i - \hat{y}_i)^2$$

Where $e_i = y_i - \hat{y}_i$ is the **residual** (difference between observed and predicted values).

The closed-form solutions are:

$$\hat{\beta}_1 = \frac{\sum_{i=1}^{n}(x_i - \bar{x})(y_i - \bar{y})}{\sum_{i=1}^{n}(x_i - \bar{x})^2}$$

$$\hat{\beta}_0 = \bar{y} - \hat{\beta}_1 \bar{x}$$

### 2.3 Implementation in R

```r
# Fit a simple linear regression
model <- lm(y ~ x, data = mydata)
summary(model)
```

> **Key Point:** The `lm()` function in R uses the formula notation `y ~ x` where `y` is the response variable and `x` is the predictor. The `~` symbol means "is modeled as a function of."

---

## 3. Multiple Linear Regression

### 3.1 The Model

Multiple linear regression extends SLR to multiple predictors:

$$Y = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \cdots + \beta_p X_p + \epsilon$$

### 3.2 Example: Toyota Corolla Price Prediction

A classic example involves predicting used car prices based on attributes:

| Variable | Description |
|----------|-------------|
| Price | Offer price in Euros (response) |
| Age | Age in months |
| Kilometers | Accumulated km on odometer |
| Fuel Type | Petrol, Diesel, CNG |
| HP | Horsepower |
| Metallic | Metallic color (Yes=1, No=0) |
| Automatic | Automatic transmission (Yes=1, No=0) |
| CC | Cylinder volume in cubic centimeters |
| Doors | Number of doors |
| QuartTax | Quarterly road tax in Euros |
| Weight | Weight in kilograms |

### 3.3 Data Partitioning

Before fitting a model, data is split into **training** and **validation** sets:

```r
# Partition data: 60% training, 40% validation
set.seed(1)
train.index <- sample(c(1:1000), 600)
train.df <- car.df[train.index, selected.var]
valid.df <- car.df[-train.index, selected.var]
```

### 3.4 Fitting in R

```r
# Use all remaining columns as predictors (. means "all other variables")
car.lm <- lm(Price ~ ., data = train.df)
options(scipen = 999)   # Disable scientific notation
summary(car.lm)
```

---

## 4. Estimating the Regression Equation

### 4.1 Interpreting the Output

The `summary()` output includes:

| Component | Description |
|-----------|-------------|
| **Estimate** | Estimated coefficient values ($\hat{\beta}_i$) |
| **Std. Error** | Standard error of the estimate |
| **t value** | Test statistic: $t_i = \hat{\beta}_i / se(\hat{\beta}_i)$ |
| **Pr(>\|t\|)** | p-value for two-sided hypothesis test |
| **Multiple R-squared** | $R^2$ — proportion of variance explained |
| **Adjusted R-squared** | $R^2_{adj}$ — adjusted for number of predictors |
| **F-statistic** | Overall significance test of the model |

### 4.2 Significance Codes

```
Signif. codes:  0 '***' 0.001 '**' 0.01 '*' 0.05 '.' 0.1 ' ' 1
```

A small p-value (< 0.05) indicates the predictor is **statistically significant**.

### 4.3 R-squared ($R^2$)

The coefficient of determination measures how well the model fits the data:

$$R^2 = 1 - \frac{RSS}{TSS} = 1 - \frac{\sum(y_i - \hat{y}_i)^2}{\sum(y_i - \bar{y})^2}$$

- $R^2 = 1$: Perfect fit
- $R^2 = 0$: Model explains nothing

The **adjusted** $R^2$ penalizes for adding unnecessary predictors:

$$R^2_{adj} = 1 - \frac{(1 - R^2)(n - 1)}{n - p - 1}$$

> **Key Point:** Always use Adjusted R-squared when comparing models with different numbers of predictors. Adding more variables always increases $R^2$ but may not improve the model.

---

## 5. Model Evaluation Metrics

### 5.1 Prediction and Residuals

```r
# Make predictions on validation set
car.lm.pred <- predict(car.lm, valid.df)

# Calculate residuals
some.residuals <- valid.df$Price[1:20] - car.lm.pred[1:20]
data.frame("Predicted" = car.lm.pred[1:20],
           "Actual" = valid.df$Price[1:20],
           "Residual" = some.residuals)
```

### 5.2 Common Accuracy Measures

| Metric | Formula | Interpretation |
|--------|---------|----------------|
| **MAE** | $\frac{1}{n}\sum\|e_i\|$ | Average absolute error magnitude |
| **ME** | $\frac{1}{n}\sum e_i$ | Average error (shows bias direction) |
| **MPE** | $100 \times \frac{1}{n}\sum \frac{e_i}{y_i}$ | Percentage error with direction |
| **MAPE** | $100 \times \frac{1}{n}\sum \frac{\|e_i\|}{y_i}$ | Average percentage deviation |
| **RMSE** | $\sqrt{\frac{1}{n}\sum e_i^2}$ | Root mean squared error (same units as Y) |

```r
library(forecast)
accuracy(car.lm.pred, valid.df$Price)
#         ME     RMSE      MAE       MPE     MAPE
# 19.62  1325.24  1048.60  -0.75    9.35
```

> **Key Point:** RMSE is the most commonly used metric because it has the same units as the response variable and penalizes large errors more heavily than MAE.

---

## 6. Variable Selection

### 6.1 Why Select Variables?

Not all predictors contribute meaningfully to the model. Including irrelevant variables can:
- Increase model complexity without improving accuracy
- Lead to **overfitting** (model memorizes training data but fails on new data)
- Reduce interpretability

### 6.2 Methods

| Method | Description |
|--------|-------------|
| **Forward Selection** | Start empty; add variables one at a time |
| **Backward Elimination** | Start with all; remove variables one at a time |
| **Stepwise** | Combination of forward and backward |
| **Best Subset** | Evaluate all possible combinations |

### 6.3 Implementation in R

```r
# Stepwise regression using AIC criterion
step(car.lm, direction = "both")

# Backward elimination
step(car.lm, direction = "backward")

# Forward selection
step(lm(Price ~ 1, data = train.df),
     scope = formula(car.lm),
     direction = "forward")
```

---

## 7. Regression with Geographic Data in R

### 7.1 US Literacy Rate Choropleth with Regression

The HW2 assignment combines geographic visualization with statistical analysis:

```r
library(tidyverse)
library(sf)

# Load US state shapefile
USMap <- st_read("data/cb_2024_us_state_5m.shp")

# Load literacy rate data
litRates <- read.csv("data/us_literacy_rates_by_state_2025.csv")

# Join spatial and attribute data
continentalUS <- USMap %>%
  left_join(litRates, by = c("NAME" = "State")) %>%
  filter(NAME != "Hawaii" & NAME != "Alaska" &
         NAME != "Puerto Rico" & !is.na(Rate))

# Create choropleth map
ggplot(continentalUS, aes(geometry = geometry, fill = Rate)) +
  geom_sf() +
  coord_sf()
```

### 7.2 Spatial Data Concepts

| Concept | Description |
|---------|-------------|
| Shapefile | Vector format storing geographic features (.shp, .dbf, .shx, .prj) |
| CRS | Coordinate Reference System (e.g., EPSG:4326 for WGS84) |
| `sf` | Simple Features package for spatial data in R |
| `st_read()` | Read shapefile into R as an sf object |
| `geom_sf()` | ggplot2 geometry for spatial data |

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Linear regression | Models linear relationship: $Y = \beta_0 + \beta_1 X + \epsilon$ |
| Least squares | Minimizes sum of squared residuals (RSS) |
| `lm()` | R function for fitting linear models; formula: `y ~ x` |
| `summary()` | Shows coefficients, significance, $R^2$, F-statistic |
| $R^2$ | Proportion of variance explained; use adjusted $R^2$ for comparison |
| Residual | $e_i = y_i - \hat{y}_i$ (actual minus predicted) |
| RMSE | Root mean squared error; same units as response variable |
| Data partitioning | Split into training (60%) and validation (40%) sets |
| Variable selection | Forward, backward, stepwise methods to choose best predictors |
| Geographic regression | Combine `sf` spatial data with `lm()` for spatial analysis |
