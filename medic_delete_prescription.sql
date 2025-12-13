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

SELECT 'redirect' AS component,
       'medic_prescriptions.sql?error=no_id' AS link
WHERE $prescription_id IS NULL;

DELETE FROM medic_prescriptions WHERE id = $prescription_id;

SELECT 'redirect' AS component,
       CASE
           WHEN :return = 'all' OR :patient_id IS NULL THEN 'medic_prescriptions.sql?success=deleted'
           ELSE 'medic_patient_prescriptions.sql?patient_id=' || :patient_id || '&success=deleted'
       END AS link;

