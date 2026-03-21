# Chapter 04 — 데이터 입출력

> **최종 수정일:** 2026-03-21

---

## 목차

1. [수동 데이터 입력](#1-수동-데이터-입력)
2. [외부 데이터 읽기](#2-외부-데이터-읽기)
3. [CSV 파일 읽기](#3-csv-파일-읽기)
4. [텍스트 파일 읽기](#4-텍스트-파일-읽기)
5. [작업 디렉토리](#5-작업-디렉토리)
6. [데이터 불러오기 후 탐색](#6-데이터-불러오기-후-탐색)
7. [요약](#요약)

---

## 1. 수동 데이터 입력

### 1.1 R에서 직접 데이터 생성

외부 데이터를 불러오기 전에, 데이터 프레임을 수동으로 생성할 수 있다:

```r
ID <- c(1, 2, 3, 4, 5)
SEX <- c("F", "M", "F", "M", "F")
DATA <- data.frame(ID = ID, SEX = SEX)
View(DATA)   # 스프레드시트 뷰어에서 열기
```

> **핵심 요점:** 수동 데이터 입력은 소규모 데이터셋이나 테스트 데이터를 만들 때 유용하지만, 실제 분석에서는 보통 외부 파일에서 데이터를 불러온다.

---

## 2. 외부 데이터 읽기

### 2.1 불러오기 함수 개요

R은 외부 데이터를 읽기 위한 여러 함수를 제공한다:

| 함수 | 파일 유형 | 패키지 |
|------|----------|--------|
| `read.csv()` | CSV (쉼표 구분) | base |
| `read.table()` | 일반 구분자 텍스트 | base |
| `read.delim()` | 탭 구분 텍스트 | base |
| `readxl::read_excel()` | Excel (.xlsx, .xls) | readxl |
| `readr::read_csv()` | CSV (더 빠름, tidyverse) | readr |

### 2.2 read.table() 함수

`read.table()`은 표 형태 데이터를 읽기 위한 가장 범용적인 함수이다:

```r
help(read.table)

# 주요 매개변수:
# file      - 파일 경로
# header    - 첫 번째 행이 열 이름을 포함하면 TRUE
# sep       - 필드 구분 문자
# dec       - 소수점 문자
```

---

## 3. CSV 파일 읽기

### 3.1 기본 CSV 불러오기

CSV(Comma-Separated Values)는 데이터 교환에 가장 일반적으로 사용되는 형식이다:

```r
# 헤더 행이 있는 CSV 파일 읽기
ex_data <- read.csv("data/data_ex.csv", header = TRUE)
View(ex_data)
```

### 3.2 주요 매개변수

```r
read.csv(
  file,                    # 파일 경로 (절대 경로 또는 상대 경로)
  header = TRUE,           # 첫 번째 행이 열 이름
  sep = ",",               # 구분자 (CSV의 경우 쉼표)
  stringsAsFactors = FALSE # 문자열을 팩터로 변환하지 않음
)
```

### 3.3 파일 경로 고려사항

```r
# 절대 경로 (플랫폼에 따라 다름)
read.csv("/Users/username/Desktop/data_ex.csv", header = TRUE)

# 상대 경로 (작업 디렉토리 기준)
read.csv("data/data_ex.csv", header = TRUE)
```

> **핵심 요점:** 상대 경로를 사용하면 다른 컴퓨터 간에 코드의 이식성이 높아진다. 작업 디렉토리를 프로젝트 루트로 설정하고 거기서부터 상대 경로를 사용하는 것이 좋다.

---

## 4. 텍스트 파일 읽기

### 4.1 탭 구분 파일 읽기

```r
# 적절한 구분자를 지정한 read.table()
data_txt <- read.table("data/data_ex-1.txt", header = TRUE, sep = "\t")

# 탭 구분 파일의 단축 함수인 read.delim()
data_txt <- read.delim("data/data_ex-1.txt", header = TRUE)
```

### 4.2 고정 폭 파일 읽기

```r
# 열이 정렬된 텍스트 파일의 경우
data_col <- read.table("data/data_ex_col.txt", header = TRUE)
```

---

## 5. 작업 디렉토리

### 5.1 작업 디렉토리 확인 및 설정

```r
# 현재 작업 디렉토리 확인
getwd()

# 작업 디렉토리 설정
setwd("/Users/username/Desktop/project/")

# 이제 상대 경로를 사용할 수 있다
data <- read.csv("data/data_ex.csv", header = TRUE)
```

### 5.2 모범 사례

- RStudio 프로젝트(`.Rproj` 파일)를 사용하여 작업 디렉토리를 자동으로 관리한다
- 스크립트에 절대 경로를 하드코딩하지 않는다
- 견고한 경로 구성을 위해 `here` 패키지를 사용한다:
  ```r
  # install.packages("here")
  library(here)
  data <- read.csv(here("data", "data_ex.csv"))
  ```

---

## 6. 데이터 불러오기 후 탐색

### 6.1 유용한 탐색 함수

데이터를 불러온 후에는 항상 데이터를 점검해야 한다:

```r
# 구조 및 요약
str(data)        # 구조의 간결한 표시
summary(data)    # 각 열의 통계 요약
head(data)       # 처음 6행
tail(data)       # 마지막 6행
dim(data)        # 차원 (행 x 열)
nrow(data)       # 행의 수
ncol(data)       # 열의 수
names(data)      # 열 이름
class(data)      # 객체 클래스

# 시각화
View(data)       # RStudio의 스프레드시트 뷰어
```

### 6.2 불러온 데이터의 일반적인 문제

| 문제 | 해결 방법 |
|------|----------|
| 잘못된 열 유형 | `stringsAsFactors = FALSE` 또는 `colClasses` 사용 |
| 결측값 | `sum(is.na(data))`로 확인 |
| 인코딩 문제 | `encoding = "UTF-8"` 지정 |
| 잘못된 구분자 | `readLines(file, n = 5)`로 원시 내용을 검사하여 확인 |

---

## 요약

| 개념 | 핵심 요점 |
|------|-----------|
| `data.frame()` | 벡터로부터 수동으로 데이터 프레임 생성 |
| `read.csv()` | 쉼표 구분 파일 불러오기; `header = TRUE` 사용 |
| `read.table()` | 범용 텍스트 파일 읽기 함수; `sep` 지정 |
| 작업 디렉토리 | `getwd()` / `setwd()` 사용; 상대 경로 권장 |
| 데이터 점검 | 불러온 후 항상 `str()`, `summary()`, `head()` 사용 |
| `View()` | RStudio의 스프레드시트 뷰어에서 데이터 열기 |
| 파일 경로 | 상대 경로가 절대 경로보다 이식성이 높다 |
