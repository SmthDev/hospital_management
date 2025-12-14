-- Таблица специализаций врачей
CREATE TABLE IF NOT EXISTS doctor_specializations (
    id SERIAL PRIMARY KEY,
    name VARCHAR(64) NOT NULL UNIQUE,
    description TEXT
);

-- 6 специализаций врачей
INSERT INTO doctor_specializations (name, description) VALUES
    ('Терапевт', 'Врач общей практики, лечение внутренних болезней'),
    ('Хирург', 'Оперативное лечение заболеваний и травм'),
    ('Кардиолог', 'Диагностика и лечение заболеваний сердечно-сосудистой системы'),
    ('Невролог', 'Лечение заболеваний нервной системы'),
    ('Педиатр', 'Лечение детских заболеваний'),
    ('Офтальмолог', 'Диагностика и лечение заболеваний глаз')
ON CONFLICT (name) DO NOTHING;

-- Таблица врачей
CREATE TABLE IF NOT EXISTS doctors (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(128) NOT NULL,
    specialization_id INTEGER REFERENCES doctor_specializations(id),
    phone VARCHAR(20),
    email VARCHAR(320),
    experience_years INTEGER,
    cabinet VARCHAR(20),
    username TEXT REFERENCES user_info(username),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 10 врачей для демонстрации
INSERT INTO doctors (full_name, specialization_id, phone, email, experience_years, cabinet) VALUES
    ('Смирнов Андрей Викторович', 1, '+375291001001', 'smirnov@clinic.by', 15, '101'),
    ('Козлова Елена Николаевна', 1, '+375291001002', 'kozlova@clinic.by', 8, '102'),
    ('Новиков Дмитрий Александрович', 2, '+375291001003', 'novikov@clinic.by', 20, '201'),
    ('Морозова Анна Сергеевна', 2, '+375291001004', 'morozova@clinic.by', 12, '202'),
    ('Волков Сергей Петрович', 3, '+375291001005', 'volkov@clinic.by', 18, '301'),
    ('Соколова Ирина Владимировна', 3, '+375291001006', 'sokolova@clinic.by', 10, '302'),
    ('Лебедев Михаил Игоревич', 4, '+375291001007', 'lebedev@clinic.by', 14, '401'),
    ('Федорова Ольга Дмитриевна', 5, '+375291001008', 'fedorova@clinic.by', 22, '501'),
    ('Егоров Александр Васильевич', 5, '+375291001009', 'egorov@clinic.by', 7, '502'),
    ('Павлова Наталья Андреевна', 6, '+375291001010', 'pavlova@clinic.by', 11, '601')
ON CONFLICT DO NOTHING;

-- Добавим ещё пациентов для демонстрации
INSERT INTO patients (full_name, birth_date, phone, email) VALUES 
    ('Кузнецов Павел Олегович', '1982-05-20', '+375294445566', 'kuznetsov@mail.com'),
    ('Новикова Светлана Игоревна', '1995-12-03', '+375297778899', 'novikova@mail.com'),
    ('Морозов Денис Валерьевич', '1970-08-14', '+375331234567', 'morozov@mail.com'),
    ('Волкова Екатерина Павловна', '1988-01-30', '+375337654321', 'volkova@mail.com'),
    ('Соколов Артём Дмитриевич', '2000-06-25', '+375292223344', 'sokolov@mail.com')
ON CONFLICT DO NOTHING;

-- Добавим ещё лекарств
INSERT INTO medicines (name, description, category) VALUES 
    ('Аспирин', 'Обезболивающее и жаропонижающее', 'Анальгетики'),
    ('Метформин', 'Препарат для лечения диабета 2 типа', 'Эндокринология'),
    ('Атенолол', 'Бета-блокатор для лечения гипертонии', 'Кардиология'),
    ('Диазепам', 'Транквилизатор, седативное средство', 'Неврология'),
    ('Цефтриаксон', 'Антибиотик цефалоспоринового ряда', 'Антибиотики')
ON CONFLICT DO NOTHING;
