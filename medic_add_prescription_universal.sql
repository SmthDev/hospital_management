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

SELECT 'shell' AS component,
       'Добавить назначение' AS title,
       'stethoscope' AS icon,
       '/' AS link,
       'logout' AS menu_item;

SELECT 'breadcrumb' AS component;
SELECT 'Все назначения' AS title, 'medic_prescriptions.sql' AS link;
SELECT 'Добавить назначение' AS title, TRUE AS active;

SELECT 'text' AS component,
       '## Добавить новое назначение' AS contents_md;

SELECT 'form' AS component,
       'Добавить назначение' AS validate,
       'POST' AS method,
       'medic_save_prescription.sql?return=all' AS action;

SELECT 'select' AS type,
       'patient_id' AS name,
       'Пациент' AS label,
       TRUE AS required,
       (SELECT json_agg(json_build_object('value', id, 'label', full_name || ' (ДР: ' || birth_date || ')')) FROM patients) AS options;

SELECT 'select' AS type,
       'medicine_id' AS name,
       'Препарат' AS label,
       TRUE AS required,
       (SELECT json_agg(json_build_object('value', id, 'label', name || ' (' || COALESCE(category, 'без категории') || ')')) FROM medicines) AS options;

SELECT 'text' AS type,
       'dosage' AS name,
       'Дозировка' AS label,
       'Например: 1 таблетка 3 раза в день' AS placeholder,
       TRUE AS required;

SELECT 'textarea' AS type,
       'instructions' AS name,
       'Инструкции' AS label,
       'Дополнительные указания по приёму' AS placeholder,
       FALSE AS required;

SELECT 'date' AS type,
       'start_date' AS name,
       'Дата начала' AS label,
       TRUE AS required,
       CURRENT_DATE::text AS value;

SELECT 'date' AS type,
       'end_date' AS name,
       'Дата окончания' AS label,
       'Оставьте пустым для бессрочного назначения' AS placeholder,
       FALSE AS required;

SELECT 'button' AS component;
SELECT 'Отмена' AS title,
       'medic_prescriptions.sql' AS link,
       'x' AS icon,
       'secondary' AS color;

