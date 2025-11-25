# FurryMetrics

> Enterprise-grade платформа для аналитики и управления профилями питомцев

## О проекте

**FurryMetrics** — production-ready full-stack решение для систематизации данных о домашних питомцах.

## Технологический стек

**Backend:**  
Python 3.11 · Django 4.2 · Django REST Framework 3.14 · PostgreSQL 15 · Redis 7 · Gunicorn

**Frontend:**  
React 18 · JavaScript ES6+

**Infrastructure:**  
Docker · Docker Compose · Nginx · Multi-stage builds

**Архитектурные решения:**
- Оптимизация запросов (select_related, prefetch_related, query annotations)
- Redis кэширование с автоматической инвалидацией
- Database indexing для критичных запросов
- Separate read/write serializers pattern
- Environment-based конфигурация (dev/prod)
- Non-root Docker containers
- Rate limiting на уровне API и Gateway

## Быстрый старт

```bash
git clone https://github.com/d1g-1t/Furrymetrics.git
cd Furrymetrics
make setup
```

**Готово!** Платформа доступна на http://localhost

## Основные команды

```bash
make setup          # Полная инициализация проекта
make up             # Запуск сервисов
make down           # Остановка
make logs           # Просмотр логов
make migrate        # Применить миграции
make shell          # Django shell
make backup-db      # Бэкап базы данных
```

## Endpoints

- **Frontend**: http://localhost
- **API**: http://localhost/api/v1/
- **Admin**: http://localhost/admin/
- **API Docs**: http://localhost/api/v1/ (browsable)

## Производительность

- N+1 queries решены через join optimization
- 15+ database indexes на критичных полях
- Redis caching с TTL 15 минут
- Connection pooling (CONN_MAX_AGE=600)
- Gzip compression в Nginx
- Multi-stage Docker builds для минимизации образа

## Безопасность

- Environment variables для всех секретов
- Security headers (XSS, HSTS, Content-Type)
- Rate limiting (100 req/hour anon, 1000 req/hour auth)
- CORS configuration
- Non-root пользователь в Docker
- Input validation на уровне моделей и serializers

## Структура

```
furrymetrics/
├── backend/
│   ├── config/settings/    # base, dev, prod
│   ├── pets/              # Основное приложение
│   └── core/              # Shared utilities
├── frontend/              # React SPA
├── nginx/                 # Gateway + static
├── docker-compose.yml     # Orchestration
└── Makefile              # Automation
```

## Требования

- Docker 20.10+
- Docker Compose 2.0+
