
SET username = (SELECT username FROM login_session WHERE id = sqlpage.cookie('session'));
SELECT 'redirect' AS component,
        'signin.sql?error' AS link
WHERE $username IS NULL;




SET random_username = 'user_' || substr(sqlpage.random_string(8), 1, 8);
SET random_password = sqlpage.random_string(12);


SELECT 'redirect' AS component,
       'admin.sql?random_username=' || $random_username || '&random_password=' || $random_password AS link
      
       
