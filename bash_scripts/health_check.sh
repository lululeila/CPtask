#!/bin/bash

LOG_FILE="/var/log/server_health.log"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
MEM_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
DISK_USAGE=$(df -h / | grep / | awk '{print $5}' | sed 's/%//g')

WEB_SERVER="nginx"
API_ENDPOINTS=(
    "http://13.61.100.109/api/students/"
    "http://13.61.100.109/api/subjects/"
)

# Logging function
log() {
    echo "$TIMESTAMP $1" >> "$LOG_FILE"
}

# Start of health check
log "Starting health check..."
log "CPU usage: $CPU_USAGE%"
log "Memory usage: $MEM_USAGE%"
log "Disk usage: $DISK_USAGE%"

# Disk warning
if [ "$DISK_USAGE" -gt 90 ]; then
    log "WARNING: Disk usage above 90%!"
fi

# Nginx status
if pgrep -x "$WEB_SERVER" > /dev/null; then
    log "$WEB_SERVER is running."
else
    log "WARNING: $WEB_SERVER is NOT running."
fi

# API checks
for endpoint in "${API_ENDPOINTS[@]}"; do
    STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$endpoint")
    if [ "$STATUS" -eq 200 ]; then
        log "API endpoint $endpoint is UP."
    else
        log "WARNING: API endpoint $endpoint is DOWN (Status: $STATUS)"
    fi
    sleep 1
done

log "Health check complete."