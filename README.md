# [Fall 2025] Global Information Society and Creative Functions of Statistics

![Last Commit](https://img.shields.io/github/last-commit/Choroning/25Fall_GIS-Statistics)
![Languages](https://img.shields.io/github/languages/top/Choroning/25Fall_GIS-Statistics)

This repository archives bilingual lecture notes and coursework for the Global Information Society and Creative Functions of Statistics course.

*Author: Cheolwon Park (Korea University Sejong, CSE) - Year 2 (Sophomore) as of 2025*
<br><br>

## 📑 Table of Contents

- [About This Repository](#about-this-repository)
- [Course Information](#course-information)
- [Prerequisites](#prerequisites)
- [Repository Structure](#repository-structure)
- [License](#license)

---


<br><a name="about-this-repository"></a>
## 📝 About This Repository

This repository contains the lecture notes and R code of a university-level general education statistics course that uses R for data analysis, visualization, and statistical modeling.

- `Lecture-Notes/` holds lecture notes with comprehensive explanations of the statistical methods and R programming of each chapter. The lecture slides follow the textbook chapters, so the units are also numbered by chapter (`Ch##`). `Ch01`-`Ch05` cover the slides for textbook Chapters 1-6, `Ch06` covers Chapters 5-8 of *Modern Data Visualization with R* from Report 2, and `Ch07`-`Ch09` cover regression analysis, time series analysis, and logistic regression, which were taught from slides outside the textbook.
- Every lecture note comes as an English file (`.md`) and a Korean file (`.ko.md`) with the same structure.
- `Coursework/` holds R code that organizes the lecture demonstration code and assignment solutions by chapter. The lab code is in `Lab02`-`Lab05` and `Lab07`-`Lab09`, `HW02` is the visualization code written for Report 2, and Report 1, a paper summary report, is not included in this repository.
- The improved R code files carry **Doxygen-style headers** that document their purpose, usage, and structure.
- The sample datasets used in the exercises (CSV, TXT, and US Census shapefiles) are in the `data/` folder of the `Coursework` item that uses them. The R code reads the data through paths relative to the folder of the code file, so run it with that folder as the working directory.

> **🤖 AI Agent Usage**
> The grading criteria of both reports deducted 3 points for copying generative AI output as is. [Claude Code](https://claude.ai/download) was used to organize and translate the lecture notes and to restructure the repository.

<br><a name="course-information"></a>
## 📚 Course Information

- **Semester:** Fall 2025 (September - December)
- **Affiliation:** Korea University Sejong

| Course&nbsp;Code| Course            | Type          | Instructor      | Organized&nbsp;by                       |
|:----------:|:------------------|:-------------:|:---------------:|:----------------------------------------|
|`GSQR026-00`|GLOBAL INFORMATION SOCIETY AND CREATIVE FUNCTIONS OF STATISTICS|Core Liberal Arts|Prof. Heeyoung&nbsp;Kim|Institute for General Education, Sejong|

### Course Overview

A core liberal arts course for students new to statistics that teaches statistical analysis and graphing with R, summarizing real data and drawing graphs step by step alongside R exercises. Following the textbook *혼자 공부하는 R 데이터 분석* by Jeonhee Kang and Dongran Eom, it covers R data structures and programming, data import and processing, and visualization with ggplot2, and the lecture slides and reports add map visualization, regression analysis, time series analysis, and logistic regression. Excerpts from the designated books *AIQ* (Korean edition *수학의 쓸모*), *Factfulness*, and *Math on Trial* are read together in class. The instructor, schedule and class format, assessment, course policies, weekly plan and progress, and references are in the [course information document](Course-Information.md).

<br><a name="prerequisites"></a>
## ✅ Prerequisites

- There is no designated prerequisite course or enrollment requirement.
- A basic understanding of statistics concepts is required.
- An R interpreter must be installed.
- Familiarity with command-line tools or an IDE is required.

- **💻 Development Environment**

| Tool | Company |  OS  | Notes |
|:-----|:-------:|:----:|:------|
|RStudio|Posit PBC|macOS|Most used IDE|
|Visual Studio Code|Microsoft|macOS|With the R extension|

<br><a name="repository-structure"></a>
## 🗂 Repository Structure

```plaintext
25Fall_GIS-Statistics
├── Lecture-Notes               Lecture notes by chapter
├── Coursework                  Lab and assignment R code by chapter
├── Course-Information.ko.md    Course operations
├── Course-Information.md
├── LICENSE                     Documentation license (CC BY-NC-SA 4.0)
├── LICENSE-CODE                Code license (PolyForm Noncommercial 1.0.0)
├── README.ko.md
└── README.md
```

The CSV and TXT files for the data import exercises (`data_ex.csv`, `data_ex-1.txt`, `data_ex-2.txt`, `data_ex_col.txt`) are in `Coursework/Lab04_Data-Import-and-Export/data/`, and the US Census Bureau state boundary shapefile (`cb_2024_us_state_5m.*`) and the CSV of literacy rates by state (`us_literacy_rates_by_state_2025.csv`) are in `Coursework/HW02_Advanced-Visualization/data/`. The map code in `Lab07` reads the data in `HW02`.

The units are listed in the [`Lecture-Notes` index](Lecture-Notes/README.md), and the lab and assignment code in the [`Coursework` index](Coursework/README.md).

<br><a name="license"></a>
## 🤝 License

The documents in this repository (lecture notes, explanations, and summary sheets) are licensed under [CC BY-NC-SA 4.0](LICENSE), and the code under [PolyForm Noncommercial 1.0.0](LICENSE-CODE). Figures and example code taken from lecture slides and textbooks, as well as assignment handouts and template code distributed by the course, belong to their original authors and are not covered by these licenses.

---
