# Joomla + MySQL via Docker (Afeka vLab Setup)

This project allows you to run a Joomla website with MySQL using Docker containers. It's designed for vLab environments where data isn't persistent.

---

## 🚀 How to Run

1. Clone the repo:
```bash
mkdir -p ~/projects && cd ~/projects
git clone https://github.com/ofekma12/joomla-project-.git
cd joomla-project-
```

2. Make scripts executable and fix line endings:
```bash
chmod +x *.sh
sed -i 's/\r$//' *.sh
```

3. Start the site:
```bash
./run.sh
```

Open: [http://localhost:8080](http://localhost:8080)

---

## 💾 After Editing Site (e.g., new articles)

1. Backup:
```bash
./backup.sh
```

2. Push to GitHub:
```bash
git add .
git commit -m "Update backup"
git push
```
```
or ./auto-backup-push.sh
```
---

## 🔁 For Next Login

Just re-clone the repo and run:
```bash
./run.sh
```

That's it. Your site and DB will be restored automatically.
