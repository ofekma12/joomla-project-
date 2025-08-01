#!/usr/bin/env bash
set -euo pipefail
MSG="${1:-backup}"

./backup.sh

DB=$(ls -1t "${HOME}"/backups/joomla-db-*.sql        | head -n1)
TGZ=$(ls -1t "${HOME}"/backups/joomla-files-*.tar.gz | head -n1)

mkdir -p backups
cp -f "$DB" backups/joomla-db-backup.sql
cp -f "$TGZ" backups/joomla-files-backup.tar.gz

git add backups/*.sql backups/*.tar.gz
git commit -m "auto: ${MSG} $(date -Iseconds)" || echo "Nothing to commit."
git push origin main
echo "✅ Pushed latest backups to this repo."
