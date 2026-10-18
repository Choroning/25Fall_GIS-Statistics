# @file    Lab_LogisticRegression.R
# @brief   Logistic regression examples in R: model fitting with glm(),
#          prediction, confusion matrix, ROC curve, and multinomial extension
# @author  Cheolwon Park
# @date    2025-12-15


# =============================================================================
# 0. PACKAGE SETUP
# =============================================================================

# install.packages("pROC")
# install.packages("nnet")
# install.packages("caret")
library(pROC)
library(nnet)
library(caret)
library(ggplot2)


# =============================================================================
# 1. DATA PREPARATION
# =============================================================================

# Using the built-in mtcars dataset
# Create binary response: am (0 = automatic, 1 = manual transmission)
data(mtcars)
str(mtcars)

# Select relevant predictors
df <- mtcars[, c("am", "mpg", "hp", "wt", "disp")]
df$am <- factor(df$am, levels = c(0, 1), labels = c("Automatic", "Manual"))
head(df)
table(df$am)

# --- 1.1 Partition data: 70% training, 30% validation ---
set.seed(42)
n <- nrow(df)
train_idx <- sample(1:n, round(0.7 * n))
train_data <- df[train_idx, ]
valid_data <- df[-train_idx, ]

cat("Training set size:", nrow(train_data), "\n")
cat("Validation set size:", nrow(valid_data), "\n")


# =============================================================================
# 2. SIMPLE LOGISTIC REGRESSION
# =============================================================================

# --- 2.1 Fit logistic regression with a single predictor ---
# Predict transmission type (am) from vehicle weight (wt)
simple_model <- glm(am ~ wt, data = train_data, family = binomial)
summary(simple_model)

# --- 2.2 Interpret coefficients ---
cat("\n--- Coefficients (log-odds scale) ---\n")
print(coef(simple_model))

cat("\n--- Odds Ratios ---\n")
print(exp(coef(simple_model)))

cat("\n--- 95% Confidence Intervals for Odds Ratios ---\n")
print(exp(confint(simple_model)))

# --- 2.3 Visualize the logistic curve ---
wt_range <- data.frame(wt = seq(min(df$wt), max(df$wt), length.out = 100))
wt_range$prob <- predict(simple_model, newdata = wt_range, type = "response")

ggplot() +
  geom_point(data = train_data,
             aes(x = wt, y = as.numeric(am) - 1),
             color = "steelblue", size = 2, alpha = 0.7) +
  geom_line(data = wt_range,
            aes(x = wt, y = prob),
            color = "red", linewidth = 1) +
  geom_hline(yintercept = 0.5, linetype = "dashed", color = "gray50") +
  labs(title = "Logistic Regression: Transmission Type vs Weight",
       x = "Weight (1000 lbs)",
       y = "P(Manual Transmission)") +
  theme_minimal()


# =============================================================================
# 3. MULTIPLE LOGISTIC REGRESSION
# =============================================================================

# --- 3.1 Fit model with multiple predictors ---
multi_model <- glm(am ~ mpg + hp + wt, data = train_data, family = binomial)
options(scipen = 999)
summary(multi_model)

# --- 3.2 Odds ratios for all predictors ---
cat("\n--- Odds Ratios (Multiple Model) ---\n")
odds_ratios <- exp(coef(multi_model))
print(odds_ratios)


# =============================================================================
# 4. PREDICTION AND CONFUSION MATRIX
# =============================================================================

# --- 4.1 Predict probabilities on validation set ---
pred_prob <- predict(multi_model, newdata = valid_data, type = "response")

# Display predicted probabilities alongside actual values
results <- data.frame(
  Actual = valid_data$am,
  Predicted_Prob = round(pred_prob, 4)
)
print(results)

# --- 4.2 Convert probabilities to class labels using 0.5 threshold ---
pred_class <- ifelse(pred_prob >= 0.5, "Manual", "Automatic")
pred_class <- factor(pred_class, levels = c("Automatic", "Manual"))

# --- 4.3 Confusion matrix ---
cat("\n--- Confusion Matrix ---\n")
cm <- table(Predicted = pred_class, Actual = valid_data$am)
print(cm)

