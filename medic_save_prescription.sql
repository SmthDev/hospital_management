SET username = (SELECT username FROM login_session WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        'signin.sql?error' AS link
WHERE $username IS NULL;

SET user_role = (SELECT r.name FROM user_info u 
                 JOIN roles r ON u.role_id = r.id 
                 WHERE u.username = $username);

SELECT 'redirect' AS component,
        'main_page.sql' AS link
WHERE $user_role != 'medic' AND $user_role != 'admin';

SET patient_id = NULLIF(:patient_id, '');
SET medicine_id = NULLIF(:medicine_id, '');
SET dosage = :dosage;
SET instructions = :instructions;
SET start_date = NULLIF(:start_date, '');
SET end_date = NULLIF(:end_date, '');

SELECT 'redirect' AS component,
       'medic.sql?error=missing_patient' AS link
WHERE $patient_id IS NULL;

SELECT 'redirect' AS component,
       'medic.sql?error=missing_medicine' AS link
WHERE $medicine_id IS NULL;

SELECT 'redirect' AS component,
       'medic_patient_prescriptions.sql?patient_id=' || $patient_id || '&error=missing_dosage' AS link
WHERE $dosage IS NULL OR $dosage = '';

INSERT INTO medic_prescriptions (patient_id, medicine_id, medic_username, dosage, instructions, start_date, end_date)
VALUES (
    CAST($patient_id AS INTEGER), 
    CAST($medicine_id AS INTEGER), 
    $username, 
    $dosage, 
    $instructions, 
    CAST($start_date AS DATE), 
    CASE WHEN $end_date IS NOT NULL THEN CAST($end_date AS DATE) ELSE NULL END
);

SELECT 'redirect' AS component,
       CASE
           WHEN :return = 'all' THEN 'medic_prescriptions.sql?success=added'
           ELSE 'medic_patient_prescriptions.sql?patient_id=' || $patient_id || '&success=added'
       END AS link;
