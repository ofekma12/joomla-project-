#!/usr/bin/env bash
set -euo pipefail

NETWORK=joomla-net

echo "▶ Creating docker network (if missing)..."
docker network inspect "$NETWORK" >/dev/null 2>&1 || docker network create "$NETWORK"

echo "▶ Removing existing containers (if any)..."
docker rm -f mysql my-joomla >/dev/null 2>&1 || true

echo "▶ Starting MySQL..."
docker run -d --name mysql       --network "$NETWORK"       -e MYSQL_ROOT_PASSWORD=my-secret-pw       -e MYSQL_DATABASE=joomla       -v mysql-data:/var/lib/mysql       -p 3306:3306       mysql:latest

echo "⌛ Waiting for MySQL to become ready..."
for i in {1..30}; do
  if docker exec mysql sh -c 'mysqladmin ping -uroot -p"$MYSQL_ROOT_PASSWORD"' >/dev/null 2>&1; then
    echo "✅ MySQL is ready."
    break
  fi
  sleep 2
  if [ "$i" -eq 30 ]; then
    echo "❌ MySQL did not become ready in time."; exit 1
  fi
done

echo "▶ Starting Joomla..."
docker run -d --name my-joomla       --network "$NETWORK"       -p 8080:80       -v joomla-data:/var/www/html       -e JOOMLA_DB_HOST=mysql       -e JOOMLA_DB_USER=root       -e JOOMLA_DB_PASSWORD=my-secret-pw       -e JOOMLA_DB_NAME=joomla       joomla:latest

echo "✅ Joomla running at: http://localhost:8080"
