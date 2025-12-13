
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

SET medicine_id = :id;

SET medicine_name = (SELECT name FROM medicines WHERE id = CAST(:id AS INTEGER));
SET medicine_category = (SELECT category FROM medicines WHERE id = CAST(:id AS INTEGER));
SET medicine_description = (SELECT description FROM medicines WHERE id = CAST(:id AS INTEGER));


SELECT 'shell' AS component, 
       'Редактировать препарат' AS title, 
       'medicine' AS icon, 
       '/' AS link,
       'logout' AS menu_item;

SELECT 'breadcrumb' AS component;
SELECT 'Справочник препаратов' AS title, 'medic_medicines.sql' AS link;
SELECT 'Редактировать препарат' AS title, TRUE AS active;

SELECT 'text' AS component,
       '## Редактировать препарат: ' || COALESCE($medicine_name, 'Не найден') AS contents_md;

SELECT 'form' AS component,
       'Сохранить изменения' AS validate,
       'POST' AS method,
       'medic_update_medicine.sql' AS action;

SELECT 'id' AS name,
       'hidden' AS type,
       :id AS value;

SELECT 'name' AS name,
       'Название препарата' AS label,
       'text' AS type,
       $medicine_name AS value,
       TRUE AS required;

SELECT 'category' AS name,
       'Категория' AS label,
       'text' AS type,
       $medicine_category AS value,
       TRUE AS required;

SELECT 'description' AS name,
       'Описание' AS label,
       'textarea' AS type,
       $medicine_description AS value;

SELECT 'button' AS component;
SELECT 'Отмена' AS title,
       'medic_medicines.sql' AS link,
       'x' AS icon,
       'secondary' AS color;
