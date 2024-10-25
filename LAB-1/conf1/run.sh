#!/bin/bash

set -e

BACKEND_PUBLIC_IP=""
DB_PUBLIC_IP=""
FRONTEND_PUBLIC_IP=""
BACKEND_PRIVATE_IP=""
DB_PRIVATE_IP=""

print_help () {
    echo "Usage: $0 [OPTIONS]
    -f, --frontend-pub      Frontend public IP
    -b, --backend-pub       Backend public IP
    -d, --db-pub            DB public IP
    -B, --backend-priv      Backend private IP
    -D, --db-priv           DB private IP
"
    exit 1
}

while [ $# -gt 0 ]; do
    case "$1" in
        -f|--frontend-pub)
            FRONTEND_PUBLIC_IP="$2"
            shift 2
            ;;
        -b|--backend-pub)
            BACKEND_PUBLIC_IP="$2"
            shift 2
            ;;
        -d|--db-pub)
            DB_PUBLIC_IP="$2"
            shift 2
            ;;
        -B|--backend-priv)
            BACKEND_PRIVATE_IP="$2"
            shift 2
            ;;
        -D|--db-priv)
            DB_PRIVATE_IP="$2"
            shift 2
            ;;
        *)
            print_help
            ;;
    esac
done

if [ -z "$FRONTEND_PUBLIC_IP" ] || [ -z "$BACKEND_PRIVATE_IP" ] || [ -z "$DB_PRIVATE_IP" ] || [ -z "$BACKEND_PUBLIC_IP" ] || [ -z "$DB_PUBLIC_IP" ]; then
    print_help
fi

cat ./db.sh | ssh azureuser@$DB_PUBLIC_IP "bash -e -s"
cat ./backend.sh | ssh azureuser@$BACKEND_PUBLIC_IP "bash -e -s $DB_PRIVATE_IP"
cat ./front-config.sh | ssh azureuser@$FRONTEND_PUBLIC_IP "bash -e -s $FRONTEND_PUBLIC_IP $BACKEND_PRIVATE_IP"
