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

SET medicine_name = :name;
SET medicine_category = :category;
SET medicine_description = NULLIF(:description, '');

INSERT INTO medicines (name, category, description)
VALUES ($medicine_name, $medicine_category, $medicine_description);

SELECT 'redirect' AS component,
       'medic_medicines.sql?success=added' AS link;
