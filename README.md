
# 📊 COVID-19 Global Analysis Dashboard (SQL & Power BI) – March 2026

## ❓ The Problem

"At what point did global vaccination rollouts statistically decouple infection rates from mortality rates?"

The sheer volume of pandemic data made it difficult to see the "big picture." I built this project to move past raw numbers and answer:

The Efficacy Inflection: Can we visually identify the "Inversion Point" where rising vaccinations led to declining death trends?

Regional Disparity: Which continents faced the highest mortality rates relative to their population density?

Data Integrity: How do we calculate rolling totals across 200+ countries without double-counting continental aggregates included in the raw data?

---

## 📂 The Data

This project utilized the Our World in Data COVID-19 dataset, processed through a rigorous SQL-based ETL pipeline.

Data Engineering & Transformation (T-SQL):

Architecting Views: Created 4 specialized SQL Views to serve as a cleaned "Reporting Layer," significantly reducing Power BI refresh times.

Complex Aggregations: Utilized Window Functions (PARTITION BY) to calculate cumulative rolling totals of vaccinations over time.

Logic Layering: Employed CTEs (Common Table Expressions) and Temp Tables to perform secondary calculations on top of partitioned data, such as "Percentage of Population Vaccinated" per day.

Normalization: Filtered out "Continent" entries within the "Location" column to ensure country-level maps didn't inflate global totals.

---

## 📊 The Insights

The resulting Power BI dashboard transformed millions of rows of SQL data into three high-level insights:

The Vaccination Inversion: The trend lines clearly show a "decoupling" effect; as cumulative vaccinations crossed a specific threshold, the correlation between new cases and new deaths weakened significantly.

Mortality Hotspots: While Europe and North America had higher infection counts, the "Death per Case" ratio highlighted specific regions in South America and Africa with much higher fatality risks.

The Population Lead: Small-population countries reached "Infection Saturation" and "Vaccination Targets" much faster than larger nations, providing a blueprint for successful rollout logistics.

---

## 💡 The Conclusion

Based on the SQL-driven analysis and visual trends, the following data-driven conclusions were reached:

Policy Validation: The data confirms that vaccination penetration is a stronger predictor of survival than raw infection numbers, supporting continued "Booster" logistics.

Resource Allocation: Governments should use the "Fatality per Case" metric (rather than just raw case counts) to determine where medical oxygen and ICU resources are most critically needed.

Data Strategy: For future health crises, maintaining the SQL View architecture used here allows for real-time reporting that scales as new daily data is appended, without needing to rebuild the dashboard logic.

---
