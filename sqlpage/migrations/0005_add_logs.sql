-- Таблица для хранения логов
CREATE TABLE IF NOT EXISTS logs (
    id SERIAL PRIMARY KEY,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    action TEXT NOT NULL,
    table_name TEXT NOT NULL,
    data JSONB NOT NULL
);

-- Функция для логирования изменений в user_info
CREATE OR REPLACE FUNCTION log_user_info_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO logs (action, table_name, data)
        VALUES ('INSERT', 'user_info', jsonb_build_object(
            'username', NEW.username,
            'role_id', NEW.role_id
        ));
        RETURN NEW;
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO logs (action, table_name, data)
        VALUES ('UPDATE', 'user_info', jsonb_build_object(
            'username', NEW.username,
            'old_role_id', OLD.role_id,
            'new_role_id', NEW.role_id
        ));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO logs (action, table_name, data)
        VALUES ('DELETE', 'user_info', jsonb_build_object(
            'username', OLD.username,
            'role_id', OLD.role_id
        ));
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Триггер для user_info
DROP TRIGGER IF EXISTS user_info_log_trigger ON user_info;
CREATE TRIGGER user_info_log_trigger
AFTER INSERT OR UPDATE OR DELETE ON user_info
FOR EACH ROW EXECUTE FUNCTION log_user_info_changes();

-- Функция для логирования сессий
CREATE OR REPLACE FUNCTION log_login_session_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO logs (action, table_name, data)
        VALUES ('LOGIN', 'login_session', jsonb_build_object(
            'username', NEW.username,
            'session_id', substring(NEW.id, 1, 8) || '...'
        ));
        RETURN NEW;
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO logs (action, table_name, data)
        VALUES ('LOGOUT', 'login_session', jsonb_build_object(
            'username', OLD.username,
            'session_id', substring(OLD.id, 1, 8) || '...'
        ));
        RETURN OLD;
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Триггер для login_session
DROP TRIGGER IF EXISTS login_session_log_trigger ON login_session;
CREATE TRIGGER login_session_log_trigger
AFTER INSERT OR DELETE ON login_session
FOR EACH ROW EXECUTE FUNCTION log_login_session_changes();
