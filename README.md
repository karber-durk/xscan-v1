# 🚀 xscan

**xscan** is a customizable, terminal-based network and port scanning tool designed for cybersecurity students, ethical hackers, and sysadmins. Built with Bash and Python, it supports TCP/UDP scanning, service version detection, and live host pinging with colorful output and input validation.

---

## 📌 Features

- 🔎 **Port Scanning** – Supports both TCP and UDP.
- 🌐 **Host Availability Check** – Ping a host to see if it’s up.
- 🛠 **Service Version Detection** – Detects running service versions (TCP only).
- 🔧 **Custom Port Ranges** – Scan single ports or port ranges (e.g., `80` or `1-100`).
- ⚡ **Color-coded Output** – Easy-to-read CLI formatting using `tput`.
- 🔐 **Root Check** – Ensures scans that require privileges are run safely.
- 🧠 **Input Validation** – Host and port validation to avoid misuse.
- 📦 **Modular Design** – Scanning logic is separated into Python files under `.bin/`.

---

## 🧪 Usage

```bash
./xscan [OPTIONS] [TARGET]
```


## 🎯 Options

| Option             | Description                                    |
|--------------------|------------------------------------------------|
| `-h`, `--help`      | Show help menu                                 |
| `-H`, `--Host`      | Specify the host or IP address                 |
| `-p`, `--port`      | Specify port or range (e.g., `80` or `1-100`)  |
| `-sT`, `--Tcp-scan` | Perform a TCP scan                             |
| `-sU`, `--Udp-scan` | Perform a UDP scan                             |
| `-sV`, `--service`  | Perform service version detection (TCP only)   |
| `-v`, `--version`   | Show tool version                              |

---

## 🔧 Examples

### ✅ 1. Check if a host is up

```bash
sudo ./xscan -H 192.168.1.1
```

### 🔍 2. Scan ports 1–100 using TCP
```bash
sudo ./xscan -H 192.168.1.1 -p 1-100 -sT
```
### 📡 3. Perform UDP scan on a single port
```
sudo ./xscan -H 192.168.1.1 -p 53 -sU
```

#### 🔍 4. Detect service version on port
```
sudo ./xscan -H example.com -p 80 -sV
```
## 👨‍💻 Author

**Kasper**  
📆 **Date:** 9/10/2024  
💬 **Telegram:** [@User0xz19](https://t.me/User0xz19)

