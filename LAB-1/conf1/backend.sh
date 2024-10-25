#!/bin/bash

DB_PRIVATE_IP="$1"
DB_PORT="3306"

sudo apt update -y
sudo apt install openjdk-17-jdk openjdk-17-jre -y

git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
cd spring-petclinic-rest

sed -i 's/hsqldb/mysql/g' src/main/resources/application.properties

cat > src/main/resources/application-mysql.properties <<EOF
database=mysql
spring.datasource.url=jdbc:mysql://$DB_PRIVATE_IP:$DB_PORT/petclinic
spring.datasource.username=petclinic
spring.datasource.password=petclinic
spring.sql.init.mode=always
EOF

nohup ./mvnw spring-boot:run > out.log 2>&1 &
