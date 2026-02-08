
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
WHERE a.status = 'Completed'
ORDER BY a.appointment_date;

-- ============================================
-- JOIN #2: LEFT JOIN
-- Purpose: Find patients who have NEVER scheduled an appointment
-- ============================================
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

-- ============================================
-- JOIN #3: RIGHT JOIN
-- Purpose: Find doctors who have NO patient appointments
-- ============================================
SELECT 
    d.doctor_id,
    d.doctor_name,
    d.specialization,
    d.department,
    d.hire_date,
    COUNT(a.appointment_id) AS total_patients_seen
FROM Appointments a
RIGHT JOIN Doctors d ON a.doctor_id = d.doctor_id
GROUP BY d.doctor_id, d.doctor_name, d.specialization, d.department, d.hire_date
HAVING COUNT(a.appointment_id) = 0;

-- ============================================
-- JOIN #4: FULL OUTER JOIN
-- Purpose: Complete overview of all patients and doctors with appointments
-- ============================================
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

-- ============================================
-- JOIN #5: SELF JOIN
-- Purpose: Find patients from the same region for community health programs
-- ============================================
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

