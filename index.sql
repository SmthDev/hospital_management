SELECT 'shell' AS component,
    'Сотрудник' AS title,
    'user' AS icon,
    '/' AS link,
    CASE COALESCE(sqlpage.cookie('session'), '')
        WHEN '' THEN '["signin", "signup"]'::json
        ELSE '["logout"]'::json
    END AS menu_item;

SELECT 'hero' AS component,
    'Поздравляю вы костик:)' AS description_md,
    'image/medic.png' AS image,
    'Войти' AS link_text;