CREATE TABLE role (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(16) NOT NULL UNIQUE
);

CREATE TABLE patient (
    id BIGSERIAL PRIMARY KEY,
    full_name      VARCHAR(64) NOT NULL,
    sex            VARCHAR(1) CHECK (sex IN ('M','F')),
    birth_date     DATE NOT NULL,
    address        VARCHAR(128),
    phone_number   VARCHAR(15) UNIQUE,
    email          VARCHAR(320) UNIQUE,
    card_number    VARCHAR(8) UNIQUE
);

CREATE TABLE department (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE position (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL UNIQUE
);

CREATE TABLE staff (
    id BIGSERIAL PRIMARY KEY,
    full_name VARCHAR(64) NOT NULL,
    birth_date DATE NOT NULL,
    email VARCHAR(320) UNIQUE,
    position_id BIGINT REFERENCES position(id),
    department_id BIGINT REFERENCES department(id),
    role_id BIGINT REFERENCES role(id),
    login VARCHAR(32) UNIQUE NOT NULL,
    password VARCHAR(32) NOT NULL
);

CREATE INDEX idx_staff_position ON staff(position_id);
CREATE INDEX idx_staff_department ON staff(department_id);
CREATE INDEX idx_staff_role ON staff(role_id);

CREATE TABLE service (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    duration INTEGER CHECK (duration > 0),
    price DECIMAL(6,2) CHECK (price >= 0)
);

CREATE TABLE medicine (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(32) NOT NULL,
    description VARCHAR(256),
    category VARCHAR(32),
    amount INT CHECK (amount >= 0),
    warranty INT CHECK (warranty >= 0)
);

CREATE TABLE medicine_operation (
    id BIGSERIAL PRIMARY KEY,
    medicine_id BIGINT NOT NULL REFERENCES medicine(id),
    operation VARCHAR(32) NOT NULL,
    amount INT CHECK (amount > 0),
    price DECIMAL(6,2) CHECK (price >= 0),
    date DATE NOT NULL
);

CREATE INDEX idx_medop_medicine ON medicine_operation(medicine_id);

CREATE TABLE schedule (
    id BIGSERIAL PRIMARY KEY,
    staff_id BIGINT REFERENCES staff(id),
    patient_id BIGINT REFERENCES patient(id),
    paid BOOLEAN DEFAULT FALSE,
    absent BOOLEAN DEFAULT FALSE,
    date_time TIMESTAMP NOT NULL
);

CREATE INDEX idx_schedule_staff ON schedule(staff_id);
CREATE INDEX idx_schedule_patient ON schedule(patient_id);

CREATE TABLE examination (
    id BIGSERIAL PRIMARY KEY,
    schedule_id BIGINT NOT NULL REFERENCES schedule(id),
    type VARCHAR(32),
    disease VARCHAR(128),
    result VARCHAR(256)
);

CREATE TABLE provided_service (
    id BIGSERIAL PRIMARY KEY,
    service_id BIGINT REFERENCES service(id),
    schedule_id BIGINT REFERENCES schedule(id)
);

CREATE TABLE prescription (
    id BIGSERIAL PRIMARY KEY,
    examination_id BIGINT REFERENCES examination(id),
    medicine_id BIGINT REFERENCES medicine(id)
);

CREATE TABLE purchase (
    id BIGSERIAL PRIMARY KEY,
    service_id BIGINT REFERENCES service(id),
    patient_id BIGINT REFERENCES patient(id),
    total DECIMAL(6,2) CHECK (total >= 0),
    paid BOOLEAN DEFAULT FALSE,
    date_time TIMESTAMP NOT NULL
);

CREATE INDEX idx_purchase_patient ON purchase(patient_id);
