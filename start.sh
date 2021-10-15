#!/usr/bin/env bash

set -e

# Definitions
export APP_METOD="POST"
export APP_HOST="myapp.dev"
export APP_PORT="80"
export APP_SEC="false"
export APP_SCHEDULE="step(10, 30, 5, 5)"
export APP_URL="/url"
export APP_TEST_TAG="my_tag"
export APP_BODY=''
export APP_ACCESS_TOKEN=""

GET_TOKEN=false
GEN_AMMO=false

err() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@" >&2
}

log(){
    echo "[$(date +'%Y-%m-%d %H:%M:%S%z')]: $@" >&1
}

# GET User access token (Example)
getToken(){
    APP_ACCESS_TOKEN="Authorization: bearer $(curl --globoff --http1.1 --location --request POST 'https://auth.myapp.dev/connect/token' \
                --header 'Content-Type: application/x-www-form-urlencoded' \
                --data-urlencode 'grant_type=password' \
                --data-urlencode 'username=ADMIN' \
                --data-urlencode 'password=PASSWORD' \
                --data-urlencode 'client_id=developerapp' \
                --data-urlencode 'client_secret=secret' | \
                jq -j .access_token)"
}

if read -p "Get API Token?[y\n]: " reply
then
    if [ $reply == "y" ]
    then
        GET_TOKEN=true
    else
        GET_TOKEN=false
    fi
fi

if read -p "Generate new ammo?[y\n]: " reply
then
    if [ $reply == "y" ]
    then
        GEN_AMMO=true
    else
        GEN_AMMO=false
    fi
fi

# Get user access_token
${GET_TOKEN} && log "GET User access token" && getToken

# Config preparation
${GEN_AMMO} && log "Config preparation" && rm -f ./tests/config.yml && envsubst < ./tests/config.yml.tpl > ./tests/config.yml

# Data preparation
${GEN_AMMO} && log "Data preparation" && rm -f ./tests/data.txt && envsubst < ./tests/data.tpl > ./tests/data.txt

# Recharging 
${GEN_AMMO} && log "Recharging ammo file" && cat ./tests/data.txt | python3 ammo_generator.py > ./tests/ammo.txt 

log "Start Influx"
docker-compose up -d influx

log "Start grafana"
docker-compose up -d grafana

log "Waiting... 5s"
sleep 5

log "Start load testing"
docker-compose run --rm tank -qc config.yml