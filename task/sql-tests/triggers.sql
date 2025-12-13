CREATE OR REPLACE FUNCTION log_patient_changes()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO logs(user_id, action, object_type, object_id, created_at)
        VALUES (NULL, 'INSERT patient', 'patient', NEW.id, NOW());
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO logs(user_id, action, object_type, object_id, created_at)
        VALUES (NULL, 'UPDATE patient', 'patient', NEW.id, NOW());
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO logs(user_id, action, object_type, object_id, created_at)
        VALUES (NULL, 'DELETE patient', 'patient', OLD.id, NOW());
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_log_patient
AFTER INSERT OR UPDATE OR DELETE ON patient
FOR EACH ROW EXECUTE FUNCTION log_patient_changes();

CREATE OR REPLACE FUNCTION update_medicine_amount()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.operation = 'поступление' THEN
        UPDATE medicine
        SET amount = amount + NEW.amount
        WHERE id = NEW.medicine_id;

    ELSIF NEW.operation = 'списание' THEN
        IF (SELECT amount FROM medicine WHERE id = NEW.medicine_id) < NEW.amount THEN
            RAISE EXCEPTION 'Недостаточно препарата на складе';
        END IF;

        UPDATE medicine
        SET amount = amount - NEW.amount
        WHERE id = NEW.medicine_id;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_medicine_op
AFTER INSERT ON medicine_operation
FOR EACH ROW EXECUTE FUNCTION update_medicine_amount();

CREATE OR REPLACE FUNCTION check_staff_age()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.birth_date > CURRENT_DATE - INTERVAL '18 years' THEN
        RAISE EXCEPTION 'Сотрудник должен быть старше 18 лет';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_staff_age
BEFORE INSERT OR UPDATE ON staff
FOR EACH ROW EXECUTE FUNCTION check_staff_age();

CREATE OR REPLACE FUNCTION validate_schedule_flags()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.paid = TRUE AND NEW.abscent IS NULL THEN
        NEW.abscent := FALSE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_schedule_flags
BEFORE INSERT OR UPDATE ON schedule
FOR EACH ROW EXECUTE FUNCTION validate_schedule_flags();

CREATE OR REPLACE FUNCTION auto_create_purchase()
RETURNS TRIGGER AS $$
DECLARE 
    service_price DECIMAL(6,2);
BEGIN
    SELECT price INTO service_price
    FROM service
    WHERE id = NEW.service_id;

    INSERT INTO purchase(service_id, patient_id, total, paid, date_time)
    SELECT NEW.service_id,
           s.patient_id,
           service_price,
           FALSE,
           NOW()
    FROM schedule s
    WHERE s.id = NEW.schedule_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_auto_purchase
AFTER INSERT ON provided_service
FOR EACH ROW EXECUTE FUNCTION auto_create_purchase();

