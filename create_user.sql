INSERT INTO user_info (username, password_hash, role_id)
VALUES (:username, sqlpage.hash_password(:password),2)
ON CONFLICT (username) DO NOTHING
RETURNING 
    'redirect' AS component,
    'create_user_welcome_message.sql?username=' || :username AS link;
SELECT 'redirect' AS component, 'signup.sql?error&username=' || :username AS link;
