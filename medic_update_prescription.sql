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

SET prescription_id = CAST(NULLIF(:id, '') AS INTEGER);
SET patient_id = CAST(NULLIF(:patient_id, '') AS INTEGER);
SET medicine_id = CAST(NULLIF(:medicine_id, '') AS INTEGER);
SET dosage = NULLIF(:dosage, '');
SET instructions = NULLIF(:instructions, '');
SET start_date = NULLIF(:start_date, '');
SET end_date = NULLIF(:end_date, '');

SELECT 'redirect' AS component,
       'medic_prescriptions.sql?error=no_id' AS link
WHERE $prescription_id IS NULL;

UPDATE medic_prescriptions
SET patient_id = $patient_id,
    medicine_id = $medicine_id,
    dosage = $dosage,
    instructions = $instructions,
    start_date = CAST($start_date AS DATE),
    end_date = CASE WHEN $end_date IS NOT NULL THEN CAST($end_date AS DATE) ELSE NULL END
WHERE id = $prescription_id;

SELECT 'redirect' AS component,
       'medic_prescriptions.sql?success=updated' AS link;
