
SET current_user = (SELECT username FROM login_session WHERE id = sqlpage.cookie('session'));
SELECT 'redirect' AS component,
        'signin.sql?error' AS link
WHERE $current_user IS NULL;
SELECT 'redirect' AS component,
       'admin.sql?error=missing' AS link
WHERE :username IS NULL OR :password IS NULL OR :username = '' OR :password = '';


INSERT INTO user_info (username, password_hash, role_id)
VALUES (:username, sqlpage.hash_password(:password), 3)
ON CONFLICT (username) DO NOTHING
RETURNING 
    'redirect' AS component,
    'admin.sql?success=1&created_username=' || :username AS link;
SELECT 'redirect' AS component, 
       'admin.sql?error=exists&username=' || :username AS link;
