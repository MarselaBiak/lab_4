CREATE TABLE app_users (
    au_id SERIAL PRIMARY KEY,
    full_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

CREATE TABLE system_controllers (
    controller_id SERIAL PRIMARY KEY,
    mode VARCHAR(20) CHECK (mode IN ('auto', 'manual')),
    update_interval INTEGER CHECK (update_interval > 0),
    au_id INT 
        REFERENCES app_users (au_id)
);

CREATE TABLE safety_modules (
    sm_id SERIAL PRIMARY KEY,
    danger_level INTEGER CHECK (danger_level BETWEEN 0 AND 10),
    alert_status VARCHAR(20),
    controller_id INT 
        REFERENCES system_controllers (controller_id)
);

CREATE TABLE sensor_units (
    su_id SERIAL PRIMARY KEY,
    temperature FLOAT CHECK (temperature BETWEEN -50 AND 150),
    location VARCHAR(50),
    controller_id INT 
        REFERENCES system_controllers (controller_id)
);

CREATE TABLE sensor_data_log (
    dl_id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    value FLOAT,
    su_id INT 
        REFERENCES sensor_units (su_id),
    au_id INT 
        REFERENCES app_users (au_id)
);

CREATE TABLE creativity_modules (
    cm_id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    model_type VARCHAR(50),
    progress FLOAT CHECK (progress BETWEEN 0 AND 100),
    au_id INT 
        REFERENCES app_users (au_id)
);

CREATE TABLE user_feedback (
    uf_id SERIAL PRIMARY KEY,
    message VARCHAR(500),
    emotion_level INT CHECK (emotion_level BETWEEN 1 AND 5),
    creation_date DATE DEFAULT CURRENT_DATE,
    au_id INT 
        REFERENCES app_users (au_id),
    cm_id INT 
        REFERENCES creativity_modules (cm_id)
);

ALTER TABLE app_users
ADD CONSTRAINT email_format_check
CHECK (POSITION('@' IN email) > 1);

ALTER TABLE app_users
ADD CONSTRAINT username_length_check
CHECK (CHAR_LENGTH(full_name) > 1);

