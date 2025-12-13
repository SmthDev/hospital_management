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
       'Добавить препарат' AS title, 
       'medicine' AS icon, 
       '/' AS link,
       'logout' AS menu_item;

SELECT 'breadcrumb' AS component;
SELECT 'Справочник препаратов' AS title, 'medic_medicines.sql' AS link;
SELECT 'Добавить препарат' AS title, TRUE AS active;

SELECT 'text' AS component,
       '## Добавить новый препарат' AS contents_md;

SELECT 'form' AS component,
       'Добавить препарат' AS validate,
       'POST' AS method,
       'medic_save_medicine.sql' AS action;

SELECT 'name' AS name,
       'Название препарата' AS label,
       'text' AS type,
       'Введите название препарата' AS placeholder,
       TRUE AS required;

SELECT 'category' AS name,
       'Категория' AS label,
       'text' AS type,
       'Например: Антибиотик, Анальгетик, Витамин' AS placeholder,
       TRUE AS required;

SELECT 'description' AS name,
       'Описание' AS label,
       'textarea' AS type,
       'Краткое описание препарата, показания к применению' AS placeholder;

SELECT 'button' AS component;
SELECT 'Отмена' AS title,
       'medic_medicines.sql' AS link,
       'x' AS icon,
       'secondary' AS color;
