#!/bin/bash

sudo apt update -y
sudo apt install mysql-server -y

sudo mysql
CREATE DATABASE petclinic;
CREATE USER 'petclinic'@'%' IDENTIFIED BY 'petclinic';
GRANT ALL PRIVILEGES ON petclinic.* TO 'petclinic'@'%';
FLUSH PRIVILEGES;
EXIT;

# TODO: Change bind address at /etc/mysql/mysql.conf.d/mysqld.cnf

# Init db
curl -s https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/refs/heads/master/src/main/resources/db/mysql/schema.sql | sudo mysql -f -D petclinic
curl -s https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/refs/heads/master/src/main/resources/db/mysql/data.sql | sudo mysql -f -D petclinic
