COMPOSE_FILE := compose.yml

MONGO_USER := default
MONGO_PASSWORD := default

JWT_SECRET := default
JWT_REFRESH_SECRET := default

USERNAME := default
NAME := default
EMAIL := default@default.com
PASSWORD := default12345678

SHELL := /usr/bin/bash

.PHONY: up dow debug

all: up

up: down
	@echo "Setting up..."
	MONGO_USER=$(MONGO_USER)\
		   MONGO_PASSWORD=$(MONGO_PASSWORD)\
		   JWT_SECRET=$(JWT_SECRET)\
		   JWT_REFRESH_SECRET=$(JWT_REFRESH_SECRET)\
		   docker compose up -d --build
	@echo "Creating user..."
	chmod +x ./setup-user.sh
	./setup-user.sh $(USERNAME) $(NAME) $(EMAIL) $(PASSWORD)

down:
	@echo "Shutting down..."
	docker compose down --remove-orphans

debug:
	docker exec -it zeroclaw /bin/sh
