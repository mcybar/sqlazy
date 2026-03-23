#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MYSQL_BIN="${MYSQL_BIN:-mysql}"
MYSQL_USER="${MYSQL_USER:-root}"
MYSQL_PASSWORD="${MYSQL_PASSWORD:-}"

dumps=(
  "exportedsql/keystone.sql"
  "exportedsql/csail_stata_glance.sql"
  "exportedsql/csail_stata_cinder.sql"
  "exportedsql/csail_stata_neutron.sql"
  "exportedsql/csail_stata_nova.sql"
)

if ! command -v "$MYSQL_BIN" >/dev/null 2>&1; then
  echo "mysql client not found: $MYSQL_BIN" >&2
  exit 1
fi

cd "$ROOT_DIR"

mysql_cmd=("$MYSQL_BIN" -u "$MYSQL_USER")
if [ -n "$MYSQL_PASSWORD" ]; then
  mysql_cmd+=("-p$MYSQL_PASSWORD")
fi

for dump in "${dumps[@]}"; do
  echo "Importing $dump"
  "${mysql_cmd[@]}" < "$dump"
done

echo "Import complete."
"${mysql_cmd[@]}" -e "SHOW DATABASES;"
