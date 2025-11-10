
/* Таблиця користувачів */
CREATE TABLE Users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

/* Таблиця контролерів системи */
CREATE TABLE SystemController (
    controller_id SERIAL PRIMARY KEY,
    mode VARCHAR(20) CHECK (mode IN ('auto', 'manual')),
    update_interval INTEGER CHECK (update_interval > 0),
    user_id INT REFERENCES Users(user_id)
);

/* Таблиця модулів безпеки */
CREATE TABLE SafetyModule (
    safety_id SERIAL PRIMARY KEY,
    danger_level INTEGER CHECK (danger_level BETWEEN 0 AND 10),
    alert_status VARCHAR(20),
    controller_id INT REFERENCES SystemController(controller_id)
);

/* Таблиця сенсорів */
CREATE TABLE Sensor (
    sensor_id SERIAL PRIMARY KEY,
    temperature FLOAT CHECK (temperature BETWEEN -50 AND 150),
    location VARCHAR(50),
    controller_id INT REFERENCES SystemController(controller_id)
);

/* Таблиця записів даних сенсорів */
CREATE TABLE DataRecord (
    record_id SERIAL PRIMARY KEY,
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    value FLOAT,
    sensor_id INT REFERENCES Sensor(sensor_id),
    user_id INT REFERENCES Users(user_id)
);

/* Таблиця модулів творчості */
CREATE TABLE CreativityModule (
    model_id SERIAL PRIMARY KEY,
    model_name VARCHAR(100) NOT NULL,
    model_type VARCHAR(50),
    progress FLOAT CHECK (progress BETWEEN 0 AND 100),
    user_id INT REFERENCES Users(user_id)
);

/* Таблиця зворотного зв’язку */
CREATE TABLE Feedback (
    feedback_id SERIAL PRIMARY KEY,
    message VARCHAR(500),
    emotion_level INT CHECK (emotion_level BETWEEN 1 AND 5),
    creation_date DATE DEFAULT CURRENT_DATE,
    user_id INT REFERENCES Users(user_id),
    model_id INT REFERENCES CreativityModule(model_id)
);

-- Обмеження цілісності з використанням регулярних виразів


/* Перевірка формату email */
ALTER TABLE Users ADD CONSTRAINT email_format_check
CHECK (email ~ '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');

/* Перевірка правильності імені користувача */
ALTER TABLE Users ADD CONSTRAINT username_pattern_check
CHECK (name ~ '^[A-Z][a-z]+(?:\s[A-Z][a-z]+)*$');
