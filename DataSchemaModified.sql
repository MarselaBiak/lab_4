create table users (
    user_id serial primary key,
    name varchar(50) not null,
    email varchar(100) not null unique,
    password_hash varchar(255) not null
);

create table systemcontroller (
    controller_id serial primary key,
    mode varchar(20) check (mode in ('auto','manual')),
    update_interval integer check (update_interval > 0),
    user_id int references users(user_id)
);

create table safety_module (
    safety_id serial primary key,
    danger_level integer check (danger_level between 0 and 10),
    alert_status varchar(20),
    controller_id int references systemcontroller(controller_id)
);

create table sensor (
    sensor_id serial primary key,
    temperature float check (temperature between -50 and 150),
    location varchar(50),
    controller_id int references systemcontroller(controller_id)
);

create table datarecord (
    record_id serial primary key,
    timestamp timestamp default current_timestamp,
    value float,
    sensor_id int references sensor(sensor_id),
    user_id int references users(user_id)
);

alter table users add constraint email_format_check
check (email ~ '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$');
