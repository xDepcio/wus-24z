#!/bin/bash

az group create \
    --location 'West Europe' \
    --name 'lab-1-conf-1' \
    --verbose

az deployment group create \
    --resource-group 'lab-1-conf-1' \
    --template-uri 'https://raw.githubusercontent.com/xDepcio/wus-24z/refs/heads/main/LAB-1/conf1/template.json' \
    --verbose
