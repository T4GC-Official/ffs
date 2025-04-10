#!/bin/bash

# ========= USER INPUT =========
read -p "Enter the site name (e.g., fms.d.c.com): " SITE_NAME
read -p "Enter the full path to your bench (e.g., /home/frappe/frappe-bench): " BENCH_PATH
read -p "Do you want to [backup] or [restore] the site? " MODE
S3_BUCKET="s3://your-bucket-name/frappe-backups/${SITE_NAME}"
TMP_DIR="/tmp/frappe_backup/${SITE_NAME}"


BACKUP_DIR="${BENCH_PATH}/sites/${SITE_NAME}/private/backups"
mkdir -p "$TMP_DIR"

# ========= JOB 1: BACKUP =========
if [[ "$MODE" == "backup" ]]; then
    SECONDS=0
    echo "Taking backup of ${SITE_NAME}..."

    cd "$BENCH_PATH" || { echo "Invalid bench path"; exit 1; }

    # Use --with-files to ensure all parts are backed up
    bench --site "$SITE_NAME" backup --with-files

    echo "Backup complete. Locating latest backup files..."

    SQL_FILE=$(ls -t "$BACKUP_DIR"/*.sql.gz | head -1)
    FILES_TAR=$(ls -t "$BACKUP_DIR"/*-files.tar 2>/dev/null | head -1)
    PRIVATE_TAR=$(ls -t "$BACKUP_DIR"/*-private.tar 2>/dev/null | head -1)

    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    ARCHIVE_NAME="${SITE_NAME}_backup_${TIMESTAMP}.tar.gz"
    ARCHIVE_PATH="$TMP_DIR/$ARCHIVE_NAME"

    echo "Compressing (progress is approximate)..."

    FILE_LIST=()
    [[ -f "$SQL_FILE" ]] && FILE_LIST+=("$(basename "$SQL_FILE")")
    [[ -f "$FILES_TAR" ]] && FILE_LIST+=("$(basename "$FILES_TAR")")
    [[ -f "$PRIVATE_TAR" ]] && FILE_LIST+=("$(basename "$PRIVATE_TAR")")

    if [[ ${#FILE_LIST[@]} -eq 0 ]]; then
        echo "No backup files found. Exiting."
        exit 1
    fi

    cd "$BACKUP_DIR"
    
    if command -v pv >/dev/null 2>&1; then
        FILE_SIZE=$(du -cb "${FILE_LIST[@]}" | tail -1 | awk '{print $1}')
        tar -cf - "${FILE_LIST[@]}" | pv -p -t -e -b -s "$FILE_SIZE" | gzip > "$ARCHIVE_PATH"
    else
        echo "!!! 'pv' not installed. Compressing without progress bar..."
        tar -czf "$ARCHIVE_PATH" "${FILE_LIST[@]}"
    fi

    read -p "Do you want to upload the backup to S3? (yes/no): " UPLOAD_TO_S3
    if [[ "$UPLOAD_TO_S3" == "yes" ]]; then
        echo -e "\n Uploading to S3..."
        if command -v pv >/dev/null 2>&1; then
            pv "$ARCHIVE_PATH" | aws s3 cp - "$S3_BUCKET/$ARCHIVE_NAME"
        else
            aws s3 cp "$ARCHIVE_PATH" "$S3_BUCKET/$ARCHIVE_NAME"
        fi
        echo " Backup uploaded: $ARCHIVE_NAME"
    else
        echo "Skipping S3 upload as requested."
    fi

    echo "Backup process complete."
    echo "Backup execution time: $SECONDS seconds."

# ========= JOB 2: RESTORE =========
elif [[ "$MODE" == "restore" ]]; then
    SECONDS=0
    echo "Fetching latest backup from S3..."

    LATEST_BACKUP=$(aws s3 ls "$S3_BUCKET/" | sort | tail -1 | awk '{print $4}')
    ARCHIVE_PATH="$TMP_DIR/$LATEST_BACKUP"

    echo "Downloading $LATEST_BACKUP..."
    aws s3 cp "$S3_BUCKET/$LATEST_BACKUP" "$ARCHIVE_PATH"

    echo "Extracting backup with progress..."
    pv "$ARCHIVE_PATH" | tar -xz -C "$TMP_DIR"

    SQL_FILE=$(ls $TMP_DIR/*.sql.gz | head -1)
    FILES_TAR=$(ls $TMP_DIR/*-files.tar | head -1)
    PRIVATE_TAR=$(ls $TMP_DIR/*-private.tar | head -1)

    echo "Restoring site $SITE_NAME..."

    cd "$BENCH_PATH" || { echo "Invalid bench path"; exit 1; }
    bench --site "$SITE_NAME" --force restore "$SQL_FILE"

    echo "Restoring files..."
    tar -xf "$FILES_TAR" -C "sites/$SITE_NAME/"
    tar -xf "$PRIVATE_TAR" -C "sites/$SITE_NAME/private/"

    bench --site "$SITE_NAME" migrate

    echo "Restore complete for site: $SITE_NAME"
    echo "Restore execution time: $SECONDS seconds."

else
    echo "X Usage: $0 [backup|restore]"
    exit 1
fi
