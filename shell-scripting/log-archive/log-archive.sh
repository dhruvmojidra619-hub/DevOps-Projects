#!/bin/bash

# ── Colours ──────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

# ── Step 1: Check an argument was passed ─────────
if [[ $# -eq 0 ]]; then
    echo -e "${RED}Error: No log directory provided.${RESET}"
    echo "Usage: ./log-archive.sh <log-directory>"
    exit 1
fi

LOG_DIR="$1"

# ── Step 2: Check the directory actually exists ──
if [[ ! -d "$LOG_DIR" ]]; then
    echo -e "${RED}Error: '$LOG_DIR' is not a valid directory.${RESET}"
    exit 1
fi

echo -e "${GREEN}✔ Log directory found: $LOG_DIR${RESET}"

# ── Step 3: Generate timestamp and filename ──────
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
ARCHIVE_NAME="logs_archive_${TIMESTAMP}.tar.gz"

# ── Step 4: Create archive storage directory ─────
ARCHIVE_DIR="$HOME/log_archives"
mkdir -p "$ARCHIVE_DIR"

echo -e "${CYAN}Timestamp  : $TIMESTAMP${RESET}"
echo -e "${CYAN}Archive    : $ARCHIVE_NAME${RESET}"
echo -e "${CYAN}Storing in : $ARCHIVE_DIR${RESET}"

# ── Step 5: Compress the log directory ───────────
tar --ignore-failed-read -czf "$ARCHIVE_DIR/$ARCHIVE_NAME" "$LOG_DIR" 2>/dev/null

if [[ -f "$ARCHIVE_DIR/$ARCHIVE_NAME" ]]; then
    SIZE=$(du -sh "$ARCHIVE_DIR/$ARCHIVE_NAME" | cut -f1)
    echo -e "${GREEN}✔ Logs compressed successfully! (Size: $SIZE)${RESET}"
else
    echo -e "${RED}✘ Compression failed.${RESET}"
    exit 1
fi

# ── Step 6: Log the event ────────────────────────
LOG_FILE="$ARCHIVE_DIR/archive_log.txt"
echo "[${TIMESTAMP}] Archived '${LOG_DIR}' -> '${ARCHIVE_NAME}'" >> "$LOG_FILE"
echo -e "${CYAN}✔ Event logged to: $LOG_FILE${RESET}"










