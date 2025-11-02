# Makefile para HelloApp

# Default target when running 'make' without arguments
.DEFAULT_GOAL := help

# Archivos docker-compose principales
COMPOSE_FILE=docker-compose.yml
COMPOSE_SERVICES_FILE=docker-compose.service.yml
COMPOSE_DEV_FILE=docker-compose.yml
COMPOSE_PROD_FILE=docker-compose.yml
DOCKER_COMPOSE=docker compose -f $(COMPOSE_FILE)
EXEC=$(DOCKER_COMPOSE) exec helloappback python ./manage.py

# Nombre del proyecto para docker-compose
PROJECT_NAME=helloapp

# Colors for output
GREEN=\033[0;32m
YELLOW=\033[1;33m
RED=\033[0;31m
NC=\033[0m # No Color

# Comandos de desarrollo
.PHONY: up-dev
up-dev:
	@echo "$(GREEN)🚀 Levantando contenedores en modo desarrollo con watch...$(NC)"
	@docker compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME) up --build --watch
	@echo "$(GREEN)✅ Modo desarrollo activo con hot-reload$(NC)"

.PHONY: down-dev
down-dev:
	@echo "$(RED)⬇️  Bajando contenedores de desarrollo...$(NC)"
	@docker compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME) down
	@echo "$(GREEN)✅ Contenedores detenidos$(NC)"

.PHONY: logs-dev
logs-dev:
	@echo "$(YELLOW)📋 Mostrando logs de desarrollo...$(NC)"
	@docker compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME) logs -f

.PHONY: restart-dev
restart-dev:
	@echo "$(YELLOW)🔄 Reiniciando contenedores de desarrollo...$(NC)"
	@docker compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME) restart
	@echo "$(GREEN)✅ Contenedores reiniciados$(NC)"

.PHONY: build-dev
build-dev:
	@echo "$(YELLOW)🔨 Construyendo imágenes de desarrollo...$(NC)"
	@docker compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME) build --no-cache
	@echo "$(GREEN)✅ Imágenes construidas$(NC)"

.PHONY: clean-dev
clean-dev:
	@echo "$(RED)🧹 Limpiando contenedores de desarrollo...$(NC)"
	@docker compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME) down --volumes
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

.PHONY: destroy-dev
destroy-dev:
	@echo "$(RED)💣 Destruyendo contenedores de desarrollo...$(NC)"
	@docker compose -f $(COMPOSE_DEV_FILE) -p $(PROJECT_NAME) down --volumes --rmi all
	@echo "$(GREEN)✅ Destrucción completada$(NC)"

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
.PHONY: up-prod
up-prod:
	@echo "$(GREEN)🚀 Levantando contenedores en modo producción...$(NC)"
	@docker compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME) up -d --build
	@echo "$(GREEN)✅ Servicios de producción levantados en modo detached$(NC)"

.PHONY: down-prod
down-prod:
	@echo "$(RED)⬇️  Bajando contenedores de producción...$(NC)"
	@docker compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME) down
	@echo "$(GREEN)✅ Contenedores detenidos$(NC)"

.PHONY: logs-prod
logs-prod:
	@echo "$(YELLOW)📋 Mostrando logs de producción...$(NC)"
	@docker compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME) logs -f

.PHONY: restart-prod
restart-prod:
	@echo "$(YELLOW)🔄 Reiniciando contenedores de producción...$(NC)"
	@docker compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME) restart
	@echo "$(GREEN)✅ Contenedores reiniciados$(NC)"

.PHONY: build-prod
build-prod:
	@echo "$(YELLOW)🔨 Construyendo imágenes de producción...$(NC)"
	@docker compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME) build --no-cache
	@echo "$(GREEN)✅ Imágenes construidas$(NC)"

.PHONY: clean-prod
clean-prod:
	@echo "$(RED)🧹 Limpiando contenedores de producción...$(NC)"
	@docker compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME) down --volumes
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

.PHONY: destroy-prod
destroy-prod:
	@echo "$(RED)💣 Destruyendo contenedores de producción...$(NC)"
	@docker compose -f $(COMPOSE_PROD_FILE) -p $(PROJECT_NAME) down --volumes --rmi all
	@echo "$(GREEN)✅ Destrucción completada$(NC)"

