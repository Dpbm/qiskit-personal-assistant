#!/usr/bin/env bash

USERNAME=$1
NAME=$2
EMAIL=$3
PASSWORD=$4

docker exec -it librechat /bin/sh -c "npm run create-user -- ${EMAIL} ${NAME} ${USERNAME} ${PASSWORD} --email-verified=true"

if [[ ! $? -eq 0 ]]; then
	echo "Failed on create user"
	exit 0
fi
