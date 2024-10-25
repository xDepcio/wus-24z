#!/bin/bash

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
cat > petclinic.conf << EOF
server {
	    listen       80 default_server;
        root         /usr/share/nginx/html;
        index index.html;

	    location /petclinic/ {
                alias /usr/share/nginx/html/petclinic/dist/;
                try_files \$uri\$args \$uri\$args/ /petclinic/index.html;
        }

        location /petclinic/api/ {
                proxy_pass http://10.0.0.4:9966/;
                include proxy_params;
        }
}
EOF
sudo mv petclinic.conf /etc/nginx/conf.d/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -s reload