# --- 4.4 Performance metrics ---
accuracy <- sum(diag(cm)) / sum(cm)
cat("\nAccuracy:", round(accuracy, 4), "\n")

# Using caret for detailed metrics
cat("\n--- Detailed Metrics (caret) ---\n")
confusionMatrix(pred_class, valid_data$am)


# =============================================================================
# 5. ROC CURVE AND AUC
# =============================================================================

# --- 5.1 Compute ROC curve ---
roc_obj <- roc(valid_data$am, pred_prob, levels = c("Automatic", "Manual"))
auc_value <- auc(roc_obj)
cat("\nAUC:", round(auc_value, 4), "\n")

# --- 5.2 Plot ROC curve ---
plot(roc_obj,
     main = paste("ROC Curve (AUC =", round(auc_value, 3), ")"),
     col = "blue",
     lwd = 2,
     print.auc = TRUE,
     print.auc.x = 0.4,
     print.auc.y = 0.3)
abline(a = 0, b = 1, lty = 2, col = "gray50")

# --- 5.3 ROC curve with ggplot2 ---
roc_df <- data.frame(
  FPR = 1 - roc_obj$specificities,
  TPR = roc_obj$sensitivities
)

ggplot(roc_df, aes(x = FPR, y = TPR)) +
  geom_line(color = "blue", linewidth = 1) +
  geom_abline(slope = 1, intercept = 0, linetype = "dashed", color = "gray50") +
  labs(title = paste("ROC Curve (AUC =", round(auc_value, 3), ")"),
       x = "False Positive Rate (1 - Specificity)",
       y = "True Positive Rate (Sensitivity)") +
  annotate("text", x = 0.6, y = 0.3,
           label = paste("AUC =", round(auc_value, 3)),
           size = 5, color = "blue") +
  theme_minimal()

# --- 5.4 Find optimal threshold ---
coords_best <- coords(roc_obj, "best", ret = c("threshold", "sensitivity", "specificity"))
cat("\nOptimal threshold:", round(coords_best$threshold, 4), "\n")
cat("Sensitivity at optimal:", round(coords_best$sensitivity, 4), "\n")
cat("Specificity at optimal:", round(coords_best$specificity, 4), "\n")


# =============================================================================
# 6. MODEL COMPARISON
# =============================================================================

# --- 6.1 Compare simple vs multiple model using AIC ---
cat("\n--- Model Comparison (AIC) ---\n")
cat("Simple model AIC:", AIC(simple_model), "\n")
cat("Multiple model AIC:", AIC(multi_model), "\n")
cat("Lower AIC indicates a better model.\n")

# --- 6.2 Likelihood ratio test ---
cat("\n--- Likelihood Ratio Test ---\n")
anova(simple_model, multi_model, test = "Chisq")


# =============================================================================
# 7. MULTINOMIAL LOGISTIC REGRESSION
# =============================================================================

# Using the iris dataset (3-class classification)
data(iris)

# --- 7.1 Partition iris data ---
set.seed(123)
iris_idx <- sample(1:nrow(iris), round(0.7 * nrow(iris)))
iris_train <- iris[iris_idx, ]
iris_valid <- iris[-iris_idx, ]

# --- 7.2 Fit multinomial logistic regression ---
multi_logit <- multinom(Species ~ ., data = iris_train, trace = FALSE)
summary(multi_logit)

# --- 7.3 Predict on validation set ---
iris_pred <- predict(multi_logit, newdata = iris_valid)

# --- 7.4 Confusion matrix for multinomial model ---
cat("\n--- Multinomial Confusion Matrix ---\n")
iris_cm <- table(Predicted = iris_pred, Actual = iris_valid$Species)
print(iris_cm)

iris_accuracy <- sum(diag(iris_cm)) / sum(iris_cm)
cat("Multinomial model accuracy:", round(iris_accuracy, 4), "\n")

# --- 7.5 Predicted probabilities ---
cat("\n--- Predicted Probabilities (first 5 observations) ---\n")
iris_probs <- predict(multi_logit, newdata = iris_valid[1:5, ], type = "probs")
print(round(iris_probs, 4))
