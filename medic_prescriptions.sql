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
       'Все назначения' AS title, 
       'stethoscope' AS icon, 
       '/' AS link,
       'logout' AS menu_item;

SELECT 'hero' AS component,
       'Все назначения' AS title,
       'Просмотр всех назначений препаратов' AS description,
       'pill' AS icon;

SELECT 'tab' AS component;
SELECT 'Пациенты' AS title, 'medic.sql' AS link, 'users' AS icon;
SELECT 'Назначения' AS title, 'medic_prescriptions.sql' AS link, TRUE AS active, 'pill' AS icon;
SELECT 'Препараты' AS title, 'medic_medicines.sql' AS link, 'medicine' AS icon;

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
       'Успех' AS title,
       'Назначение успешно обновлено!' AS description,
       'success' AS color
WHERE :success = 'updated';

SELECT 'button' AS component;
SELECT 'Добавить назначение' AS title,
       'medic_add_prescription_universal.sql' AS link,
       'plus' AS icon,
       'primary' AS color;

SELECT 'form' AS component,
       'inline' AS layout;

SELECT 'filter' AS name,
       'Поиск по пациенту или препарату' AS placeholder,
       :filter AS value;

SELECT 'table' AS component,
       'Назначения' AS title,
       TRUE AS sort,
       TRUE AS search;

SELECT 
    mp.id AS "ID",
    p.full_name AS "Пациент",
    m.name AS "Препарат",
    m.category AS "Категория",
    mp.dosage AS "Дозировка",
    mp.start_date AS "Дата начала",
    mp.end_date AS "Дата окончания",
    CASE 
        WHEN mp.end_date IS NULL OR mp.end_date >= CURRENT_DATE THEN 'Активно'
        ELSE 'Завершено'
    END AS "Статус",
    mp.medic_username AS "Назначил",
    '[
        {"link": "medic_edit_prescription.sql?id=' || mp.id || '", "icon": "edit", "color": "blue", "title": "Изменить"},
        {"link": "medic_delete_prescription_confirm.sql?id=' || mp.id || '&return=all", "icon": "trash", "color": "red", "title": "Удалить"}
    ]' AS _sqlpage_actions
FROM medic_prescriptions mp
JOIN patients p ON mp.patient_id = p.id
JOIN medicines m ON mp.medicine_id = m.id
WHERE (:filter IS NULL OR :filter = '' 
       OR p.full_name ILIKE '%' || :filter || '%' 
       OR m.name ILIKE '%' || :filter || '%')
ORDER BY mp.created_at DESC;

SELECT 'alert' AS component,
       'Нет назначений' AS title,
       'В системе пока нет назначенных препаратов.' AS description,
       'info' AS color
WHERE NOT EXISTS (SELECT 1 FROM medic_prescriptions);
