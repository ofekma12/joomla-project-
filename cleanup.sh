#!/usr/bin/env bash
set -euo pipefail
echo "▶ Removing containers..."
docker rm -f my-joomla mysql 2>/dev/null || true
echo "▶ Removing network (joomla-net)..."
docker network rm joomla-net 2>/dev/null || true
echo "ℹ️ Volumes (mysql-data, joomla-data) remain. Remove manually if needed:"
echo "   docker volume rm mysql-data joomla-data"
echo "✅ Cleanup complete."
