
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
SET medicine_name = :name;
SET medicine_category = :category;
SET medicine_description = NULLIF(:description, '');


SELECT 'redirect' AS component,
       'medic_medicines.sql?error=missing_id' AS link
WHERE $medicine_id IS NULL OR $medicine_id = '';

UPDATE medicines
SET name = $medicine_name,
    category = $medicine_category,
    description = $medicine_description
WHERE id = $medicine_id::int;

SELECT 'redirect' AS component,
       'medic_medicines.sql?success=updated' AS link;
