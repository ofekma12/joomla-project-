#!/usr/bin/env bash
set -Eeuo pipefail

echo "== Joomla one-click runner =="

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "❌ Missing dependency: $1"; exit 1; }; }

# 0) Basic checks
need_cmd docker
if [ ! -f "./setup.sh" ] || [ ! -f "./restore.sh" ]; then
  echo "❌ Please run this script from the project root (where setup.sh and restore.sh exist)."
  exit 1
fi

# 1) Make scripts executable + fix Windows line endings if needed
chmod +x ./*.sh 2>/dev/null || true
if grep -Iq $'\r' -- ./*.sh 2>/dev/null; then
  echo "↺ Converting CRLF to LF in *.sh ..."
  sed -i 's/\r$//' ./*.sh || true
fi

# 2) If repo uses Git LFS for backups, ensure content is pulled
if [ -f .gitattributes ] && grep -E '(\.sql|\.tar\.gz).*lfs' .gitattributes >/dev/null 2>&1; then
  if ! command -v git-lfs >/dev/null 2>&1; then
    if command -v sudo >/dev/null 2>&1; then
      echo "🔧 Installing git-lfs (requires sudo) ..."
      sudo apt-get update -y && sudo apt-get install -y git-lfs || true
    fi
  fi
  git lfs install >/dev/null 2>&1 || true
  git lfs pull    >/dev/null 2>&1 || true
fi

# 3) Run setup (network + mysql + joomla; setup waits for MySQL)
echo "▶ Running setup.sh"
./setup.sh

# 4) Auto-restore logic
# Usage override: ./run.sh <DB.sql> <FILES.tar.gz>
DB_ARG="${1:-}"
TGZ_ARG="${2:-}"

do_restore() {
  echo "▶ Restoring from:"
  echo "   DB : $1"
  echo "   TGZ: $2"
  ./restore.sh "$1" "$2"
}

if [ -n "$DB_ARG" ] && [ -n "$TGZ_ARG" ] && [ -f "$DB_ARG" ] && [ -f "$TGZ_ARG" ]; then
  do_restore "$DB_ARG" "$TGZ_ARG"
else
  mkdir -p "${HOME}/restore"
  # Prefer backups inside repo/backups, fall back to ~/restore
  DB=$(ls -1t ./backups/joomla-db-*.sql 2>/dev/null | head -n1 || true)
  TGZ=$(ls -1t ./backups/joomla-files-*.tar.gz 2>/dev/null | head -n1 || true)
  if [ -n "$DB" ] && [ -n "$TGZ" ]; then
    cp -f "$DB" "${HOME}/restore/joomla-db-backup.sql"
    cp -f "$TGZ" "${HOME}/restore/joomla-files-backup.tar.gz"
    do_restore "${HOME}/restore/joomla-db-backup.sql" "${HOME}/restore/joomla-files-backup.tar.gz"
  elif ls "${HOME}/restore"/joomla-db-*.sql >/dev/null 2>&1 && ls "${HOME}/restore"/joomla-files-*.tar.gz >/dev/null 2>&1; then
    echo "▶ Using backups already found in ${HOME}/restore"
    ./restore.sh
  else
    echo "ℹ️ No backups found. Proceed with initial Joomla web installer."
  fi
fi

echo "✅ Done. Open: http://localhost:8080/administrator  (or the port you configured)"
