# Log Archive Automation

## Overview

Log Archive Automation is a Bash shell script designed to automate the management of log files on Linux systems. System logs can grow rapidly over time and consume valuable disk space if they are not maintained properly.

The script identifies files older than seven days, compresses them into a timestamped archive, verifies archive integrity, records archive activity, and removes original files only after successful verification.

The project demonstrates practical DevOps concepts including automation, file management, backup strategies, logging, scheduling, and shell scripting best practices.

It was developed and tested on Ubuntu 22.04 and is intended for Linux administrators, DevOps engineers, and anyone learning Bash scripting.

---

## Features

### 1. Command Line Argument Parsing

The script accepts command-line arguments such as `--dry-run` and `--restore`, allowing different modes of operation without modifying source code.

### 2. Default Log Directory Fallback

If no directory is supplied, the script automatically uses `/var/log` as the target directory.

### 3. Directory Validation

The script checks whether the specified directory exists before performing any operations.

### 4. Empty Directory Check

The script verifies that files older than seven days are available before attempting to create an archive.

### 5. Dry Run Mode

Users can preview which files would be archived without making any changes to the system.

### 6. Restore Mode

Previously created archives can be restored into a dedicated restore directory.

### 7. Timestamped Archive Creation

Every archive receives a unique timestamp to prevent naming conflicts.

### 8. Archive Integrity Verification

Archives are tested after creation to ensure they are readable and valid.

### 9. Automatic Deletion of Original Files

Original files are removed only after archive creation and verification succeed.

### 10. Event Logging

Every archive operation is logged in `archive_log.txt` with timestamps, archive names, archive sizes, and file counts.

### 11. Archive Summary Report

A detailed summary is displayed after every successful execution.

### 12. Cron Job Scheduling

The script can optionally create a daily cron job that runs automatically at 10:00 AM.

---

## Requirements

### Operating System

Linux (Tested on Ubuntu 22.04)

### Shell

Bash

### Permissions

sudo may be required when accessing protected directories such as `/var/log`.

### Tools Used

- tar
- find
- du
- crontab

These utilities are pre-installed on most Ubuntu systems.

---

## Installation

Clone the repository:

```bash
git clone https://github.com/dhruvmojidra619-hub/DevOps-Projects.git
```

Navigate to the project directory:

```bash
cd DevOps-Projects/Log_Archive_Project
```

Make the script executable:

```bash
chmod +x log_archive.sh
```

---

## Usage

### Normal Run

```bash
sudo ./log_archive.sh /var/log
```

### Dry Run

```bash
sudo ./log_archive.sh /var/log --dry-run
```

### Restore Mode

```bash
./log_archive.sh --restore
```

---

## How It Works

### Step 1 – Read Command Line Arguments

The script reads all supplied arguments and determines user preferences.

### Step 2 – Determine Operating Mode

The script checks whether normal mode, dry-run mode, or restore mode should be executed.

### Step 3 – Validate Directory

The target directory is validated before any file operations occur.

### Step 4 – Search for Old Files

Files older than seven days are identified using the `find` command.

### Step 5 – Execute Dry Run Logic

If dry-run mode is enabled, matching files are displayed and execution stops.

### Step 6 – Create Archive Directory

The archive directory is created automatically if it does not already exist.

### Step 7 – Generate Archive Name

A timestamp is generated and used to create a unique archive filename.

### Step 8 – Create Compressed Archive

Matching files are compressed into a `.tar.gz` archive.

### Step 9 – Verify Archive Integrity

The archive is tested using `tar` to ensure it can be read successfully.

### Step 10 – Log Archive Information

Archive details are written to `archive_log.txt`.

### Step 11 – Delete Original Files

Original files are removed only after the integrity check succeeds.

### Step 12 – Display Summary Report

A summary showing archive information is displayed to the user.

### Step 13 – Configure Cron Job

The user can choose to schedule the script to run automatically every day at 10:00 AM.

---

## Example Output

```text
===== Archive Summary =====
Archive Name    : logs_archive_20260618_114747.tar.gz
Archive Size    : 4.0K
Location        : /home/dpm/log_archives
Files           : 1
Log File        : /home/dpm/log_archives/archive_log.txt
Status          : SUCCESS
===========================
```

---

## Notes

Running the script with sudo changes the HOME environment variable to `/root`.

As a result, archives may be stored in:

```text
/root/log_archives
```

Dry-run mode is completely safe and does not modify any files.

Original files are deleted only after archive integrity verification succeeds.

The script has been tested on Ubuntu 22.04.

---

## Author

Dhruv Mojidra

GitHub: https://github.com/dhruvmojidra619-hub

## Project URL

https://roadmap.sh/projects/log-archive
