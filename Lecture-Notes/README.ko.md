# 강의 노트

[레포지토리 안내](../README.ko.md) | [English](README.md) | [한국어](README.ko.md)

> **최종 수정일:** 2026-11-27

## 교재 단원

| 단원 | 주제 | 문서 |
|:-----|:-----|:-----|
| [1장 R과 GIS 통계학 개론](Ch01_Introduction/) | R의 정의와 역사, R과 RStudio 설치, 할당 연산자와 데이터 유형, GIS와 통계 기법, GIS 통계를 위한 R 패키지, 빅데이터의 특성, R의 장점과 한계, RStudio 탭과 환경 설정, 도움말 문서 읽기, 특수값(NA, NaN, Inf, NULL), 부동소수점 비교, 연산자 우선순위, 오류와 경고, 벡터와 래스터 자료 모형, 좌표 참조 체계, sf 점 자료 | [강의 노트](Ch01_Introduction/Concepts_Lecture.ko.md) |
| [2장 R의 데이터 구조](Ch02_Data-Structures/) | 벡터, 행렬, 배열, 리스트, 데이터 프레임, 팩터, 유형 확인과 변환, 원자 벡터의 유형, 인덱싱, 재활용 규칙, 암묵적 형 변환, 행렬 연산, 리스트의 `[`와 `[[`, 데이터의 생김새, 티블과 데이터 프레임, 순서형 팩터, `cut()`, Date 클래스, 데이터 분석 과정 | [강의 노트](Ch02_Data-Structures/Concepts_Lecture.ko.md) |
| [3장 함수와 제어 흐름](Ch03_Functions-and-Control-Flow/) | 변수와 내장 함수, `print()`와 `cat()`, 사용자 정의 함수, 패키지, 티블과 결측값, 연산자, 조건문과 반복문, 인수 전달과 기본값, 문자열 만들기, 유효 범위, `stop()`과 `warning()`, 패키지 마스킹과 `::`, 결측값 판별, `&&`와 `\|\|`, `ifelse()`와 `switch()`, 이중 for문, `break`와 `next`, apply 계열 함수 | [강의 노트](Ch03_Functions-and-Control-Flow/Concepts_Lecture.ko.md) |
| [4장 데이터 입출력](Ch04_Data-Import-and-Export/) | 수동 데이터 입력, `read.table()`과 `read.csv()`, 텍스트 파일 읽기, 작업 디렉토리와 상대 경로, 불러온 데이터의 탐색, `read.table()`의 주요 인수, 문자 인코딩, readr의 열 사양, CSV와 RDS 저장, `read.fwf()`, Excel과 JSON, 기술 통계, 도수분포표와 교차표, 상관계수, base 그래픽 | [강의 노트](Ch04_Data-Import-and-Export/Concepts_Lecture.ko.md) |
| [5장 dplyr을 활용한 데이터 가공](Ch05_Data-Wrangling-with-dplyr/) | dplyr 동사와 파이프 연산자, 그룹별 요약, 데이터 결합과 기본 키 확인, `filter()`와 결측값, `select()` 도우미, 순위와 조건 함수, 그룹별 요약의 동작, `distinct()`와 `count()`, 표본 추출, 관계형 데이터와 키, 변경 조인과 필터링 조인, 정돈 데이터와 피벗, 결측값과 이상치 정제 | [강의 노트](Ch05_Data-Wrangling-with-dplyr/Concepts_Lecture.ko.md) |
| [6장 ggplot2를 활용한 데이터 시각화](Ch06_Data-Visualization-with-ggplot2/) | 그래픽 문법, 기본 그래프 유형, 미적 매핑, 패싯, 기준선과 주석, 층 문법의 구성 요소, 히스토그램, `geom_smooth()`, 전역 매핑과 지역 매핑, `facet_grid()`, `annotate()`와 `labs()`, 통계 변환과 위치 조정, 척도, 좌표계, 테마, 단계구분도 | [강의 노트](Ch06_Data-Visualization-with-ggplot2/Concepts_Lecture.ko.md) |

## 교재 밖 강의 단원

