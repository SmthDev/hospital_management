
SELECT 'authentication' AS component,
    'signin.sql?error' AS link,
    (SELECT password_hash FROM user_info WHERE username = :username) AS password_hash,
    :password AS password;

INSERT INTO login_session (id, username)
VALUES (sqlpage.random_string(32), :username)
RETURNING 
    'cookie' AS component,
    'session' AS name,
    id AS value,
    FALSE AS secure;


SET user_role = (SELECT r.name FROM user_info u 
                 JOIN roles r ON u.role_id = r.id 
                 WHERE u.username = :username);


SELECT 'redirect' AS component, 'admin.sql' AS link
WHERE $user_role = 'admin';

SELECT 'redirect' AS component, 'medic.sql' AS link
WHERE $user_role = 'medic';

SELECT 'redirect' AS component, 'index.sql' AS link
WHERE COALESCE($user_role, 'guest') NOT IN ('admin', 'medic');
