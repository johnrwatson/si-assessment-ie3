# Define required macros here
SHELL = /bin/sh

.PHONY: build, test
default: build

deploy:
	docker compose -f ./local-development/docker-compose-stack.yml --env-file ./local-development/development.env up

build-be:
	echo "Info: Building Backend:"
	docker build --platform linux/amd64 -f ./backend/hosting/docker/Dockerfile -t si-assessment-ie3-backend:latest .

build-fe:
	echo "Info: Building Frontend:"
	docker build --platform linux/amd64 -f ./frontend/hosting/docker/Dockerfile -t si-assessment-ie3-frontend:latest .

fmt:
	go fmt ./cmd/...
