# 🔒  Automating security audits and server hardening on Linux servers.  
---

This Bash script automates a comprehensive security audit and server hardening process for Linux-based systems. It systematically inspects various aspects of server configuration, highlights vulnerabilities, and implements best-practice security enhancements.

---

## ✅ Features

- **👥 User and Group Audit**  
  Lists system users and groups, helping detect potential privilege escalations or misconfigurations.

- **🗂️ File and Directory Permissions**  
  Detects world-writable files and directories, as well as SUID/SGID files that may pose a security risk.

- **🛠️ Service Audit**  
  Displays all active services and highlights critical ones like SSH and iptables.

- **🌐 Firewall & Network Security**  
  Reviews firewall status, open ports, and whether IP forwarding is enabled.

- **📡 IP and Network Configuration**  
  Identifies assigned IP addresses and distinguishes between public and private IPs.

- **🔐 Security Updates and Patching**  
  Checks for available security updates and the status of automatic updates.

- **🪵 Log Monitoring**  
  Monitors recent SSH login attempts to detect unauthorized access patterns.

- **🛡️ Server Hardening**  
  Disables unnecessary services like IPv6, enforces SSH key-based login, configures bootloader security, and more.

- **⚙️ Custom Security Checks**  
  Executes user-defined checks from a `security_checks.conf` configuration file.

- **📝 Reporting**  
  Generates a log-based report summarizing all performed checks and hardening steps.

---

## 📦 Installation

### Prerequisites

Ensure the following tools are installed:

```bash
sudo apt update
sudo apt install -y net-tools procps sysstat gawk ufw iptables grub2 unattended-upgrades openssh-client openssh-server
```

---

### Clone the Repository

```bash
git clone
cd security-audit
```

---

### Make Script Executable

```bash
chmod +x security_audit.sh
```

---

## ⚙️ Configuration

### Custom Security Checks

Edit the `security_checks.conf` file to add organization-specific commands for additional checks.

```bash
nano security_checks.conf
```

Each line should contain a valid shell command.

---

## 🚀 Usage

Run the script with:

```bash
./security_audit.sh
```

This executes all audit modules and generates a full report in `security_audit.log`.

---



---

## 🛠️ Troubleshooting

### Permission Errors

- **Executable Error:**

```bash
chmod +x security_audit.sh
```

- **Ownership Issues:**

```bash
sudo chown youruser:yourgroup security_audit.sh
```

---

### Common Issues

- **Missing Tools**: Verify that all required packages are installed.
- **Invalid Commands in Config File**: Ensure each line in `security_checks.conf` is a valid shell command.

---

## 📑 Script Structure and Modularity

The script is modular, making it easy to maintain, scale, and customize. Each security section is defined in its own function:

| Module                          | Description                                             |
|---------------------------------|---------------------------------------------------------|
| `user_group_audit`             | Lists users/groups and checks for anomalies             |
| `file_permissions`             | Checks for risky file/directory permissions             |
| `service_audit`                | Identifies active and critical services                 |
| `firewall_network`             | Reviews network security and firewall settings          |
| `ip_network`                   | Lists IPs and highlights private vs public              |
| `security_updates`             | Scans for pending security updates                      |
| `log_monitoring`               | Monitors logs for suspicious login attempts             |
| `server_hardening`             | Applies core hardening like SSH/IPv6/bootloader changes |
| `custom_checks`                | Executes user-defined commands from config file         |

---

## 📁 File Descriptions

- **`security_audit.sh`** – Main executable script
- **`security_checks.conf`** – Custom commands for extended audit
- **`security_audit.log`** – Output log with results and status messages

---

## 🤝 Contribution

Contributions are welcome! Fork the repository, make changes, and submit a pull request.

---

**Author**: Rutik Khedekar  
**Script Name**: `Automating security audits and server hardening on Linux servers.'
