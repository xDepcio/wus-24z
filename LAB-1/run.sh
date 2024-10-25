#!/bin/bash

FRONTEND_PUBLIC_IP=""
BACKEND_PRIVATE_IP=""
DB_PRIVATE_IP=""

print_help () {
    echo "Usage: $0 [OPTIONS]
    -f, --frontend-pub      Frontend public IP
    -B, --backend-priv      Backend private IP
    -D, --db-priv           DB private IP
"
    exit 1
}

while [ $# -gt 0 ]; do
    case "$1" in
        -f|--frontend-pub)
            FRONTEND_PUBLIC_IP="$2"
            ;;
        -B|--backend-priv)
            BACKEND_PRIVATE_IP="$2"
            ;;
        -D|--db-priv)
            DB_PRIVATE_IP="$2"
            ;;
        *)
            print_help
            ;;
    esac
    shift
done

cat ./db.sh | ssh azureuser@$DB_IP "bash -s"
cat ./backend.sh | ssh azureuser@$BACKEND_IP "bash -s $DB_PRIVATE_IP"
cat ./front-config.sh | ssh azureuser@$FRONTEND_IP "bash -s $FRONTEND_PUBLIC_IP $BACKEND_PRIVATE_IP"
