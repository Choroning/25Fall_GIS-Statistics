# 수업 결과물

[레포지토리 안내](../README.ko.md) | [English](README.md) | [한국어](README.ko.md)

> **최종 수정일:** 2026-11-27

| 항목 | 내용 | 문서 |
|:-----|:-----|:-----|
| [HW02_Advanced-Visualization](HW02_Advanced-Visualization/) | 2차 과제. *Modern Data Visualization with R*의 5~8장에서 장마다 그림을 5개 이상 골라 R 코드를 실행하고, 콘솔과 Plots 창의 캡처를 보고서로 엮습니다. 그래프 유형의 개념은 [9장 고급 시각화](../Lecture-Notes/Ch09_Advanced-Visualization/Concepts_Lecture.ko.md)에 있고, R 코드가 읽는 자료는 `data/`에 있습니다 | [과제 안내문](HW02_Advanced-Visualization/Original/Assignment.ko.md), [과제 해설](HW02_Advanced-Visualization/Assignment-Explanation.ko.md), [코드 총정리](HW02_Advanced-Visualization/Code-Walkthrough.ko.md), [R 코드](HW02_Advanced-Visualization/Solution/HW_AdvancedVisualization.R) |
| [Lab02_Data-Structures](Lab02_Data-Structures/) | [2장 R의 데이터 구조](../Lecture-Notes/Ch02_Data-Structures/Concepts_Lecture.ko.md) 수업의 실습 코드. 변수와 기본 연산, 데이터 프레임, 내장 함수와 도움말, 벡터, 행렬, 배열, 리스트, 팩터를 차례로 만들고 확인하며, 숫자형과 팩터의 비교, 복합 데이터 구조 예제를 포함합니다 | [Lab_DataStructures.R](Lab02_Data-Structures/Lab_DataStructures.R) |
| [Lab03_Functions-and-Control-Flow](Lab03_Functions-and-Control-Flow/) | [3장 함수와 제어 흐름](../Lecture-Notes/Ch03_Functions-and-Control-Flow/Concepts_Lecture.ko.md) 수업의 실습 코드. 변수 할당, 내장 함수, 사용자 정의 함수, `print()`와 `cat()`, for 반복문, 티블과 정규화, 반복을 줄이는 `rescale` 함수, 비교와 논리 연산자, if-else 조건문, 클래스 확인을 다룹니다 | [Lab_FunctionsAndControlFlow.R](Lab03_Functions-and-Control-Flow/Lab_FunctionsAndControlFlow.R) |
| [Lab04_Data-Import-and-Export](Lab04_Data-Import-and-Export/) | [4장 데이터 입출력](../Lecture-Notes/Ch04_Data-Import-and-Export/Concepts_Lecture.ko.md) 수업의 실습 코드. 데이터를 직접 입력해 데이터 프레임을 만들고, `read.table()`과 `read.csv()`로 `data/`의 CSV와 TXT 파일을 읽습니다 | [Lab_DataIO.R](Lab04_Data-Import-and-Export/Lab_DataIO.R) |
| [Lab05_Data-Wrangling-and-Visualization](Lab05_Data-Wrangling-and-Visualization/) | [5장 dplyr을 활용한 데이터 가공](../Lecture-Notes/Ch05_Data-Wrangling-with-dplyr/Concepts_Lecture.ko.md)과 [6장 ggplot2를 활용한 데이터 시각화](../Lecture-Notes/Ch06_Data-Visualization-with-ggplot2/Concepts_Lecture.ko.md) 수업의 실습 코드. nycflights13과 mtcars 데이터로 dplyr의 `filter()`, `arrange()`, `select()`, `mutate()`, `summarise()`와 `group_by()`, 데이터 결합, ggplot2의 막대 그래프, 상자 그림, 산점도, 패싯, 기준선과 주석을 다룹니다 | [Lab_Visualization.R](Lab05_Data-Wrangling-and-Visualization/Lab_Visualization.R) |
| [Lab10_Regression-Analysis](Lab10_Regression-Analysis/) | [10장 회귀 분석](../Lecture-Notes/Ch10_Regression-Analysis/Concepts_Lecture.ko.md) 수업의 실습 코드. `HW02_Advanced-Visualization/data/`의 미국 주 shapefile과 문해율 CSV로 그린 단계구분도, 단순 선형 회귀, mtcars 다중 선형 회귀, 70:30 데이터 분할과 예측, 오차 지표(ME, MAE, RMSE, MAPE), 단계적 변수 선택, 잔차 진단 그래프를 다룹니다 | [Lab_RegressionAnalysis.R](Lab10_Regression-Analysis/Lab_RegressionAnalysis.R) |
| [Lab11_Time-Series-Analysis](Lab11_Time-Series-Analysis/) | [11장 시계열 분석](../Lecture-Notes/Ch11_Time-Series-Analysis/Concepts_Lecture.ko.md) 수업의 실습 코드. 날짜와 시간 객체(Date, POSIXct, POSIXlt), `ts` 객체, ggplot2 시계열 그래프, AirPassengers의 승법, 가법 분해와 STL 분해, ACF와 PACF, ARIMA 모형과 24개월 예측, 예측 정확도 평가를 다룹니다 | [Lab_TimeSeriesAnalysis.R](Lab11_Time-Series-Analysis/Lab_TimeSeriesAnalysis.R) |
| [Lab12_Logistic-Regression](Lab12_Logistic-Regression/) | [12장 로지스틱 회귀](../Lecture-Notes/Ch12_Logistic-Regression/Concepts_Lecture.ko.md) 수업의 실습 코드. mtcars로 단순, 다중 로지스틱 회귀를 적합하고 오즈비, 혼동 행렬과 성능 지표, ROC 곡선과 AUC, 최적 임계값, AIC와 우도비 검정에 의한 모형 비교를 다루며, iris로 다항 로지스틱 회귀를 실습합니다 | [Lab_LogisticRegression.R](Lab12_Logistic-Regression/Lab_LogisticRegression.R) |

실습 코드는 수업 중에 작성한 코드이며, 각 코드의 개념 설명은 행마다 연결한 장의 강의 노트에 있습니다.
