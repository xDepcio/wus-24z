#!/bin/bash

MYSQL_PASSWORD="petclinic"
MYSQL_USER="petclinic"
MYSQL_URL="jdbc:mysql://10.0.0.6:3306/petclinic"

sudo apt update -y
sudo apt install openjdk-17-jdk openjdk-17-jre -y

git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
cd spring-petclinic-rest

sed -i 's/hsqldb/mysql/g' src/main/resources/application.properties

./mvnw spring-boot:run
