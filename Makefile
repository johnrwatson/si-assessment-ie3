# Define required macros here
SHELL = /bin/sh

.PHONY: build, test
default: build

# There is some code duplication here that could be handled later. For now this will
# function accordingly for quick validation

deploy:
	docker compose -f ./local-development/docker-compose-stack.yml --env-file ./local-development/development.env up

build-be:
	docker build --platform linux/amd64 -f ./backend/hosting/docker/Dockerfile -t si-assessment-ie3-backend:latest .

build-fe:
	docker build --platform linux/amd64 -f ./frontend/hosting/docker/Dockerfile -t si-assessment-ie3-frontend:latest .

validate-be:
	docker compose -f ./local-development/docker-compose-be.yml --env-file ./local-development/development.env up -d
	.github/healthchecker.sh 15 user:pass http://localhost:3030/api/users

validate-fe:
	docker compose -f ./local-development/docker-compose-fe.yml --env-file ./local-development/development.env up -d
	.github/healthchecker.sh 15 user:pass http://localhost:8080
