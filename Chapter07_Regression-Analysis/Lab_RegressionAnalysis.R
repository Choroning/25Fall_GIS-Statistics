# @file    Lab_RegressionAnalysis.R
# @brief   Multiple linear regression analysis with geographic data,
#          including choropleth mapping of US literacy rates and
#          model evaluation metrics
# @author  Cheolwon Park
# @date    2025-11-17


# =============================================================================
# 0. PACKAGE SETUP
# =============================================================================

# install.packages("tidyverse")
# install.packages("sf")
# install.packages("forecast")
library(tidyverse)
library(sf)
library(ggplot2)


# =============================================================================
# 1. GEOGRAPHIC DATA VISUALIZATION
# =============================================================================

# --- 1.1 Load US state shapefile ---
USMap <- st_read("data/cb_2024_us_state_5m.shp")

# --- 1.2 Load literacy rates data ---
litRates <- read.csv("data/us_literacy_rates_by_state_2025.csv")
str(litRates)
head(litRates)

# --- 1.3 Join spatial and attribute data ---
# Perform left join on state name to combine map geometry with rates
continentalUS <- USMap %>%
  left_join(litRates, by = c("NAME" = "State")) %>%
  filter(
    NAME != "Hawaii" &
      NAME != "Alaska" &
      NAME != "Puerto Rico" &
      !is.na(Rate)
  )

# --- 1.4 Choropleth map: US literacy rates ---
ggplot(continentalUS, aes(geometry = geometry, fill = Rate)) +
  geom_sf() +
  coord_sf() +
  scale_fill_gradient(low = "lightyellow", high = "darkred") +
  labs(title = "US Literacy Rates by State (2025)",
       fill = "Literacy Rate") +
  theme_minimal()


# =============================================================================
# 2. SIMPLE LINEAR REGRESSION EXAMPLE
# =============================================================================

# Using the built-in cars dataset: speed vs. stopping distance
data(cars)
str(cars)

# --- 2.1 Fit simple linear regression ---
# Response: dist (stopping distance)
# Predictor: speed
simple_model <- lm(dist ~ speed, data = cars)
summary(simple_model)

# --- 2.2 Visualize the regression line ---
ggplot(cars, aes(x = speed, y = dist)) +
  geom_point(color = "steelblue", size = 2) +
  geom_smooth(method = "lm", se = TRUE, color = "red") +
  labs(title = "Simple Linear Regression: Speed vs. Stopping Distance",
       x = "Speed (mph)",
       y = "Stopping Distance (ft)") +
  theme_minimal()


# =============================================================================
# 3. MULTIPLE LINEAR REGRESSION: mtcars EXAMPLE
# =============================================================================

# --- 3.1 Explore the dataset ---
data(mtcars)
str(mtcars)
head(mtcars)

# --- 3.2 Fit multiple linear regression ---
# Predict mpg using multiple predictors
multi_model <- lm(mpg ~ cyl + hp + wt + am, data = mtcars)
options(scipen = 999)   # Disable scientific notation
summary(multi_model)

# --- 3.3 Interpretation ---
# Estimate: coefficient values
# Std. Error: uncertainty in the estimates
# t value: test statistic (Estimate / Std. Error)
# Pr(>|t|): p-value for significance testing
# Multiple R-squared (R^2): proportion of variance explained
# Adjusted R-squared: R^2 adjusted for number of predictors


# =============================================================================
# 4. DATA PARTITIONING AND PREDICTION
# =============================================================================

# --- 4.1 Partition data: 70% training, 30% validation ---
set.seed(42)
n <- nrow(mtcars)
train_idx <- sample(1:n, round(0.7 * n))
train_data <- mtcars[train_idx, ]
valid_data <- mtcars[-train_idx, ]

# --- 4.2 Fit model on training data ---
train_model <- lm(mpg ~ cyl + hp + wt + am, data = train_data)
summary(train_model)

# --- 4.3 Predict on validation data ---
predictions <- predict(train_model, newdata = valid_data)

# --- 4.4 Calculate residuals ---
residuals <- valid_data$mpg - predictions

# Display predictions vs actuals
results <- data.frame(
  Predicted = round(predictions, 2),
  Actual = valid_data$mpg,
  Residual = round(residuals, 2)
)
print(results)


# =============================================================================
# 5. MODEL EVALUATION METRICS
# =============================================================================

# --- 5.1 Manual calculation of error metrics ---

# Mean Absolute Error (MAE)
mae <- mean(abs(residuals))
cat("MAE:", round(mae, 3), "\n")

# Mean Error (ME) - indicates bias
me <- mean(residuals)
cat("ME:", round(me, 3), "\n")

# Root Mean Squared Error (RMSE)
rmse <- sqrt(mean(residuals^2))
cat("RMSE:", round(rmse, 3), "\n")

# Mean Absolute Percentage Error (MAPE)
mape <- mean(abs(residuals / valid_data$mpg)) * 100
cat("MAPE:", round(mape, 3), "%\n")

# --- 5.2 Using forecast package ---
# install.packages("forecast")
library(forecast)
accuracy(predictions, valid_data$mpg)


# =============================================================================
# 6. VARIABLE SELECTION
# =============================================================================

# --- 6.1 Full model with all predictors ---
full_model <- lm(mpg ~ ., data = train_data)
summary(full_model)

# --- 6.2 Stepwise selection (both directions) ---
step_model <- step(full_model, direction = "both", trace = 0)
summary(step_model)
cat("\nSelected variables:", paste(names(coef(step_model))[-1], collapse = ", "), "\n")

# --- 6.3 Compare models ---
cat("\nFull model Adjusted R-squared:", summary(full_model)$adj.r.squared, "\n")
cat("Stepwise model Adjusted R-squared:", summary(step_model)$adj.r.squared, "\n")


# =============================================================================
# 7. DIAGNOSTIC PLOTS
# =============================================================================

# Residual diagnostic plots for the final model
par(mfrow = c(2, 2))
plot(step_model)
par(mfrow = c(1, 1))
