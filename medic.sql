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
       'Панель врача' AS title, 
       'stethoscope' AS icon, 
       '/' AS link,
       'logout' AS menu_item;

SELECT 'hero' AS component,
       'Панель врача' AS title,
       'Добро пожаловать, ' || $username || '!' AS description,
       'stethoscope' AS icon;

SELECT 'tab' AS component;
SELECT 'Пациенты' AS title, 'medic.sql' AS link, TRUE AS active, 'users' AS icon;
SELECT 'Назначения' AS title, 'medic_prescriptions.sql' AS link, 'pill' AS icon;
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

SELECT 'text' AS component,
       '## Список пациентов' AS contents_md;

SELECT 'table' AS component,
       'Пациенты' AS title,
       TRUE AS sort,
       TRUE AS search

SELECT 
    p.id AS "ID",
    p.full_name AS "ФИО",
    p.birth_date AS "Дата рождения",
    p.phone AS "Телефон",
    p.email AS "Email"
FROM patients p
ORDER BY p.full_name;

SELECT 'card' AS component,
       3 AS columns;

SELECT 
    'Всего пациентов' AS title,
    (SELECT COUNT(*) FROM patients)::text AS description,
    'users' AS icon,
    'blue' AS color;

SELECT 
    'Активных назначений' AS title,
    (SELECT COUNT(*) FROM medic_prescriptions WHERE end_date IS NULL OR end_date >= CURRENT_DATE)::text AS description,
    'pill' AS icon,
    'green' AS color;

SELECT 
    'Препаратов в базе' AS title,
    (SELECT COUNT(*) FROM medicines)::text AS description,
    'medicine' AS icon,
    'orange' AS color; 
