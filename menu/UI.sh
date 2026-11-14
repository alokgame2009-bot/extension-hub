#!/usr/bin/env bash
# EXTENSION HUB | ZIRO EDITION v1.0
set -u

OWNER="alokgame2009-bot"
REPO="Extension-Hub"
BRANCH="main"
BASE="https://raw.githubusercontent.com/${OWNER}/${REPO}/${BRANCH}"

C=$'\033[1;96m'; B=$'\033[1;94m'; G=$'\033[1;92m'
Y=$'\033[1;93m'; M=$'\033[1;95m'; R=$'\033[1;91m'
W=$'\033[1;97m'; D=$'\033[0;37m'; N=$'\033[0m'

run_remote() {
    local path="$1" tmp
    tmp="$(mktemp)"
    printf "\n%bDownloading %s...%b\n" "$C" "$path" "$N"
    if ! curl -fLsS --connect-timeout 10 --max-time 120 "$BASE/$path" -o "$tmp"; then
        printf "%bERROR: Could not download %s%b\n" "$R" "$path" "$N"
        rm -f "$tmp"
        read -r -p "Press Enter to return to the menu..."
        return 1
    fi
    if [[ ! -s "$tmp" ]]; then
        printf "%bERROR: Downloaded file is empty: %s%b\n" "$R" "$path" "$N"
        rm -f "$tmp"
        read -r -p "Press Enter to return to the menu..."
        return 1
    fi
    bash "$tmp"
    local status=$?
    rm -f "$tmp"
    if (( status != 0 )); then
        printf "\n%bModule exited with status %s.%b\n" "$Y" "$status" "$N"
        read -r -p "Press Enter to return to the menu..."
    fi
    return 0
}

get_metrics() {
    CPU="$(top -bn1 2>/dev/null | awk -F'[, ]+' '/Cpu\(s\)/ {print int($2+$4); found=1} END {if (!found) print "?"}')"
    RAM="$(free 2>/dev/null | awk '/Mem:/ {if ($2>0) printf "%d", $3*100/$2; else print "?"}')"
    UPT="$(uptime -p 2>/dev/null | sed 's/^up //' || echo Unknown)"
    DISK="$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')"
    HOST="$(hostname 2>/dev/null || echo VPS)"
    CPU=${CPU:-?}; RAM=${RAM:-?}; UPT=${UPT:-Unknown}; DISK=${DISK:-?}
}

center_line() {
    local line="$1" cols pad
    cols="$(tput cols 2>/dev/null || printf '100')"
    [[ "$cols" =~ ^[0-9]+$ ]] || cols=100
    (( cols > 0 )) || cols=100
    if (( ${#line} < cols )); then
        pad=$(( (cols - ${#line}) / 2 ))
        printf '%*s%s\n' "$pad" '' "$line"
    else
        printf '%s\n' "$line"
    fi
}

show_logo() {
    printf '%b' "$C"
    while IFS= read -r line; do center_line "$line"; done <<'LOGO'
███████╗██╗  ██╗████████╗███████╗███╗   ██╗███████╗██╗ ██████╗ ███╗   ██╗    ██╗  ██╗██╗   ██╗██████╗
██╔════╝╚██╗██╔╝╚══██╔══╝██╔════╝████╗  ██║██╔════╝██║██╔═══██╗████╗  ██║    ██║  ██║██║   ██║██╔══██╗
█████╗   ╚███╔╝    ██║   █████╗  ██╔██╗ ██║███████╗██║██║   ██║██╔██╗ ██║    ███████║██║   ██║██████╔╝
██╔══╝   ██╔██╗    ██║   ██╔══╝  ██║╚██╗██║╚════██║██║██║   ██║██║╚██╗██║    ██╔══██║██║   ██║██╔══██╗
███████╗██╔╝ ██╗   ██║   ███████╗██║ ╚████║███████║██║╚██████╔╝██║ ╚████║    ██║  ██║╚██████╔╝██████╔╝
╚══════╝╚═╝  ╚═╝   ╚═╝   ╚══════╝╚═╝  ╚═══╝╚══════╝╚═╝ ╚═════╝ ╚═╝  ╚═══╝    ╚═╝  ╚═╝ ╚═════╝ ╚═════╝
LOGO
    center_line 'ZIRO EDITION  |  VERSION 1.0'
    printf '%b' "$N"
}

render_menu() {
    clear 2>/dev/null || true
    get_metrics
    show_logo
    printf "\n%b HOST:%b %s  %b|%b  %bUPTIME:%b %s  %b|%b  %bDISK:%b %s  %b|%b  %bCPU:%b %s%%  %b|%b  %bRAM:%b %s%%\n" \
      "$C" "$W" "$HOST" "$D" "$N" "$C" "$W" "$UPT" "$D" "$N" "$C" "$W" "$DISK" "$D" "$N" "$C" "$W" "$CPU" "$D" "$N" "$C" "$W" "$RAM"
    printf "%b────────────────────────────────────────────────────────────────────────%b\n" "$C" "$N"
    printf "%b MAIN MENU%b\n\n" "$C" "$N"
    printf "  %b[1]%b  %bPanel Manager%b       %b[5]%b  %bSystem Information%b\n" "$C" "$W" "$W" "$N" "$B" "$W" "$W" "$N"
    printf "  %b[2]%b  %bWings Manager%b       %b[6]%b  %bDocker Tools%b\n" "$C" "$W" "$W" "$N" "$B" "$W" "$W" "$N"
    printf "  %b[3]%b  %bToolbox%b              %b[7]%b  %bNew Module%b\n" "$C" "$W" "$W" "$N" "$B" "$W" "$W" "$N"
    printf "  %b[4]%b  %bThemes%b               %b[8]%b  %bExtras%b\n" "$C" "$W" "$W" "$N" "$B" "$W" "$W" "$N"
    printf "\n  %b[0] Exit%b\n" "$R" "$N"
    printf "%b────────────────────────────────────────────────────────────────────────%b\n" "$C" "$N"
    printf "%b Select option (0-8), then press Enter: %b" "$C" "$N"
}

if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required. Install it with: apt install curl -y"
    exit 1
fi

while true; do
    render_menu
    IFS= read -r opt || exit 0
    case "$opt" in
        1) run_remote "panel/1.sh" ;;
        2) run_remote "wings/run.sh" ;;
        3) run_remote "toolbox/run.sh" ;;
        4) run_remote "thame/run.sh" ;;
        5) run_remote "toolbox/info.sh" ;;
        6) run_remote "Extras/docker.sh" ;;
        7)
            printf "\n%bNew Module slot is not configured yet.%b\n" "$Y" "$N"
            read -r -p "Press Enter to return to the menu..."
            ;;
        8) run_remote "Extras/run.sh" ;;
        0|q|quit|exit)
            printf "\n%bExtension Hub closed. Goodbye!%b\n" "$G" "$N"
            exit 0
            ;;
        *)
            printf "\n%bInvalid option: %s%b\n" "$R" "$opt" "$N"
            sleep 1
            ;;
    esac
done
