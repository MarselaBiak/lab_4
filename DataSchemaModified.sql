create table users (
user_id serial primary key,
name varchar(50) not null,
email varchar(100) not null unique,
password_hash varchar(255) not null
)

create table systemcontroller (
controller_id serial primary key,
mode varchar(20) check (mode in ('auto','manual')),
update_interval integer check (update_interval > 0),
user_id int references users(user_id)
)
