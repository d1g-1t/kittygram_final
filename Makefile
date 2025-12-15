COMPOSE_FILE := docker-compose.yml
COMPOSE_PROD_FILE := docker-compose.production.yml

BACKEND_SVC := backend
FRONTEND_SVC := frontend
GATEWAY_SVC := gateway
DB_SVC := db

.PHONY: help
help:
	@echo "Available commands:"
	@echo "  make setup          # Full initialization (build, migrate, collectstatic, up)"
	@echo "  make up             # Start all services"
	@echo "  make down           # Stop all services"
	@echo "  make logs           # Show logs of all services"
	@echo "  make migrate        # Apply Django migrations"
	@echo "  make shell          # Open Django shell"
	@echo "  make backup-db      # Dump PostgreSQL database to backup.sql"
	@echo "  make clean          # Remove containers, volumes, and temporary files"

.PHONY: setup
setup: build up wait-backend collectstatic
	@echo "Setup complete! Application is running at http://localhost"

.PHONY: build
build:
	@docker compose -f $(COMPOSE_FILE) build

.PHONY: up
up:
	@docker compose -f $(COMPOSE_FILE) up -d

.PHONY: wait-backend
wait-backend:
	@echo "Waiting for backend to be ready..."
	@timeout 60 bash -c 'until docker compose -f $(COMPOSE_FILE) ps $(BACKEND_SVC) | grep -q "Up"; do sleep 2; done' || true
	@sleep 5

.PHONY: down
down:
	@docker compose -f $(COMPOSE_FILE) down

.PHONY: logs
logs:
	@docker compose -f $(COMPOSE_FILE) logs -f

.PHONY: migrate
migrate:
	@docker compose -f $(COMPOSE_FILE) run --rm $(BACKEND_SVC) python manage.py migrate

.PHONY: shell
shell:
	@docker compose -f $(COMPOSE_FILE) exec $(BACKEND_SVC) python manage.py shell

.PHONY: collectstatic
collectstatic:
	@docker compose -f $(COMPOSE_FILE) run --rm $(BACKEND_SVC) python manage.py collectstatic --noinput

.PHONY: backup-db
backup-db:
	@docker compose -f $(COMPOSE_FILE) exec $(DB_SVC) pg_dump -U postgres -Fc postgres > backup.sql

.PHONY: clean
clean: down
	@docker volume prune -f
	@docker image prune -f
	@rm -f backup.sql