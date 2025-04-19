#!/bin/bash

TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
PROJECT_DIR="/home/ubuntu/project/CPtask"
BACKUP_DIR="/home/ubuntu/project/backups"
BACKUP_FILE="$BACKUP_DIR/cp_task_backup_$TIMESTAMP.tar.gz"
PG_BACKUP_FILE="$BACKUP_DIR/postgres_backup_$TIMESTAMP.sql"

DB_NAME="cptask"
DB_USER="postgres"
DB_HOST="localhost"
DB_PORT="5432"

mkdir -p "$BACKUP_DIR"

echo "Backing up project from $PROJECT_DIR to $BACKUP_FILE..."
tar --exclude="$PROJECT_DIR/env" -czf "$BACKUP_FILE" -C "$(dirname "$PROJECT_DIR")" "$(basename "$PROJECT_DIR")"

echo "Backing up PostgreSQL database $DB_NAME..."
PGPASSWORD=postgres pg_dump -U "$DB_USER" -h "$DB_HOST" -p "$DB_PORT" "$DB_NAME" > "$PG_BACKUP_FILE"

# === DONE ===
echo "Backup completed!"
echo "Project backup: $BACKUP_FILE"
echo "Database backup: $PG_BACKUP_FILE"