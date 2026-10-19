# 4장 — 데이터 입출력

[레포지토리 안내](../../README.ko.md) | [English](Concepts_Lecture.md) | [한국어](Concepts_Lecture.ko.md)

> **최종 수정일:** 2026-10-18
>
> 혼자 공부하는 R 데이터 분석, 강전희와 엄동란, Ch 4

> **학습 목표:**
> 1. 벡터로 데이터 프레임을 직접 만들고, CSV 파일과 텍스트 파일의 데이터를 R로 불러올 수 있다
> 2. 작업 디렉토리와 상대 경로를 사용하여 다른 컴퓨터에서도 동작하는 불러오기 코드를 작성할 수 있다
> 3. 불러온 데이터를 탐색 함수로 점검하고 흔한 불러오기 문제를 해결할 수 있다

---

## 목차

- [1. 수동 데이터 입력](#1-수동-데이터-입력)
  - [1.1 R에서 직접 데이터 생성](#11-r에서-직접-데이터-생성)
- [2. 외부 데이터 읽기](#2-외부-데이터-읽기)
  - [2.1 불러오기 함수 개요](#21-불러오기-함수-개요)
  - [2.2 read.table() 함수](#22-readtable-함수)
- [3. CSV 파일 읽기](#3-csv-파일-읽기)
  - [3.1 기본 CSV 불러오기](#31-기본-csv-불러오기)
  - [3.2 주요 매개변수](#32-주요-매개변수)
  - [3.3 파일 경로 고려사항](#33-파일-경로-고려사항)
- [4. 텍스트 파일 읽기](#4-텍스트-파일-읽기)
  - [4.1 탭 구분 파일 읽기](#41-탭-구분-파일-읽기)
  - [4.2 고정 폭 파일 읽기](#42-고정-폭-파일-읽기)
- [5. 작업 디렉토리](#5-작업-디렉토리)
  - [5.1 작업 디렉토리 확인 및 설정](#51-작업-디렉토리-확인-및-설정)
  - [5.2 모범 사례](#52-모범-사례)
- [6. 데이터 불러오기 후 탐색](#6-데이터-불러오기-후-탐색)
  - [6.1 유용한 탐색 함수](#61-유용한-탐색-함수)
  - [6.2 불러온 데이터의 일반적인 문제](#62-불러온-데이터의-일반적인-문제)
- [요약](#요약)
- [점검 문제](#점검-문제)

---

<br>

## 1. 수동 데이터 입력

### 1.1 R에서 직접 데이터 생성

외부 데이터를 불러오기 전에, 데이터 프레임을 수동으로 생성할 수 있다:

```r
ID <- c(1, 2, 3, 4, 5)
SEX <- c("F", "M", "F", "M", "F")
DATA <- data.frame(ID = ID, SEX = SEX)
View(DATA)   # 스프레드시트 뷰어에서 열기
```

`c()`로 만든 두 벡터를 `data.frame()`으로 묶으면 각 벡터가 하나의 열이 되어 5행 2열의 데이터 프레임이 만들어진다. `ID = ID`에서 등호 왼쪽은 열 이름이고 오른쪽은 그 열에 넣을 벡터이다.

> **핵심:** 수동 데이터 입력은 소규모 데이터셋이나 테스트 데이터를 만들 때 유용하지만, 실제 분석에서는 보통 외부 파일에서 데이터를 불러온다.

---

<br>

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

*표 1. 외부 데이터를 불러오는 R 함수*

`readxl::read_excel()`처럼 `패키지::함수` 형식으로 쓰면 `library()`로 패키지를 불러오지 않고도 그 패키지의 함수를 호출할 수 있다. 다만 패키지는 미리 설치되어 있어야 한다.

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

`read.table()`의 기본값은 `header = FALSE`, `sep = ""`, `dec = "."`이다. `sep = ""`는 공백이나 탭 같은 공백 문자가 하나 이상 이어진 곳을 구분자로 본다는 뜻이다.

---

<br>

## 3. CSV 파일 읽기

### 3.1 기본 CSV 불러오기

CSV(Comma-Separated Values)는 데이터 교환에 가장 일반적으로 사용되는 형식이다:

```r
# 헤더 행이 있는 CSV 파일 읽기
ex_data <- read.csv("data/data_ex.csv", header = TRUE)
View(ex_data)
```

`read.csv()`는 `read.table()`에 CSV에 맞는 기본값(`header = TRUE`, `sep = ","` 등)을 지정한 함수이므로, 위 코드의 `header = TRUE`는 기본값을 명시한 것이다.

### 3.2 주요 매개변수

```r
read.csv(
  file,                    # 파일 경로 (절대 경로 또는 상대 경로)
  header = TRUE,           # 첫 번째 행이 열 이름
  sep = ",",               # 구분자 (CSV의 경우 쉼표)
  stringsAsFactors = FALSE # 문자열을 팩터로 변환하지 않음
)
```

R 4.0.0부터 `stringsAsFactors`의 기본값은 `FALSE`이다. 이 인수는 이전 버전의 R에서도 같은 결과를 얻거나 의도를 분명히 하려고 지정한다.

### 3.3 파일 경로 고려사항

```r
# 절대 경로 (플랫폼에 따라 다름)
read.csv("/Users/username/Desktop/data_ex.csv", header = TRUE)

# 상대 경로 (작업 디렉토리 기준)
read.csv("data/data_ex.csv", header = TRUE)
```

상대 경로는 작업 디렉토리를 기준으로 해석된다. 작업 디렉토리가 `/Users/username/Desktop/project/`이면 `"data/data_ex.csv"`는 그림 1의 파일을 가리킨다.

```text
/Users/username/Desktop/project/   ← 작업 디렉토리 (getwd()의 결과)
└── data/
    ├── data_ex.csv                ← "data/data_ex.csv"가 가리키는 파일
    ├── data_ex-1.txt
    └── data_ex_col.txt
```

*그림 1. 작업 디렉토리를 기준으로 한 상대 경로의 해석*

> **핵심:** 상대 경로를 사용하면 다른 컴퓨터 간에 코드의 이식성이 높아진다. 작업 디렉토리를 프로젝트 루트로 설정하고 거기서부터 상대 경로를 사용하는 것이 좋다.

---

<br>

## 4. 텍스트 파일 읽기

### 4.1 탭 구분 파일 읽기

탭 구분 파일은 `read.table()`에 `sep = "\t"`를 지정하거나 `read.delim()`으로 읽는다. `read.delim()`은 `header = TRUE`, `sep = "\t"`가 기본값이다.

```r
# 적절한 구분자를 지정한 read.table()
data_txt <- read.table("data/data_ex-1.txt", header = TRUE, sep = "\t")

# 탭 구분 파일의 단축 함수인 read.delim()
data_txt <- read.delim("data/data_ex-1.txt", header = TRUE)
```

### 4.2 고정 폭 파일 읽기

`data_ex_col.txt`에는 열 이름 행이 없고 첫 행부터 자료가 들어 있다. 따라서 `header = FALSE`로 모든 행을 자료로 읽고, `col.names`로 열 이름을 지정한다. `header = TRUE`로 읽으면 첫 자료 행이 열 이름이 되어 자료가 한 행 줄어든다.

```r
# 열이 정렬된 텍스트 파일의 경우
data_col <- read.table("data/data_ex_col.txt", header = FALSE, col.names = c("ID", "SEX", "AGE", "AREA"))
```

> **주의:** `read.table()`은 기본값 `sep = ""`에서 공백 문자를 구분자로 쓰므로, 열 사이에 공백이나 탭이 있어 열이 정렬된 파일을 읽을 수 있다. 구분자 없이 글자 위치로만 열을 나누는 엄밀한 의미의 고정 폭 파일은 열 너비를 지정하는 `read.fwf()`로 읽는다.

---

<br>

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

`setwd()`로 작업 디렉토리를 바꾸면 그 뒤의 상대 경로는 새 작업 디렉토리를 기준으로 해석된다.

### 5.2 모범 사례

- RStudio 프로젝트(`.Rproj` 파일)를 사용하여 작업 디렉토리를 자동으로 관리한다.
- 스크립트에 절대 경로를 하드코딩하지 않는다.
- 견고한 경로 구성을 위해 `here` 패키지를 사용한다. `here()`는 `.Rproj` 파일 같은 표지로 찾은 프로젝트 루트를 기준으로 경로를 만들므로, 그 뒤에 작업 디렉토리가 바뀌어도 같은 파일을 가리킨다:
  ```r
  # install.packages("here")
  library(here)
  data <- read.csv(here("data", "data_ex.csv"))
  ```

---

<br>

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
| 인코딩 문제 | `encoding = "UTF-8"` 지정 (파일의 인코딩을 변환하며 읽으려면 `fileEncoding = "CP949"`처럼 지정) |
| 잘못된 구분자 | `readLines(file, n = 5)`로 원시 내용을 검사하여 확인 |

*표 2. 불러온 데이터의 흔한 문제와 해결 방법*

---

<br>

## 요약

| 개념 | 핵심 요약 |
|------|-----------|
| `data.frame()` | 벡터로부터 데이터 프레임을 직접 만든다. |
| `read.csv()` | 쉼표로 구분된 파일을 불러오며, `header = TRUE`(기본값)이면 첫 행을 열 이름으로 읽는다. |
| `read.table()` | 범용 텍스트 파일 읽기 함수이며, 구분자를 `sep`로 지정한다. |
| 작업 디렉토리 | `getwd()`로 확인하고 `setwd()`로 설정하며, 상대 경로를 쓰는 편이 좋다. |
| 데이터 점검 | 불러온 뒤에는 항상 `str()`, `summary()`, `head()`로 데이터를 확인한다. |
| `View()` | RStudio의 스프레드시트 뷰어에서 데이터를 연다. |
| 파일 경로 | 상대 경로는 절대 경로보다 이식성이 높다. |

---

<br>

## 점검 문제

1. **기본값 비교:** `read.csv()`와 `read.table()`의 `header`와 `sep` 기본값을 각각 쓰고, 쉼표로 구분되며 첫 행이 열 이름인 파일을 `read.table()`로 읽으려면 어떤 인수를 지정해야 하는지 쓰라.

   <details>
   <summary>정답</summary>

   `read.csv()`는 `header = TRUE`, `sep = ","`가 기본값이고, `read.table()`은 `header = FALSE`, `sep = ""`(공백 문자)가 기본값이다. 따라서 이 파일을 `read.table()`로 읽으려면 `header = TRUE, sep = ","`를 지정해야 한다.

   </details>

2. **상대 경로:** 작업 디렉토리가 `/Users/username/Desktop/project/`일 때 `read.csv("data/data_ex.csv")`가 읽는 파일의 절대 경로를 쓰고, 상대 경로가 절대 경로보다 이식성이 높은 이유를 설명하라.

   <details>
   <summary>정답</summary>

   읽는 파일은 `/Users/username/Desktop/project/data/data_ex.csv`이다. 상대 경로는 작업 디렉토리를 기준으로 해석되므로, 프로젝트 폴더를 다른 컴퓨터나 다른 위치로 옮겨도 작업 디렉토리만 프로젝트 루트로 맞추면 코드를 고치지 않고 실행할 수 있다. 절대 경로는 사용자 이름이나 폴더 구조가 다른 컴퓨터에서는 존재하지 않는 경로가 된다.

   </details>

3. **열 이름 행이 없는 파일:** 첫 행이 `1`, `F`, `50`, `서울`로 시작하는 10행 4열 파일 `data_ex_col.txt`를 `read.table("data/data_ex_col.txt", header = TRUE)`로 읽으면 결과가 어떻게 되는지 쓰고, 올바르게 읽는 코드를 쓰라.

   <details>
   <summary>정답</summary>

   첫 자료 행이 열 이름으로 쓰여 행이 9개만 남고, 열 이름은 `X1`, `F`, `X50`, `서울`이 된다. 숫자로 시작하는 이름은 R이 앞에 `X`를 붙여 유효한 이름으로 바꾸기 때문이다. 올바른 코드는 `read.table("data/data_ex_col.txt", header = FALSE, col.names = c("ID", "SEX", "AGE", "AREA"))`이며, 10행 4열의 데이터 프레임이 만들어진다.

   </details>

4. **불러온 데이터 점검:** 데이터 프레임 `data`를 불러온 뒤 (a) 행 수와 열 수, (b) 각 열의 자료형, (c) 전체 결측값 개수를 확인하는 함수 호출을 각각 쓰라.

   <details>
   <summary>정답</summary>

   (a)는 `dim(data)`이며, `nrow(data)`와 `ncol(data)`로 따로 확인할 수도 있다. (b)는 `str(data)`이며, 각 열의 자료형과 앞부분 값을 보여 준다. (c)는 `sum(is.na(data))`이며, `is.na()`가 만든 논리값에서 `TRUE`의 개수를 세어 결측값 개수를 구한다.

   </details>
