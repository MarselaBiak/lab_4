-- Таблиця користувачів
CREATE TABLE "users" (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- Таблиця контролерів системи
CREATE TABLE system_controllers (
    controller_id SERIAL PRIMARY KEY,
    mode VARCHAR(20) CHECK (mode IN ('auto', 'manual')),
    update_interval INTEGER CHECK (update_interval > 0),
    user_id INT REFERENCES "users" (user_id)
);

-- Таблиця модулів безпеки
CREATE TABLE safety_modules (
    safety_id SERIAL PRIMARY KEY,
    danger_level INTEGER CHECK (danger_level BETWEEN 0 AND 10),
    alert_status VARCHAR(20),
    controller_id INT REFERENCES system_controllers (controller_id)
);

-- Таблиця сенсорів
CREATE TABLE sensors (
    sensor_id SERIAL PRIMARY KEY,
    temperature FLOAT CHECK (temperature BETWEEN -50 AND 150),
    location VARCHAR(50),
    controller_id INT REFERENCES system_controllers (controller_id)
);

-- Таблиця записів даних сенсорів
CREATE TABLE sensor_data_logs (
    record_id SERIAL PRIMARY KEY,
    ts TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    value FLOAT,
    sensor_id INT REFERENCES sensors (sensor_id),
    user_id INT REFERENCES "users" (user_id)
);

-- Таблиця модулів творчості
CREATE TABLE creativity_modules (
    model_id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    model_type VARCHAR(50),
    progress FLOAT CHECK (progress BETWEEN 0 AND 100),
    user_id INT REFERENCES "users" (user_id)
);

-- Таблиця зворотного зв’язку
CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    message VARCHAR(500),
    emotion_level INT CHECK (emotion_level BETWEEN 1 AND 5),
    creation_date DATE DEFAULT CURRENT_DATE,
    user_id INT REFERENCES "users" (user_id),
    model_id INT REFERENCES creativity_modules (model_id)
);

ALTER TABLE "users"
    ADD CONSTRAINT email_format_check
    CHECK (email ~ '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');

ALTER TABLE "users"
    ADD CONSTRAINT username_pattern_check
    CHECK (full_name ~ '^([A-Z][a-z]+)(\s[A-Z][a-z]+)*$');

