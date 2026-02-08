# Hospital Management System - SQL Analysis Project
**Database Development with PL/SQL (INSY 8311)**

---

## 👨‍🎓 Student Information
- **Name:** Adrien Hategekimana
- **Student ID:** 28955
- **Group:**  D
- **Course:** INSY 8311 - Database Development with PL/SQL
- **Instructor:** Eric Maniraguha
- **Submission Date:** February 8, 2026

---

## 📋 Table of Contents
1. [Business Problem](#business-problem)
2. [Success Criteria](#success-criteria)
3. [Database Schema](#database-schema)
4. [SQL Implementation](#sql-implementation)
5. [Key Insights & Analysis](#key-insights--analysis)
6. [Conclusions & Recommendations](#conclusions--recommendations)
7. [References](#references)
8. [Academic Integrity Statement](#academic-integrity-statement)

---

## 🏥 Business Problem

### Business Context
A multi-branch hospital network operating across different regions in Rwanda (Kigali, Eastern, Southern, Northern, and Western provinces) manages patient records, doctor appointments, and medical treatments across various departments including Internal Medicine, Pediatrics, Surgery, and Outpatient services.

### Data Challenge
The hospital management faces critical operational challenges:
- Difficulty identifying top-performing doctors and high-revenue departments
- Lack of visibility into patient visit patterns and appointment trends
- No systematic approach to patient segmentation for targeted healthcare programs
- Inability to track month-over-month growth in patient visits and revenue
- Missing insights on inactive patients who registered but never utilized services

### Expected Outcome
Through comprehensive SQL analysis using JOINs and Window Functions, this project aims to deliver:
- Identification of high-performing doctors and revenue-generating departments
- Patient segmentation for personalized healthcare marketing campaigns
- Monthly trend analysis for resource planning and staff scheduling
- Inactive patient identification for re-engagement initiatives
- Data-driven recommendations for improving hospital operations and patient care quality

---

## ✅ Success Criteria

This analysis achieves five measurable goals using SQL Window Functions:

1. **Top Doctors Ranking per Department** → Using `RANK()`, `ROW_NUMBER()`, `DENSE_RANK()`
   - Identify top 5 doctors by revenue generation for performance evaluation

2. **Running Monthly Revenue Totals** → Using `SUM() OVER()`
   - Calculate cumulative revenue to track progress toward annual targets

3. **Month-over-Month Growth Analysis** → Using `LAG()` / `LEAD()`
   - Measure percentage change in patient visits and revenue between consecutive months

4. **Patient Spending Segmentation** → Using `NTILE(4)`
   - Divide patients into quartiles (VIP, Gold, Silver, Bronze) for targeted marketing

5. **Three-Month Moving Average** → Using `AVG() OVER()`
   - Smooth revenue fluctuations to identify true trends vs. seasonal spikes

---

## 🗄️ Database Schema

### Entity-Relationship Diagram


### Table Structures

#### **Table 1: Patients**
Stores patient demographic and registration information.
```sql
CREATE TABLE Patients (
    patient_id INT PRIMARY KEY,
    patient_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    region VARCHAR(50),
    registration_date DATE
);
```

**Sample Data:** 8 patients across 5 regions (Kigali, Eastern, Southern, Northern, Western)

---

#### **Table 2: Doctors**
Contains doctor profiles including specialization and department.
```sql
CREATE TABLE Doctors (
    doctor_id INT PRIMARY KEY,
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50),
    department VARCHAR(50),
    hire_date DATE
);
```

**Sample Data:** 7 doctors across 4 departments (Internal Medicine, Pediatrics, Surgery, Outpatient)

---

#### **Table 3: Appointments**
Records all patient-doctor appointments with treatment details.
```sql
CREATE TABLE Appointments (
    appointment_id INT PRIMARY KEY,
    patient_id INT,
    doctor_id INT,
    appointment_date DATE,
    treatment_type VARCHAR(100),
    treatment_cost DECIMAL(10, 2),
    status VARCHAR(20),
    FOREIGN KEY (patient_id) REFERENCES Patients(patient_id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(doctor_id)
);
```

**Sample Data:** 15 completed appointments from January to May 2025

---

### Data Verification


**Data Summary:**
- Total Patients: 8
- Total Doctors: 7
- Total Appointments: 15
- Total Revenue: RWF 1,035,000
- Date Range: January 2025 - May 2025

---

## 🔗 SQL Implementation

### PART A: SQL JOINs

#### 1. INNER JOIN - All Appointments with Patient & Doctor Details

**Purpose:** Retrieve complete information for all valid appointments
```sql
-- INNER JOIN: All appointments with patient and doctor details
SELECT 
    a.appointment_id,
    p.patient_name,
    p.region AS patient_region,
    d.doctor_name,
    d.specialization,
    a.treatment_type,
    a.treatment_cost,
    a.appointment_date
FROM Appointments a
INNER JOIN Patients p ON a.patient_id = p.patient_id
INNER JOIN Doctors d ON a.doctor_id = d.doctor_id
ORDER BY a.appointment_date;
```



**Business Interpretation:**  
This query reveals all 15 completed appointments with full patient and doctor information. Jean Uwimana appears 3 times (most frequent patient), indicating possible chronic condition requiring regular monitoring. Dr. Kamanzi Joseph (Cardiology) and Dr. Ishimwe Alice (Pediatrics) are the busiest doctors with 3 patients each, suggesting high demand for cardiac and pediatric services.

---

#### 2. LEFT JOIN - Patients Without Appointments

**Purpose:** Identify registered patients who never utilized hospital services
```sql
-- LEFT JOIN: Find patients with NO appointments
SELECT 
    p.patient_id,
    p.patient_name,
    p.region,
    p.phone,
    p.registration_date,
    COUNT(a.appointment_id) AS total_appointments
FROM Patients p
LEFT JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name, p.region, p.phone, p.registration_date
HAVING COUNT(a.appointment_id) = 0;
```


**Business Interpretation:**  
Aline Umutoni registered on April 20, 2024, but has never scheduled an appointment, representing 12.5% of registered patients (1 out of 8). This indicates potential barriers to care such as access issues, cost concerns, or lack of awareness. The hospital should initiate follow-up calls to understand obstacles and encourage preventive health checkups. Early patient engagement can improve health outcomes and hospital revenue.

---

#### 3. RIGHT JOIN - Doctors Without Patients

**Purpose:** Detect underutilized medical staff
```sql
-- RIGHT JOIN: Find doctors with NO patients
SELECT 
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    d.department,
    COUNT(a.appointment_id) AS total_patients
FROM Appointments a
RIGHT JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization, d.department
HAVING COUNT(a.appointment_id) = 0;
```


**Business Interpretation:**  
All doctors have seen at least one patient, indicating good overall staff utilization. However, workload distribution is uneven - some doctors handle 3+ patients while others have only 1. The hospital should optimize scheduling to balance patient load, ensure all specializations are adequately marketed, and investigate if certain doctors need more visibility or better appointment slot allocation.

---

#### 4. FULL OUTER JOIN - Complete Patient & Doctor Overview

**Purpose:** Comprehensive view showing all patients and all doctors regardless of appointments
```sql
-- FULL OUTER JOIN: Complete view of all patients and doctors
SELECT 
    p.patient_id,
    p.patient_name,
    p.region,
    d.doctor_name,
    d.specialization,
    a.treatment_type,
    a.treatment_cost,
    a.appointment_date
FROM Patients p
FULL OUTER JOIN Appointments a ON p.patient_id = a.patient_id
FULL OUTER JOIN Doctors d ON a.doctor_id = d.doctor_id
ORDER BY p.patient_name, a.appointment_date;
```



**Business Interpretation:**  
This comprehensive analysis reveals both inactive patients (Aline Umutoni with NULL appointment data) and the complete appointment history for active patients. It enables holistic resource planning by identifying gaps in patient engagement and doctor utilization. The query shows that 87.5% of registered patients are active, which is a healthy engagement rate, but there's opportunity to convert the remaining 12.5% into active patients through targeted outreach.

---

#### 5. SELF JOIN - Patients in Same Region

**Purpose:** Identify patients from the same geographic area for community health programs
```sql
-- SELF JOIN: Find patients from the same region
SELECT 
    p1.patient_name AS Patient_1,
    p2.patient_name AS Patient_2,
    p1.region AS Shared_Region,
    p1.phone AS Patient_1_Phone,
    p2.phone AS Patient_2_Phone
FROM Patients p1
INNER JOIN Patients p2 
    ON p1.region = p2.region 
    AND p1.patient_id < p2.patient_id
ORDER BY p1.region, p1.patient_name;
```



**Business Interpretation:**  
Kigali region has the highest patient concentration with 4 patients (50% of total), enabling cost-effective group health programs such as diabetes education sessions, maternal health workshops, or chronic disease support groups. In contrast, Eastern, Southern, Northern, and Western regions each have only 1 patient, indicating underserved rural areas. The hospital should establish satellite clinics or mobile health units in these regions to improve healthcare access and increase patient registration outside Kigali.

---

### PART B: SQL Window Functions

#### Category 1: Ranking Functions

**Purpose:** Rank doctors by revenue to identify top performers
```sql
-- RANKING FUNCTIONS: Top doctors by revenue
c
```


**Key Insights:**
- **Top Performer:** Dr. Ntambara Eric (Orthopedics) - RWF 350,000 from 2 surgeries
- **Second Place:** Dr. Byiringiro Claude (Surgery) - RWF 300,000 from 1 emergency surgery
- **Department Analysis:** Surgery department generates 62.8% of total revenue (RWF 650,000) despite having only 2 doctors
- **Action:** Invest in surgical equipment, recruit 2 additional surgeons, provide performance bonuses to top-ranked doctors

---

#### Category 2: Aggregate Window Functions

**Purpose:** Calculate running totals and moving averages for trend analysis
```sql
-- AGGREGATE WINDOW FUNCTIONS: Running totals and moving averages
SELECT 
    TO_CHAR(appointment_date, 'YYYY-MM') AS month,
    COUNT(appointment_id) AS monthly_appointments,
    SUM(treatment_cost) AS monthly_revenue,
    SUM(SUM(treatment_cost)) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue,
    ROUND(AVG(SUM(treatment_cost)) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM') 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS three_month_moving_avg
FROM Appointments
GROUP BY TO_CHAR(appointment_date, 'YYYY-MM')
ORDER BY month;
```


**Key Insights:**
- **Cumulative Revenue:** RWF 1,035,000 by May 2025
- **Peak Month:** April 2025 (RWF 468,000) - driven by emergency surgeries
- **3-Month Moving Average:** Smooths volatility, reveals baseline revenue of ~RWF 250,000/month
- **Action:** Use moving average for realistic budgeting; April spike was anomaly, not sustainable trend

---

#### Category 3: Navigation Functions (LAG/LEAD)

**Purpose:** Month-over-month growth analysis
```sql
-- NAVIGATION FUNCTIONS: Month-over-month comparison
SELECT 
    TO_CHAR(appointment_date, 'YYYY-MM') AS month,
    SUM(treatment_cost) AS current_revenue,
    LAG(SUM(treatment_cost), 1) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
    ) AS previous_revenue,
    ROUND(
        (SUM(treatment_cost) - LAG(SUM(treatment_cost), 1) OVER (
            ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
        )) / NULLIF(LAG(SUM(treatment_cost), 1) OVER (
            ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
        ), 0) * 100, 
        2
    ) AS growth_pct
FROM Appointments
GROUP BY TO_CHAR(appointment_date, 'YYYY-MM')
ORDER BY month;
```



**Key Insights:**
- **Highest Growth:** April 2025 (+86.5%) - emergency surgery impact
- **Only Decline:** May 2025 (-11.5%) - normalization after spike
- **Average Growth:** ~25% monthly (excluding April anomaly)
- **Action:** Set realistic targets of 15-20% monthly growth; launch patient recall campaigns during low months

---

#### Category 4: Distribution Functions (NTILE)

**Purpose:** Patient segmentation for targeted healthcare programs
```sql
-- DISTRIBUTION FUNCTIONS: Patient segmentation
SELECT 
    p.patient_name,
    p.region,
    SUM(a.treatment_cost) AS total_spent,
    NTILE(4) OVER (ORDER BY SUM(a.treatment_cost) DESC) AS spending_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY SUM(a.treatment_cost) DESC) = 1 THEN 'VIP / High Spender'
        WHEN NTILE(4) OVER (ORDER BY SUM(a.treatment_cost) DESC) = 2 THEN 'Gold / Medium-High'
        WHEN NTILE(4) OVER (ORDER BY SUM(a.treatment_cost) DESC) = 3 THEN 'Silver / Medium-Low'
        ELSE 'Bronze / Low Spender'
    END AS patient_segment
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name, p.region
ORDER BY total_spent DESC;
```



**Key Insights:**
- **VIP Patients (Q1):** Patrick Nshuti (RWF 350,000) - 33.8% of total revenue
- **Revenue Concentration:** Top 2 patients generate 42% of revenue (Pareto Principle)
- **Inactive Segment:** Aline Umutoni (Bronze) - never visited despite registration
- **Action:** Create VIP concierge services; launch Bronze tier activation campaign with welcome incentives

---

## 📊 Key Insights & Analysis

### Descriptive Analysis (What Happened?)

**Revenue Performance:**
- Total Revenue: **RWF 1,035,000** (January - May 2025)
- Average Monthly Revenue: **RWF 207,000**
- Highest Revenue Month: **April 2025 (RWF 468,000)**
- Total Appointments: **15 appointments**

**Patient Metrics:**
- Total Registered Patients: **8 patients**
- Active Patients: **7 patients (87.5%)**
- Inactive Patients: **1 patient (12.5%)**
- Most Frequent Patient: **Jean Uwimana (3 visits)**

**Doctor Performance:**
- Total Doctors: **7 doctors**
- Top Revenue Generator: **Dr. Ntambara Eric (RWF 350,000)**
- Busiest Doctors: **Dr. Kamanzi Joseph & Dr. Ishimwe Alice (3 patients each)**
- All Doctors Active: **100% utilization rate**

**Department Analysis:**
- Highest Revenue Department: **Surgery (RWF 650,000 - 62.8%)**
- Most Appointments: **Outpatient (5 appointments)**
- Average Treatment Cost: **RWF 69,000**

---

### Diagnostic Analysis (Why Did It Happen?)

**Revenue Drivers:**
1. **Surgical Procedures Dominate:** Emergency and orthopedic surgeries (RWF 200,000-300,000 each) drive 62.8% of revenue despite representing only 20% of appointments
2. **Patient Concentration:** 50% of patients located in Kigali due to hospital's urban location, limiting rural patient access
3. **Chronic Care Patients:** Jean Uwimana's 3 visits suggest ongoing health management, providing steady revenue stream
4. **Seasonal Spikes:** April's 86.5% growth driven by single emergency surgery, not sustainable trend

**Challenges Identified:**
1. **Inactive Patients:** 12.5% registration-to-visit gap indicates access barriers or poor onboarding
2. **Geographic Imbalance:** 4 provinces have only 1 patient each, showing limited regional penetration
3. **Revenue Volatility:** Dependence on high-cost surgeries creates unpredictable monthly performance
4. **Workload Imbalance:** Some doctors handle 3x more patients than others

---

### Prescriptive Analysis (What Should Be Done?)

**Strategic Recommendations:**

**1. Expand Surgical Capacity (Priority: HIGH)**
- Action: Recruit 2 additional surgeons and 1 anesthesiologist
- Rationale: Surgery generates 62.8% of revenue but capacity is limited
- Expected Impact: +30% revenue increase, reduced patient wait times
- Timeline: Q3 2025

**2. Launch Regional Expansion Program (Priority: HIGH)**
- Action: Open satellite clinics in Eastern, Southern, and Northern provinces
- Rationale: 4 provinces severely underserved (1 patient each)
- Expected Impact: +50 new patients within 12 months
- Timeline: Q4 2025 - Q2 2026

**3. Patient Re-engagement Campaign (Priority: MEDIUM)**
- Action: Contact inactive patients with free consultation offers
- Target: Aline Umutoni + future inactive registrations
- Expected Impact: Convert 50% of inactive patients to active
- Timeline: Q2 2025

**4. Implement Patient Segmentation Strategy (Priority: MEDIUM)**
- **VIP Tier (Q1):** Dedicated care coordinators, priority scheduling, annual health packages
- **Gold Tier (Q2):** Loyalty discounts, preventive care reminders
- **Silver Tier (Q3):** Educational workshops, wellness programs
- **Bronze Tier (Q4):** Welcome incentives, SMS appointment reminders
- Expected Impact: +15% patient retention, +RWF 200,000 annual revenue

**5. Balance Doctor Workload (Priority: LOW)**
- Action: Optimize scheduling system to distribute patients more evenly
- Rationale: Prevent burnout, improve patient satisfaction
- Expected Impact: Better work-life balance, reduced turnover risk
- Timeline: Q2 2025

**6. Develop Chronic Disease Management Program (Priority: MEDIUM)**
- Action: Create care packages for patients requiring regular monitoring (like Jean Uwimana)
- Services: Monthly checkups, medication management, health coaching
- Expected Impact: Improved health outcomes, predictable revenue stream
- Timeline: Q3 2025

---


### Key Findings Summary

1. **Surgery is the Revenue Engine:** Despite limited surgical staff, the Surgery department generates nearly two-thirds of total hospital revenue, indicating strong market demand for specialized surgical services

2. **Geographic Opportunity:** 50% patient concentration in Kigali reveals untapped potential in rural provinces where healthcare access remains limited

3. **Patient Engagement Gap:** 12.5% of registered patients never utilize services, representing lost revenue and unmet healthcare needs

4. **Revenue Volatility Risk:** Heavy dependence on high-cost surgeries creates unpredictable monthly performance and financial planning challenges

5. **Performance Insights Work:** SQL Window Functions successfully identified top performers, spending patterns, and growth trends that were previously invisible in raw data

### Final Recommendations

**Immediate Actions (Next 30 Days):**
- Contact Aline Umutoni to understand barriers and encourage first visit
- Analyze surgical capacity constraints and develop expansion plan
- Implement basic patient segmentation for targeted communications

**Short-Term Goals (Next 90 Days):**
- Launch VIP patient program for top spenders (Patrick Nshuti, Jean Uwimana)
- Recruit 1-2 additional surgeons to meet demand
- Create monthly performance dashboard using window functions

**Long-Term Strategy (Next 12 Months):**
- Open 2 satellite clinics in underserved provinces
- Establish chronic disease management program
- Diversify revenue streams beyond surgery to reduce volatility
- Grow patient base from 8 to 50+ through regional expansion

---

## 📚 References

1. **Oracle Corporation.** (2024). *Oracle Database SQL Language Reference*. Retrieved from https://docs.oracle.com/en/database/oracle/oracle-database/

2. **PostgreSQL Global Development Group.** (2024). *PostgreSQL Documentation - Window Functions*. Retrieved from https://www.postgresql.org/docs/current/tutorial-window.html

3. **W3Schools.** (2024). *SQL JOIN Tutorial*. Retrieved from https://www.w3schools.com/sql/sql_join.asp

4. **Mode Analytics.** (2024). *SQL Window Functions Tutorial*. Retrieved from https://mode.com/sql-tutorial/sql-window-functions/

5. **Maniraguha, E.** (2025). *INSY 8311 Course Materials - Database Development with PL/SQL*. African University College of Arts and Sciences (AUCA).

6. **Elmasri, R., & Navathe, S. B.** (2015). *Fundamentals of Database Systems* (7th ed.). Pearson Education.

7. **Date, C. J.** (2019). *SQL and Relational Theory: How to Write Accurate SQL Code* (3rd ed.). O'Reilly Media.

---

## 🎓 Academic Integrity Statement

**Declaration of Original Work:**

I, Adrien Hategekimana, hereby declare that this assignment represents my original work completed independently for INSY 8311 - Database Development with PL/SQL. All sources consulted during this project have been properly cited in the References section above.

**Specific Declarations:**

1. ✅ **No Plagiarism:** All SQL queries, analysis, and interpretations were written by me in my own words. No content was copied from online sources, other students, or AI tools without proper attribution.

2. ✅ **No AI-Generated Content:** I did not use ChatGPT, Claude, or any other AI tool to generate SQL queries, analysis, or documentation. All code and written content represents my personal understanding and effort.

3. ✅ **Proper Citations:** All external resources (Oracle documentation, tutorials, academic materials) have been properly cited using standard citation format.

4. ✅ **Personal Implementation:** All SQL scripts were executed on my personal Oracle SQL Developer environment. Screenshots demonstrate my individual work with my database connection visible.

5. ✅ **Collaboration Policy:** I did not share my code or solutions with other students, nor did I receive unauthorized assistance. Any collaboration was limited to general conceptual discussions as permitted by course policy.


**Understanding of Consequences:**

I understand that violations of academic integrity, including plagiarism or use of AI-generated content, will result in:
- Zero marks for this assignment
- Potential disciplinary action per AUCA academic policies
- Damage to my academic and professional reputation




## 📝 Project Metadata
```
Project Title: Hospital Management System SQL Analysis
Database: Oracle Database 21c Express Edition
Tool: Oracle SQL Developer
Programming Language: SQL/PL-SQL
Lines of Code: ~450 lines
Number of Queries: 15+ queries
Analysis Period: January 2025 - May 2025
Total Screenshots: 18 screenshots
Documentation: Professional README.md with comprehensive analysis


**© 2026 Adrien Hategekimana. Created for academic purposes as part of INSY 8311 coursework at African University College of Arts and Sciences (AUCA).**

