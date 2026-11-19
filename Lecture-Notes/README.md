# Lecture Notes

[Repository Guide](../README.md) | [English](README.md) | [한국어](README.ko.md)

> **Last Updated:** 2026-11-19

## Textbook Units

| Unit | Topics | Documents |
|:-----|:-----|:-----|
| [Chapter 1 Introduction to R and GIS Statistics](Ch01_Introduction/) | Definition and history of R, R and RStudio setup, assignment operators and data types, GIS and statistical methods, R packages for GIS statistics, characteristics of big data, strengths and limitations of R, RStudio tabs and settings, reading help pages, special values (NA, NaN, Inf, NULL), floating-point comparison, operator precedence, errors and warnings, vector and raster data models, coordinate reference systems, point data with sf | [Lecture notes](Ch01_Introduction/Concepts_Lecture.md) |
| [Chapter 2 Data Structures in R](Ch02_Data-Structures/) | Vectors, matrices, arrays, lists, data frames, factors, type checking and conversion, atomic vector types, indexing, the recycling rule, implicit coercion, matrix operations, `[` and `[[` on lists, the shape of data, tibbles and data frames, ordered factors, `cut()`, the Date class, the data analysis process | [Lecture notes](Ch02_Data-Structures/Concepts_Lecture.md) |
| [Chapter 3 Functions and Control Flow](Ch03_Functions-and-Control-Flow/) | Variables and built-in functions, `print()` and `cat()`, user-defined functions, packages, tibbles and missing values, operators, conditional statements and loops, argument passing and defaults, building strings, scope, `stop()` and `warning()`, package masking and `::`, detecting missing values, `&&` and `\|\|`, `ifelse()` and `switch()`, nested for loops, `break` and `next`, the apply family | [Lecture notes](Ch03_Functions-and-Control-Flow/Concepts_Lecture.md) |
| [Chapter 4 Data Import and Export](Ch04_Data-Import-and-Export/) | Manual data entry, `read.table()` and `read.csv()`, reading text files, working directories and relative paths, exploring imported data, main arguments of `read.table()`, character encoding, readr column specifications, saving CSV and RDS files, `read.fwf()`, Excel and JSON, descriptive statistics, frequency and contingency tables, the correlation coefficient, base graphics | [Lecture notes](Ch04_Data-Import-and-Export/Concepts_Lecture.md) |
| [Chapter 5 Data Wrangling with dplyr](Ch05_Data-Wrangling-with-dplyr/) | The dplyr verbs and the pipe operator, grouped summaries, joining data and checking primary keys, `filter()` and missing values, `select()` helpers, ranking and conditional functions, how grouped summaries work, `distinct()` and `count()`, sampling rows, relational data and keys, mutating and filtering joins, tidy data and pivoting, cleaning missing values and outliers | [Lecture notes](Ch05_Data-Wrangling-with-dplyr/Concepts_Lecture.md) |
| [Chapter 6 Data Visualization with ggplot2](Ch06_Data-Visualization-with-ggplot2/) | Grammar of graphics, basic plot types, aesthetic mappings, faceting, reference lines and annotations, components of the layered grammar, histograms, `geom_smooth()`, global and local mappings, `facet_grid()`, `annotate()` and `labs()`, statistical transformations and position adjustments, scales, coordinate systems, themes, choropleth maps | [Lecture notes](Ch06_Data-Visualization-with-ggplot2/Concepts_Lecture.md) |

## Lecture Units Beyond the Textbook

These units cover topics taught with lecture slides and assignment materials outside the textbook.

| Unit | Topics | Documents |
|:-----|:-----|:-----|
| [Chapter 9 Advanced Visualization](Ch09_Advanced-Visualization/) | Grouped, stacked, and segmented bar charts and labels, box plots and violin plots, mean and standard error plots, kernel density and bandwidth, ridgeline and strip plots, Cleveland dot charts, multivariate mappings and faceting, mapview and choropleth maps, class intervals and normalization in choropleth maps, time-based visualization (dumbbell charts, slope graphs, stream graphs), choosing a graph and common mistakes | [Lecture notes](Ch09_Advanced-Visualization/Concepts_Lecture.md) |
| [Chapter 10 Regression Analysis](Ch10_Regression-Analysis/) | Simple linear regression and the normal equations, standard errors and confidence intervals of coefficients, t tests, prediction intervals, multiple linear regression and dummy variables, interactions, the sum-of-squares decomposition and the coefficient of determination, the F test, data partitioning and model evaluation metrics (RMSE, MAE), residual diagnostics and Anscombe's quartet, multicollinearity and VIF, leverage and Cook's distance, AIC and variable selection, regression with geographic data | [Lecture notes](Ch10_Regression-Analysis/Concepts_Lecture.md) |
| [Chapter 11 Time Series Analysis](Ch11_Time-Series-Analysis/) | Characteristics of time series data, date and time objects, `ts` objects, stochastic processes and stationarity, differencing and unit root tests, sample autocorrelation, ACF and PACF, properties of MA, AR, and ARMA models, additive and multiplicative decomposition, ARIMA and seasonal ARIMA, the Box-Jenkins procedure and the Ljung-Box test, forecasting and forecast accuracy | [Lecture notes](Ch11_Time-Series-Analysis/Concepts_Lecture.md) |
| [Chapter 12 Logistic Regression](Ch12_Logistic-Regression/) | Linear probability models and generalized linear models, the logistic function, odds and log-odds, maximum likelihood estimation and IRLS, deviance, Wald and likelihood ratio tests, odds ratios and relative risk, case-control studies, confusion matrices, ROC curves and AUC, threshold selection, multinomial logistic regression | [Lecture notes](Ch12_Logistic-Regression/Concepts_Lecture.md) |
| [Chapter 13 Statistical Thinking and Probability Fallacies](Ch13_Statistical-Thinking-and-Probability-Fallacies/) | Statistical thinking (averages and distributions, rates and per-capita figures, risk and exposure), the history of probability and classical probability, independent events and the problem of the points, conditional probability and Bayes' theorem, the prosecutor's fallacy and base rates, Simpson's paradox (SAT, UC Berkeley admissions), the birthday problem, DNA random match probability and database searches | [Lecture notes](Ch13_Statistical-Thinking-and-Probability-Fallacies/Concepts_Lecture.md) |

## Supplementary Units

A unit that supplements the foundations of statistical inference, which the course did not cover, explaining from the beginning the standard errors, confidence intervals, hypothesis tests, and p-values that appear in Chapters 10-13.

| Unit | Topics | Documents |
|:-----|:-----|:-----|
| [Chapter 14 Foundations of Statistical Inference](Ch14_Foundations-of-Statistical-Inference/) | Sampling distributions and the central limit theorem, standard errors, confidence intervals and the bootstrap, hypothesis tests and p-values, type I and type II errors, power, t tests and one-way ANOVA, chi-square tests and comparing two proportions, correlation tests, misuse of p-values and multiple comparisons | [Lecture notes](Ch14_Foundations-of-Statistical-Inference/Concepts_Lecture.md) |
