CREATE DATABASE hvp;
use hvp;

CREATE TABLE users (
  user_id        INTEGER AUTO_INCREMENT PRIMARY KEY,
  full_name      VARCHAR(100) NOT NULL DEFAULT '',
  affiliation    VARCHAR(100) NOT NULL DEFAULT '',
  email          VARCHAR(100) NOT NULL,
  password       CHAR(60)     NOT NULL,
  alt_password   CHAR(60)     NOT NULL DEFAULT '',
  last_login_utc DATETIME              DEFAULT NULL,
  added_by       INTEGER      NOT NULL,
  added_utc      DATETIME     NOT NULL DEFAULT (UTC_TIMESTAMP())
);

CREATE TABLE auth_tokens (
  auth_token_id    INTEGER AUTO_INCREMENT PRIMARY KEY,
  user_id          INTEGER   NOT NULL,
  auth_token_sha   CHAR(128) NOT NULL,
  valid_until_utc  DATETIME  NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);

INSERT INTO users (full_name, affiliation, email, password, added_by)
  VALUES ('Daniel Smith', 'BCM', 'dpsmith@bcm.edu', '$2a$12$Hfj7shdBenM6oJcSJm7CLeVac44mYfb3uAL9T2c9zTigXB1SBwOKO', 1);

CREATE UNIQUE INDEX users_idx1 ON users (email);
CREATE UNIQUE INDEX auth_tokens_idx1 ON auth_tokens (auth_token_sha);
ALTER TABLE users ADD CONSTRAINT users_fk1 FOREIGN KEY (added_by) REFERENCES users(user_id);


CREATE USER 'website'@'localhost';
GRANT SELECT, INSERT, UPDATE, DELETE ON hvp.* TO 'website'@'localhost';

FLUSH PRIVILEGES;
