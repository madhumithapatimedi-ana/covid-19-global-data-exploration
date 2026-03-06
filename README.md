
# 📊 COVID-19 Global Analysis Dashboard (SQL & Power BI) – Feb 2026

## 📌 Project Overview

This project is a comprehensive data exploration and visualization tool built using global COVID-19 datasets. The objective is to analyze the relationship between infection rates, mortality, and vaccination rollout across different continents and countries using **SQL Server** for data engineering and **Power BI** for interactive reporting.

The project transforms raw, messy data into actionable insights, specifically highlighting the "Inversion Point" where vaccination scales began to impact death trends.

---

## 🎯 Objectives

* **Analyze Mortality Trends:** Compare total cases vs. total deaths to calculate real-time fatality rates.
* **Track Vaccination Progress:** Visualize the rolling total of vaccinations and its impact on death declines.
* **Identify Global Hotspots:** Map countries with the highest infection rates relative to their population.
* **Normalize Regional Data:** Compare continent-level impacts while avoiding data double-counting.
* **Predictive Insights:** Use dynamic measures to see how vaccination penetration affects overall survival rates.

---

## 🛠 Tools & Features Used

* **Microsoft SQL Server (T-SQL):** For ETL and complex data joins.
* **Power BI Desktop:** For data modeling and dashboard creation.
* **SQL Views:** To centralize logic and optimize dashboard performance.
* **Window Functions:** Specifically `PARTITION BY` for rolling calculations.
* **CTE & Temp Tables:** To handle multi-layered data transformations.
* **DAX (Data Analysis Expressions):** For dynamic measures like Mortality Rate and Vax %.

---

## 🔢 Key SQL Logic Used

### 1️⃣ Window Functions (Rolling Totals)

Used to calculate the cumulative sum of vaccinations as they were administered over time.

Example:

```sql
SUM(CONVERT(bigint, vac.new_vaccinations)) OVER (PARTITION BY dea.Location ORDER BY dea.Date) AS RollingPeopleVaccinated

```

### 2️⃣ CTE (Common Table Expressions)

Used to perform secondary calculations on the rolling totals created in the previous step.

Example:

```sql
WITH PopvsVac AS ( ... ) 
SELECT *, ROUND((RollingPeopleVaccinated/Population)*100, 2) AS PercPplVaccinated
FROM PopvsVac

```

---

## 📊 Dashboard Features

* **Global KPI Cards:** Real-time display of Total Cases, Deaths, and Global Fatality Percentage.
* **Interactive Infection Map:** Bubble-size visualization of the "Highest Infection Count" by country.
* **Correlation Trend Lines:** Dual-axis charts comparing Daily Cases vs. Daily Vaccinations.
* **Continental Bar Charts:** Comparing the total death count across the six major continents.
* **Dynamic Slicers:** Filter the entire report by **Continent**, **Country**, or **Date Range**.

---

## 📂 Dataset Information

The dataset includes:

* **CovidDeaths:** Transactional data on new cases, deaths, and population metrics per country.
* **CovidVaccinations:** Daily tracking of new doses administered and cumulative vaccination totals.
* **Cleaned Views:** 4 specialized SQL Views (`Global_Stats`, `Continent_Deaths`, `Country_Infections`, `Vaccination_Timeline`) created to ensure the dashboard remains fast and accurate.

---

