

-- Insert Patients (8 patients across 5 regions)
INSERT INTO Patients VALUES (1, 'Jean Uwimana', 'jean@email.com', '0788123456', DATE '1985-03-15', 'Kigali', DATE '2024-01-10');
INSERT INTO Patients VALUES (2, 'Marie Mukandori', 'marie@email.com', '0788234567', DATE '1990-07-22', 'Kigali', DATE '2024-01-15');
INSERT INTO Patients VALUES (3, 'Patrick Nshuti', 'patrick@email.com', '0788345678', DATE '1978-11-05', 'Eastern', DATE '2024-02-01');
INSERT INTO Patients VALUES (4, 'Grace Uwase', 'grace@email.com', '0788456789', DATE '1995-05-18', 'Southern', DATE '2024-02-10');
INSERT INTO Patients VALUES (5, 'Emmanuel Habimana', 'emmanuel@email.com', '0788567890', DATE '1982-09-30', 'Northern', DATE '2024-03-01');
INSERT INTO Patients VALUES (6, 'Claudine Imanishimwe', 'claudine@email.com', '0788678901', DATE '1988-12-12', 'Kigali', DATE '2024-03-15');
INSERT INTO Patients VALUES (7, 'David Mugisha', 'david@email.com', '0788789012', DATE '1992-04-25', 'Western', DATE '2024-04-05');
INSERT INTO Patients VALUES (8, 'Aline Umutoni', 'aline@email.com', '0788890123', DATE '1987-08-08', 'Kigali', DATE '2024-04-20');

-- Insert Doctors (7 doctors across 4 departments)
INSERT INTO Doctors VALUES (101, 'Dr. Kamanzi Joseph', 'Cardiology', 'Internal Medicine', DATE '2020-01-15');
INSERT INTO Doctors VALUES (102, 'Dr. Ishimwe Alice', 'Pediatrics', 'Pediatrics', DATE '2019-05-20');
INSERT INTO Doctors VALUES (103, 'Dr. Ntambara Eric', 'Orthopedics', 'Surgery', DATE '2021-03-10');
INSERT INTO Doctors VALUES (104, 'Dr. Uwera Francine', 'General Practice', 'Outpatient', DATE '2018-07-01');
INSERT INTO Doctors VALUES (105, 'Dr. Mugabo Richard', 'Neurology', 'Internal Medicine', DATE '2020-09-15');
INSERT INTO Doctors VALUES (106, 'Dr. Ingabire Peace', 'Dermatology', 'Outpatient', DATE '2022-01-10');
INSERT INTO Doctors VALUES (107, 'Dr. Byiringiro Claude', 'Surgery', 'Surgery', DATE '2019-11-05');

-- Insert Appointments (15 completed appointments)
INSERT INTO Appointments VALUES (1001, 1, 101, DATE '2025-01-15', 'Cardiac Checkup', 50000, 'Completed');
INSERT INTO Appointments VALUES (1002, 2, 102, DATE '2025-01-18', 'Child Vaccination', 15000, 'Completed');
INSERT INTO Appointments VALUES (1003, 1, 104, DATE '2025-01-22', 'General Consultation', 10000, 'Completed');
INSERT INTO Appointments VALUES (1004, 3, 103, DATE '2025-02-05', 'Knee Surgery', 200000, 'Completed');
INSERT INTO Appointments VALUES (1005, 4, 102, DATE '2025-02-10', 'Pediatric Consultation', 12000, 'Completed');
INSERT INTO Appointments VALUES (1006, 2, 101, DATE '2025-02-15', 'Heart Screening', 45000, 'Completed');
INSERT INTO Appointments VALUES (1007, 5, 105, DATE '2025-03-01', 'Neurological Assessment', 60000, 'Completed');
INSERT INTO Appointments VALUES (1008, 1, 106, DATE '2025-03-10', 'Skin Treatment', 25000, 'Completed');
INSERT INTO Appointments VALUES (1009, 6, 104, DATE '2025-03-15', 'General Checkup', 10000, 'Completed');
INSERT INTO Appointments VALUES (1010, 3, 103, DATE '2025-04-05', 'Follow-up Surgery', 150000, 'Completed');
INSERT INTO Appointments VALUES (1011, 4, 102, DATE '2025-04-12', 'Child Immunization', 18000, 'Completed');
INSERT INTO Appointments VALUES (1012, 7, 107, DATE '2025-04-20', 'Emergency Surgery', 300000, 'Completed');
INSERT INTO Appointments VALUES (1013, 2, 104, DATE '2025-05-01', 'Annual Physical', 10000, 'Completed');
INSERT INTO Appointments VALUES (1014, 6, 101, DATE '2025-05-10', 'Cardiac Follow-up', 50000, 'Completed');
INSERT INTO Appointments VALUES (1015, 5, 105, DATE '2025-05-15', 'Brain Scan', 80000, 'Completed');

-- Verify data insertion
SELECT 'Patients' AS TableName, COUNT(*) AS RowCount FROM Patients
UNION ALL
SELECT 'Doctors', COUNT(*) FROM Doctors
UNION ALL
SELECT 'Appointments', COUNT(*) FROM Appointments;



