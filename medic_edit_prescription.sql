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

SET current_patient_id = (SELECT patient_id FROM medic_prescriptions WHERE id = CAST($prescription_id AS INTEGER));
SET current_medicine_id = (SELECT medicine_id FROM medic_prescriptions WHERE id = CAST($prescription_id AS INTEGER));
SET current_dosage = (SELECT dosage FROM medic_prescriptions WHERE id = CAST($prescription_id AS INTEGER));
SET current_instructions = (SELECT instructions FROM medic_prescriptions WHERE id = CAST($prescription_id AS INTEGER));
SET current_start_date = (SELECT start_date FROM medic_prescriptions WHERE id = CAST($prescription_id AS INTEGER));
SET current_end_date = (SELECT end_date FROM medic_prescriptions WHERE id = CAST($prescription_id AS INTEGER));
SET patient_name = (SELECT full_name FROM patients WHERE id = CAST($current_patient_id AS INTEGER));

SELECT 'shell' AS component, 
       'Редактировать назначение' AS title, 
       'stethoscope' AS icon, 
       '/' AS link,
       'logout' AS menu_item;

SELECT 'breadcrumb' AS component;
SELECT 'Все назначения' AS title, 'medic_prescriptions.sql' AS link;
SELECT 'Редактировать назначение' AS title, TRUE AS active;

SELECT 'text' AS component,
       '## Редактировать назначение' AS contents_md;

SELECT 'form' AS component,
       'Сохранить изменения' AS validate,
       'medic_update_prescription.sql' AS action;

SELECT 'hidden' AS type,
       'id' AS name,
       CAST($prescription_id AS TEXT) AS value;

SELECT 'select' AS type,
       'patient_id' AS name,
       'Пациент' AS label,
       TRUE AS required,
       (SELECT json_agg(json_build_object(
           'value', id,
           'label', full_name || ' (ДР: ' || birth_date || ')',
           'selected', CASE WHEN id = $current_patient_id THEN true ELSE false END
       )) FROM patients) AS options;

SELECT 'select' AS type,
       'medicine_id' AS name,
       'Препарат' AS label,
       TRUE AS required,
       (SELECT json_agg(json_build_object(
           'value', id,
           'label', name || ' (' || COALESCE(category, 'без категории') || ')',
           'selected', CASE WHEN id = $current_medicine_id THEN true ELSE false END
       )) FROM medicines) AS options;

SELECT 'text' AS type,
       'dosage' AS name,
       'Дозировка' AS label,
       'Например: 1 таблетка 3 раза в день' AS placeholder,
       TRUE AS required,
       $current_dosage AS value;

SELECT 'textarea' AS type,
       'instructions' AS name,
       'Инструкции' AS label,
       'Дополнительные указания по приёму' AS placeholder,
       FALSE AS required,
       $current_instructions AS value;

SELECT 'date' AS type,
       'start_date' AS name,
       'Дата начала' AS label,
       TRUE AS required,
       CAST($current_start_date AS TEXT) AS value;

SELECT 'date' AS type,
       'end_date' AS name,
       'Дата окончания' AS label,
       'Оставьте пустым для бессрочного назначения' AS placeholder,
       FALSE AS required,
       CAST($current_end_date AS TEXT) AS value;

SELECT 'button' AS component;
SELECT 'Отмена' AS title,
       'medic_prescriptions.sql' AS link,
       'x' AS icon,
       'secondary' AS color;
