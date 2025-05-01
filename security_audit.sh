#!/bin/bash

# ============================================
# 📜 Script: Security Audit and Hardening Script
# 👨‍💻 Author: Rutik Khedekar
# 📅 Date: $(date +%Y-%m-%d)
# ============================================

# Define log and config file
CONFIG_FILE="security_checks.conf"
LOG_FILE="security_audit.log"

# Function to log messages with timestamp
log_message() {
    echo "$(date '+%Y-%m-%d %H:%M:%S'): $1" | tee -a "$LOG_FILE"
}

# Function to display header
show_header() {
    clear
    echo "==============================================================="
    echo "         🔐 Security Audit and Hardening Script"
    echo "         👨‍💻 Created by: Rutik Khedekar"
    echo "         📂 Log File: $LOG_FILE"
    echo "         📅 Date: $(date)"
    echo "==============================================================="
    echo
}

# User and Group Audits
user_group_audit() {
    log_message "Starting User and Group Audit..."
    echo "🔎 List of System Users:"
    cut -d: -f1 /etc/passwd
    echo

    echo "🔎 List of Groups:"
    cut -d: -f1 /etc/group
    echo
}

# File and Directory Permissions
file_permissions() {
    log_message "Checking File and Directory Permissions..."
    echo "🔒 World-Writable Files:"
    find / -type f -perm -002 -exec ls -l {} \; 2>/dev/null

    echo
    echo "🔒 World-Writable Directories:"
    find / -type d -perm -002 -exec ls -ld {} \; 2>/dev/null

    echo
    echo "⚙️  Files with SUID/SGID Permissions:"
    find / -perm /6000 -exec ls -l {} \; 2>/dev/null
    echo
}

# Service Audits
service_audit() {
    log_message "Auditing Running and Critical Services..."
    echo "⚙️ Currently Running Services:"
    systemctl list-units --type=service --state=running

    echo
    echo "🔍 Status of Critical Services (e.g., sshd, iptables):"
    for service in sshd iptables; do
        echo -n "$service: "
        systemctl is-active --quiet $service && echo "Running ✅" || echo "Not Running ❌"
    done
    echo
}

# Firewall and Network Security
firewall_network() {
    log_message "Checking Firewall and Network Security..."
    echo "🔥 Firewall Status:"
    ufw status verbose 2>/dev/null || echo "UFW not installed or active."

    echo
    echo "🌐 Open Ports and Listening Services:"
    ss -tuln

    echo
    echo "🔁 IP Forwarding Status:"
    sysctl net.ipv4.ip_forward
    echo
}

# IP and Network Configuration
ip_network() {
    log_message "Gathering IP and Network Configuration..."
    echo "🌐 IP Address Details:"
    ip addr show

    echo
    echo "📌 Interface and IPv4 Info (Public/Private):"
    ip -o -4 addr show | awk '{print $2, $4}'
    echo
}

# Security Updates
security_updates() {
    log_message "Checking for Security Updates..."
    echo "⬆️  Available Security Updates:"
    apt list --upgradable 2>/dev/null | grep -i security || echo "No security updates available."

    echo
    echo "🛡️  Unattended-Upgrades Package Status:"
    dpkg -l | grep unattended-upgrades || echo "unattended-upgrades not installed."
    echo
}

# Log Monitoring
log_monitoring() {
    log_message "Monitoring Logs for Recent SSH Activity..."
    echo "🕵️ Recent SSH Login Attempts:"
    grep "sshd" /var/log/auth.log | tail -n 20 2>/dev/null || echo "Log file not available or insufficient permissions."
    echo
}

# Server Hardening
server_hardening() {
    log_message "Applying Basic Server Hardening..."
    echo "🔐 Disabling SSH Password Authentication (if applicable)..."
    SSHD_CONFIG="/etc/ssh/sshd_config"
    if grep -q "^#PasswordAuthentication" "$SSHD_CONFIG"; then
        sed -i 's/^#PasswordAuthentication.*/PasswordAuthentication no/' "$SSHD_CONFIG"
    else
        echo "PasswordAuthentication no" >> "$SSHD_CONFIG"
    fi
    systemctl restart sshd

    echo
    echo "🚫 Disabling IPv6:"
    echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
    sysctl -p

    echo
    echo "🔐 Enabling GRUB Bootloader Password Protection:"
    grub-mkpasswd-pbkdf2

    echo
}

# Custom Checks from Config File
custom_checks() {
    log_message "Executing Custom Security Checks from $CONFIG_FILE..."
    if [[ -f $CONFIG_FILE ]]; then
        while IFS= read -r line; do
            echo "▶️  Running: $line"
            eval "$line"
        done < "$CONFIG_FILE"
    else
        echo "❌ No custom configuration file ($CONFIG_FILE) found."
    fi
    echo
}

# Display Final Report
generate_report() {
    log_message "Generating Summary Report..."
    echo "📋 Summary of Security Audit:"
    cat "$LOG_FILE"
}

# Main Function
main() {
    show_header
    user_group_audit
    file_permissions
    service_audit
    firewall_network
    ip_network
    security_updates
    log_monitoring
    server_hardening
    custom_checks
    generate_report
}

# Run Script
main
