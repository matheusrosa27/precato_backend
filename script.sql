DROP DATABASE IF EXISTS precato;
CREATE DATABASE precato;
USE precato;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';
SET SQL_SAFE_UPDATES = 0;

CREATE TABLE message_flow (
	id SERIAL AUTO_INCREMENT NOT NULL,
    template_name VARCHAR(255),
    position INT,
    primary key(id)
);

CREATE TABLE subscriptions (
	id SERIAL AUTO_INCREMENT NOT NULL,
    subscription_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    name VARCHAR(255) UNIQUE,
    last_message INT DEFAULT 0,
    active BOOLEAN DEFAULT TRUE,
    primary key(id)
);

INSERT INTO subscriptions (name, last_message, active)
VALUES ("matheusmemphis@gmail.com", 01, false);
INSERT INTO subscriptions (name, last_message)
VALUES ("matheusphis@gmail.com", 02);
INSERT INTO subscriptions (name, last_message)
VALUES ("matheusmes@gmail.com", 03);

INSERT INTO message_flow (template_name, position)
VALUES ("test 1", 01);
INSERT INTO message_flow (template_name, position)
VALUES ("test 2", 11);
INSERT INTO message_flow (template_name, position)
VALUES ("test 3", 04);

select * from subscriptions;
select * from message_flow;
select * from subscriptions inner join message_flow on message_flow.id = last_message;

CREATE EVENT att ON SCHEDULE
	EVERY 8 DAY_HOUR
    DO
		UPDATE `subscriptions` SET `last_message` = CASE
			WHEN active = 1 THEN (select id from message_flow ORDER BY id DESC LIMIT 1)
            ELSE (last_message)
            END
		