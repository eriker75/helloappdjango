# Makefile para Pawify

# Default target when running 'make' without arguments
.DEFAULT_GOAL := help

# Archivos docker-compose principales
COMPOSE_FILE=docker-compose.yml
COMPOSE_SERVICES_FILE=docker-compose.service.yml
DOCKER_COMPOSE=docker compose -f $(COMPOSE_FILE)
EXEC=$(DOCKER_COMPOSE) exec pawifyback python ./manage.py

# Nombre del proyecto para docker-compose
PROJECT_NAME=pawify

# Colors for output
GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m # No Color

# Comandos de desarrollo
up-dev:
	@echo "Levantando los contenedores en modo desarrollo..."
	docker-compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME)_dev up --build

down-dev:
	@echo "Bajando los contenedores en modo desarrollo..."
	docker-compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME)_dev down

logs-dev:
	@echo "Mostrando logs de los contenedores en modo desarrollo..."
	docker-compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME)_dev logs -f

restart-dev:
	@echo "Reiniciando los contenedores en modo desarrollo..."
	docker-compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME)_dev restart

build-dev:
	@echo "Construyendo las imágenes en modo desarrollo..."
	docker-compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME)_dev build

clean-dev:
	@echo "Limpiando los contenedores en modo desarrollo..."
	docker-compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME)_dev down --volumes

destroy-dev:
	@echo "Destruyendo los contenedores en modo desarrollo..."
	docker-compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME)_dev down --volumes --rmi all

migrate:
	@echo "Aplicando migraciones a la base de datos..."
	$(EXEC) migrate

makemigrations:
	@echo "Creando nuevas migraciones..."
	$(EXEC) makemigrations

load-data:
	@echo "Cargando datos iniciales en la base de datos..."
# 	$(EXEC) loaddata fixtures/countries.json
	$(EXEC) loaddata fixtures/pets.json
	$(EXEC) loaddata fixtures/petimages.json

# Comandos de producción
up-prod:
	@echo "Levantando los contenedores en modo producción..."
	docker-compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME)_prod up -d --build

down-prod:
	@echo "Bajando los contenedores en modo producción..."
	docker-compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME)_prod down

logs-prod:
	@echo "Mostrando logs de los contenedores en modo producción..."
	docker-compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME)_prod logs -f

restart-prod:
	@echo "Reiniciando los contenedores en modo producción..."
	docker-compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME)_prod restart

build-prod:
	@echo "Construyendo las imágenes en modo producción..."
	docker-compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME)_prod build

clean-prod:
	@echo "Limpiando los contenedores en modo producción..."
	docker-compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME)_prod down --volumes

destroy-prod:
	@echo "Destruyendo los contenedores en modo producción..."
	docker-compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME)_prod down --volumes --rmi all

# Pawify: Comandos docker-compose principales

.PHONY: up
up:
	@echo "$(GREEN)🚀 Levantando todos los servicios (backend + infraestructura)...$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) up -d --build
	@echo "$(GREEN)✅ Servicios levantados exitosamente!$(NC)"
	@echo "$(YELLOW)📋 URLs disponibles:$(NC)"
	@echo "  - Django Backend:    http://localhost:8000"
	@echo "  - pgAdmin:           http://localhost:8082"
	@echo "  - Redis Commander:   http://localhost:8081"
	@echo "  - Mailpit (SMTP UI): http://localhost:8025"
	@echo "$(YELLOW)💡 Ver logs con: make logs$(NC)"

.PHONY: down
down:
	@echo "$(RED)⬇️  Bajando todos los servicios...$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down
	@echo "$(GREEN)✅ Servicios detenidos$(NC)"

.PHONY: logs
logs:
	@echo "$(YELLOW)📋 Mostrando logs de todos los servicios (Ctrl+C para salir)...$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) logs -f

.PHONY: logs-back
logs-back:
	@echo "$(YELLOW)📋 Mostrando logs del backend Django...$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) logs -f pawifyback

