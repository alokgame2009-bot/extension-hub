#!/usr/bin/env bash
# ==========================================================
# EXTENSION HUB | ZIRO EDITION
# Main menu
# ==========================================================
set -u

C='\033[1;96m'
W='\033[1;97m'
G='\033[0;37m'
R='\033[1;91m'
N='\033[0m'

get_metrics() {
    CPU=$(top -bn1 2>/dev/null | awk -F'[, ]+' '/Cpu\(s\)/ {print int($2+$4); found=1} END {if (!found) print "?"}')
    RAM=$(free 2>/dev/null | awk '/Mem:/ {if ($2>0) printf "%d", $3*100/$2; else print "?"}')
    UPT=$(uptime -p 2>/dev/null | sed 's/^up //' || echo "Unknown")
    DISK=$(df -h / 2>/dev/null | awk 'NR==2 {print $5}')
    CURRENT_HOST=$(hostname 2>/dev/null || echo "VPS")
    CPU=${CPU:-?}; RAM=${RAM:-?}; UPT=${UPT:-Unknown}; DISK=${DISK:-?}
}

center_line() {
    local line="$1" cols pad
    cols=$(tput cols 2>/dev/null || printf '120')
    (( cols > 0 )) || cols=120
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
    printf "\n%b  HOST: %s  |  UPTIME: %s  |  DISK: %s  |  CPU: %s%%  |  RAM: %s%%%b\n" "$C" "$CURRENT_HOST" "$UPT" "$DISK" "$CPU" "$RAM" "$N"
    printf "%b────────────────────────────────────────────────────────────────────%b\n" "$C" "$N"
    printf "%b  MAIN MENU%b\n\n" "$C" "$N"
    printf "  %b[1]%b  Panel Manager       %b[5]%b  System Tools\n" "$C" "$W" "$C" "$W"
    printf "  %b[2]%b  Wings Manager       %b[6]%b  Container Tools\n" "$C" "$W" "$C" "$W"
    printf "  %b[3]%b  Toolbox             %b[7]%b  New Module\n" "$C" "$W" "$C" "$W"
    printf "  %b[4]%b  Themes              %b[8]%b  Extras\n" "$C" "$W" "$C" "$W"
    printf "\n%b  [0] Exit%b\n" "$R" "$N"
    printf "%b────────────────────────────────────────────────────────────────────%b\n" "$C" "$N"
    printf "%b  Select option (0-8): %b" "$C" "$N"
}

while true; do
    render_menu
    read -r opt
    case "$opt" in
        1) bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/Extension-Hub/refs/heads/main/panel/1.sh) ;;
        2) bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/Extension-Hub/refs/heads/main/wings/run.sh) ;;
        3) bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/ptero/refs/heads/main/ptero/tools/run.sh) ;;
        4) bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/Extension-Hub/refs/heads/main/thame/run.sh) ;;
        5) bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/Extension-Hub/refs/heads/main/srv/menu/System1.sh) ;;
        6) bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/ptero/refs/heads/main/ptero/no-kvm/run.sh) ;;
        7)
            printf "\n%b  New Module slot is ready for your own script.%b\n" "$C" "$N"
            read -r -p "  Press Enter to continue..."
            ;;
        8) bash <(curl -fsSL https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/Extension-Hub/refs/heads/main/Extras/run.sh) ;;
        0|exit|quit)
            printf "\n%b  Extension Hub closed. Goodbye!%b\n" "$C" "$N"
            exit 0
            ;;
        *)
            printf "\n%b  Invalid option. Please try again.%b\n" "$R" "$N"
            sleep 1
            ;;
    esac
done