# HelloApp: Comandos docker-compose principales

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
	@docker compose -f $(COMPOSE_FILE) -p $(PROJECT_NAME) logs -f helloappback

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
.PHONY: up-services
up-services:
	@echo "$(GREEN)🔧 Levantando solo servicios de infraestructura (sin backend Django)...$(NC)"
	@docker compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra up -d --build
	@echo "$(GREEN)✅ Infraestructura levantada$(NC)"
	@echo "$(YELLOW)📋 URLs disponibles:$(NC)"
	@echo "  - PostgreSQL:        localhost:5432"
	@echo "  - pgAdmin:           http://localhost:8082"
	@echo "  - Redis:             localhost:6379"
	@echo "  - Redis Commander:   http://localhost:8081"
	@echo "  - Mailpit (SMTP UI): http://localhost:8025"

.PHONY: down-services
down-services:
	@echo "$(RED)⬇️  Bajando servicios de infraestructura...$(NC)"
	@docker compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra down
	@echo "$(GREEN)✅ Servicios detenidos$(NC)"

.PHONY: logs-services
logs-services:
	@echo "$(YELLOW)📋 Mostrando logs de infraestructura...$(NC)"
	@docker compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra logs -f

.PHONY: restart-services
restart-services:
	@echo "$(YELLOW)🔄 Reiniciando servicios de infraestructura...$(NC)"
	@docker compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra restart
	@echo "$(GREEN)✅ Servicios reiniciados$(NC)"

.PHONY: clean-services
clean-services:
	@echo "$(RED)🧹 Limpiando servicios de infraestructura...$(NC)"
	@docker compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra down --volumes
	@echo "$(GREEN)✅ Limpieza completada$(NC)"

.PHONY: destroy-services
destroy-services:
	@echo "$(RED)💣 Destruyendo servicios de infraestructura...$(NC)"
	@docker compose -f $(COMPOSE_SERVICES_FILE) -p $(PROJECT_NAME)_infra down --volumes --rmi all
	@echo "$(GREEN)✅ Destrucción completada$(NC)"

# Entrar a contenedores
.PHONY: shell-back
shell-back:
	@echo "$(YELLOW)💻 Entrando al contenedor backend (helloappback)...$(NC)"
	@docker exec -it helloappback bash

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
	@docker exec -it postgres psql -U helloapp -d helloapp

.PHONY: db-backup
db-backup:
	@echo "$(YELLOW)💾 Creando backup de la base de datos...$(NC)"
	@docker exec -t postgres pg_dump -U helloapp helloapp > backup_$$(date +%Y%m%d_%H%M%S).sql
	@echo "$(GREEN)✅ Backup creado exitosamente$(NC)"

.PHONY: db-restore
db-restore:
	@echo "$(RED)⚠️  Restaurando base de datos desde backup...$(NC)"
	@if [ -z "$(file)" ]; then echo "$(RED)Error: Especifica el archivo con file=backup.sql$(NC)"; exit 1; fi
	@docker exec -i postgres psql -U helloapp helloapp < $(file)
	@echo "$(GREEN)✅ Base de datos restaurada$(NC)"

