#!/bin/bash

set -e

DB_PORT="$1"

sudo apt update -y
sudo apt install mysql-server -y

sudo mysql -e 'CREATE DATABASE petclinic;'
sudo mysql -e "CREATE USER 'petclinic'@'%' IDENTIFIED BY 'petclinic';"
sudo mysql -e "GRANT ALL PRIVILEGES ON petclinic.* TO 'petclinic'@'%';"
sudo mysql -e 'FLUSH PRIVILEGES;'

sudo sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
sudo sed -i "s/^#\sport\s*=.*/port = $DB_PORT/g" /etc/mysql/mysql.conf.d/mysqld.cnf

# Init db
curl -s https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/refs/heads/master/src/main/resources/db/mysql/schema.sql | sudo mysql -f -D petclinic
curl -s https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/refs/heads/master/src/main/resources/db/mysql/data.sql | sudo mysql -f -D petclinic

# Restart service
sudo service mysql restart
