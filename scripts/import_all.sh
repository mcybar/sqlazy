#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SQL_DIR="$ROOT_DIR/exportedsql"
CONTAINER_NAME="${MYSQL_CONTAINER_NAME:-sqlazy-mysql}"
MYSQL_PASSWORD="${MYSQL_ROOT_PASSWORD:-root}"

dumps=(
  "keystone.sql"
  "csail_stata_glance.sql"
  "csail_stata_cinder.sql"
  "csail_stata_neutron.sql"
  "csail_stata_nova.sql"
)

if ! command -v docker >/dev/null 2>&1; then
  echo "docker is required but not installed." >&2
  exit 1
fi

echo "Starting MySQL container..."
docker compose up -d mysql

echo "Waiting for MySQL to become healthy..."
until [ "$(docker inspect -f '{{if .State.Health}}{{.State.Health.Status}}{{else}}starting{{end}}' "$CONTAINER_NAME" 2>/dev/null)" = "healthy" ]; do
  sleep 5
done

echo "Importing dumps into $CONTAINER_NAME"
for dump in "${dumps[@]}"; do
  path="$SQL_DIR/$dump"
  if [ ! -f "$path" ]; then
    echo "Missing dump: $path" >&2
    exit 1
  fi

  echo "  -> $dump"
  docker exec -i "$CONTAINER_NAME" mysql -uroot "-p$MYSQL_PASSWORD" < "$path"
done

echo "Import complete."
echo "Databases loaded:"
docker exec "$CONTAINER_NAME" mysql -uroot "-p$MYSQL_PASSWORD" -e "SHOW DATABASES;"
