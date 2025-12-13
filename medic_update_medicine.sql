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

SELECT 'redirect' AS component,
       'medic_medicines.sql?error=missing_id' AS link
WHERE COALESCE(:id, '') = '';

UPDATE medicines
SET name = :name,
    category = :category,
    description = NULLIF(:description, '')
WHERE id = CAST(:id AS INTEGER);

SELECT 'redirect' AS component,
       CASE 
           WHEN changes() > 0 THEN 'medic_medicines.sql?success=updated'
           ELSE 'medic_medicines.sql?error=update_failed'
       END AS link;