.PHONY: restart
restart:
	@echo "$(YELLOW)🔄 Reiniciando todos los servicios...$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) restart
	@echo "$(GREEN)✅ Servicios reiniciados$(NC)"

.PHONY: build
build:
	@echo "$(YELLOW)🔨 Construyendo imágenes de todos los servicios...$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) build
	@echo "$(GREEN)✅ Imágenes construidas$(NC)"

.PHONY: clean
clean:
	@echo "$(RED)🧹 Limpiando todos los servicios (eliminando volúmenes)...$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down --volumes
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

.PHONY: destroy
destroy:
	@echo "$(RED)💣 Destruyendo todos los servicios (volúmenes + imágenes)...$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) down --volumes --rmi all
	@echo "$(GREEN)✅ Destrucción completada$(NC)"

.PHONY: ps
ps:
	@echo "$(YELLOW)📊 Estado de los contenedores:$(NC)"
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) ps

.PHONY: status
status: ps

# Solo infraestructura (sin backend Django)
up-services:
	@echo "Levantando solo servicios de infraestructura (sin backend Django)..."
	docker-compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra up -d --build

down-services:
	@echo "Bajando solo servicios de infraestructura..."
	docker-compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra down

logs-services:
	@echo "Mostrando logs de los servicios de infraestructura..."
	docker-compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra logs -f

restart-services:
	@echo "Reiniciando servicios de infraestructura..."
	docker-compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra restart

clean-services:
	@echo "Limpiando servicios de infraestructura (eliminando volúmenes)..."
	docker-compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra down --volumes

destroy-services:
	@echo "Destruyendo servicios de infraestructura (volúmenes + imágenes)..."
	docker-compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra down --volumes --rmi all

# Entrar a contenedores
.PHONY: shell-back
shell-back:
	@echo "$(YELLOW)💻 Entrando al contenedor backend (pawifyback)...$(NC)"
	@docker exec -it pawifyback bash

.PHONY: shell-postgres
shell-postgres:
	@echo "$(YELLOW)💻 Entrando al contenedor PostgreSQL...$(NC)"
	@docker exec -it postgres sh

.PHONY: shell-db
shell-db: shell-postgres

.PHONY: shell-redis
shell-redis:
	@echo "$(YELLOW)💻 Entrando al contenedor Redis...$(NC)"
	@docker exec -it redis sh

.PHONY: shell-mailpit
shell-mailpit:
	@echo "$(YELLOW)💻 Entrando al contenedor Mailpit...$(NC)"
	@docker exec -it mailpit sh

.PHONY: shell-pgadmin
shell-pgadmin:
	@echo "$(YELLOW)💻 Entrando al contenedor pgAdmin...$(NC)"
	@docker exec -it pgadmin sh

# PostgreSQL Database commands
.PHONY: db-shell
db-shell:
	@echo "$(YELLOW)🗄️  Conectando a PostgreSQL shell...$(NC)"
	@docker exec -it postgres psql -U pawify -d pawify

.PHONY: db-backup
db-backup:
	@echo "$(YELLOW)💾 Creando backup de la base de datos...$(NC)"
	@docker exec -t postgres pg_dump -U pawify pawify > backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✅ Backup creado exitosamente$(NC)"

.PHONY: db-restore
db-restore:
	@echo "$(RED)⚠️  Restaurando base de datos desde backup...$(NC)"
	@if [ -z "$(file)" ]; then echo "$(RED)Error: Especifica el archivo con file=backup.sql$(NC)"; exit 1; fi
	@docker exec -i postgres psql -U pawify pawify < $(file)
	@echo "$(GREEN)✅ Base de datos restaurada$(NC)"

