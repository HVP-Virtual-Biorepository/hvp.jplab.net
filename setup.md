
## Purpose

This file contains technical notes for re-creating the
AWS resources needed by this website.


### RDS Database Cluster

In the AWS Management Console, navigate to "Aurora and RDS" and select "Create a Database".

* Engine options: Engine type = Aurora (MySQL Compatible)
* Settings: Credentials management = Self Managed
* Settings: Specify a master username and password.
* Cluster storage configuration: Configuration options = Aurora Standard
* Instance configuration: DB instance class = Serverless v2
* Instance configuration: Minimum capacity (ACUs) = 0
* Instance configuration: Maximum capacity (ACUs) = 4
* Availability & durability: Multi-AZ deployment = Multi-AZ deployment
* Connectivity: Public access = Yes
* Connectivity: VPC security group (firewall) = Create new
* Connectivity: New VPC security group name = mysql_secgrp
* Connectivity: Enable the RDS Data API = Checked
* Monitoring: Database Insights = Standard
* Monitoring: Performance Insights = Unchecked
* Monitoring: Enhanced Monitoring = Unchecked

Take note of the endpoint name (e.g. db.cluster-abcdef1234.us-east-1.rds.amazonaws.com). 
This will be the host for MySQL clients to connect to.


### Edit/Add MySQL Accounts

Once the database is available, go to the "Query editor" (left menu).
Connect by setting Database username = "Add new database credentials" and entering 
the master username and password.
Next time you connect, set Database username = master username.

Run the following commands, replacing `mypass` with the master password. 
Take note of the generated passwords created by the `CREATE USER` commands.

```mysql
ALTER USER 'admin'@'%' IDENTIFIED WITH caching_sha2_password BY 'mypass' REPLACE 'mypass';

CREATE USER 'readonly'@'%' IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;
CREATE USER 'hvp_lambda'@'%' IDENTIFIED WITH caching_sha2_password BY RANDOM PASSWORD;

CREATE DATABASE hvp;
GRANT ALL PRIVILEGES ON hvp.*           TO 'admin'@'%';
GRANT SELECT         ON hvp.*           TO 'readonly'@'%';
GRANT SELECT, INSERT ON hvp.*           TO 'hvp_lambda'@'%';
GRANT UPDATE         ON hvp.users       TO 'hvp_lambda'@'%';
GRANT UPDATE, DELETE ON hvp.auth_tokens TO 'hvp_lambda'@'%';

FLUSH PRIVILEGES;
```

### Connect to MySQL Server

Use a MySQL client to connect using:

* Host = endpoint name
* Port = 3306
* Username
* Password



### Add MySQL Tables

After connecting with the master account:

```mysql
use hvp;

DROP TABLE auth_tokens;
DROP TABLE users;

CREATE TABLE users (
  user_id        INTEGER PRIMARY KEY,
  full_name      VARCHAR(100) NOT NULL DEFAULT '',
  affiliation    VARCHAR(100) NOT NULL DEFAULT '',
  email          VARCHAR(100) NOT NULL,
  password       CHAR(60)     NOT NULL,
  alt_password   CHAR(60)     NOT NULL DEFAULT '',
  last_login_utc DATETIME              DEFAULT NULL,
  added_by       INTEGER      NOT NULL,
  added_utc      DATETIME     NOT NULL DEFAULT (UTC_TIMESTAMP())
);
CREATE UNIQUE INDEX users_idx1 ON users (email);


CREATE TABLE auth_tokens (
  auth_token_id    INTEGER PRIMARY KEY,
  user_id          INTEGER   NOT NULL,
  auth_token_sha   CHAR(128) NOT NULL,
  valid_until_utc  DATETIME  NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users (user_id)
);
CREATE UNIQUE INDEX auth_tokens_idx1 ON auth_tokens (auth_token_sha);

INSERT INTO users (full_name, affiliation, email, password, added_by)
  VALUES ('Daniel Smith', 'Baylor College of Medicine', 'dpsmith@bcm.edu', '$2a$12$biB44WB7g9PN/9aIt65Ag.adpD1ZQ/LEiaAKmQ6MD8M9Qy6M9uobi', 0);

ALTER TABLE users ADD CONSTRAINT users_fk1 FOREIGN KEY (added_by) REFERENCES users(user_id);

```



## Lambda environment variables

| Key                | Example Value                                            |
| ------------------ | -------------------------------------------------------- |
|  MYSQL_DATABASE    | hvp                                                      |
|  MYSQL_HOST        | hvp-mysql.cluster-[redacted].us-east-1.rds.amazonaws.com |
|  MYSQL_PASSWORD    | [redacted]                                               |
|  MYSQL_PORT        | 3306                                                     |
|  MYSQL_USERNAME    | lambda_rw                                                |
|  SMTP_FROMADDR     | Virtual Biorepository &lt;hvp-no-reply@jplab.net&gt;     |
|  SMTP_MAX_RATE     | 25                                                       |
|  SMTP_PASSWORD     | [redacted]                                               |
|  SMTP_PORT         | 465                                                      |
|  SMTP_SERVER       | email-smtp.us-east-1.amazonaws.com                       |
|  SMTP_SSL          | true                                                     |
|  SMTP_USERNAME     | [redacted]                                               |






	

