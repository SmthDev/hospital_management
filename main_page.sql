SET username = (SELECT username FROM login_session WHERE id = sqlpage.cookie('session'));

SELECT 'redirect' AS component,
        'signin.sql?error' AS link
WHERE $username IS NULL;

SET user_role = (SELECT r.name FROM user_info u 
                 JOIN roles r ON u.role_id = r.id 
                 WHERE u.username = $username);

SELECT 'redirect' AS component,
        'index.sql' AS link
WHERE $user_role != 'guest' AND $user_role != 'medic' AND $user_role != 'admin';

SELECT 'shell' AS component, 
       'Защищённая страница' AS title, 
       'lock' AS icon, 
       '/' AS link,
       CASE WHEN $user_role = 'admin' THEN 'admin.sql' ELSE NULL END AS menu_item,
       CASE WHEN $user_role = 'medic' OR $user_role = 'admin' THEN 'medic.sql' ELSE NULL END AS menu_item,
       'logout' AS menu_item;



SELECT 'text' AS component,
        'Добро пожаловать, ' || $username || '!' AS title
       


SELECT 'alert' AS component,
       'Панель администратора' AS title,
       'Вы вошли как администратор. Используйте панель администратора для создания новых пользователей.' AS description,
       'admin.sql' AS link,
       'Открыть панель администратора' AS button_text,
       'info' AS color
WHERE $user_role = 'admin';

SELECT 'alert' AS component,
       'Панель врача' AS title,
       'Вы вошли как врач. Перейдите в панель врача для управления назначениями пациентов.' AS description,
       'medic.sql' AS link,
       'Открыть панель врача' AS button_text,
       'teal' AS color
WHERE $user_role = 'medic';