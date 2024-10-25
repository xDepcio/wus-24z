#!/bin/bash

sudo apt update -y
sudo apt install mysql-server -y

sudo mysql 'CREATE DATABASE petclinic;'
sudo mysql "CREATE USER 'petclinic'@'%' IDENTIFIED BY 'petclinic';"
sudo mysql "GRANT ALL PRIVILEGES ON petclinic.* TO 'petclinic'@'%';"
sudo mysql 'FLUSH PRIVILEGES;'

sudo sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf

# Init db
curl -s https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/refs/heads/master/src/main/resources/db/mysql/schema.sql | sudo mysql -f -D petclinic
curl -s https://raw.githubusercontent.com/spring-petclinic/spring-petclinic-rest/refs/heads/master/src/main/resources/db/mysql/data.sql | sudo mysql -f -D petclinic

# Restart service
sudo service mysql restart
