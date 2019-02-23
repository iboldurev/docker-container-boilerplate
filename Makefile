#!/usr/bin/make

SHELL = /bin/sh
APP_CONTAINER_NAME := app

docker_bin := $(shell command -v docker 2> /dev/null)
docker_compose_bin := $(shell command -v docker-compose 2> /dev/null)

.PHONY : up
.DEFAULT_GOAL := up

up:
	$(docker_compose_bin) up --no-recreate -d

down:
	$(docker_compose_bin) down

restart: up
	$(docker_compose_bin) restart

shell: up
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" /bin/sh

install: up
	$(docker_bin) run --rm -v $(shell pwd)/src:/$(APP_CONTAINER_NAME) composer install --no-interaction --ansi --no-suggest

init: install
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" php artisan migrate --force --no-interaction -vvv
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" php artisan db:seed --force -vvv

test: up
	$(docker_compose_bin) exec "$(APP_CONTAINER_NAME)" phpunit
