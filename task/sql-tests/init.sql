create table if not exists role (
	id bigserial primary key,
	name varchar(16) not null unique
);

create table if not exists patient (
	id bigserial primary key,
	full_name varchar(64) not null,
	sex varchar(1) check (sex in ('M', 'F')),
	birth_date date not null,
	adress varchar(128),
	phone_number varchar(16) unique,
	email varchar(320) unique,
	card_number varchar(16) unique
);

create table if not exists department (
	id bigserial primary key,
	name varchar(32) not null unique
);

create table if not exists position (
	id bigserial primary key,
	name varchar(32) not null unique
);

create table if not exists staff (
	id bigserial primary key,
	full_name varchar(64) not null,
	birth_date date not null,
	email varchar(320) unique,
	position_id bigint references position(id),
	department_id bigint references department(id),
	role_id bigint references role(id),
	login varchar(32) not null unique,
	password varchar not null
);

create index if not exists idx_staff_position on staff(position_id);
create index if not exists idx_staff_department on staff(department_id);
create index if not exists idx_staff_role on staff(role_id);

create table if not exists service (
	id bigserial primary key,
	name varchar(64) not null unique,
	duration int check (duration > 0),
	price decimal(6,2) check (price > 0)
);

create table if not exists medicine (
	id bigserial primary key,
	name varchar(32) not null unique,
	description varchar(256),
	category varchar(32),
	amount int check (amount >= 0),
	warranty int check (warranty >= 0)
);

create table if not exists medicine_operation (
    id bigserial primary key,
    medicine_id bigint not null references medicine(id),
    operation varchar(32) not null,
    amount int check (amount > 0),
    price decimal(6,2) check (price >= 0),
    date date not null
);

create index if not exists idx_medop_medicine on medicine_operation(medicine_id);

create table if not exists schedule (
    id bigserial primary key,
    staff_id bigint references staff(id),
    patient_id bigint references patient(id),
    paid boolean default false,
    absent boolean default false,
    date_time timestamp not null
);

create index if not exists idx_schedule_staff on schedule(staff_id);
create index if not exists idx_schedule_patient on schedule(patient_id);

create table if not exists examination (
    id bigserial primary key,
    schedule_id bigint not null references schedule(id),
    type varchar(32),
    disease varchar(128),
    result varchar(256)
);

create table if not exists provided_service (
    id bigserial primary key,
    service_id bigint references service(id),
    schedule_id bigint references schedule(id)
);

create table if not exists prescription (
    id bigserial primary key,
    examination_id bigint references examination(id),
    medicine_id bigint references medicine(id)
);

create table if not exists purchase (
    id bigserial primary key,
    service_id bigint references service(id),
    patient_id bigint references patient(id),
    total decimal(6,2) check (total >= 0),
    paid boolean default false,
    date_time timestamp not null
);

create table if not exists logs (
	id bigserial primary key,
	user_id bigint references staff(id),
	action varchar(256),
	object_type varchar(128),
	object_id varchar(128),
	created_at timestamp
)




