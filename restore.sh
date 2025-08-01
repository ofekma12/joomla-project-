#!/usr/bin/env bash
set -euo pipefail

# Usage: ./restore.sh [DB.sql] [FILES.tar.gz]
# If not provided, picks the latest under ~/restore/

SRC_DIR="${HOME}/restore"
DB="${1:-}"
TGZ="${2:-}"

if [ -z "${DB}" ]; then
  DB=$(ls -1t "${SRC_DIR}"/joomla-db-*.sql 2>/dev/null | head -n1 || true)
fi
if [ -z "${TGZ}" ]; then
  TGZ=$(ls -1t "${SRC_DIR}"/joomla-files-*.tar.gz 2>/dev/null | head -n1 || true)
fi

[ -f "${DB}" ] || { echo "❌ DB dump not found (looked for ${SRC_DIR}/joomla-db-*.sql)."; exit 1; }
[ -f "${TGZ}" ] || { echo "❌ Files archive not found (looked for ${SRC_DIR}/joomla-files-*.tar.gz)."; exit 1; }

echo "▶ Restoring Joomla files to volume 'joomla-data'..."
docker volume create joomla-data >/dev/null
docker run --rm -v joomla-data:/data -v "${SRC_DIR}":/backup       busybox sh -c 'rm -rf /data/* && tar xzf "/backup/'"$(basename "${TGZ}")"'" -C /data'
echo "✅ Files restored."

echo "▶ Restoring MySQL database 'joomla'..."
cat "${DB}" | docker exec -i mysql sh -c 'mysql -uroot -p"$MYSQL_ROOT_PASSWORD" joomla'
echo "✅ Database restored."

echo "▶ Restarting Joomla container..."
docker restart my-joomla >/dev/null || true
echo "✅ Done. Open http://localhost:8080"
