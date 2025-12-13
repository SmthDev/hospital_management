
SELECT 'shell' AS component,
       'Тест ссылок назначений' AS title;

SELECT 'text' AS component,
       '# Тестовые ссылки для добавления назначений' AS contents_md;

SELECT 'text' AS component,
       'Для работы с назначениями нужно сначала авторизоваться как врач (username: tt)' AS contents_md;

SELECT 'card' AS component,
       2 AS columns;

SELECT
    'Пациент: ' || p.full_name AS title,
    'ID: ' || p.id AS description,
    'user' AS icon,
    'blue' AS color,
    'medic_add_prescription.sql?patient_id=' || p.id AS link,
    'Добавить назначение' AS footer
FROM patients p
ORDER BY p.id;

SELECT 'text' AS component,
       '## Прямые ссылки для копирования:' AS contents_md;

SELECT 'list' AS component;

SELECT
    '[Добавить назначение для: ' || p.full_name || '](medic_add_prescription.sql?patient_id=' || p.id || ')' AS title,
    'Patient ID: ' || p.id AS description
FROM patients p
ORDER BY p.id;

SELECT 'text' AS component,
       '## Пример POST запроса с curl:' AS contents_md;

SELECT 'code' AS component;

SELECT 'bash' AS language,
       'curl -X POST \
  -b "session=YOUR_SESSION_COOKIE" \
  http://localhost:8080/medic_save_prescription.sql \
  -d "patient_id=1" \
  -d "medicine_id=1" \
  -d "dosage=1 таб 3 раза/день" \
  -d "instructions=После еды" \
  -d "start_date=2025-12-13"' AS contents;

