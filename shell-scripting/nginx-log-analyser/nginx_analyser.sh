#!/bin/bash

LOG_FILE="${1:-nginx-access.log}"

if [[ ! -f "$LOG_FILE" ]]; then
    echo "Error: log file '$LOG_FILE' not found." >&2
    exit 1
fi

echo "=== Top 5 IP Addresses ==="
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5 | awk '{print $2, "-", $1, "requests"}'

echo ""
echo "=== Top 5 Requested Paths ==="
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5 | awk '{print $2, "-", $1, "requests"}'

echo ""
echo "=== Top 5 Response Status Codes ==="
awk '$9 ~ /^[0-9]+$/ {print $9}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5 | awk '{print $2, "-", $1, "requests"}'

echo ""
echo "=== Top 5 User Agents ==="
awk -F'"' '{print $6}' "$LOG_FILE" | sort | uniq -c | sort -rn | head -5 | awk '{$1=$1; count=$1; $1=""; sub(/^ /, ""); print $0, "-", count, "requests"}'
