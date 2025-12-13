SET username = (SELECT username FROM login_session WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        'signin.sql?error' AS link
WHERE $username IS NULL;

SELECT 'redirect' AS component,
        'main_page.sql' AS link
WHERE $username IS NOT NULL
  AND (SELECT r.name FROM user_info u
       JOIN roles r ON u.role_id = r.id
       WHERE u.username = $username) NOT IN ('medic', 'admin');

SET user_role = (SELECT r.name FROM user_info u
                 JOIN roles r ON u.role_id = r.id 
                 WHERE u.username = $username);



SET patient_name = (SELECT full_name FROM patients WHERE id = CAST(:patient_id AS INTEGER));

SELECT 'shell' AS component, 
       'Назначения пациента' AS title, 
       'stethoscope' AS icon, 
       '/' AS link,
       'logout' AS menu_item;

SELECT 'breadcrumb' AS component;
SELECT 'Панель врача' AS title, 'medic.sql' AS link;
SELECT 'Назначения пациента' AS title, TRUE AS active;

SELECT 'hero' AS component,
       'Назначения: ' || COALESCE($patient_name, 'Пациент не найден') AS title,
       'user' AS icon;

SELECT 'alert' AS component,
       'Успех' AS title,
       'Назначение успешно добавлено!' AS description,
       'success' AS color
WHERE :success = 'added';

SELECT 'alert' AS component,
       'Успех' AS title,
       'Назначение успешно удалено!' AS description,
       'success' AS color
WHERE :success = 'deleted';

SELECT 'alert' AS component,
       'Ошибка' AS title,
       'Не указана дозировка препарата!' AS description,
       'danger' AS color
WHERE :error = 'missing_dosage';

SELECT 'button' AS component;
SELECT 'Добавить назначение' AS title,
       'medic_add_prescription.sql?patient_id=' || :patient_id AS link,
       'plus' AS icon,
       'primary' AS color;

SELECT 'text' AS component,
       '## Текущие назначения' AS contents_md;

SELECT 'table' AS component,
       'Назначения' AS title,
       TRUE AS sort;

SELECT 
    mp.id AS "ID",
    m.name AS "Препарат",
    m.category AS "Категория",
    mp.dosage AS "Дозировка",
    mp.instructions AS "Инструкции",
    mp.start_date AS "Дата начала",
    mp.end_date AS "Дата окончания",
    mp.medic_username AS "Назначил",
    '[
        {"link": "medic_edit_prescription.sql?id=' || mp.id || '", "icon": "edit", "color": "blue", "title": "Изменить"},
        {"link": "medic_delete_prescription_confirm.sql?id=' || mp.id || '&patient_id=' || :patient_id || '", "icon": "trash", "color": "red", "title": "Удалить"}
    ]' AS _sqlpage_actions
FROM medic_prescriptions mp
JOIN medicines m ON mp.medicine_id = m.id
WHERE mp.patient_id = CAST(:patient_id AS INTEGER)
ORDER BY mp.created_at DESC;

SELECT 'alert' AS component,
       'Нет назначений' AS title,
       'У этого пациента пока нет назначенных препаратов.' AS description,
       'info' AS color
WHERE NOT EXISTS (SELECT 1 FROM medic_prescriptions WHERE patient_id = CAST(:patient_id AS INTEGER));

SELECT 'button' AS component;
SELECT 'Назад к списку пациентов' AS title,
       'medic.sql' AS link,
       'arrow-left' AS icon,
       'secondary' AS color;
