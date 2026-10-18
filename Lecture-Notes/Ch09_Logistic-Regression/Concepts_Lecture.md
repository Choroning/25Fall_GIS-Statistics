# Chapter 9 — Logistic Regression

[Repository Guide](../../README.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **Last Updated:** 2026-10-18

> **Learning Objectives:**
> 1. Apply logistic regression for binary classification
> 2. Interpret odds ratios and log-odds coefficients
> 3. Evaluate classification models using confusion matrices and ROC curves
> 4. Classify three or more classes with multinomial logistic regression

---

## Table of Contents

- [1. Motivation: Classification vs Regression](#1-motivation-classification-vs-regression)
  - [1.1 Why Not Linear Regression for Classification?](#11-why-not-linear-regression-for-classification)
  - [1.2 The Classification Setting](#12-the-classification-setting)
- [2. The Logistic Function (Sigmoid)](#2-the-logistic-function-sigmoid)
  - [2.1 Definition](#21-definition)
  - [2.2 Properties](#22-properties)
  - [2.3 The Logistic Regression Model](#23-the-logistic-regression-model)
- [3. Odds and Log-Odds](#3-odds-and-log-odds)
  - [3.1 Odds](#31-odds)
  - [3.2 Log-Odds (Logit)](#32-log-odds-logit)
  - [3.3 Relationship Summary](#33-relationship-summary)
- [4. Maximum Likelihood Estimation](#4-maximum-likelihood-estimation)
  - [4.1 Why Not Least Squares?](#41-why-not-least-squares)
  - [4.2 The Likelihood Function](#42-the-likelihood-function)
  - [4.3 The Log-Likelihood](#43-the-log-likelihood)
  - [4.4 Implementation in R](#44-implementation-in-r)
- [5. Model Interpretation](#5-model-interpretation)
  - [5.1 Interpreting Coefficients](#51-interpreting-coefficients)
  - [5.2 Odds Ratios](#52-odds-ratios)
  - [5.3 Computing Odds Ratios in R](#53-computing-odds-ratios-in-r)
- [6. Model Evaluation](#6-model-evaluation)
  - [6.1 Predicted Classes](#61-predicted-classes)
  - [6.2 Confusion Matrix](#62-confusion-matrix)
  - [6.3 ROC Curve and AUC](#63-roc-curve-and-auc)
  - [6.4 ROC Curve in R](#64-roc-curve-in-r)
- [7. Multinomial Logistic Regression](#7-multinomial-logistic-regression)
  - [7.1 Extension to Multi-Class](#71-extension-to-multi-class)
  - [7.2 Predicted Probabilities](#72-predicted-probabilities)
  - [7.3 Implementation in R](#73-implementation-in-r)
- [Summary](#summary)
- [Self-Check Questions](#self-check-questions)

---

<br>

## 1. Motivation: Classification vs Regression

### 1.1 Why Not Linear Regression for Classification?

Linear regression, covered in Chapter 7, predicts a continuous response variable $Y \in (-\infty, +\infty)$. When the response is **binary** (e.g., Yes/No, 0/1), linear regression has critical limitations:

- Predicted values can fall **outside** the range $[0, 1]$, making them uninterpretable as probabilities.
- The linear model assumes a constant effect of predictors, which is unrealistic for bounded outcomes.
- Residuals are heteroscedastic and non-normal, violating OLS assumptions.

### 1.2 The Classification Setting

| Aspect | Regression | Classification |
|--------|-----------|----------------|
| Response variable | Continuous ($Y \in \mathbb{R}$) | Categorical (binary or multi-class) |
| Goal | Predict a numerical value | Predict a class label |
| Output | Point estimate | Probability of class membership |
| Example | House price prediction | Disease diagnosis (sick / healthy) |

*Table 1. Comparison of regression and classification problems*

Logistic regression bridges the gap: it uses a **regression framework** to solve a **classification problem** by modeling the probability that $Y$ belongs to a particular class.

---

<br>

## 2. The Logistic Function (Sigmoid)

### 2.1 Definition

The **logistic function** (also called the sigmoid function) maps any real-valued input to the interval $(0, 1)$:

$$\sigma(z) = \frac{1}{1 + e^{-z}}$$

Where $z = \beta_0 + \beta_1 X_1 + \beta_2 X_2 + \cdots + \beta_p X_p$ is the linear combination of predictors. Plotting $\sigma(z)$ rounded to one decimal place at the integers $z$ from -6 to 6 gives the following S-shaped curve.

```text
P(Y=1)
1.0 |                                     *   *   *   *
0.9 |                                 *
0.8 |
0.7 |                             *
0.6 |
0.5 |                         *
0.4 |
0.3 |                     *
0.2 |
0.1 |                 *
0.0 | *   *   *   *
    +----------------------------------------------------> z
     -6      -4      -2       0       2       4       6
```

*Figure 1. S-shaped curve of the sigmoid function*

### 2.2 Properties

| Property | Description |
|----------|-------------|
| Range | $(0, 1)$, always outputs a valid probability |
| Monotonicity | Strictly increasing |
| Symmetry | $\sigma(-z) = 1 - \sigma(z)$ |
| Midpoint | $\sigma(0) = 0.5$ |
| Derivative | $\sigma'(z) = \sigma(z)(1 - \sigma(z))$ |

*Table 2. Properties of the sigmoid function*

### 2.3 The Logistic Regression Model

The probability that the response equals 1 given the predictors is:

$$P(Y = 1 \mid X) = \frac{1}{1 + e^{-(\beta_0 + \beta_1 X_1 + \cdots + \beta_p X_p)}}$$

This ensures the predicted probability is always between 0 and 1, regardless of the predictor values.

---

<br>

## 3. Odds and Log-Odds

### 3.1 Odds

The **odds** of an event are defined as the ratio of the probability that the event occurs to the probability that it does not:

$$\text{Odds} = \frac{P(Y=1)}{P(Y=0)} = \frac{P(Y=1)}{1 - P(Y=1)}$$

- If $P = 0.8$, then $\text{Odds} = 0.8 / 0.2 = 4$. This means the event is 4 times as likely to occur as not to occur.
- Odds range from $0$ to $+\infty$.

### 3.2 Log-Odds (Logit)

Taking the natural logarithm of the odds yields the **logit** function:

$$\text{logit}(P) = \log\left(\frac{P}{1-P}\right) = \beta_0 + \beta_1 X_1 + \cdots + \beta_p X_p$$

This is the key transformation: while $P$ is bounded between 0 and 1, the log-odds are **unbounded** $(-\infty, +\infty)$, so they can be modeled as a linear function of the predictors.

### 3.3 Relationship Summary

$$X \xrightarrow{\text{linear combination}} z = \beta_0 + \beta X \xrightarrow{\text{sigmoid}} P = \sigma(z) \xrightarrow{\text{threshold}} \hat{Y} \in \{0, 1\}$$

That is, the linear combination $z$ of the predictors is passed through the sigmoid function to obtain the probability $P$, and $P$ is compared with a threshold to decide the predicted class $\hat{Y}$.

---

<br>

## 4. Maximum Likelihood Estimation

### 4.1 Why Not Least Squares?

Unlike linear regression, logistic regression does **not** use ordinary least squares (OLS) to estimate its coefficients because:
- The response is binary, not continuous.
- The relationship between predictors and $P(Y=1)$ is non-linear.
- Least squares does not produce meaningful estimates for probability models.

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

<br>

## 5. Model Interpretation

### 5.1 Interpreting Coefficients

In logistic regression, the coefficients represent the change in **log-odds** for a one-unit increase in the predictor:

$$\log\left(\frac{P}{1-P}\right) = \beta_0 + \beta_1 X_1$$

- $\beta_0$: The log-odds of $Y=1$ when all predictors equal zero.
- $\beta_k$: A one-unit increase in $X_k$ changes the log-odds by $\beta_k$ (holding other variables constant).

### 5.2 Odds Ratios

Exponentiating the coefficients gives the **odds ratio**:

$$\text{OR}_k = e^{\beta_k}$$

| $\beta_k$ | $e^{\beta_k}$ | Interpretation |
|-----------|---------------|----------------|
| Positive | $> 1$ | Predictor **increases** the odds of $Y=1$ |
| Zero | $= 1$ | Predictor has **no effect** |
| Negative | $< 1$ | Predictor **decreases** the odds of $Y=1$ |

*Table 3. Interpretation of the odds ratio by the sign of the coefficient*

For example, if $\beta_1 = 0.693$, then $e^{0.693} \approx 2.0$, meaning a one-unit increase in $X_1$ **doubles** the odds of $Y=1$. It is the odds, not the probability, that doubles.

### 5.3 Computing Odds Ratios in R

```r
# Get odds ratios with 95% confidence intervals
exp(coef(model))
exp(confint(model))
```

`coef(model)` gives the coefficients on the log-odds scale, so applying `exp()` yields the odds ratios, and applying `exp()` to both ends of the 95% confidence intervals of the coefficients from `confint(model)` yields 95% confidence intervals for the odds ratios.

---

<br>

## 6. Model Evaluation

### 6.1 Predicted Classes

A **decision threshold** (typically 0.5) converts predicted probabilities into class labels:

$$\hat{Y} = \begin{cases} 1 & \text{if } P(Y=1 \mid X) \geq 0.5 \\ 0 & \text{otherwise} \end{cases}$$

Changing the threshold changes the number of observations predicted as positive, and the ROC curve in Section 6.3 shows the performance at all thresholds at once.

### 6.2 Confusion Matrix

The confusion matrix summarizes classification performance:

|  | Predicted Positive | Predicted Negative |
|--|--------------------|--------------------|
| **Actual Positive** | True Positive (TP) | False Negative (FN) |
| **Actual Negative** | False Positive (FP) | True Negative (TN) |

*Table 4. Confusion matrix for binary classification*

Key metrics derived from the confusion matrix:

| Metric | Formula | Description |
|--------|---------|-------------|
| **Accuracy** | $\frac{TP + TN}{TP + TN + FP + FN}$ | Overall correct rate |
| **Sensitivity (Recall)** | $\frac{TP}{TP + FN}$ | True positive rate |
| **Specificity** | $\frac{TN}{TN + FP}$ | True negative rate |
| **Precision** | $\frac{TP}{TP + FP}$ | Positive predictive value |
| **F1 Score** | $\frac{2 \cdot \text{Precision} \cdot \text{Recall}}{\text{Precision} + \text{Recall}}$ | Harmonic mean of precision and recall |

*Table 5. Classification metrics derived from the confusion matrix*

### 6.3 ROC Curve and AUC

The **Receiver Operating Characteristic (ROC)** curve plots the True Positive Rate (Sensitivity) against the False Positive Rate (1 - Specificity) at various threshold values.

- A perfect classifier passes through the top-left corner (TPR = 1, FPR = 0).
- A random classifier follows the diagonal line.
- The **Area Under the Curve (AUC)** quantifies overall model performance as a value between 0 and 1, and a common rule of thumb is:

| AUC | Model Quality |
|-----|---------------|
| $[0.9, 1.0]$ | Excellent |
| $[0.8, 0.9)$ | Good |
| $[0.7, 0.8)$ | Fair |
| $[0.6, 0.7)$ | Poor |
| 0.5 | No discrimination (random) |

*Table 6. Rule of thumb for model quality by AUC*

### 6.4 ROC Curve in R

```r
library(pROC)
roc_obj <- roc(actual, predicted_prob)
plot(roc_obj, main = "ROC Curve", col = "blue", lwd = 2)
auc(roc_obj)
```

`roc()` computes the ROC curve from the actual classes and the predicted probabilities, and `auc()` computes the area under that curve.

---

<br>

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

> **Key Point:** The `multinom()` function from the `nnet` package fits multinomial logistic regression. Each non-reference class gets its own set of coefficients. `multinom()` uses the first level of the response factor (setosa in iris) as the reference category.

---

<br>

## Summary

| Concept | Key Summary |
|---------|-----------|
| Logistic regression | It models the probability of a binary outcome using the sigmoid function. |
| Sigmoid function | It is $\sigma(z) = \frac{1}{1 + e^{-z}}$ and maps $(-\infty, +\infty)$ to $(0, 1)$. |
| Odds | It is the ratio $P / (1-P)$ and ranges from $0$ to $+\infty$. |
| Log-odds (logit) | It is $\log(P/(1-P)) = \beta_0 + \beta X$, which is linear in the predictors. |
| Maximum likelihood | It finds $\hat{\beta}$ by maximizing $\ell(\beta) = \sum [y_i \log p_i + (1-y_i)\log(1-p_i)]$. |
| `glm()` | It is the R function for fitting logistic regression, used with `family = binomial`. |
| Odds ratio | It is $e^{\beta_k}$, the factor by which the odds are multiplied per unit increase in $X_k$. |
| Confusion matrix | It is a cross-tabulation of predicted and actual classes. |
| ROC curve | It plots TPR against FPR across thresholds and is summarized by the AUC. |
| Multinomial logistic | It extends the model to $K > 2$ classes using softmax and $K-1$ logit equations. |

---

<br>

## Self-Check Questions

1. **Probability and odds:** In a logistic regression with $\beta_0 = -3$ and $\beta_1 = 0.5$, find $P(Y=1)$, the odds, and the predicted class at threshold 0.5 when $X = 4$. For what value of $X$ is $P(Y=1) = 0.5$?

   <details>
   <summary>Answer</summary>

   $z = -3 + 0.5 \times 4 = -1$, so $P = 1/(1 + e^{1}) \approx 0.269$. The odds are $0.269/0.731 \approx 0.368$, which equals $e^{-1}$. Since $P < 0.5$, the predicted class is 0. $P = 0.5$ when $z = 0$, so $-3 + 0.5X = 0$ gives $X = 6$.

   </details>

2. **Odds ratio:** A predictor has the coefficient $\hat{\beta}_k = 0.405$. Find and interpret the odds ratio. By what factor do the odds change when this variable increases by 2 units?

   <details>
   <summary>Answer</summary>

   $e^{0.405} \approx 1.50$, so holding the other variables constant, a one-unit increase in this variable multiplies the odds of $Y=1$ by about 1.5 (a 50% increase). A two-unit increase multiplies them by $e^{0.81} = (e^{0.405})^2 \approx 2.25$.

   </details>

3. **Confusion matrix metrics:** For 200 observations with TP = 40, FN = 10, FP = 20, and TN = 130, find the accuracy, sensitivity, specificity, precision, and F1 score.

   <details>
   <summary>Answer</summary>

   Accuracy = (40 + 130)/200 = 0.85, sensitivity = 40/50 = 0.80, specificity = 130/150 ≈ 0.867, and precision = 40/60 ≈ 0.667. F1 = 2 × 0.667 × 0.80/(0.667 + 0.80) ≈ 0.727, which equals 2TP/(2TP + FP + FN) = 80/110.

   </details>

4. **Threshold and ROC:** How do sensitivity and specificity change when the decision threshold is lowered from 0.5 to 0.3? How are the ROC curve and the AUC related to this choice?

   <details>
   <summary>Answer</summary>

   More observations are predicted as positive, so TP rises and FN falls, and sensitivity rises or stays the same; FP rises and TN falls, so specificity falls or stays the same. The ROC curve connects the (FPR, TPR) points at all thresholds, so changing the threshold moves from one point on the curve to another. The AUC represents the overall discrimination performance, which does not depend on a particular threshold.

   </details>

5. **Multinomial logistic regression:** With 3 classes and 4 predictors, as in the iris data, how many coefficients does `multinom()` estimate in total? What is the reference category?

   <details>
   <summary>Answer</summary>

   For each of the $K - 1 = 2$ non-reference classes, it estimates an intercept and 4 predictor coefficients, so there are $2 \times (4 + 1) = 10$ coefficients. `multinom()` uses setosa, the first level of the factor, as the reference category and reports coefficients for versicolor and virginica.

   </details>
