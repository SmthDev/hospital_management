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
       'Справочник препаратов' AS title, 
       'stethoscope' AS icon, 
       '/' AS link,
       'logout' AS menu_item;

SELECT 'hero' AS component,
       'Справочник препаратов' AS title,
       'Список доступных препаратов для назначения' AS description,
       'medicine' AS icon;

SELECT 'tab' AS component;
SELECT 'Пациенты' AS title, 'medic.sql' AS link, 'users' AS icon;
SELECT 'Назначения' AS title, 'medic_prescriptions.sql' AS link, 'pill' AS icon;
SELECT 'Препараты' AS title, 'medic_medicines.sql' AS link, TRUE AS active, 'medicine' AS icon;

SELECT 'alert' AS component,
       'success' AS color,
       'Препарат успешно добавлен!' AS title
WHERE :success = 'added';

SELECT 'alert' AS component,
       'success' AS color,
       'Препарат успешно обновлен!' AS title
WHERE :success = 'updated';

SELECT 'alert' AS component,
       'success' AS color,
       'Препарат успешно удален!' AS title
WHERE :success = 'deleted';

SELECT 'alert' AS component,
       'danger' AS color,
       'Ошибка: не удалось обновить препарат' AS title
WHERE :error = 'update_failed';

SELECT 'alert' AS component,
       'danger' AS color,
       'Ошибка: отсутствует ID препарата' AS title
WHERE :error = 'missing_id';

SELECT 'button' AS component,
       'center' AS justify;
SELECT 'Добавить препарат' AS title,
       'medic_add_medicine.sql' AS link,
       'plus' AS icon,
       'green' AS color;

SELECT 'table' AS component,
       'Препараты' AS title,
       TRUE AS sort,
       TRUE AS search,
       TRUE AS hover;

SELECT 
    m.id AS "ID",
    m.name AS "Название",
    m.category AS "Категория",
    m.description AS "Описание",
    (SELECT COUNT(*) FROM medic_prescriptions WHERE medicine_id = m.id) AS "Назначений",
    '[
        {"link": "medic_edit_medicine.sql?id=' || m.id || '", "icon": "edit", "color": "blue", "title": "Изменить"},
        {"link": "medic_delete_medicine.sql?id=' || m.id || '", "icon": "trash", "color": "red", "title": "Удалить"}
    ]' AS _sqlpage_actions
FROM medicines m
ORDER BY m.name;

SELECT 'text' AS component,
       '## Статистика по категориям' AS contents_md;

SELECT 'card' AS component,
       4 AS columns;

SELECT 
    category AS title,
    CAST(COUNT(*) AS TEXT) || ' препаратов' AS description,
    'medicine' AS icon,
    'blue' AS color
FROM medicines
WHERE category IS NOT NULL
GROUP BY category
ORDER BY COUNT(*) DESC;
