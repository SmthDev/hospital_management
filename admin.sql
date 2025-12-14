SET username = (SELECT username FROM login_session WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        'signin.sql?error' AS link
WHERE $username IS NULL;

SET user_role = (SELECT r.name FROM user_info u 
                 JOIN roles r ON u.role_id = r.id 
                 WHERE u.username = $username);

SELECT 'redirect' AS component,
        'main_page.sql' AS link
WHERE $user_role != 'admin';


SET new_username = :new_username;
SET new_password = :new_password;


SELECT 'alert' AS component,
       'Пользователь успешно создан!' AS title,
       'Логин: ' || :created_username AS description,
       'success' AS color
WHERE :success = '1';

SELECT 'alert' AS component,
       'Ошибка при создании пользователя' AS title,
       'Пользователь с логином "' || :username || '" уже существует' AS description,
       'danger' AS color
WHERE :error = 'exists';

SELECT 'alert' AS component,
       'Ошибка' AS title,
       'Отсутствуют необходимые параметры (логин или пароль)' AS description,
       'danger' AS color
WHERE :error = 'missing';

SELECT 'alert' AS component,
       'Ошибка при создании пользователя' AS title,
       'Не удалось создать пользователя в базе данных' AS description,
       'danger' AS color
WHERE :error = 'failed';

SELECT 'alert' AS component,
       'Ошибка' AS title,
       'Роль "medic" не найдена в базе данных' AS description,
       'danger' AS color
WHERE :error = 'no_role';

SELECT 'alert' AS component,
       'Ошибка при создании пользователя' AS title,
       'INSERT не выполнился. Проверьте логи базы данных.' AS description,
       'danger' AS color
WHERE :error = 'insert_failed';

SELECT 'shell' AS component, 
       'Панель администратора' AS title, 
       '/' AS link,
       'logout' AS menu_item;


SELECT 'hero' AS component,
       'Панель администратора' AS title;

SET random_username = COALESCE(:gen_username, 'user_' || substr(sqlpage.random_string(8), 1, 8));
SET random_password = COALESCE(:gen_password, sqlpage.random_string(12));

SELECT 'card' AS component,
       'Сгенерированные учётные данные' AS title;

SELECT 'Логин' AS title,
       $random_username AS description


SELECT 'Пароль' AS title,
       $random_password AS description



SELECT 'form' AS component,
       'Создать пользователя' AS title,
       'Создать' AS validate,
       'create_generated_user.sql' AS action;

SELECT 'username' AS name, 
       'Логин' AS label,
       $random_username AS value;

SELECT 'password' AS name, 
       'Пароль' AS label,
       $random_password AS value;

SELECT 'button' AS component;

SELECT 'Сгенерировать новые данные' AS title,
       'admin.sql' AS link,
       'refresh-cw' AS icon,
       'info' AS color;



SELECT 'table' AS component,
       'Список пользователей' AS title,
       TRUE AS sort,
       TRUE AS search;

SELECT u.username AS "Логин", r.name AS "Роль"
FROM user_info AS u
LEFT JOIN roles r ON u.role_id = r.id
ORDER BY u.username;

-- Логи системы
SELECT 'title' AS component,
       'Логи системы' AS contents,
       3 AS level;

SELECT 'table' AS component,
       'История действий' AS title,
       TRUE AS sort,
       TRUE AS search;

SELECT 
    id AS "ID",
    to_char(created_at, 'DD.MM.YYYY HH24:MI:SS') AS "Время",
    action AS "Действие",
    table_name AS "Таблица",
    data::text AS "Данные (JSON)"
FROM logs
ORDER BY created_at DESC
LIMIT 100




