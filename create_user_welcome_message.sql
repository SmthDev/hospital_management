SELECT 'hero' AS component,
    'Список докторов' AS title,
    -- 'Welcome, ' || $username || '! ' || 'Зашел, молодец, вопрос зачем' AS description,
    'logout.sql' AS link,
    'Выйти' AS link_text
WHERE $error IS NULL;

-- Список докторов
SELECT 'table' AS component,
    'Список докторов' AS title
WHERE $error IS NULL;

SELECT 
    d.full_name AS "ФИО",
    ds.name AS "Специализация",
    d.phone AS "Телефон",
    d.email AS "Email",
    d.experience_years AS "Стаж (лет)",
    d.cabinet AS "Кабинет"
FROM doctors d
LEFT JOIN doctor_specializations ds ON d.specialization_id = ds.id
WHERE $error IS NULL;

SELECT 'hero' AS component,
    'Sorry' AS title,
    'Sorry, the user name "' || $username || '" is already taken.' AS description,
    'signup.sql' AS link,
    'Try again' AS link_text
WHERE $error IS NOT NULL;