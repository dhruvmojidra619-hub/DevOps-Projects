# 📊 server-stats.sh

A Bash script to analyse live server performance stats on any Linux system.  
Built as part of a structured DevOps mentorship program.

---

## 🚀 What It Does

| Stat | Details |
|------|---------|
| 🖥️ System Info | OS, Kernel, Architecture |
| ⏱️ Uptime & Load | Uptime duration + 1/5/15 min load average vs core count |
| ⚙️ CPU Usage | Live used/idle % sampled from `/proc/stat` |
| 🧠 Memory | Total, Used, Free, Available (MiB + %) — with Swap |
| 💾 Disk | Per-filesystem usage with colour-coded alerts |
| 🔝 Top Processes | Top 5 by CPU and top 5 by Memory |
| 👤 Logged-in Users | Active sessions via `who` |
| 🔐 Failed Logins | Count + top offending IPs from auth log (root only) |

---

## 🛠️ Requirements

- Any Linux system (tested on Ubuntu 22.04 WSL2 & Ubuntu 24.04)
- Bash 4+
- Standard utils: `ps`, `df`, `free`, `who`, `awk`, `grep`

No external dependencies. No package installs.

---

## ▶️ Usage

```bash
# Clone the repo
git clone https://github.com/dhruvmojidra619-hub/devops-projects.git
cd devops-projects/shell-scripting/server-stats

# Make executable
chmod +x server-stats.sh

# Run
./server-stats.sh

# Run with sudo for failed login data
sudo ./server-stats.sh
```

---

## 🖼️ Sample Output

```
╔══════════════════════════════════════════════════╗
║        SERVER PERFORMANCE STATS ANALYSER        ║
╚══════════════════════════════════════════════════╝
  Host   : BEASTY   |   Date: 2026-06-16 14:45:51 IST

  SYSTEM INFORMATION
  OS:                Ubuntu 22.04.3 LTS
  Kernel:            6.6.87.2-microsoft-standard-WSL2

  CPU USAGE
  Used:              0.2%
  Idle:              99.8%

  MEMORY USAGE
  Total:             9946 MiB
  Used:              656 MiB  (6.6%)

  TOP 5 PROCESSES BY CPU USAGE
  PID      USER         %CPU   %MEM  COMMAND
  1        root          0.5    0.1  /sbin/init
  ...
```

---

## 🎨 Colour Coding

| Colour | Meaning |
|--------|---------|
| 🟢 Green | Below 70% — healthy |
| 🟡 Yellow | 70–89% — watch this |
| 🔴 Red | 90%+ — needs attention |

---

## 📁 File Structure

```
server-stats/
├── server-stats.sh   ← the script
└── README.md         ← this file
```

---

## 🔗 Part of

[devops-projects](https://github.com/dhruvmojidra619-hub/devops-projects) — a growing DevOps portfolio by Dhruv Mojidra.
