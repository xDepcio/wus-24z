#!/bin/bash

set -e

BACKEND_PUBLIC_IP=""
BACKEND_PRIVATE_IP=""
BACKEND_PORT=""

FRONTEND_PRIVATE_IP=""
FRONTEND_PUBLIC_IP=""
FRONTEND_PORT=""

DB_PUBLIC_IP=""
DB_PRIVATE_IP=""
DB_PORT=""

print_help () {
    echo "Usage: $0 [OPTIONS]
    -f, --frontend-pub      Frontend public IP
    -b, --backend-pub       Backend public IP
    -d, --db-pub            DB public IP
    -B, --backend-priv      Backend private IP
    -D, --db-priv           DB private IP
    -F, --frontend-priv     Frontend private IP
    -1, --backend-port      Backend port
    -2, --db-port           DB port
    -3, --frontend-port     Frontend port
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
        -F|--frontend-priv)
            FRONTEND_PRIVATE_IP="$2"
            shift 2
            ;;
        -1|--backend-port)
            BACKEND_PORT="$2"
            shift 2
            ;;
        -2|--db-port)
            DB_PORT="$2"
            shift 2
            ;;
        -3|--frontend-port)
            FRONTEND_PORT="$2"
            shift 2
            ;;
        *)
            print_help
            ;;
    esac
done

: "${BACKEND_PORT:=9966}"
: "${DB_PORT:=3306}"
: "${FRONTEND_PORT:=80}"

if [ -z "$FRONTEND_PUBLIC_IP" ] || [ -z "$BACKEND_PRIVATE_IP" ] || [ -z "$DB_PRIVATE_IP" ] || [ -z "$BACKEND_PUBLIC_IP" ] || [ -z "$DB_PUBLIC_IP" ] || [ -z "$FRONTEND_PRIVATE_IP" ]; then
    print_help
fi

cat ./db.sh | ssh azureuser@$DB_PUBLIC_IP "bash -s $DB_PORT"
cat ./backend.sh | ssh azureuser@$BACKEND_PUBLIC_IP "bash -s $DB_PRIVATE_IP $DB_PORT"
cat ./front-config.sh | ssh azureuser@$FRONTEND_PUBLIC_IP "bash -s $FRONTEND_PUBLIC_IP $BACKEND_PRIVATE_IP $FRONTEND_PORT $BACKEND_PORT"
