# Chapter 09 -- Logistic Regression

> **Last Updated:** 2026-03-21

---

## Table of Contents

1. [Motivation: Classification vs Regression](#1-motivation-classification-vs-regression)
2. [The Logistic Function (Sigmoid)](#2-the-logistic-function-sigmoid)
3. [Odds and Log-Odds](#3-odds-and-log-odds)
4. [Maximum Likelihood Estimation](#4-maximum-likelihood-estimation)
5. [Model Interpretation](#5-model-interpretation)
6. [Model Evaluation](#6-model-evaluation)
7. [Multinomial Logistic Regression](#7-multinomial-logistic-regression)
8. [Summary](#summary)

---

## 1. Motivation: Classification vs Regression

### 1.1 Why Not Linear Regression for Classification?

Linear regression predicts a continuous response variable $Y \in (-\infty, +\infty)$. When the response is **binary** (e.g., Yes/No, 0/1), linear regression has critical limitations:

- Predicted values can fall **outside** the range $[0, 1]$, making them uninterpretable as probabilities
- The linear model assumes a constant effect of predictors, which is unrealistic for bounded outcomes
- Residuals are heteroscedastic and non-normal, violating OLS assumptions

### 1.2 The Classification Setting

| Aspect | Regression | Classification |
|--------|-----------|----------------|
| Response variable | Continuous ($Y \in \mathbb{R}$) | Categorical (binary or multi-class) |
| Goal | Predict a numerical value | Predict a class label |
| Output | Point estimate | Probability of class membership |
| Example | House price prediction | Disease diagnosis (sick / healthy) |

Logistic regression bridges the gap: it uses a **regression framework** to solve a **classification problem** by modeling the probability that $Y$ belongs to a particular class.

---

## 2. The Logistic Function (Sigmoid)

### 2.1 Definition

The **logistic function** (also called the sigmoid function) maps any real-valued input to the interval $(0, 1)$:

$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

Where $z = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \cdots + \beta_p X_p$ is the linear combination of predictors.

### 2.2 Properties

| Property | Description |
|----------|-------------|
| Range | $(0, 1)$ -- always outputs a valid probability |
| Monotonicity | Strictly increasing |
| Symmetry | $\sigma(-z) = 1 - \sigma(z)$ |
| Midpoint | $\sigma(0) = 0.5$ |
| Derivative | $\sigma'(z) = \sigma(z)(1 - \sigma(z))$ |

### 2.3 The Logistic Regression Model

The probability that the response equals 1 given the predictors is:

$$P(Y = 1 \mid X) = \frac{1}{1 + e^{-(\beta_0 + \beta_1 X_1 + \cdots + \beta_p X_p)}}$$

This ensures the predicted probability is always between 0 and 1, regardless of the predictor values.

---

## 3. Odds and Log-Odds

### 3.1 Odds

The **odds** of an event are defined as the ratio of the probability that the event occurs to the probability that it does not:

$$\text{Odds} = \frac{P(Y=1)}{P(Y=0)} = \frac{P(Y=1)}{1 - P(Y=1)}$$

- If $P = 0.8$, then $\text{Odds} = 0.8 / 0.2 = 4$ (the event is 4 times more likely to occur than not)
- Odds range from $0$ to $+\infty$

### 3.2 Log-Odds (Logit)

Taking the natural logarithm of the odds yields the **logit** function:

$$\text{logit}(P) = \log\left(\frac{P}{1-P}\right) = \beta_0 + \beta_1 X_1 + \cdots + \beta_p X_p$$

This is the key transformation: while $P$ is bounded between 0 and 1, the log-odds are **unbounded** $(-\infty, +\infty)$, allowing us to model them as a linear function of the predictors.

### 3.3 Relationship Summary

$$X \xrightarrow{\text{linear combination}} z = \beta_0 + \beta X \xrightarrow{\text{sigmoid}} P = \sigma(z) \xrightarrow{\text{threshold}} \hat{Y} \in \{0, 1\}$$

---

## 4. Maximum Likelihood Estimation

### 4.1 Why Not Least Squares?

Unlike linear regression, logistic regression **cannot** use ordinary least squares because:
- The response is binary, not continuous
- The relationship between predictors and $P(Y=1)$ is non-linear
- Least squares does not produce meaningful estimates for probability models

### 4.2 The Likelihood Function

For $n$ observations, the **likelihood** is the probability of observing the actual data given the model parameters:

$$L(\beta) = \prod_{i=1}^{n} P(Y_i = y_i \mid X_i) = \prod_{i=1}^{n} p_i^{y_i}(1 - p_i)^{1 - y_i}$$

Where $p_i = P(Y_i = 1 \mid X_i)$.

### 4.3 The Log-Likelihood

Taking the logarithm converts the product into a sum, which is easier to optimize:

$$\ell(\beta) = \sum_{i=1}^{n} \left[ y_i \log(p_i) + (1 - y_i) \log(1 - p_i) \right]$$

The MLE finds $\hat{\beta}$ that **maximizes** $\ell(\beta)$. This is solved iteratively using algorithms such as **Newton-Raphson** or **Iteratively Reweighted Least Squares (IRLS)**.

### 4.4 Implementation in R

```r
# Fit logistic regression using maximum likelihood
model <- glm(y ~ x1 + x2, data = mydata, family = binomial)
summary(model)
```

> **Key Point:** The `glm()` function with `family = binomial` uses MLE internally. The `summary()` output reports coefficients on the **log-odds** scale.

---

## 5. Model Interpretation

### 5.1 Interpreting Coefficients

In logistic regression, the coefficients represent the change in **log-odds** for a one-unit increase in the predictor:

$$\log\left(\frac{P}{1-P}\right) = \beta_0 + \beta_1 X_1$$

- $\beta_0$: The log-odds of $Y=1$ when all predictors equal zero
- $\beta_k$: A one-unit increase in $X_k$ changes the log-odds by $\beta_k$ (holding other variables constant)

### 5.2 Odds Ratios

Exponentiating the coefficients gives the **odds ratio**:

$$\text{OR}_k = e^{\beta_k}$$

| $\beta_k$ | $e^{\beta_k}$ | Interpretation |
|-----------|---------------|----------------|
| Positive | $> 1$ | Predictor **increases** the odds of $Y=1$ |
| Zero | $= 1$ | Predictor has **no effect** |
| Negative | $< 1$ | Predictor **decreases** the odds of $Y=1$ |

For example, if $\beta_1 = 0.693$, then $e^{0.693} = 2.0$, meaning a one-unit increase in $X_1$ **doubles** the odds of $Y=1$.

### 5.3 Computing Odds Ratios in R

```r
# Get odds ratios with 95% confidence intervals
exp(coef(model))
exp(confint(model))
```

---

## 6. Model Evaluation

### 6.1 Predicted Classes

A **decision threshold** (typically 0.5) converts predicted probabilities into class labels:

$$\hat{Y} = \begin{cases} 1 & \text{if } P(Y=1 \mid X) \geq 0.5 \\ 0 & \text{otherwise} \end{cases}$$

### 6.2 Confusion Matrix

The confusion matrix summarizes classification performance:

|  | Predicted Positive | Predicted Negative |
|--|--------------------|--------------------|
| **Actual Positive** | True Positive (TP) | False Negative (FN) |
| **Actual Negative** | False Positive (FP) | True Negative (TN) |

Key metrics derived from the confusion matrix:

| Metric | Formula | Description |
|--------|---------|-------------|
| **Accuracy** | $\frac{TP + TN}{TP + TN + FP + FN}$ | Overall correct rate |
| **Sensitivity (Recall)** | $\frac{TP}{TP + FN}$ | True positive rate |
| **Specificity** | $\frac{TN}{TN + FP}$ | True negative rate |
| **Precision** | $\frac{TP}{TP + FP}$ | Positive predictive value |
| **F1 Score** | $\frac{2 \cdot \text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}$ | Harmonic mean of precision and recall |

### 6.3 ROC Curve and AUC

The **Receiver Operating Characteristic (ROC)** curve plots the True Positive Rate (Sensitivity) against the False Positive Rate (1 - Specificity) at various threshold values.

- A perfect classifier follows the top-left corner (TPR = 1, FPR = 0)
- A random classifier follows the diagonal line
- The **Area Under the Curve (AUC)** quantifies overall model performance:

| AUC | Model Quality |
|-----|---------------|
| 0.9 -- 1.0 | Excellent |
| 0.8 -- 0.9 | Good |
| 0.7 -- 0.8 | Fair |
| 0.6 -- 0.7 | Poor |
| 0.5 | No discrimination (random) |

### 6.4 ROC Curve in R

```r
library(pROC)
roc_obj <- roc(actual, predicted_prob)
plot(roc_obj, main = "ROC Curve", col = "blue", lwd = 2)
auc(roc_obj)
```

---

## 7. Multinomial Logistic Regression

### 7.1 Extension to Multi-Class

When the response has more than two categories ($K > 2$), **multinomial logistic regression** generalizes the binary model. One category is designated as the **reference** (baseline), and the model estimates $K - 1$ sets of coefficients.

For category $k$ relative to the reference category $K$:

$$\log\left(\frac{P(Y = k)}{P(Y = K)}\right) = \beta_{k0} + \beta_{k1} X_1 + \cdots + \beta_{kp} X_p$$

### 7.2 Predicted Probabilities

The probability of each class is computed using the **softmax** function:

$$P(Y = k \mid X) = \frac{e^{z_k}}{\sum_{j=1}^{K} e^{z_j}}$$

Where $z_k = \beta_{k0} + \beta_{k1} X_1 + \cdots + \beta_{kp} X_p$ and $z_K = 0$ (reference category).

### 7.3 Implementation in R

```r
library(nnet)
multi_model <- multinom(Species ~ ., data = iris)
summary(multi_model)

# Predicted probabilities
predict(multi_model, newdata = iris[1:5, ], type = "probs")
```

> **Key Point:** The `multinom()` function from the `nnet` package fits multinomial logistic regression. Each non-reference class gets its own set of coefficients.

---

## Summary

| Concept | Key Point |
|---------|-----------|
| Logistic regression | Models the probability of a binary outcome using the sigmoid function |
| Sigmoid function | $\sigma(z) = \frac{1}{1 + e^{-z}}$; maps $(-\infty, +\infty)$ to $(0, 1)$ |
| Odds | Ratio $P / (1-P)$; ranges from $0$ to $+\infty$ |
| Log-odds (logit) | $\log(P/(1-P)) = \beta_0 + \beta X$; linear in predictors |
| Maximum likelihood | Finds $\hat{\beta}$ by maximizing $\ell(\beta) = \sum y_i \log p_i + (1-y_i)\log(1-p_i)$ |
| `glm()` | R function for logistic regression; use `family = binomial` |
| Odds ratio | $e^{\beta_k}$; multiplicative effect on odds per unit increase in $X_k$ |
| Confusion matrix | Cross-tabulation of predicted vs actual classes |
| ROC curve | Plots TPR vs FPR across thresholds; summarized by AUC |
| Multinomial logistic | Extension to $K > 2$ classes using softmax and $K-1$ logit equations |
