#!/bin/bash

# Backend 10.0.0.4
ssh azureuser@20.16.244.199 << EOF
git clone https://github.com/spring-petclinic/spring-petclinic-rest.git
yes | sudo apt install openjdk-17-jdk openjdk-17-jre
cd spring-petclinic-rest
./mvnw spring-boot:run
EOF

# Frontend 10.0.0.5
ssh azureuser@front << EOF
sudo apt install nginx -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
source ~/.bashrc
nvm install 20
npm install -g @angular/cli@latest

git clone https://github.com/spring-petclinic/spring-petclinic-angular.git
cd spring-petclinic-angular
npm install
sed -i 's/localhost/10.0.0.4/g' src/environments/environment.prod.ts
ng build --configuration production --base-href=/petclinic/ --deploy-url=/petclinic/

sudo mkdir /usr/share/nginx/html/petclinic
sudo cp -r ./dist/ /usr/share/nginx/html/petclinic/

EOF