.PHONY: help
help:
	@echo "$(GREEN)════════════════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  🐾 Makefile para Pawify Backend Django$(NC)"
	@echo "$(GREEN)════════════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(YELLOW)📦 Comandos Principales:$(NC)"
	@echo "  $(GREEN)make up$(NC)                - 🚀 Levantar todos los servicios (backend + infraestructura)"
	@echo "  $(GREEN)make down$(NC)              - ⬇️  Bajar todos los servicios"
	@echo "  $(GREEN)make restart$(NC)           - 🔄 Reiniciar todos los servicios"
	@echo "  $(GREEN)make build$(NC)             - 🔨 Construir imágenes de todos los servicios"
	@echo "  $(GREEN)make ps$(NC)                - 📊 Ver estado de los contenedores"
	@echo "  $(GREEN)make status$(NC)            - 📊 Alias de ps"
	@echo ""
	@echo "$(YELLOW)📋 Logs:$(NC)"
	@echo "  $(GREEN)make logs$(NC)              - 📋 Mostrar logs de todos los servicios"
	@echo "  $(GREEN)make logs-back$(NC)         - 📋 Mostrar solo logs del backend Django"
	@echo "  $(GREEN)make logs-services$(NC)     - 📋 Logs de servicios de infraestructura"
	@echo ""
	@echo "$(YELLOW)🗄️  Base de Datos:$(NC)"
	@echo "  $(GREEN)make migrate$(NC)           - 🗄️  Aplicar migraciones a la base de datos"
	@echo "  $(GREEN)make makemigrations$(NC)    - 📝 Crear nuevas migraciones"
	@echo ""
	@echo "$(YELLOW)🧹 Limpieza:$(NC)"
	@echo "  $(GREEN)make clean$(NC)             - 🧹 Limpiar servicios (eliminar volúmenes)"
	@echo "  $(GREEN)make destroy$(NC)           - 💣 Destruir todo (volúmenes + imágenes)"
	@echo ""
	@echo "$(YELLOW)🔧 Servicios (solo infraestructura):$(NC)"
	@echo "  $(GREEN)make up-services$(NC)       - Levantar solo infraestructura (PostgreSQL, Redis, etc.)"
	@echo "  $(GREEN)make down-services$(NC)     - Bajar solo servicios de infraestructura"
	@echo "  $(GREEN)make clean-services$(NC)    - Limpiar servicios de infraestructura"
	@echo "  $(GREEN)make destroy-services$(NC)  - Destruir servicios de infraestructura"
	@echo ""
	@echo "$(YELLOW)💻 Shell/Terminal en contenedores:$(NC)"
	@echo "  $(GREEN)make shell-back$(NC)        - Entrar al contenedor backend (pawifyback)"
	@echo "  $(GREEN)make shell-postgres$(NC)    - Entrar al contenedor PostgreSQL"
	@echo "  $(GREEN)make shell-db$(NC)          - Alias de shell-postgres"
	@echo "  $(GREEN)make shell-redis$(NC)       - Entrar al contenedor Redis"
	@echo "  $(GREEN)make shell-mailpit$(NC)     - Entrar al contenedor Mailpit"
	@echo "  $(GREEN)make shell-pgadmin$(NC)     - Entrar al contenedor pgAdmin"
	@echo ""
	@echo "$(YELLOW)🗄️  PostgreSQL Database:$(NC)"
	@echo "  $(GREEN)make db-shell$(NC)          - Conectar a PostgreSQL shell (psql)"
	@echo "  $(GREEN)make db-backup$(NC)         - Crear backup de la base de datos"
	@echo "  $(GREEN)make db-restore file=X$(NC) - Restaurar desde backup"
	@echo ""
	@echo "$(YELLOW)📌 URLs de servicios:$(NC)"
	@echo "  - Django Backend:    $(GREEN)http://localhost:8000$(NC)"
	@echo "  - pgAdmin:           $(GREEN)http://localhost:8082$(NC) (admin@admin.com / admin)"
	@echo "  - Redis Commander:   $(GREEN)http://localhost:8081$(NC)"
	@echo "  - Mailpit (SMTP UI): $(GREEN)http://localhost:8025$(NC)"
	@echo ""
	@echo "$(GREEN)════════════════════════════════════════════════════════════════$(NC)"