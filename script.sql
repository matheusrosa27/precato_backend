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
    last_message INT DEFAULT 1,
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
VALUES ("inicial message", 01);
INSERT INTO message_flow (template_name, position)
VALUES ("test 2", 02);
INSERT INTO message_flow (template_name, position)
VALUES ("test 3", 03);

SELECT * FROM subscriptions;
SELECT * FROM message_flow;
SELECT * FROM subscriptions INNER JOIN message_flow ON message_flow.id = last_message;

CREATE EVENT att ON SCHEDULE
	EVERY 8 DAY_HOUR
    DO
		UPDATE `subscriptions` SET `last_message` = CASE
			WHEN active = 1 THEN (select id from message_flow ORDER BY id DESC LIMIT 1)
            ELSE (last_message)
            END;
            
CREATE EVENT att_sec ON SCHEDULE
	EVERY 2 second
	DO
		UPDATE `subscriptions` SET `active` = CASE
			WHEN last_message = (select id from message_flow ORDER BY id DESC LIMIT 1) THEN (0)
            ELSE (1)
            END;
            
/* Testes */
INSERT INTO subscriptions (name) VALUES ("matheusblega@gmail.com");            

INSERT INTO message_flow (template_name, position)
VALUES ("test 4", 04);

INSERT INTO message_flow (template_name, position)
VALUES ("test 5", 05);

SELECT * FROM subscriptions INNER JOIN message_flow ON message_flow.id = last_message;