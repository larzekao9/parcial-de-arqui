#!/usr/bin/env bash
# =====================================================
# levantar.sh - crea/puebla la BD y levanta el servidor PHP
# Uso: ./levantar.sh
# =====================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-BaseDatosGym}"
DB_USER="${DB_USER:-gym}"
DB_PASS="${DB_PASS:-gym123}"
APP_PORT="${APP_PORT:-8000}"

echo "==> Verificando PostgreSQL en $DB_HOST:$DB_PORT..."
if ! pg_isready -h "$DB_HOST" -p "$DB_PORT" >/dev/null 2>&1; then
    echo "ERROR: PostgreSQL no responde en $DB_HOST:$DB_PORT. Inícialo (ej: brew services start postgresql) y vuelve a intentar."
    exit 1
fi

PSQL_ADMIN="psql -h $DB_HOST -p $DB_PORT -U $(whoami) -d postgres -v ON_ERROR_STOP=1"

echo "==> Creando rol '$DB_USER' (si no existe)..."
$PSQL_ADMIN -tAc "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1 || \
    $PSQL_ADMIN -c "CREATE ROLE $DB_USER LOGIN PASSWORD '$DB_PASS';"

echo "==> Creando base de datos '$DB_NAME' (si no existe)..."
$PSQL_ADMIN -tAc "SELECT 1 FROM pg_database WHERE datname='$DB_NAME'" | grep -q 1 || \
    $PSQL_ADMIN -c "CREATE DATABASE \"$DB_NAME\" OWNER $DB_USER;"

echo "==> Verificando esquema..."
TABLE_COUNT=$(psql -h "$DB_HOST" -p "$DB_PORT" -U "$(whoami)" -d "$DB_NAME" -tAc \
    "SELECT count(*) FROM information_schema.tables WHERE table_schema='public'")

if [ "$TABLE_COUNT" -eq 0 ]; then
    echo "==> Cargando esquema y datos de ejemplo (db/init.sql)..."
    PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
        -v ON_ERROR_STOP=1 -f "$DIR/db/init.sql"
else
    echo "==> El esquema ya existe ($TABLE_COUNT tablas), se omite la carga de db/init.sql."
fi

echo "==> Asegurando permisos de '$DB_USER' sobre las tablas..."
psql -h "$DB_HOST" -p "$DB_PORT" -U "$(whoami)" -d "$DB_NAME" -v ON_ERROR_STOP=1 -c \
    "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USER; GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;" \
    >/dev/null

export DB_HOST DB_PORT DB_NAME DB_USER DB_PASS

echo "==> Iniciando servidor PHP en http://localhost:$APP_PORT ..."
cd "$DIR/gym mvc"
php -d upload_max_filesize=100M \
    -d post_max_size=100M \
    -d memory_limit=256M \
    -d max_execution_time=300 \
    -d max_input_time=300 \
    -S "localhost:$APP_PORT" index.php
