
SELECT 
    d.doctor_name,
    d.specialization,
    d.department,
    COUNT(a.appointment_id) AS total_patients,
    SUM(a.treatment_cost) AS total_revenue,
    ROW_NUMBER() OVER (ORDER BY SUM(a.treatment_cost) DESC) AS row_num,
    RANK() OVER (ORDER BY SUM(a.treatment_cost) DESC) AS rank_position,
    DENSE_RANK() OVER (ORDER BY SUM(a.treatment_cost) DESC) AS dense_rank_position,
    ROUND(PERCENT_RANK() OVER (ORDER BY SUM(a.treatment_cost) DESC) * 100, 2) AS percent_rank
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization, d.department
ORDER BY total_revenue DESC;

-- ============================================
-- CATEGORY 2: AGGREGATE WINDOW FUNCTIONS
-- Purpose: Running totals and moving averages using ROWS and RANGE frames
-- ============================================
SELECT 
    TO_CHAR(appointment_date, 'YYYY-MM') AS month,
    COUNT(appointment_id) AS monthly_appointments,
    SUM(treatment_cost) AS monthly_revenue,
    
    -- Running total using ROWS frame
    SUM(SUM(treatment_cost)) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM') 
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue,
    
    -- 3-month moving average
    ROUND(AVG(SUM(treatment_cost)) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM') 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS three_month_moving_avg,
    
    -- Cumulative average
    ROUND(AVG(SUM(treatment_cost)) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS cumulative_avg,
    
    -- Max and min revenue to date
    MAX(SUM(treatment_cost)) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS max_revenue_to_date,
    
    MIN(SUM(treatment_cost)) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS min_revenue_to_date
    
FROM Appointments
GROUP BY TO_CHAR(appointment_date, 'YYYY-MM')
ORDER BY month;

-- ============================================
-- CATEGORY 3: NAVIGATION FUNCTIONS
-- Purpose: Month-over-month comparison using LAG and LEAD
-- ============================================
SELECT 
    TO_CHAR(appointment_date, 'YYYY-MM') AS month,
    COUNT(appointment_id) AS current_appointments,
    SUM(treatment_cost) AS current_revenue,
    
    -- Previous month's data using LAG
    LAG(COUNT(appointment_id), 1) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
    ) AS previous_appointments,
    
    LAG(SUM(treatment_cost), 1) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
    ) AS previous_revenue,
    
    -- Next month's data using LEAD
    LEAD(SUM(treatment_cost), 1) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
    ) AS next_month_revenue,
    
    -- Calculate changes
    COUNT(appointment_id) - LAG(COUNT(appointment_id), 1) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
    ) AS appointment_change,
    
    SUM(treatment_cost) - LAG(SUM(treatment_cost), 1) OVER (
        ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
    ) AS revenue_change,
    
    -- Calculate percentage growth
    ROUND(
        (SUM(treatment_cost) - LAG(SUM(treatment_cost), 1) OVER (
            ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
        )) / NULLIF(LAG(SUM(treatment_cost), 1) OVER (
            ORDER BY TO_CHAR(appointment_date, 'YYYY-MM')
        ), 0) * 100, 
        2
    ) AS revenue_growth_pct
    
FROM Appointments
GROUP BY TO_CHAR(appointment_date, 'YYYY-MM')
ORDER BY month;

-- ============================================
-- CATEGORY 4: DISTRIBUTION FUNCTIONS
-- Purpose: Patient segmentation using NTILE and CUME_DIST
-- ============================================
SELECT 
    p.patient_id,
    p.patient_name,
    p.region,
    p.phone,
    COUNT(a.appointment_id) AS total_visits,
    SUM(a.treatment_cost) AS total_spent,
    
    -- Divide patients into 4 equal groups (quartiles)
    NTILE(4) OVER (ORDER BY SUM(a.treatment_cost) DESC) AS spending_quartile,
    
    -- Cumulative distribution (percentile)
    ROUND(CUME_DIST() OVER (ORDER BY SUM(a.treatment_cost) DESC) * 100, 2) AS cumulative_dist_pct,
    
    -- Assign segment labels
    CASE 
        WHEN NTILE(4) OVER (ORDER BY SUM(a.treatment_cost) DESC) = 1 THEN 'VIP / High Spender'
        WHEN NTILE(4) OVER (ORDER BY SUM(a.treatment_cost) DESC) = 2 THEN 'Gold / Medium-High'
        WHEN NTILE(4) OVER (ORDER BY SUM(a.treatment_cost) DESC) = 3 THEN 'Silver / Medium-Low'
        ELSE 'Bronze / Low Spender'
    END AS patient_segment,
    
    -- Revenue contribution percentage
    ROUND(
        SUM(a.treatment_cost) / SUM(SUM(a.treatment_cost)) OVER () * 100, 
        2
    ) AS revenue_contribution_pct
    
FROM Patients p
JOIN Appointments a ON p.patient_id = a.patient_id
GROUP BY p.patient_id, p.patient_name, p.region, p.phone
ORDER BY total_spent DESC;


```


---

