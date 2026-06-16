#!/bin/bash

# =============================================================================
# server-stats.sh — Basic Server Performance Analyser
# Author : Dhruv Mojidra
# =============================================================================

# ── Colour palette ────────────────────────────────────────────────────────────
RED='\033[0;31m'; YELLOW='\033[1;33m'; GREEN='\033[0;32m'
CYAN='\033[0;36m'; BOLD='\033[1m'; RESET='\033[0m'

divider() { printf "${CYAN}%s${RESET}\n" "────────────────────────────────────────────────────"; }
header()  { echo; divider; printf "${BOLD}${CYAN}  %-50s${RESET}\n" "$1"; divider; }

# ── Helper: colour-code a percentage ─────────────────────────────────────────
colour_pct() {
    local pct="${1%.*}"          # integer part only
    if   (( pct >= 90 )); then printf "${RED}%s%%${RESET}"    "$1"
    elif (( pct >= 70 )); then printf "${YELLOW}%s%%${RESET}" "$1"
    else                        printf "${GREEN}%s%%${RESET}"  "$1"
    fi
}

# =============================================================================
# 0. BANNER
# =============================================================================
clear
echo
printf "${BOLD}${CYAN}╔══════════════════════════════════════════════════╗${RESET}\n"
printf "${BOLD}${CYAN}║        SERVER PERFORMANCE STATS ANALYSER        ║${RESET}\n"
printf "${BOLD}${CYAN}╚══════════════════════════════════════════════════╝${RESET}\n"
printf "  Host   : ${BOLD}$(hostname)${RESET}   |   Date: ${BOLD}$(date '+%Y-%m-%d %H:%M:%S %Z')${RESET}\n"

# =============================================================================
# 1. OS / SYSTEM INFO  (stretch)
# =============================================================================
header "SYSTEM INFORMATION"
OS=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
KERNEL=$(uname -r)
ARCH=$(uname -m)
printf "  %-18s %s\n" "OS:"     "${OS:-$(uname -s)}"
printf "  %-18s %s\n" "Kernel:" "$KERNEL"
printf "  %-18s %s\n" "Arch:"   "$ARCH"

# =============================================================================
# 2. UPTIME & LOAD AVERAGE  (stretch)
# =============================================================================
header "UPTIME & LOAD AVERAGE"
UPTIME_STR=$(uptime -p 2>/dev/null || uptime)
LOAD=$(awk '{print $1, $2, $3}' /proc/loadavg)
NPROC=$(nproc)
printf "  %-18s %s\n" "Uptime:"       "$UPTIME_STR"
printf "  %-18s %s  (cores: %s)\n" "Load (1/5/15m):" "$LOAD" "$NPROC"

# =============================================================================
# 3. CPU USAGE
# =============================================================================
header "CPU USAGE"
# Sample two /proc/stat readings 0.5 s apart for an accurate idle delta
read_cpu() { grep '^cpu ' /proc/stat | awk '{print $2+$3+$4+$5+$6+$7+$8, $5}'; }
S1=$(read_cpu); sleep 0.5; S2=$(read_cpu)
TOTAL1=$(echo $S1 | cut -d' ' -f1); IDLE1=$(echo $S1 | cut -d' ' -f2)
TOTAL2=$(echo $S2 | cut -d' ' -f1); IDLE2=$(echo $S2 | cut -d' ' -f2)
DTOTAL=$(( TOTAL2 - TOTAL1 )); DIDLE=$(( IDLE2 - IDLE1 ))
CPU_USED=$(awk "BEGIN{printf \"%.1f\", ($DTOTAL-$DIDLE)*100/$DTOTAL}")
CPU_IDLE=$(awk "BEGIN{printf \"%.1f\", $DIDLE*100/$DTOTAL}")
printf "  %-18s " "Used:"; colour_pct "$CPU_USED"; echo
printf "  %-18s %s%%\n" "Idle:" "$CPU_IDLE"

# =============================================================================
# 4. MEMORY USAGE
# =============================================================================
header "MEMORY USAGE"
MEM_TOTAL=$(free -m | awk '/^Mem:/{print $2}')
MEM_USED=$(free -m  | awk '/^Mem:/{print $3}')
MEM_FREE=$(free -m  | awk '/^Mem:/{print $4}')
MEM_AVAIL=$(free -m | awk '/^Mem:/{print $7}')
# fallback: if $7 is empty (older free versions), use $6
[[ -z "$MEM_AVAIL" ]] && MEM_AVAIL=$(free -m | awk '/^Mem:/{print $6}')
MEM_PCT=$(awk "BEGIN{printf \"%.1f\", ${MEM_USED}*100/${MEM_TOTAL}}")
printf "  %-18s %s MiB\n" "Total:"     "$MEM_TOTAL"
printf "  %-18s %s MiB  (" "Used:" "$MEM_USED"; colour_pct "$MEM_PCT"; echo ")"
printf "  %-18s %s MiB\n" "Free:"      "$MEM_FREE"
printf "  %-18s %s MiB\n" "Available:" "$MEM_AVAIL"

