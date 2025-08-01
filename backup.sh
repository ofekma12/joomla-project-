#!/usr/bin/env bash
set -euo pipefail

TS=$(date +%Y%m%d-%H%M%S)
BK_DIR="${HOME}/backups"
mkdir -p "${BK_DIR}"

echo "▶ Dumping MySQL database 'joomla'..."
docker exec mysql sh -c 'exec mysqldump -uroot -p"$MYSQL_ROOT_PASSWORD" joomla' > "${BK_DIR}/joomla-db-${TS}.sql"
echo "✅ DB dump: ${BK_DIR}/joomla-db-${TS}.sql"

echo "▶ Archiving Joomla files from volume 'joomla-data'..."
docker run --rm -v joomla-data:/data -v "${BK_DIR}":/backup       busybox sh -c 'cd /data && tar czf /backup/joomla-files-'${TS}'.tar.gz .'
echo "✅ Files archive: ${BK_DIR}/joomla-files-${TS}.tar.gz"

echo ""
echo "ℹ️  To persist outside vLab, copy backups to a shared folder."
echo "    Example (adjust path if needed):"
echo "    cp ${BK_DIR}/joomla-* /home/devtools/tsclient/C/joomla-backups/"
