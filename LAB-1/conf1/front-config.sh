#!/bin/bash

FRONTEND_PUBLIC_IP="$1"
BACKEND_PRIVATE_IP="$2"
FRONTEND_PORT="$3"
BACKEND_PORT="$4"

sudo apt install nginx -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.0/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
nvm install 20
npm install -g @angular/cli@latest

git clone https://github.com/spring-petclinic/spring-petclinic-angular.git
cd spring-petclinic-angular
npm install
sed -i "s/localhost/$FRONTEND_PUBLIC_IP/g" src/environments/environment.prod.ts
sed -i "s/9966/$FRONTEND_PORT/g" src/environments/environment.prod.ts
yes | ng build --configuration production --base-href=/petclinic/ --deploy-url=/petclinic/

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
                proxy_pass http://$BACKEND_PRIVATE_IP:$BACKEND_PORT/petclinic/api/;
                include proxy_params;
        }
}
EOF
sudo mv petclinic.conf /etc/nginx/conf.d/
sudo rm /etc/nginx/sites-enabled/default
sudo nginx -s reload