.PHONY: help
help:
	@echo "$(GREEN)════════════════════════════════════════════════════════════════$(NC)"
	@echo "$(GREEN)  🐾 Makefile para HelloApp Backend Django$(NC)"
	@echo "$(GREEN)════════════════════════════════════════════════════════════════$(NC)"
	@echo ""
	@echo "$(YELLOW)🚀 Modos de Ejecución:$(NC)"
	@echo "  $(GREEN)make up-dev$(NC)            - 🔥 Desarrollo con hot-reload (watch mode, NO detached)"
	@echo "  $(GREEN)make up$(NC)                - 🚀 Producción detached (backend + infraestructura)"
	@echo "  $(GREEN)make up-prod$(NC)           - 🚀 Alias de 'make up' para producción"
	@echo "  $(GREEN)make up-services$(NC)       - 🔧 Solo infraestructura (PostgreSQL, Redis, etc.)"
	@echo ""
	@echo "$(YELLOW)📦 Comandos Principales:$(NC)"
	@echo "  $(GREEN)make down$(NC)              - ⬇️  Bajar todos los servicios"
	@echo "  $(GREEN)make down-dev$(NC)          - ⬇️  Bajar servicios de desarrollo"
	@echo "  $(GREEN)make down-prod$(NC)         - ⬇️  Bajar servicios de producción"
	@echo "  $(GREEN)make down-services$(NC)     - ⬇️  Bajar solo infraestructura"
	@echo "  $(GREEN)make restart$(NC)           - 🔄 Reiniciar todos los servicios"
	@echo "  $(GREEN)make build$(NC)             - 🔨 Construir imágenes"
	@echo "  $(GREEN)make build-dev$(NC)         - 🔨 Construir imágenes (desarrollo, sin cache)"
	@echo "  $(GREEN)make ps$(NC)                - 📊 Ver estado de los contenedores"
	@echo "  $(GREEN)make status$(NC)            - 📊 Alias de ps"
	@echo ""
	@echo "$(YELLOW)📋 Logs:$(NC)"
	@echo "  $(GREEN)make logs$(NC)              - 📋 Mostrar logs de todos los servicios"
	@echo "  $(GREEN)make logs-back$(NC)         - 📋 Mostrar solo logs del backend Django"
	@echo "  $(GREEN)make logs-dev$(NC)          - 📋 Logs de desarrollo"
	@echo "  $(GREEN)make logs-prod$(NC)         - 📋 Logs de producción"
	@echo "  $(GREEN)make logs-services$(NC)     - 📋 Logs de servicios de infraestructura"
	@echo ""
	@echo "$(YELLOW)🗄️  Base de Datos:$(NC)"
	@echo "  $(GREEN)make migrate$(NC)           - 🗄️  Aplicar migraciones a la base de datos"
	@echo "  $(GREEN)make makemigrations$(NC)    - 📝 Crear nuevas migraciones"
	@echo "  $(GREEN)make db-shell$(NC)          - 💻 Conectar a PostgreSQL shell (psql)"
	@echo "  $(GREEN)make db-backup$(NC)         - 💾 Crear backup de la base de datos"
	@echo "  $(GREEN)make db-restore file=X$(NC) - 📥 Restaurar desde backup"
	@echo ""
	@echo "$(YELLOW)🧹 Limpieza:$(NC)"
	@echo "  $(GREEN)make clean$(NC)             - 🧹 Limpiar servicios (eliminar volúmenes)"
	@echo "  $(GREEN)make clean-dev$(NC)         - 🧹 Limpiar desarrollo"
	@echo "  $(GREEN)make clean-prod$(NC)        - 🧹 Limpiar producción"
	@echo "  $(GREEN)make clean-services$(NC)    - 🧹 Limpiar infraestructura"
	@echo "  $(GREEN)make destroy$(NC)           - 💣 Destruir todo (volúmenes + imágenes)"
	@echo "  $(GREEN)make destroy-dev$(NC)       - 💣 Destruir desarrollo"
	@echo "  $(GREEN)make destroy-prod$(NC)      - 💣 Destruir producción"
	@echo "  $(GREEN)make destroy-services$(NC)  - 💣 Destruir infraestructura"
	@echo ""
	@echo "$(YELLOW)💻 Shell/Terminal en contenedores:$(NC)"
	@echo "  $(GREEN)make shell-back$(NC)        - Entrar al contenedor backend (helloappback)"
	@echo "  $(GREEN)make shell-postgres$(NC)    - Entrar al contenedor PostgreSQL"
	@echo "  $(GREEN)make shell-db$(NC)          - Alias de shell-postgres"
	@echo "  $(GREEN)make shell-redis$(NC)       - Entrar al contenedor Redis"
	@echo "  $(GREEN)make shell-mailpit$(NC)     - Entrar al contenedor Mailpit"
	@echo "  $(GREEN)make shell-pgadmin$(NC)     - Entrar al contenedor pgAdmin"
	@echo ""
	@echo "$(YELLOW)📌 URLs de servicios:$(NC)"
	@echo "  - Django Backend:    $(GREEN)http://localhost:8000$(NC)"
	@echo "  - pgAdmin:           $(GREEN)http://localhost:8082$(NC) (admin@admin.com / admin)"
	@echo "  - Redis Commander:   $(GREEN)http://localhost:8081$(NC)"
	@echo "  - Mailpit (SMTP UI): $(GREEN)http://localhost:8025$(NC)"
	@echo ""
	@echo "$(GREEN)════════════════════════════════════════════════════════════════$(NC)"