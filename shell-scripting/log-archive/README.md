# 🗜️ log-archive.sh

A Bash CLI tool to compress and archive log directories with a timestamp.  
Built as part of a structured DevOps mentorship program.

---

## 🚀 What It Does

| Step | Action |
|------|--------|
| ✅ Validates | Checks argument is provided and directory exists |
| 🕐 Timestamps | Generates a unique filename with date and time |
| 🗜️ Compresses | Archives logs into a `.tar.gz` file |
| 📁 Stores | Saves archive to `~/log_archives/` |
| 📝 Logs | Records every archive event to `archive_log.txt` |

---

## 🛠️ Requirements

- Any Linux system (tested on Ubuntu 22.04 WSL2)
- Bash 4+
- Standard utils: `tar`, `date`, `du`

No external dependencies. No package installs.

---

## ▶️ Usage

```bash
# Make executable
chmod +x log-archive.sh

# Run with a log directory
./log-archive.sh <log-directory>

# Example
./log-archive.sh /var/log
```

---

## 🖼️ Sample Output

```
✔ Log directory found: /var/log
Timestamp  : 20260616_223606
Archive    : logs_archive_20260616_223606.tar.gz
Storing in : /home/dpm/log_archives
✔ Logs compressed successfully! (Size: 37M)
✔ Event logged to: /home/dpm/log_archives/archive_log.txt
```

---

## 📁 Archive Structure

```
~/log_archives/
├── logs_archive_20260616_223606.tar.gz   ← compressed archive
├── logs_archive_20260616_221355.tar.gz   ← previous run
└── archive_log.txt                       ← event log
```

---

## 📝 Event Log Format

```
[20260616_223606] Archived '/var/log' -> 'logs_archive_20260616_223606.tar.gz'
```

---

## 📁 File Structure

```
log-archive/
├── log-archive.sh   ← the script
└── README.md        ← this file
```

---

## 🔗 Part of

[DevOps-Projects](https://github.com/dhruvmojidra619-hub/DevOps-Projects) — a growing DevOps portfolio by Dhruv Mojidra.
