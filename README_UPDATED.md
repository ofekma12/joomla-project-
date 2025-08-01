# Joomla + MySQL via Docker (Afeka vLab)

Run a Joomla site with MySQL in Docker. Designed for vLab where local data may not persist.

---

## 🚀 Quick Start (everyone)
```bash
git clone https://github.com/ofekma12/joomla-project-.git
cd joomla-project-
chmod +x *.sh
./run.sh
```
Open: **http://localhost:8080**  
If no backups exist yet, complete Joomla’s web installer. If backups are present under `./backups/`, they will be restored automatically.

---

## 🔁 Manual Restore (optional)
```bash
./setup.sh
mkdir -p ~/restore
cp ./backups/* ~/restore/   # or place your backup files here
./restore.sh
# Open http://localhost:8080
```

---

## 💾 After Editing the Site (backup & update)

When you finish adding articles or making any changes, create a backup and **upload it via GitHub Web** – no command‑line push credentials required.

1) **Create the backup files locally**
```bash
./backup.sh
# files created in  ~/backups/
```

2) **Prepare copies inside the repo (stable names)**
```bash
mkdir -p backups
cp ~/backups/joomla-db-*.sql        backups/joomla-db-backup.sql
cp ~/backups/joomla-files-*.tar.gz  backups/joomla-files-backup.tar.gz
```

3) **Upload via GitHub Web**
- Go to the repository page on GitHub
- **Add file → Upload files**
- Drag the two files from `backups/`:
  - `backups/joomla-db-backup.sql`
  - `backups/joomla-files-backup.tar.gz`
- Write a short message (e.g., *“backup after adding articles”*) and **Commit changes**

> Next time anyone clones the repo and runs `./run.sh`, these backups under `./backups/` will be restored automatically.

---

## 🛠 Notes
- If port **8080** is busy, edit `setup.sh` and change `-p 8080:80` to a free port (e.g., `-p 8081:80`) and browse to `http://localhost:8081`.
- Do **not** store secrets in the repo. The DB password is used only inside the containers.
