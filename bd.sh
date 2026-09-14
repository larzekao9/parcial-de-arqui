#!/usr/bin/env bash
# =====================================================
# bd.sh - cargar o borrar la base de datos rápido (examen)
# Uso:
#   ./bd.sh cargar   -> borra si existe y recrea + carga db/init.sql
#   ./bd.sh borrar   -> elimina la base de datos por completo
# =====================================================
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-5432}"
DB_NAME="${DB_NAME:-BaseDatosGym}"
DB_USER="${DB_USER:-gym}"
DB_PASS="${DB_PASS:-gym123}"

ACCION="${1:-}"

case "$ACCION" in
  cargar)
    echo "==> Eliminando '$DB_NAME' si existe..."
    dropdb -h "$DB_HOST" -p "$DB_PORT" -U "$(whoami)" --if-exists "$DB_NAME"

    echo "==> Creando rol '$DB_USER' (si no existe)..."
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$(whoami)" -d postgres -tAc \
        "SELECT 1 FROM pg_roles WHERE rolname='$DB_USER'" | grep -q 1 || \
        psql -h "$DB_HOST" -p "$DB_PORT" -U "$(whoami)" -d postgres -c \
        "CREATE ROLE $DB_USER LOGIN PASSWORD '$DB_PASS';"

    echo "==> Creando base de datos '$DB_NAME'..."
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$(whoami)" -d postgres -c \
        "CREATE DATABASE \"$DB_NAME\" OWNER $DB_USER;"

    echo "==> Cargando esquema y datos de ejemplo (db/init.sql)..."
    PGPASSWORD="$DB_PASS" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" \
        -v ON_ERROR_STOP=1 -f "$DIR/db/init.sql"

    echo "==> Asegurando permisos de '$DB_USER'..."
    psql -h "$DB_HOST" -p "$DB_PORT" -U "$(whoami)" -d "$DB_NAME" -v ON_ERROR_STOP=1 -c \
        "GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO $DB_USER; GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO $DB_USER;" \
        >/dev/null

    echo "==> Listo. Ahora corre ./levantar.sh para iniciar el servidor PHP."
    ;;
  borrar)
    echo "==> Eliminando base de datos '$DB_NAME'..."
    dropdb -h "$DB_HOST" -p "$DB_PORT" -U "$(whoami)" --if-exists "$DB_NAME"
    echo "==> Listo, '$DB_NAME' eliminada."
    ;;
  *)
    echo "Uso: $0 {cargar|borrar}"
    exit 1
    ;;
esac
