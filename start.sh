#!/usr/bin/env bash

set -e

# Definitions
export APP_HOST="api.myapp.dev"
export APP_URL="/api/users/profile"
export APP_TEST_TAG="my_tag"
export APP_BODY=""
export APP_ACCESS_TOKEN=""

GET_TOKEN=false

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

while [ "$1" != "" ]; do
    case $1 in
        "--get-token") shift
                        GET_TOKEN='true'
                        ;;
    esac
    shift || true
done

# Get user access_token
${GET_TOKEN} && log "GET User access token" && getToken

# Data preparation
${GET_TOKEN} && log "Data preparation" && rm -f ./tests/data.txt && envsubst < ./tests/data.tpl > ./tests/data.txt

# Recharging 
${GET_TOKEN} && log "Recharging ammo file" && cat ./tests/data.txt | python3 ammo_generator.py > ./tests/ammo.txt 

log "Start Influx"
docker-compose up -d influx

log "Start grafana"
docker-compose up -d grafana

log "Waiting... 5s"
sleep 5

log "Start load testing"
docker-compose run --rm tank -qc config.yml