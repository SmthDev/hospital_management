


CREATE TABLE  if not exists roles (
    id Serial PRIMARY KEY,
    name TEXT NOT NULL UNIQUE
);

INSERT INTO roles (name) VALUES ('admin');
INSERT INTO roles (name) VALUES ('guest');
INSERT INTO roles (name) VALUES ('medic');

ALTER TABLE user_info ADD COLUMN role_id INTEGER REFERENCES roles(id);

UPDATE user_info SET role_id = (SELECT id FROM roles WHERE name = 'guest');

UPDATE user_info SET role_id = (SELECT id FROM roles WHERE name = 'admin') WHERE username = 'admin';
