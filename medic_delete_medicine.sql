
SET username = (
    SELECT username
    FROM login_session
    WHERE id = sqlpage.cookie('session')
);

SELECT 'redirect' AS component,
       'signin.sql?error' AS link
WHERE $username IS NULL;


SET user_role = (
    SELECT r.name
    FROM user_info u
    JOIN roles r ON u.role_id = r.id
    WHERE u.username = $username
);

SELECT 'redirect' AS component,
       'main_page.sql' AS link
WHERE $user_role != 'medic' AND $user_role != 'admin';


SET med_id = $id::int;


SELECT 'redirect' AS component,
       'medic_medicines.sql?error=bad_id' AS link
WHERE $med_id IS NULL;


SET del_id = (
    SELECT id
    FROM medicines
    WHERE id = $med_id::int
);

SELECT 'redirect' AS component,
       'medic_medicines.sql?error=not_found' AS link
WHERE $del_id IS NULL;

-- 5. Удаляем запись
DELETE FROM medicines
WHERE id = $med_id::int;

-- 6. Редирект после удаления
SELECT 'redirect' AS component,
       'medic_medicines.sql?success=deleted' AS link;
