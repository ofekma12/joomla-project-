# Joomla + MySQL with Docker (Afeka vLab)

## Quick Start
```bash
./setup.sh
# Open http://localhost:8080 and finish Joomla setup:
# Admin: demoadmin / secretpassword (or per your course sheet)
# DB: host=mysql user=root pass=my-secret-pw db=joomla
```

## Backup
```bash
./backup.sh
# Backups in ~/backups:
#   joomla-db-YYYYmmdd-HHMMSS.sql
#   joomla-files-YYYYmmdd-HHMMSS.tar.gz
# Copy them outside the VM so they don't get wiped:
cp ~/backups/* /home/devtools/tsclient/C/joomla-backups/
```

## Restore (on any machine)
```bash
./setup.sh
mkdir -p ~/restore
cp /home/devtools/tsclient/C/joomla-backups/* ~/restore/
./restore.sh
# Open http://localhost:8080
```

## Cleanup
```bash
./cleanup.sh
```

## Notes
- Requires Docker Engine.
- Adjust the shared-folder path if your VM maps it differently (e.g. `/run/user/$UID/gvfs/...` or `/mnt/tsclient/...`).
