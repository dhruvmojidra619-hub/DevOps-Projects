#!/bin/bash

dry_run=false
restore=false
log_dir="/var/log"

archive_dir="$HOME/log_archives"
archive_log="$archive_dir/archive_log.txt"

TIMESTAMP=""
ARCHIVE_NAME=""
ARCHIVE_SIZE=""

for arg in "$@"
do
	case $arg in
		--dry-run)
			dry_run=true
			;;
		--restore)
			restore=true
			;;
		--*)
			;;
		*)
			log_dir="$arg"
			;;
	esac
done

validate_directory() {
	if [ ! -d "$log_dir" ]; then
		echo "Error: Directory does not exist"
		exit 1
	fi
}

check_old_files() {
	FILE_COUNT=$(find "$log_dir" -type f -mtime +7 2>/dev/null | wc -l)

	if [ "$FILE_COUNT" -eq 0 ]; then
		echo "No files older than 7 days found."
		exit 0
	fi

	echo "Found $FILE_COUNT files older than 7 days."
}

dry_run_mode() {
	if [ "$dry_run" = true ]; then
		echo "Dry run mode enabled"

		find "$log_dir" -type f -mtime +7 2>/dev/null

		echo ""
		echo "These files would be archived"
		echo "Original files would be deleted after successful archive"

		exit 0
	fi
}

restore_mode() {
    if [ "$restore" = true ]; then

        echo "Available archives:"

        ls "$archive_dir"/*.tar.gz 2>/dev/null

        echo ""
        read -p "Enter archive filename: " archive_name

        restore_dir="$HOME/restored_logs"
        mkdir -p "$restore_dir"

        if tar -xzvf "$archive_dir/$archive_name" -C "$restore_dir"; then
            echo "Archive restored successfully."
            echo "Files restored to: $restore_dir"
        else
            echo "Restore failed."
            exit 1
        fi

        exit 0
    fi
}

create_archive_dir() {
	mkdir -p "$archive_dir"
}

archive_files() {

    TIMESTAMP=$(date +%Y%m%d_%H%M%S)
    ARCHIVE_NAME="logs_archive_$TIMESTAMP.tar.gz"

    find "$log_dir" -type f -mtime +7 -print0 2>/dev/null | \
    tar -czvf "$archive_dir/$ARCHIVE_NAME" --null -T -

    if [ $? -ne 0 ]; then
        echo "Archive creation failed"
        exit 1
    fi

    echo "Archive created successfully"
}

integrity_check() {
	  if tar -tzf "$archive_dir/$ARCHIVE_NAME" > /dev/null 2>&1; then
        echo "Integrity check passed."
    else
        echo "Integrity check FAILED. Originals NOT deleted."
        exit 1
    fi
}


log_archive() {

    ARCHIVE_SIZE=$(du -h "$archive_dir/$ARCHIVE_NAME" | cut -f1)

    echo "$(date '+%Y-%m-%d %H:%M:%S') | $ARCHIVE_NAME | $ARCHIVE_SIZE | $FILE_COUNT files" >> "$archive_log"
}


delete_original_files() {

	find "$log_dir" -type f -mtime +7 -delete

	echo "Original files deleted."
}

show_summary() {

	echo ""
	echo "===== Archive Summary ====="
	echo "Archive Name    :$ARCHIVE_NAME"
	echo "Archive Size    :$ARCHIVE_SIZE"
	echo "Location        :$archive_dir"
	echo "Files           :$FILE_COUNT"
	echo "Log File        :$archive_log"
	echo "Status          : SUCCESS"
	echo "=============================="

}


setup_cron() {

    read -p "Do you want to schedule this script daily at 10:00 AM? (yes/no): " cron_choice

    if [ "$cron_choice" = "yes" ]; then

        (crontab -l 2>/dev/null; echo "0 10 * * * /mnt/d/Projects/Devops_projects/shell-scripting/Log_Archive_Project/log_archive.sh") | crontab -

        echo "Cron job added successfully."
        echo "The script will run every day at 10:00 AM."

    else

        echo "Cron job setup skipped."

    fi
}



# Main Execution Flow

restore_mode

validate_directory

check_old_files

dry_run_mode

create_archive_dir

archive_files

integrity_check

log_archive

delete_original_files

show_summary

setup_cron
