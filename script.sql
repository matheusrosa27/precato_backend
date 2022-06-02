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

/* Email with active: false */
INSERT INTO subscriptions (name, active)
VALUES ("matheusmemphis@gmail.com", false);

/* Normal emails */
INSERT INTO subscriptions (name)
VALUES ("matheusphis@gmail.com");
INSERT INTO subscriptions (name, last_message)
VALUES ("matheusmes@gmail.com", 02);

/* Normal messages */
INSERT INTO message_flow (template_name, position)
VALUES ("inicial message", 01);
INSERT INTO message_flow (template_name, position)
VALUES ("test 2", 02);
INSERT INTO message_flow (template_name, position)
VALUES ("test 3", 02);

SELECT * FROM subscriptions;
SELECT * FROM message_flow;
SELECT * FROM subscriptions INNER JOIN message_flow ON message_flow.id = last_message;

CREATE EVENT att ON SCHEDULE
	EVERY 24 HOUR
    DO
		UPDATE `subscriptions` SET `last_message` = CASE
			WHEN (active = 1) 
				THEN ( CASE
					WHEN (SELECT position FROM message_flow WHERE position = (SELECT DAY(CURDATE())) ORDER BY id DESC LIMIT 1) = (SELECT DAY(CURDATE()))
						THEN (select id from message_flow WHERE position = (SELECT DAY(CURDATE())) ORDER BY id DESC LIMIT 1)
					ELSE (last_message)
                END)
            ELSE (last_message)
            END;
CREATE EVENT att2 ON SCHEDULE
	EVERY 1 second
    DO
		UPDATE subscriptions SET active = CASE
			WHEN last_message = (SELECT id FROM message_flow WHERE position = (select day(curdate())))
            THEN (0)
            ELSE (active)
		END;

    
/* Tests */
/* Creating another email after basic DB */
INSERT INTO subscriptions (name) VALUES ("matheusblega@gmail.com");

/* Creating another messages after basic DB */
INSERT INTO message_flow (template_name, position)
VALUES ("test 4", 03);
INSERT INTO message_flow (template_name, position)
VALUES ("test 5", 05);

/* Select to see everything */
SELECT 
    subscriptions.id,
    subscription_date,
    name,
    last_message,
    active,
    message_flow.id,
    template_name,
    position
FROM subscriptions INNER JOIN message_flow ON message_flow.id = last_message;

/* If you want to activate ALL EMAILS, run this */
/* UPDATE subscriptions SET active = 1; */