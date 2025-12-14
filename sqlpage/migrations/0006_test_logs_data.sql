-- Тестовые данные для таблицы logs

INSERT INTO logs (created_at, action, table_name, data) VALUES
-- Логины пользователей
(NOW() - INTERVAL '7 days', 'LOGIN', 'login_session', '{"username": "admin", "session_id": "abc12345..."}'),
(NOW() - INTERVAL '6 days 23 hours', 'LOGIN', 'login_session', '{"username": "doctor1", "session_id": "def67890..."}'),
(NOW() - INTERVAL '6 days 20 hours', 'LOGOUT', 'login_session', '{"username": "doctor1", "session_id": "def67890..."}'),
(NOW() - INTERVAL '6 days', 'LOGIN', 'login_session', '{"username": "nurse1", "session_id": "ghi11111..."}'),

-- Создание пользователей
(NOW() - INTERVAL '5 days', 'INSERT', 'user_info', '{"username": "doctor2", "role_id": 3}'),
(NOW() - INTERVAL '5 days 2 hours', 'INSERT', 'user_info', '{"username": "patient1", "role_id": 2}'),
(NOW() - INTERVAL '4 days 18 hours', 'INSERT', 'user_info', '{"username": "nurse2", "role_id": 3}'),

-- Обновления ролей
(NOW() - INTERVAL '4 days', 'UPDATE', 'user_info', '{"username": "nurse1", "old_role_id": 2, "new_role_id": 3}'),
(NOW() - INTERVAL '3 days 12 hours', 'UPDATE', 'user_info', '{"username": "patient1", "old_role_id": 2, "new_role_id": 3}'),

-- Еще логины
(NOW() - INTERVAL '3 days', 'LOGIN', 'login_session', '{"username": "admin", "session_id": "jkl22222..."}'),
(NOW() - INTERVAL '2 days 20 hours', 'LOGIN', 'login_session', '{"username": "doctor2", "session_id": "mno33333..."}'),
(NOW() - INTERVAL '2 days 15 hours', 'LOGOUT', 'login_session', '{"username": "admin", "session_id": "jkl22222..."}'),
(NOW() - INTERVAL '2 days', 'LOGIN', 'login_session', '{"username": "nurse2", "session_id": "pqr44444..."}'),

-- Удаление пользователя
(NOW() - INTERVAL '1 day 18 hours', 'DELETE', 'user_info', '{"username": "patient1", "role_id": 3}'),

-- Недавние действия
(NOW() - INTERVAL '1 day', 'LOGIN', 'login_session', '{"username": "admin", "session_id": "stu55555..."}'),
(NOW() - INTERVAL '20 hours', 'INSERT', 'user_info', '{"username": "doctor3", "role_id": 3}'),
(NOW() - INTERVAL '15 hours', 'LOGIN', 'login_session', '{"username": "doctor3", "session_id": "vwx66666..."}'),
(NOW() - INTERVAL '10 hours', 'UPDATE', 'user_info', '{"username": "doctor2", "old_role_id": 3, "new_role_id": 1}'),
(NOW() - INTERVAL '5 hours', 'LOGOUT', 'login_session', '{"username": "doctor3", "session_id": "vwx66666..."}'),
(NOW() - INTERVAL '2 hours', 'LOGIN', 'login_session', '{"username": "admin", "session_id": "yz077777..."}'),
(NOW() - INTERVAL '1 hour', 'INSERT', 'user_info', '{"username": "intern1", "role_id": 2}'),
(NOW() - INTERVAL '30 minutes', 'LOGIN', 'login_session', '{"username": "intern1", "session_id": "aaa88888..."}');
