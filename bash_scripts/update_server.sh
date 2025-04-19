#!/bin/bash

# Log file
LOG_FILE="/var/log/update.log"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

REPO_DIR="/home/ubuntu/project/CPtask"
VENV_DIR="/home/ubuntu/project/env" 
WEB_SERVICE="nginx"
SUPERVISOR_SERVICE="supervisor"

echo "[$TIMESTAMP] Starting system and project update..." >> $LOG_FILE

sudo apt update && sudo apt upgrade -y >> $LOG_FILE

cd $REPO_DIR || {
    echo "[$TIMESTAMP] ERROR: Failed to cd into $REPO_DIR" >> $LOG_FILE
    exit 1
}

if git checkout main >> $LOG_FILE 2>&1 && git pull origin main >> $LOG_FILE 2>&1; then
    echo "[$TIMESTAMP] Git pull from main successful." >> $LOG_FILE
else
    echo "[$TIMESTAMP] ERROR: Git pull failed. Update aborted." >> $LOG_FILE
    exit 1
fi

source "$VENV_DIR/bin/activate"
pip install -r requirements.txt >> $LOG_FILE 2>&1

python manage.py migrate >> $LOG_FILE 2>&1

sudo service $SUPERVISOR_SERVICE restart >> $LOG_FILE
echo "[$TIMESTAMP] Supervisor service restarted." >> $LOG_FILE

sudo systemctl restart $WEB_SERVICE >> $LOG_FILE
echo "[$TIMESTAMP] Web server ($WEB_SERVICE) restarted." >> $LOG_FILE

echo "[$TIMESTAMP] Update complete!" >> $LOG_FILE