SW_TOTAL=$(free -m | awk '/^Swap:/{print $2}')
SW_USED=$(free -m  | awk '/^Swap:/{print $3}')
SW_FREE=$(free -m  | awk '/^Swap:/{print $4}')
if (( SW_TOTAL > 0 )); then
    SW_PCT=$(awk "BEGIN{printf \"%.1f\", $SW_USED*100/$SW_TOTAL}")
    echo
    printf "  ${BOLD}Swap:${RESET}\n"
    printf "  %-18s %s MiB\n" "  Total:" "$SW_TOTAL"
    printf "  %-18s %s MiB  (" "  Used:" "$SW_USED"; colour_pct "$SW_PCT"; echo ")"
    printf "  %-18s %s MiB\n" "  Free:"  "$SW_FREE"
fi

# =============================================================================
# 5. DISK USAGE
# =============================================================================
header "DISK USAGE"
printf "  ${BOLD}%-20s %8s %8s %8s %6s  %s${RESET}\n" \
       "Filesystem" "Size" "Used" "Avail" "Use%" "Mounted on"
df -h --output=source,size,used,avail,pcent,target -x tmpfs -x devtmpfs \
    -x squashfs 2>/dev/null | tail -n +2 \
    | grep -v '^snapfuse' \
    | grep -v '^none.*wslg' \
    | grep -v 'wsl/lib\|wsl/modules\|versions\.txt\|/doc$\|/init$' \
    | while IFS= read -r line; do
    PCT=$(echo "$line" | awk '{print $5}' | tr -d '%')
    COLOUR=$GREEN
    (( PCT >= 90 )) && COLOUR=$RED || (( PCT >= 70 )) && COLOUR=$YELLOW
    printf "  ${COLOUR}%-20s %8s %8s %8s %5s%%  %s${RESET}\n" \
        $(echo "$line" | awk '{print $1,$2,$3,$4,$5,$6}' | tr -d '%')
done

# =============================================================================
# 6. TOP 5 PROCESSES — CPU
# =============================================================================
header "TOP 5 PROCESSES BY CPU USAGE"
printf "  ${BOLD}%-8s %-10s %6s %6s  %s${RESET}\n" "PID" "USER" "%CPU" "%MEM" "COMMAND"
ps aux --sort=-%cpu | awk 'NR>1{printf "  %-8s %-10s %6s %6s  %s\n",$2,$1,$3,$4,$11}' \
    | head -5

# =============================================================================
# 7. TOP 5 PROCESSES — MEMORY
# =============================================================================
header "TOP 5 PROCESSES BY MEMORY USAGE"
printf "  ${BOLD}%-8s %-10s %6s %6s  %s${RESET}\n" "PID" "USER" "%MEM" "%CPU" "COMMAND"
ps aux --sort=-%mem | awk 'NR>1{printf "  %-8s %-10s %6s %6s  %s\n",$2,$1,$4,$3,$11}' \
    | head -5

# =============================================================================
# 8. LOGGED-IN USERS  (stretch)
# =============================================================================
header "LOGGED-IN USERS"
WHO=$(who 2>/dev/null)
if [[ -z "$WHO" ]]; then
    printf "  (no users currently logged in)\n"
else
    printf "  ${BOLD}%-12s %-10s %-20s %s${RESET}\n" "USER" "TTY" "LOGIN TIME" "FROM"
    who | awk '{printf "  %-12s %-10s %-20s %s\n", $1, $2, $3" "$4, $5}'
fi

# =============================================================================
# 9. FAILED LOGIN ATTEMPTS  (stretch)
# =============================================================================
header "FAILED LOGIN ATTEMPTS (last 24 h)"
FAIL_LOG=""
for log in /var/log/auth.log /var/log/secure; do
    [[ -r "$log" ]] && FAIL_LOG=$log && break
done
if [[ -n "$FAIL_LOG" ]]; then
    COUNT=$(grep -c "Failed password" "$FAIL_LOG" 2>/dev/null || echo 0)
    COUNT=$(echo "$COUNT" | tr -d '[:space:]' | cut -c1-10 | grep -oE '^[0-9]+' | head -1)
    COUNT=${COUNT:-0}
    printf "  Total failed attempts : "
    if (( COUNT >= 10 )); then printf "${RED}%s${RESET}\n" "$COUNT"
    elif (( COUNT > 0 )); then printf "${YELLOW}%s${RESET}\n" "$COUNT"
    else printf "${GREEN}%s${RESET}\n" "$COUNT"; fi
    if (( COUNT > 0 )); then
        echo
        printf "  ${BOLD}Top offending IPs:${RESET}\n"
        grep "Failed password" "$FAIL_LOG" 2>/dev/null \
            | grep -oP '(?<=from )\S+' \
            | sort | uniq -c | sort -rn | head -5 \
            | awk '{printf "  %6s attempts  from  %s\n", $1, $2}'
    fi
else
    printf "  (auth log not readable — run as root for this section)\n"
fi

# =============================================================================
# FOOTER
# =============================================================================
echo
divider
printf "${GREEN}  ✔  Stats collection complete — $(date '+%H:%M:%S')${RESET}\n"
divider
echo
