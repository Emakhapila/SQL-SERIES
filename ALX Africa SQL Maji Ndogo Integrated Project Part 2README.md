Maji Ndogo Water Services: Strategic Water Access Optimization (SQL Case Study)


Executive Summary: Informing Strategic Investment


The goal of this comprehensive SQL-based consulting project is to evaluate and improve the Republic of Maji Ndogo's water infrastructure and operational effectiveness. 
The main goal was to give the MD Water Services board practical insights to maximize resource allocation, reduce public health hazards (pollution), and expedite service delivery times 
by utilizing sophisticated SQL analytics against extensive, multi-table survey data.

A clear, phased repair strategy centered on improving high-impact water sources and resolving crucial operational bottlenecks was provided by the analysis, 
which also developed a strong data governance framework.

## Business Problem

Access to clean, reliable water remains a critical challenge in Maji Ndogo.  
Government stakeholders require a **data-driven assessment** to identify:
- Areas with inadequate infrastructure
- Sources vulnerable to contamination
- Regions under population stress
- Queue time bottlenecks
- Opportunities for targeted interventions

---

## Analytical Approach

Using SQL, the project:
- Standardized and cleaned survey data
- Assessed water source distribution by type, town, and province
- Evaluated contamination patterns across source types
- Measured population reliance on shared infrastructure
- Analyzed queue times by day and time
- Reviewed survey coverage and employee performance

---

## Key Findings

### 1. Water Source Distribution

- **Total sources**: 39,650
- **Most common type**: Wells (17,383), but shared taps serve the largest population (~40M).
- **Provincial disparities**: Kilimani leads in source availability (15,271), while Hawassa lags (8,844).
- **Town-level**: Rural areas dominate in both number of sources and population served.

### 2. Water Quality

- **Contamination risks**: Shared taps and rivers show the highest vulnerability to coliform and E. coli.
- **Wells**: Only 28% are clean; majority require filtration or remediation.

### 3. Queue Times

- Citizens face **average wait times > 120 minutes**.
- **Peak queues**: Saturdays, mornings, and evenings.
- **Shortest queues**: Wednesdays and Sundays.
- UN standards recommend < 30 minutes — Maji Ndogo exceeds this by 4x.

### 4. Infrastructure Reliability

- 31% of citizens have taps at home, but **45% of these systems are non-functional** due to broken pipes, pumps, and reservoirs.
- Shared taps are overcrowded, with **~2000 people per tap** on average.

### 5. Workforce & Coverage

- Rural areas are well-documented, ensuring reliable data integrity.
- Top-performing surveyors contributed thousands of visits, enabling robust analysis.

---

## Strategic Recommendations

### Priority Actions

1. **Shared Taps**  
   - Short-term: Deploy water tankers to busiest taps at peak times.  
   - Medium-term: Install additional taps to reduce queues.
   - Long-term: Transition toward household taps where feasible.

2. **Wells**  
   - Install **UV filters** for biological contamination.  
   - Use **reverse osmosis filters** for polluted wells.  
   - Investigate root causes of pollution for sustainable solutions.

3. **Broken Infrastructure**  
   - Repair reservoirs and pipes to restore multiple taps at once.  
   - High-cost but high-impact interventions.

4. **Rivers**
  
   - Short-term: Dispatch water trucks.  
   - Long-term: Drill wells to replace unsafe river reliance.

### Operational Considerations

- **Rural focus**: 60% of sources are rural, requiring logistical planning for road access, supplies, and labor.  
- **Queue management**: Aim to reduce wait times below **30 minutes**, aligning with UN standards.  
- **Resource allocation**: Prioritize interventions that benefit the largest populations first.

---

## Skills Demonstrated

- SQL schema creation & cleaning
- Aggregations & GROUP BY
- JOINs across multiple tables
- Queue time analysis with pivot-style queries
- Insight generation & business storytelling
- Translating technical results into strategic recommendations

---

## Example Query
```sql
-- Queue time analysis by day of week
SELECT DAYNAME(visit_time) AS day,
       AVG(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS avg_queue_minutes
FROM visits
GROUP BY day
ORDER BY avg_queue_minutes DESC;

Technical Governance & Methodology

This project is a demonstrator of robust SQL data preparation and analytical modeling, designed for seamless deployment and auditing.

Technical Approach

SQL Techniques Used

Grouping & aggregations
Time-based analysis using HOUR() & DAYNAME()
Joining multiple relational tables
Calculating population distributions
Creating pivot-style summaries
Data cleaning & validation checks
Identifying infrastructure issues through visit patterns
Detecting anomalies in usage

Tools

MySQL / SQL Server

Jupyter Notebook for validation & exploration

Python (pandas, matplotlib) for supplementary insights

