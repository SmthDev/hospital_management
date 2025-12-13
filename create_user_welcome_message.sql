SELECT 'hero' AS component,
    'Welcome' AS title,
    'Welcome, ' || $username || '! ' || 'Зашел, молодец, вопрос зачем' AS description,
    'logout.sql' AS link,
    'нахер отсюда' AS link_text
WHERE $error IS NULL;

SELECT 'hero' AS component,
    'Sorry' AS title,
    'Sorry, the user name "' || $username || '" is already taken.' AS description,
    'signup.sql' AS link,
    'Try again' AS link_text
WHERE $error IS NOT NULL;