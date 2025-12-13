CREATE TABLE IF NOT EXISTS patients (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(64) NOT NULL,
    birth_date DATE,
    phone VARCHAR(15),
    email VARCHAR(320),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS medicines (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL,
    description TEXT,
    category VARCHAR(32)
);

CREATE TABLE IF NOT EXISTS medic_prescriptions (
    id SERIAL PRIMARY KEY,
    patient_id INTEGER NOT NULL REFERENCES patients(id) ON DELETE CASCADE,
    medicine_id INTEGER NOT NULL REFERENCES medicines(id) ON DELETE CASCADE,
    medic_username TEXT NOT NULL REFERENCES user_info(username),
    dosage VARCHAR(128),
    instructions TEXT,
    start_date DATE NOT NULL DEFAULT CURRENT_DATE,
    end_date DATE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX IF NOT EXISTS idx_prescriptions_patient ON medic_prescriptions(patient_id);
CREATE INDEX IF NOT EXISTS idx_prescriptions_medic ON medic_prescriptions(medic_username);
CREATE INDEX IF NOT EXISTS idx_prescriptions_medicine ON medic_prescriptions(medicine_id);

INSERT INTO medicines (name, description, category) VALUES 
    ('Парацетамол', 'Жаропонижающее и обезболивающее', 'Анальгетики'),
    ('Ибупрофен', 'Противовоспалительное средство', 'НПВС'),
    ('Амоксициллин', 'Антибиотик широкого спектра', 'Антибиотики'),
    ('Омепразол', 'Препарат для лечения ЖКТ', 'Гастроэнтерология'),
    ('Лоратадин', 'Антигистаминное средство', 'Антигистаминные')
ON CONFLICT DO NOTHING;

INSERT INTO patients (full_name, birth_date, phone, email) VALUES 
    ('Иванов Иван Иванович', '1985-03-15', '+375291234567', 'ivanov@mail.com'),
    ('Петрова Мария Сергеевна', '1990-07-22', '+375297654321', 'petrova@mail.com'),
    ('Сидоров Алексей Петрович', '1978-11-08', '+375331112233', 'sidorov@mail.com')
ON CONFLICT DO NOTHING;