교재 밖의 강의자료와 과제 자료로 가르친 주제의 단원입니다.

| 단원 | 주제 | 문서 |
|:-----|:-----|:-----|
| [9장 고급 시각화](Ch09_Advanced-Visualization/) | 그룹화, 누적, 비율 막대 그래프와 레이블, 상자 그림과 violin plot, 평균과 표준 오차 그래프, 커널 밀도와 대역폭, 능선 그래프와 strip plot, Cleveland 점 그래프, 다변량 매핑과 패싯, mapview와 단계구분도, 단계구분도의 구간과 정규화, 시간 기반 시각화(dumbbell chart, 기울기 그래프, stream graph), 그래프의 선택과 흔한 실수 | [강의 노트](Ch09_Advanced-Visualization/Concepts_Lecture.ko.md) |
| [10장 회귀 분석](Ch10_Regression-Analysis/) | 단순 선형 회귀와 정규 방정식, 계수의 표준 오차와 신뢰 구간, t 검정, 예측 구간, 다중 선형 회귀와 가변수, 상호작용, 제곱합의 분해와 결정 계수, F 검정, 데이터 분할과 모형 평가 지표(RMSE, MAE), 잔차 진단과 Anscombe의 네 자료, 다중공선성과 VIF, 레버리지와 Cook의 거리, AIC와 변수 선택, 지리 데이터 회귀 | [강의 노트](Ch10_Regression-Analysis/Concepts_Lecture.ko.md) |
| [11장 시계열 분석](Ch11_Time-Series-Analysis/) | 시계열 자료의 특성, 날짜와 시간 객체, `ts` 객체, 확률 과정과 정상성, 차분과 단위근 검정, 표본 자기상관, ACF와 PACF, MA, AR, ARMA 모형의 성질, 가법 분해와 승법 분해, ARIMA와 계절 ARIMA, Box-Jenkins 절차와 Ljung-Box 검정, 예측과 예측 정확도 | [강의 노트](Ch11_Time-Series-Analysis/Concepts_Lecture.ko.md) |
| [12장 로지스틱 회귀](Ch12_Logistic-Regression/) | 선형 확률 모형과 일반화 선형 모형, 로지스틱 함수, 오즈와 로그 오즈, 최대 우도 추정과 IRLS, 이탈도, Wald 검정과 우도비 검정, 오즈비와 상대 위험, 사례-대조 연구, 혼동 행렬, ROC 곡선과 AUC, 임계값 선택, 다항 로지스틱 회귀 | [강의 노트](Ch12_Logistic-Regression/Concepts_Lecture.ko.md) |
| [13장 통계적 사고와 확률의 오류](Ch13_Statistical-Thinking-and-Probability-Fallacies/) | 통계적 사고(평균과 분포, 비율과 1인당 수치, 위험과 노출), 확률의 역사와 고전적 확률, 독립 사건과 점수 문제, 조건부 확률과 Bayes 정리, 검사의 오류와 기저율, Simpson의 역설(SAT, UC 버클리 입학), 생일 문제, DNA 무작위 일치 확률과 데이터베이스 검색 | [강의 노트](Ch13_Statistical-Thinking-and-Probability-Fallacies/Concepts_Lecture.ko.md) |

## 보충 단원

수업에서 다루지 않은 통계적 추론의 기초를 보충한 단원으로, 10~13장에 나오는 표준 오차, 신뢰 구간, 가설 검정, p값을 처음부터 설명합니다.

| 단원 | 주제 | 문서 |
|:-----|:-----|:-----|
| [14장 통계적 추론의 기초](Ch14_Foundations-of-Statistical-Inference/) | 표본 분포와 중심 극한 정리, 표준 오차, 신뢰 구간과 Bootstrap, 가설 검정과 p값, 제1종 오류와 제2종 오류, 검정력, t 검정과 일원 분산 분석, 카이제곱 검정과 두 비율의 비교, 상관 검정, p값의 오용과 다중 비교 | [강의 노트](Ch14_Foundations-of-Statistical-Inference/Concepts_Lecture.ko.md) |
