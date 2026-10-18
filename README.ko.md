# [2025학년도 가을학기] 글로벌정보사회와 통계의 창의적 기능

![Last Commit](https://img.shields.io/github/last-commit/Choroning/25Fall_GIS-Statistics)
![Languages](https://img.shields.io/github/languages/top/Choroning/25Fall_GIS-Statistics)

이 레포지토리는 글로벌정보사회와 통계의 창의적 기능 과목의 이중 언어 강의 노트와 수업 결과물을 정리한 아카이브입니다.

*작성자: 박철원 (고려대학교(세종), 컴퓨터소프트웨어학과) - 2025년 기준 2학년*
<br><br>

## 📑 목차

- [레포지토리 소개](#about-this-repository)
- [강의 정보](#course-information)
- [사전 요구사항](#prerequisites)
- [레포지토리 구조](#repository-structure)
- [라이선스](#license)

---


<br><a name="about-this-repository"></a>
## 📝 레포지토리 소개

이 레포지토리에는 R을 활용해 데이터 분석, 시각화, 통계 모형을 다루는 대학 교양 통계 과목의 강의 노트와 R 코드가 담겨 있습니다.

- `Lecture-Notes/`에는 장마다 통계 기법과 R 프로그래밍을 종합적으로 정리한 강의 노트가 있습니다. 강의자료가 교재의 장을 따라 진행되어 단원도 장 번호(`Ch##`)로 나눴습니다. `Ch01`\~`Ch05`는 교재 1\~6장의 강의자료를, `Ch06`은 2차 과제에서 다룬 *Modern Data Visualization with R*의 5\~8장을, `Ch07`\~`Ch09`는 교재 밖의 강의자료로 다룬 회귀 분석, 시계열 분석, 로지스틱 회귀를 정리했습니다.
- 모든 강의 노트는 영어 파일(`.md`)과 한국어 파일(`.ko.md`)이 같은 구성으로 짝을 이룹니다.
- `Coursework/`에는 강의 시연 코드와 과제 풀이를 장마다 정리한 R 코드가 있습니다. 실습 코드는 `Lab02`\~`Lab05`와 `Lab07`\~`Lab09`이고, `HW02`는 2차 과제에서 작성한 시각화 코드이며, 논문 요약 보고서인 1차 과제는 이 레포지토리에 포함되어 있지 않습니다.
- 개선된 R 코드 파일에는 목적, 사용법, 구조를 문서화한 **Doxygen 스타일 헤더**가 있습니다.
- 실습에 사용된 샘플 데이터셋(CSV, TXT, US Census shapefile)은 그 데이터를 쓰는 `Coursework` 항목 안의 `data/`에 있습니다. R 코드는 코드 파일이 있는 폴더를 기준으로 한 상대 경로로 데이터를 읽으므로, 그 폴더를 작업 디렉토리로 두고 실행합니다.

> **🤖 AI 에이전트 활용**
> 두 과제의 채점 기준은 생성형 AI의 결과를 그대로 베낀 경우 3점을 감점했습니다. 강의 노트의 정리와 번역, 레포지토리 구조 정리에는 [Claude Code](https://claude.ai/download)를 활용했습니다.

<br><a name="course-information"></a>
## 📚 강의 정보

- **학기:** 2025학년도 가을학기 (9월 - 12월)
- **소속:** 고려대학교(세종)

|학수번호      |강의명    |이수구분|교수자|개설기관|
|:----------:|:-------|:----:|:------:|:----------------|
|`GSQR026-00`|글로벌정보사회와통계의창의적기능|핵심교양|김희영 교수|세종교양교육원|

### 과목 개요

통계학을 처음 접하는 학생을 대상으로 R을 이용한 통계 분석과 그래프 작성을 익히는 핵심교양 과목으로, R 실습을 차근차근 병행하며 실제 데이터를 요약하고 그래프를 만든다. 강전희와 엄동란의 *혼자 공부하는 R 데이터 분석*을 교재로 R의 데이터 구조와 프로그래밍, 데이터 입출력과 가공, ggplot2 시각화를 배우고, 강의자료와 과제로 지도 시각화, 회귀 분석, 시계열 분석, 로지스틱 회귀를 다룬다. 지정 도서인 *수학의 쓸모*, *팩트풀니스*, *법정에 선 수학*은 수업 시간에 발췌하여 함께 다룬다. 교수자, 수업 일정과 형식, 평가, 수업 운영 규정, 주차별 계획 및 진도, 참고 자료는 [강의 정보 문서](Course-Information.ko.md)에 정리했다.

<br><a name="prerequisites"></a>
## ✅ 사전 요구사항

- 지정된 선수 과목이나 수강 요건은 없습니다.
- 통계 개념을 기본적으로 이해하고 있어야 합니다.
- R 인터프리터가 설치되어 있어야 합니다.
- 커맨드 라인 도구나 IDE 사용에 익숙해야 합니다.

- **💻 개발 환경**

| 도구 | 회사 |  운영체제  | 비고 |
|:-----|:-------:|:----:|:------|
|RStudio|Posit PBC|macOS|가장 많이 사용한 IDE|
|Visual Studio Code|Microsoft|macOS|R 확장 프로그램 사용|

<br><a name="repository-structure"></a>
## 🗂 레포지토리 구조

```plaintext
25Fall_GIS-Statistics
├── Lecture-Notes               장별 강의 노트
├── Coursework                  장별 실습 R 코드와 과제 코드
├── Course-Information.ko.md    수업 운영 정보
├── Course-Information.md
├── LICENSE                     문서 라이선스 (CC BY-NC-SA 4.0)
├── LICENSE-CODE                코드 라이선스 (PolyForm Noncommercial 1.0.0)
├── README.ko.md
└── README.md
```

데이터 불러오기 실습용 CSV와 TXT 파일(`data_ex.csv`, `data_ex-1.txt`, `data_ex-2.txt`, `data_ex_col.txt`)은 `Coursework/Lab04_Data-Import-and-Export/data/`에, 미국 인구조사국의 주 경계 shapefile(`cb_2024_us_state_5m.*`)과 주별 문해율 CSV(`us_literacy_rates_by_state_2025.csv`)는 `Coursework/HW02_Advanced-Visualization/data/`에 있습니다. `Lab07`의 지도 코드는 `HW02`의 데이터를 읽습니다.

단원 목록은 [`Lecture-Notes` 색인](Lecture-Notes/README.ko.md)에, 실습 코드와 과제 코드는 [`Coursework` 색인](Coursework/README.ko.md)에 있습니다.

<br><a name="license"></a>
## 🤝 라이선스

이 레포지토리의 문서(강의 노트, 해설, 요약지)는 [CC BY-NC-SA 4.0](LICENSE), 코드는 [PolyForm Noncommercial 1.0.0](LICENSE-CODE)에 따라 배포됩니다. 강의자료와 교재에서 가져온 그림과 예제 코드, 강의가 배포한 과제 원본과 템플릿 코드는 원저작자에게 권리가 있으며 이 라이선스의 대상이 아닙니다.

---
