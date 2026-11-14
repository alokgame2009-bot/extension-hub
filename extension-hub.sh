
#!/usr/bin/env bash

# ==========================================
# EXTENSION HUB - ZIRO EDITION v1.0
# Main Launcher
# ==========================================

set -e

REPO="https://raw.githubusercontent.com/alokgame2009-bot/Extension-Hub/main"
TMP_FILE="$(mktemp)"

cleanup() {
    rm -f "$TMP_FILE"
}
trap cleanup EXIT

printf '\033[1;96m'
echo "Starting Extension Hub - Ziro Edition v1.0"
printf '\033[0m'

if ! command -v curl >/dev/null 2>&1; then
    echo "Error: curl is not installed."
    exit 1
fi

if ! curl -fLsS "$REPO/menu/UI.sh" -o "$TMP_FILE"; then
    echo "Error: Unable to download Extension Hub."
    exit 1
fi

bash "$TMP_FILE"
