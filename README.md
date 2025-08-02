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

Open: [http://localhost:8080/administrator](http://localhost:8080)

login:  

```Admin Username:  admin

Admin Password: secretpassword

Email:  demo@example.com

Host: mysql

Username: root

Password: my-secret-pw

Database Name: joomla ```
---

## 💾 After Editing Site (e.g., new articles)

1. set your account for git uploading:
```bash
git config --global user.email "(YourEmail)@gmail.com"
git config --global user.name "(YourUsername)"
```
2. Backup:
```bash
./backup.sh
```
or: 
```bash
mkdir -p backups
cp ~/backups/joomla-db-*.sql        backups/joomla-db-backup.sql
cp ~/backups/joomla-files-*.tar.gz  backups/joomla-files-backup.tar.gz
```
3. Push to GitHub:
```bash
git add .
git commit -m "Update backup"
git push
```
---

## 🔁 For Next Login

Just re-clone the repo and run:
```bash
./run.sh
```

That's it. Your site and DB will be restored automatically.
