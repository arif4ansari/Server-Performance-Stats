#!/bin/bash

echo "======================================="
echo "       SERVER PERFORMANCE STATS"
echo "======================================="
echo

# Hostname
echo "Hostname: $(hostname)"
echo "Date: $(date)"
echo

# CPU Usage
echo "========== CPU USAGE =========="
CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d. -f1)
CPU_USAGE=$((100 - CPU_IDLE))
echo "Total CPU Usage: ${CPU_USAGE}%"
echo

# Memory Usage
echo "========== MEMORY USAGE =========="
MEM_TOTAL=$(free -m | awk '/Mem:/ {print $2}')
MEM_USED=$(free -m | awk '/Mem:/ {print $3}')
MEM_FREE=$(free -m | awk '/Mem:/ {print $4}')
MEM_PERCENT=$(awk "BEGIN {printf \"%.2f\", ($MEM_USED/$MEM_TOTAL)*100}")

echo "Total Memory : ${MEM_TOTAL} MB"
echo "Used Memory  : ${MEM_USED} MB"
echo "Free Memory  : ${MEM_FREE} MB"
echo "Usage        : ${MEM_PERCENT}%"
echo

# Disk Usage
echo "========== DISK USAGE =========="
df -h / | awk 'NR==2 {
    print "Total Disk   : " $2
    print "Used Disk    : " $3
    print "Free Disk    : " $4
    print "Usage        : " $5
}'
echo

# Top 5 CPU Consuming Processes
echo "========== TOP 5 PROCESSES BY CPU =========="
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6
echo

# Top 5 Memory Consuming Processes
echo "========== TOP 5 PROCESSES BY MEMORY =========="
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6
echo

# Stretch Goals

echo "========== SYSTEM INFORMATION =========="
echo "OS Version:"
grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"'
echo

echo "Uptime:"
uptime -p
echo

echo "Load Average:"
uptime | awk -F'load average:' '{print $2}'
echo

echo "Logged In Users:"
who | awk '{print $1}' | sort | uniq
echo

echo "Failed Login Attempts (last 5):"
lastb 2>/dev/null | head -5
echo

echo "======================================="
